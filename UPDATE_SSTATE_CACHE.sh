#!/bin/sh
DATA=`date -u +%m%d_%H%M`
BACKUP_NAME="sstate-cache_"$DATA
# component needed compiled every time
    component_name=`ls ../meta-icom-cms/recipes-backend/ ; ls ../meta-icom-cms/recipes-icom-cms-ui/ ; ls ../meta-icom-cms/recipes-support/ ; ls ../meta-icom-cms/recipes-patches/ ; ls ../meta-icom-cms/recipes-cloudclient`
    component_name+=" rpm-native"    
    component_name+=" luajit-native"
    component_name+=" luajit-openresty-native"
echo "=======> Generate sstate-cache.tgz "
    if [ ! -f pattern.log ];then
        touch pattern.log
    else
        rm pattern.log
    fi
	
    for component in $component_name
    do
        exclude_component_pattern="*$component*"
        echo "$exclude_component_pattern" >> pattern.log
    done
    
    tar cf sstate-cache.tgz sstate-cache/ -X pattern.log

    # varify the component is tared to tarball
    #tar -tvf sstate-cache.tgz |grep lcdconf
    #tar -tvf sstate-cache.tgz |grep ssiplugins	
echo "=======> backup old sstate-cache, save name to $BACKUP_NAME  "
mv /sys_home/space_for_http_server/sstate-cache /sys_home/space_for_http_server/$BACKUP_NAME && \
echo "=======> untar new sstate-cache  " && \
tar xf sstate-cache.tgz -C /sys_home/space_for_http_server/
