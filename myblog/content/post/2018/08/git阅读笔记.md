---
title: "Git笔记"
date: 2018-08-28T19:33:59+08:00
draft: false
tags: ["git"]
categories: ["工具"]
---

## 版本控制系统
#### 作用：
- 使项目回溯到过去的某个版本
- 查看每个版本相比之前的改动，找到问题出在哪儿

#### 发展：
最开始的版本控制系统是单机的
![img](https://raw.githubusercontent.com/zh1014/zh1014.github.io/master/images/2018/08/local.png "local")
接下来人们又遇到一个问题，如何让在不同系统上的开发者协同工作？ 于是，集中化的版本控制系统（Centralized Version Control Systems，简称 CVCS）应运而生。
![img](https://raw.githubusercontent.com/zh1014/zh1014.github.io/master/images/2018/08/centralized.png "centralized")
为了解决单点故障的问题，又有了分布式版本控制系统。即使远端仓库丢失了，拥有本地仓库的人就可以将它恢复。
![img](https://raw.githubusercontent.com/zh1014/zh1014.github.io/master/images/2018/08/distributed.png "distributed")

Git就是一个分布式版本控制系统！

## 开始的方式有两种：
1. 在一个目录下初始化一个本地仓库：
```shell
$ git init 
Initialized empty Git repository in /.git/
$ ls -a
.	..	.git # 本地仓库就在.git下
```
2. 更常用的，直接克隆远端仓库到本地：
```shell
$ git clone https://github.com/xxx/xxx.git
```

## 文件4种状态：
![img](https://raw.githubusercontent.com/zh1014/zh1014.github.io/master/images/2018/08/command.png "command")
`untracked`[未跟踪]:
下面三种都是`tracked`状态。文件刚被创建时就是untracked状态。此时文件内容发生改变也不会被git察觉到。
`staged`[已暂存]:
要commit的文件需要先全部加到staged，再一次性commit，生成一个版本。
`committed`[已提交]:（就是unmodified）
已经安全的保存在了本地仓库中
`modified`[已修改]:
文件修改了，还没有保存到本地仓库中。删除（deleted）也算是一种修改。

## 基本命令
![cb03e2cfa80da1ec8b767c4230a9d245.jpeg](evernotecid://38A90FAA-62B0-4931-83BD-E4CA59841F47/appyinxiangcom/16104284/ENResource/p82)

`git add`
添加到staged。还能用于合并时把有冲突的文件标记为已解决状态等

`git status`
查看modified、staged、untracked状态的文件有哪些

`删除`
```shell
$ git rm <file> # equal to rm <file> & git add <file>
```
当文件是修改过然后存到staged，还需要加-f选项

`tracked->untracked`
```shell
$ git rm --cached <file>
```

`撤销`
```shell
$ git reset
```

`撤销修改(modified->committed)`
```shell
$ git checkout -- <file>

# 撤销删除
$ git reset -- <file>
$ git checkout -- <file>
```

`回溯到以前某个版本`
此操作会丢失当前的进度
```shell
$ git reset --hard <commit-hash-value>
```
