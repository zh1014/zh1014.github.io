---
title: "Git阅读笔记"
date: 2018-08-28T19:33:59+08:00
draft: false
tags: ["Git"]
categories: ["工具"]
---

### 状态
git本地状态图:
![img](https://raw.githubusercontent.com/zh1014/zh1014.github.io/master/images/git本地状态图.png "git本地状态图")

生命周期 https://git-scm.com/book/en/v2/images/lifecycle.png

### 个人笔记（散乱）
**git add**

添加内容到下一次提交中（我想就是指加到staged中）：可以是untrack->staged 或 modified -> staged。另外，还能用于合并时把有冲突的文件标记为已解决状态等

**git status**

Changes to be committed：已暂存状态

Changes not staged for commit ：已跟踪文件的内容发生了变化

**git rm**

（不在暂存区：）首先我们知道发生任何modify都应该用git add来告诉暂存区。如果直接rm已跟踪文件，同样是一个modify，不同的是这个情况下modify却不能用git add来告诉git发生了什么变化，于是有了git rm。git rm 才是删除的标准操作，而不是rm；但用了rm，可以再用一次git rm  进行纠正

（暂存区：）如果删除之前修改过并且已经放到暂存区域的话，则必须要用强制删除选项 -f

### 分支
- git branch <分支>      创建分支
- git branch -d <分支>   删除分支

相关命令：

git checkout <分支>   切换到此分支，-b则创建并切换过去
```
git checkout -b <分支> 
等于下面组合：
git branch <分支>  
git checkout <分支>
```
git merge <分支>  合并此分支与当前分支

- git branch 所有分支列表，-v可列出最后一次提交，--merged 与--no-merged过滤这个列表中已经合并或尚未合并到当前分支的分支