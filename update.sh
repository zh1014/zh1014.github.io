#! /bin/sh
cd ~/go/src/github.com/zh1014/zh1014.github.io/myblog/
rm -rf ./public
hugo
cd ..
shopt -s extglob
git rm -rf ./!(myblog|README.md|.gitignore|.nojekyll|update.sh)
shopt -u extglob
mv ./myblog/public/*  .
git add ./*
git commit -m "update blog"
git push origin master:master