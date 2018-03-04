#!/bin/bash

function sourceme(){
   echo "source me :"
   echo ". $0"
   exit 42
}

[[ $_ != $0 ]] || sourceme

NODE_HOME=$(pwd)/src/web/node_modules/.node/node
PATH=$(pwd)/src/web/node_modules/.bin:$NODE_HOME:$PATH
echo now running node $(node --version) and npm $(npm -version)
cd src/web
echo have fun !