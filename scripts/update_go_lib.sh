#!/usr/bin/env bash

# check git
if [[ $(which git) == "git not found" ]];then
    echo "git not found, please install git or set git to path"
    exit 2
fi

go_path_src=$HOME/go/src/

# check GOPATH/src
if [[ ! -d ${go_path_src} ]];then
    echo "GOPATH/src not found, please create dir: mkdir -p ~/go/src"
    exit 2
fi

# check go/src/golang.org
if [[ ! -d ${go_path_src}/golang.org ]];then
    # create dir golang.org
    mkdir -p ${go_path_src}/golang.org
fi

x_path=${go_path_src}/golang.org/x

# check golang.org 下 x
if [[ ! -d ${x_path} ]];then
    # create dir golang.org
    mkdir -p ${x_path}
fi


function progress_bar () {

for ((i=0; i<$1; i ++))
do
	printf "[%-100s %d%% %c]\r" "$str" "$num" "${pro[$index]}"
	let num++
    sleep 0.1
    str+='#'
done
printf "\r                                                                                                             \r"
}

update_or_clone_x_lib () {

    if [[ ! $1 ]];then
        echo "error! tell me what you want update or clone"
        exit 2
    fi

    echo "================= $1 ================="
    if [[ ! -d ${x_path}/$1 ]];then
        # clone net
        cd ${x_path}
        git clone https://github.com/golang/$1.git -q
    else
        # update net
        cd ${x_path}/$1
        git pull
        cd ${x_path}
    fi
#    echo "======================================"
    echo "  "

    return $?
}

# 开始更新或者下载go 官方lib

echo "Start update or clone golang/x/, please wait..."
echo "  "

num=0
str='#'
max=100
pro=('|' '/' '-' '\')
let index=num%4
#update_or_clone_x_lib

## net
update_or_clone_x_lib net &

progress_bar 5

wait

## tools
update_or_clone_x_lib tools &

progress_bar 15

wait

## text
update_or_clone_x_lib text &

progress_bar 5

wait

## sys
update_or_clone_x_lib sys &

progress_bar 15

wait

## lint
update_or_clone_x_lib lint &

progress_bar 20

wait

## crypto
update_or_clone_x_lib crypto &

progress_bar 20

wait

## time
update_or_clone_x_lib "time" &

progress_bar 10

wait

### perf
#update_or_clone_x_lib perf
#
### review
#update_or_clone_x_lib review

## image
update_or_clone_x_lib image &

progress_bar 10

wait

echo "================= finish ================="




