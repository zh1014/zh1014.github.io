---
title: "Go的database/sql包使用笔记"
date: 2018-10-30T00:00:36+08:00
draft: false
tags: ["go","database"]
categories: ["go"]
---

# **连接**
sql.Open()连接数据库时，dsn中dbname为空，不会出现错误；dbname为不存在数据库，进行查询时才会panic，（unknown database）
# **检索结果集**
检索结果的常用操作：
1. 执行返回rows的查询（query）
2. 准备（prepare）以得到一个statement来重复地使用，多次地执行它，最后销毁它。
3. 免去准备（prepare）步骤，执行一个一次性的语句。
4. 执行一个返回单排（single row）的查询。

go中的database/sql的函数命名是有意义的。名字含query的函数是用来查询的，即使结果为空，也会返回rows。不返回rows的语句应该使用Exec()。

`遍历：`

几个容易出错的地方：

- rows.Next()循环结束后应该检查错误：err = rows.Err()。循环体中出现错误时你应该知道。
- 只要rows处于打开状态，那么该rows的连接就是繁忙状态的，也就不能用于其他查询。意味着该连接在连接池中不可用。使用rows.Next()读完了rows之后，再读的话就会得到一个EOF错误，并且会自动为你调用rows.Close()。但是如果你因为某些原因，中途退出循环，rows没有自动关闭（只有读到错误才会为你自动关闭），那么连接就会一直打开。很容易耗尽资源。
- rows.Close()是无害操作，可以多次调用。关闭之前应该执行err = rows.Err() ，如果没有错误，只调用rows.Close（），以避免运行时出现混乱。
- 你应该总是调用defer rows.Close()，尽管你在循环结束后显式调用了rows.Close()。这不是个坏主意。
- 如果你在循环内反复的进行查询，那么就不要使用defer了。因为defer的内容要等到函数结束才执行，就会缓慢地堆积在内存。你应该在处理完一个结果集后立即调用rows.Close()，而不是用defer。

`Scan()的工作方式：`

在使用Scan的时候，go已经做好了类型转换，你不要重复做了。
go会尽可能的做类型转换，比如一个int类型或者Time类型的赋值给一个string。但是像nil这样的空无法通过scan()赋值给一个string，这时候就会返回一个err了。

`Prepare查询：`

当一个查询语句会用到多次的时候，你最好使用db.Prepare()方法

`QueryRow()：`

当你只想获取一行数据的时候用QueryRow是比较方便的，因为这个时候没有Rows需要你去关闭。

# **异常处理**

`rows.Next()` 需要检查遍历是否正常退出。
```go
for rows.Next() {
	// ...
}
if err = rows.Err(); err != nil {
	// handle the error here
}
```
`rows.Close()` 检查rows是否正常关闭，若没有就打个日志吧。
```go
for rows.Next() {
	// ...
	break; // whoops, rows is not closed! memory leak...
}
// do the usual "if err = rows.Err()" [omitted here]...
// it's always safe to [re?]close here:
if err = rows.Close(); err != nil {
	// but what should we do if there's an error?
	log.Println(err)
}
```
`db.QueryRow()` 当没有查到结果进行scan会返回sql.ErrNoRows
```go
var name string
err = db.QueryRow("select name from users where id = ?", 1).Scan(&name)
if err != nil {
	if err == sql.ErrNoRows {
		// there were no rows, but otherwise no error occurred
	} else {
		log.Fatal(err)
	}
}
fmt.Println(name)
```
检查错误类型的时候，driver层可能定义了错误。调用driver层常量来知晓错误类型。
```go
if driverErr, ok := err.(*mysql.MySQLError); ok {
	if driverErr.Number == mysqlerr.ER_ACCESS_DENIED_ERROR {
		// Handle the permission-denied error
	}
}
```

最后，sql.DB实现了一个connection的管理池，所以当当前连接出现问题，database/sql层会自动换一个连接重试。我们完全感觉不到。

# **对付空值**
1.最好是避免数据库中的空值，通过设置`默认值`或者`NOT NULL`。

2.使用sql包内定义的可为空的类型：`sql.NullString` `sql.NullInt64` `sql.NullFloat64` `sql.NullBool` 。仅此4种，虽然只有四种，但像int32 uint8 等整型都是可以用NullInt64 ，database/sql层会做转换。
```go
for rows.Next() {
	var s sql.NullString
	err := rows.Scan(&s)
	// check err
	if s.Valid {
	   // use s.String
	} else {
	   // NULL value
	}
}
```
也可以自己定义类型，模仿NullString实现Scanner接口即可。

3.使用`COALESCE()`函数。
```go
rows, err := db.Query(`
	SELECT
		name,
		COALESCE(other_field, '') as other_field
	WHERE id = ?
`, 42)

for rows.Next() {
	err := rows.Scan(&name, &otherField)
	// ..
	// If `other_field` was NULL, `otherField` is now an empty string. This works with other data types as well.
}
```
COALESCE()会返回第一个不为空的参数，这样使得当other_field为空时，返回空字符串。

# **RawBytes**
当不知道列的个数和或者类型的时候，用sql.RawBytes
```go
cols, err := rows.Columns() // Remember to check err afterwards
vals := make([]interface{}, len(cols))
for i, _ := range cols {
	vals[i] = new(sql.RawBytes)
}
for rows.Next() {
	err = rows.Scan(vals...)
	// Now you can check each element of vals for nil-ness,
	// and you can use type introspection and type assertions
	// to fetch the column into a typed variable.
}
```
# **db.Exec()**
db.Exec() 返回一个result 与一个error，当执行DELETE操作的时候，WHERE 条件没有符合的情况下，返回的error为nil，修改的行数为0。.因此在需要的时候我们可以使用result.RowsAffected()查看到修改的行数。

此外，UPDATE的时候，若WHERE条件没有找到或者更新后与之前相同，同样返回的error为nil，修改的行数为0。

[原文](http://go-database-sql.org/index.html)