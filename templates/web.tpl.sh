#!/bin/bash

project=MVN_WEB_PROJECT_NAME

function sourceme(){
   echo "source me :"
   echo ". $0"
   exit 42
}

[[ $_ != $0 ]] || sourceme

NODE_HOME=$(pwd)/src/$project/node_modules/.node/node
PATH=$(pwd)/src/$project/node_modules/.bin:$NODE_HOME:$PATH
echo now running node $(node --version) and npm $(npm -version)
cd src/$project
echo have fun !