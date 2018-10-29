---
title: "Go中的反引号、单引号与双引号"
date: 2018-10-29T19:10:55+08:00
draft: false
tags: ["go"]
categories: ["go"]
---

`单引号`一般用来表示一个字符，表示字符串一般不用。比如'a','b'。有点像表示char

`反引号`与`双引号`都可以表示字符串，反引号不支持转义，双引号支持转义。
即\n写在""里面，底层会用一个assic码中的换行符来替换它。而写在\``里面则不会，\``就是使内容保持原样，在\``里面输入一个换行符（按回车）来换行。
```go
func main() {
	fmt.Println([]byte("\n"))
}
输出：[10]
```
```go
func main() {
	fmt.Println([]byte(`\n`))
}
输出：[92 110]
```
```go
func main() {
	fmt.Println([]byte(`
`))
}
输出：[10]
```
因此，go代码中写sql语句或者html等的时侯用\``是非常好的，一行写不下直接换行。而用""则需要：
```go
db.Exec(
    "SELECT * FROM table1 "+
    "LOCK IN SHARE MODE"
)
```
[link](https://blog.csdn.net/xxy0403/article/details/54969713)