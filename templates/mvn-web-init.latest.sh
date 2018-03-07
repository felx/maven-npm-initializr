#!/bin/bash

echo $project_name
if [ "$project_name" = "" ]
then
echo "ERROR : env variable project_name missing"
echo "set var project_name BEFORE bash call e.g.:"
echo "curl https://raw.githubusercontent.com/felx/maven-npm-initializr/stage/templates/mvn-web-init.latest.sh | project_name=ionic bash"
exit -1
fi

# config
web_root="https://raw.githubusercontent.com/felx/maven-npm-initializr/stage"
maven_project_root=frontend.build


# initializing
node_version="v8.9.4"
npm_version="5.6.0"

echo "intializing $project_name with node $node_version / npm $npm_version ..."


mkdir -p "$maven_project_root/$project_name"
frontend_modules=$(cd $maven_project_root; echo  */ | sed 's,/,,g' | tr ' ' '\n' | sed 's,\(.*\),<module>\1</module>,g' )

# get template content
function get(){
 template=$1
 echo curl "$web_root/templates/$template" >> urls.txt
 curl "$web_root/templates/$template"
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
tpl_out "pom.tpl.xml" "$maven_project_root/$project_name/pom.xml"

# fixme : bof
function rebuild_frontend_parent_pom(){
    pom_file=$1    
    pom_header='<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd"> <modelVersion>4.0.0</modelVersion><groupId>frontend</groupId><artifactId>builds</artifactId><version>1.0.0-SNAPSHOT</version><packaging>pom</packaging><modules>'
    pom_footer='</modules></project>'    
    echo $pom_header > $pom_file
    echo $frontend_modules  >> $pom_file
    echo $pom_footer >> $pom_file
}

rebuild_frontend_parent_pom "$maven_project_root/pom.xml"

echo "frontend maven project maven-frontend-$project_name : ./$maven_project_root/$project_name/pom.xml"
echo "frontend env setup scripts : ./$project_name.bat and ./ $project_name.sh"
echo "adds these files to your project directory"
echo "TODO : exec maven plugin to build frontend"
echo "to initialize, run : "
echo "mvn -f "$maven_project_root/$project_name" -P maven-frontend-$project_name com.github.eirslett:frontend-maven-plugin:install-node-and-npm"