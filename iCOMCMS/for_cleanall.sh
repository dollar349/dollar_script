#/bin/sh
REBUILD_LIST="luajit-openresty-native rpm-native openssh openresty redis jansson lua-resty-http lapis lua-resty-random redfishschema lua-cmsgpack md5 "
REBUILD_LIST+="stingray libevent ssi cloudclient "
REBUILD_LIST+="accountlib "
REBUILD_LIST+="asmlib tzdata "
REBUILD_LIST+="fw-update "
REBUILD_LIST+="lcdconf netconflib librs485 icombackend icomstartup bridgeD "
REBUILD_LIST+="ledcontrol ssiplugins "
REBUILD_LIST+="icom-cms-ui fndry-mcp dhcp dnsmasq initscripts networkmanager ntp "
REBUILD_LIST+="icomcms-image"

for i in $REBUILD_LIST
do
   bitbake -c cleanall $i
   #echo $?
   if [ $? == "1" ]; then
       echo "failed to clean $i";
       break;
   fi
done

