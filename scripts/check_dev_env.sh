#!/usr/bin/env bash

#check env
#echo "Start check development env, please wait..."

# check git
if [[ $(which git) == "git not found" ]];then
    echo "git not found, please install git or set git to path"
    exit 2
fi

echo "git           ok!"

# check go
if [[ $(which go) == "go not found" ]];then
    echo "go not found, please install go or set go to path"
    exit 2
fi

echo "go            ok!"

go_path_src=$HOME/go/src/
# check GOPATH/src
if [[ ! -d ${go_path_src} ]];then
    echo "GOPATH/src not found, please create dir: mkdir -p ~/go/src"
    exit 2
fi

echo "GOPATH        ok!"

# check lib
if [[ ! -d ${go_path_src}/github.com/fatih/color ]];then
    go get github.com/fatih/color
fi

if [[ ! -d ${go_path_src}/github.com/gosuri/uiprogress ]];then
    go get github.com/gosuri/uiprogress
fi

#todo 这里还需要补充

echo "lib           ok!"

echo "done!"
