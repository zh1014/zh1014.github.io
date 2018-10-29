---
title: "Go类型断言与.(type)的区别"
date: 2018-10-29T19:04:00+08:00
draft: false
tags: ["go"]
categories: ["go"]
---

`类型断言`
```go
// 当断言正确，效果相当于直接赋值
func main() {
	var i interface{} = "hello"
	s, _ := i.(string)
	println(s)
	fmt.Println(reflect.TypeOf(s))
}

输出：
hello
string
```
```go
// 当断言不正确，效果相当于是在声明变量，声明类型就是右边的类型
func main() {
	var i interface{} = "hello"
	s, _ := i.(int)
	println(s)
	fmt.Println(reflect.TypeOf(s))
}

输出：
0
int
```
`使用.(type)` 不是类型断言，没有成功不成功，相当于直接赋值。
```go
func main() {
	var i interface{} = 3
	switch x := i.(type) { // .(type)只能用于switch结构中
	case int:
		println(x)
		println(i)
		fmt.Println("typeof x:", reflect.TypeOf(x))
		fmt.Println("typeof i:", reflect.TypeOf(i))
		fmt.Println(x)
		fmt.Println(i)
	default:
		fmt.Println("default")
	}
}

输出：
3
(0x109d300,0xc420084008)
typeof x: int
typeof i: int // interface{}的当前类型
3
3
```
我们知道interface{}由两部分组成。正如用println(i)打印结果，一个是类型，一个实际值有关系。
拿interface{}的类型去比选择符合的case，然后x相当于被直接赋值。

