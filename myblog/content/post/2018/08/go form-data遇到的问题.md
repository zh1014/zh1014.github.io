---
title: "Git阅读笔记"
date: 2018-08-28T19:33:59+08:00
draft: true
tags: ["Git"]
categories: ["工具"]
---

### go使用multipart/form-data遇到的问题

http使用multipart/form-data类型传输数据，需要golang使用FormValue()或者PostFormValue()方法来获取。

但是当请求header中设置了Content-Type时会导致获取的数据为空。好像是强制使用了FormFile()来获取。

然后当把请求中的Content-Type去掉，居然还是获取到空值，后来发现是因为我在获取form-data之前执行了request.Header().Get("Content-type")，并正确获取到Content-type。即使传数据的人没有加Content-Type，可能在我这边又把它自动加上了。

所以，请求中不要带Content-Type，后台也不要去获取请求的Content-Type。

[link](https://github.com/golang/go/issues/24041)