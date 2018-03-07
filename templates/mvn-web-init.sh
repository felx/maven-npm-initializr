#!/bin/bash

# config
web_maven_project_root=frontend.build

# initializing
default_node_version="v8.9.4"
default_npm_version="5.6.0"
default_project_name="web"
read -e -i "$default_node_version" -p "node version: " node_version
read -e -i "$default_npm_version" -p "npm version: " npm_version
read -e -i "$default_project_name" -p "project name: " project_name
echo "intializing $project_name with node $node_version / npm $npm_version ..."

mkdir -p "$web_maven_project_root/$project_name"
frontend_modules=$(cd $web_maven_project_root; echo  */ | sed 's,/,,g' | tr ' ' '\n' | sed 's,\(.*\),<module>\1</module>,g' )

# get template content
function get(){
 input_file=$1
 cat $input_file
}

function tpl_out(){
    template=$1
    output_file=$2
    get $template | sed s/MVN_WEB_NODE_VERSION/$node_version/g  | \
        sed s/MVN_WEB_NPM_VERSION/$npm_version/g | \
        sed s/MVN_WEB_PROJECT_NAME/$project_name/g | \
        tee $output_file > /dev/null 
}

tpl_out "web.tpl.bat" "$project_name.bat"
tpl_out "web.tpl.sh" "$project_name.sh"
tpl_out "pom.tpl.xml" "$web_maven_project_root/$project_name/pom.xml"

# fixme : bof
function rebuild_frontend_parent_pom(){
    pom_file=$1    
    pom_header='<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd"> <modelVersion>4.0.0</modelVersion><groupId>frontend</groupId><artifactId>builds</artifactId><version>1.0.0-SNAPSHOT</version><packaging>pom</packaging><modules>'
    pom_footer='</modules></project>'    
    echo $pom_header > $pom_file
    echo $frontend_modules  >> $pom_file
    echo $pom_footer >> $pom_file
}

rebuild_frontend_parent_pom "$web_maven_project_root/pom.xml"

echo "frontend maven project maven-frontend-$project_name : ./$web_maven_project_root/$project_name/pom.xml"
echo "frontend env setup scripts : ./$project_name.bat and ./ $project_name.sh"
echo "adds these files to your project directory"
echo "TODO : exec maven plugin to build frontend"
echo "to initialize, run : "
echo "mvn -f "$web_maven_project_root/$project_name" -P maven-frontend-$project_name com.github.eirslett:frontend-maven-plugin:install-node-and-npm"