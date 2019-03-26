#!/usr/bin/env bash

#check env

# check git
if [[ $(which git) == "git not found" ]];then
    echo "git not found, please install git or set git to path"
    exit 2
fi

# check go
if [[ $(which go) == "go not found" ]];then
    echo "go not found, please install go or set go to path"
    exit 2
fi

