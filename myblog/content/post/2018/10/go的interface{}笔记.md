---
title: "Go的interface{}笔记"
date: 2018-10-29T19:19:19+08:00
draft: false
tags: ["go"]
categories: ["go"]
---

# **interface{}组成**
interface{}由两部分组成：动态类型+实际值。
```go
func main() {
	var sp *string
	var i interface{}
	i = sp
	println(sp == nil)
	println(i == nil) // 类型不为空，为*string
	println(i == (*string)(nil))
	println(i)
}

输出：
true
false
true
(0x1052a80,0x0)
```
>Interface values are comparable. Two interface values are equal if they have identical dynamic types and equal dynamic values or if both have value nil.

只有与interface{}的动态类型及实际值均相同时，才与这个interface{}相等。

[The representation of an interface](https://blog.golang.org/laws-of-reflection#TOC_3.)

[stackoverflow的讨论](https://stackoverflow.com/questions/29138591/hiding-nil-values-understanding-why-golang-fails-here/29138676#29138676)

### **例子**:
```go
package main

import "fmt"

type Stringer interface {
	String() string
}

type String struct {
	data string
}

func main() {
	fmt.Println(CheckString(GetString()))
}

func (s *String) String() string {
	return s.data
}

func GetString() *String {return nil}

func CheckString(s Stringer) bool {
	println(interface{}(s))
	println(s)
	return s == nil
}

输出:
(0x10a42a0,0x0)
(0x10d08a0,0x0)
false
```

# **嵌套interface{}**
下面这个能通过编译，说明嵌入的匿名结构体的方法相当于外层结构体的方法。嵌入的匿名结构体实现的接口也被外层结构体实现。

仅当内层结构体匿名才这样。
```go
package main

import "fmt"

type Aer interface {
	Af()
}

type A struct {}

type B struct {
	A
	Name string
}


func (A)Af(){}

func main(){
	var b B
	var aer Aer
	aer = b
	fmt.Println(aer)
}
```