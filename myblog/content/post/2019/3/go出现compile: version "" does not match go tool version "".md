---
title: "go出现compile: version does not match go tool version"
date: 2019-03-28T18:07:13+08:00
draft: false
tags: ["go"]
categories: ["go"]
---
报错：
compile: version "" does not match go tool version ""

出现在用brew升级了go，没有修改GOROOT。
例如1.11.2升级为1.11.4，GOROOT仍然为/usr/local/Cellar/go/1.11.2/libexec。需要改成/usr/local/Cellar/go/1.11.4/libexec
```shell
vim ~/.bash_profile # MAC
[修改GOROOT]
```