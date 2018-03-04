#!/bin/bash -v

# initializing
default_node_version="v8.9.4"
default_npm_version="5.6.0"
default_project_name="web"
read -e -i "$default_node_version" -p "node version: " node_version
read -e -i "$default_npm_version" -p "npm version: " npm_version
read -e -i "$default_project_name" -p "project name: " project_name
echo "intializing $project_name with node $node_version / npm $npm_version ..."

# get template content
function get(){
 input_file=$1
 cat $input_file
}

function tpl_out(){
    template=$1
    output_file=$2    
    get $template | sed s/MVN_WEB_NODE_VERSION/$node_version/g | sed s/MVN_WEB_NPM_VERSION/$npm_version/g | sed s/MVN_WEB_PROJECT_NAME/$project_name/g  | tee $output_file > /dev/null
}

function concat_profiles(){
    output_file=$1
    echo "concat_profiles to $0 $output_file"
    echo '<profilesXml><profiles>' > $output_file
    ls profile.*.xml 
    cat profile.*.xml >> $output_file
    echo '</profiles><activeProfiles/></profilesXml>'  >> $output_file
}

tpl_out "web.tpl.bat" "$project_name.bat"
tpl_out "web.tpl.sh" "$project_name.sh"
tpl_out "profile-name.tpl.xml" "profile.$project_name.xml"

concat_profiles "profiles.xml"
 