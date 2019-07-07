#! /bin/bash

function killContainer () {
   echo "destroying moonlight-switch container..."
   docker kill moonlight-switch > /dev/null
   docker rm moonlight-switch > /dev/null
   echo "container destroyed"
}

function checkMounts () {

    if ! [ -d ./build ]; then
        mkdir ./build
    fi

    if ! [ -d ./dist ]; then
        mkdir ./dist
    fi

    
}

if ! [ -x "$(command -v grep)" ]; then
    echo 'Error: grep is not installed.' >&2
    exit 1
elif ! [ -x "$(command -v docker)"  ]; then
    echo 'Error: docker is not installed.' >&2
    exit 1
fi

checkMounts

if ! (docker build -t moonlight-switch .); then
    exit 1
fi

if [ "$(docker ps | grep moonlight-switch)"  ]; then
    killContainer
fi

if [ "$( docker run -itd --name moonlight-switch \
    --mount type=bind,source="$(pwd)"/data,target=/home/builder/moonlight-switch/data \
    --mount type=bind,source="$(pwd)"/build,target=/home/builder/moonlight-switch/build \
    --mount type=bind,source="$(pwd)"/src,target=/home/builder/moonlight-switch/src \
    --mount type=bind,source="$(pwd)"/dist,target=/home/builder/moonlight-switch/dist \
    --mount type=bind,source="$(pwd)"/assets,target=/home/builder/moonlight-switch/assets \
      moonlight-switch )"  ]; then
    
    echo -e "\e[92mContainer shell session starting...\e[39m"
    docker exec -it moonlight-switch bash

    killContainer

    exit 0
else
    echo "Error: error running moonlight-switch docker container"
    exit 1
fi

#         -v 'data:/home/builder/moonlight-switch/data:rw' \
#         -v 'build:/home/builder/moonlight-switch/build:rw' \
#         -v 'src:/home/builder/moonlight-switch/src:rw' \
#         -v 'dist:/home/builder/moonlight-switch/dist:rw' \
#         -v 'assets:/home/builder/moonlight-switch/assets:rw' \
 
