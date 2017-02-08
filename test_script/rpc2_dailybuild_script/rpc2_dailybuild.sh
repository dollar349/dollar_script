#!/bin/bash
export PATH=~/bin:/usr/sbin:/sbin:/usr/local/bin:$PATH

#=========================
#   Mail list Setting
#=========================
COMPANY="Emerson.com"
#COMPANY="vertivco.com"
#mailList=${mailList}" ""DL-AESS-ASIA-SE-FW2@Emerson.com"
mailList="Dollar.Wang@${COMPANY}"
mailList+="; Ann.Lee@${COMPANY}"
mailList+="; Jacob.Lin@${COMPANY}"
mailList+="; Ken.Lin@${COMPANY}"
mailList+="; Vince.Chang@${COMPANY}"
mailList+="; Sonata.Tsai@${COMPANY}"
mailList+="; Edward.Lin@${COMPANY}"
mailList+="; Archie.Huang@${COMPANY}"
mailList+="; Kelvin.Kao@${COMPANY}"
mailList+="; Rick.Chen@${COMPANY}"
mailList+="; Kevin.Ferguson@${COMPANY}"
mailList+="; Bryan.McDonald@${COMPANY}"

ccList=""
# It will send error message to maintainer if build steps error.
maintainerList="Dollar.Wang@${COMPANY}"
maintainerCCList=""

#============================================
#   Test dailybuild image
#============================================
# If mask "PDU_IP", it will not do test after build successful
PDU_IP="10.162.244.181" 

#============================================
#   User config
#============================================
PRJ_NAME="RPC2"
RPC2_BRANCH="rpc_lima"
P4_USER="WangDollar"
P4_PASSWORD="Emerson02"
Keep_N=180

LOCALIP=`ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1'`
FTP_PATH="ftp://${LOCALIP}/${PRJ_NAME}"

SCRIPT_FOLDER="~/rpc2_dailybuild_script"
eval SCRIPT_FOLDER=${SCRIPT_FOLDER}
UPDATE_SCRIPT="${SCRIPT_FOLDER}/rpc2_update.sh"
BUILD_SCRIPT="${SCRIPT_FOLDER}/rpc2_build.sh"
FWUPDATE_SCRIPT="${SCRIPT_FOLDER}/rpc2_fwupdate.sh"
CHECKARRAYSIZE_SCRIPT="${SCRIPT_FOLDER}/check_array_size.sh"
AVCT_PATCH="avct_patch"
MAIL_TEXT="${SCRIPT_FOLDER}/MailText"

DAILYBUILD_FOLDER="~/dailybuild_${RPC2_BRANCH}"
CACHE_FOLDER="${DAILYBUILD_FOLDER}_CACHE"
WORKSPACE="DailyBuild_rpc2kLinux_${RPC2_BRANCH}"
IMAGE_FOLDER="${DAILYBUILD_FOLDER}/rpc2k/build-rpc2k/tmp/deploy/images/"
eval DAILYBUILD_FOLDER=${DAILYBUILD_FOLDER}
eval CACHE_FOLDER=${CACHE_FOLDER}
eval WORKSPACE=${WORKSPACE}
eval IMAGE_FOLDER=${IMAGE_FOLDER}

DAILY_DATE=`date +%Y_%m_%d`
DAILY_TIME=`date +%02H%02M`
LOCAL_FTP_PATH=/var/ftp/${PRJ_NAME}
DAILY_IMAGE_FTP_FOLDER="${FTP_PATH}/${DAILY_DATE}/${DAILY_TIME}"
DAILY_IMAGE_FOLDER="${LOCAL_FTP_PATH}/${DAILY_DATE}/${DAILY_TIME}"

MAIL_DATE=`date +%Y/%m/%d`

export date_begin
export date_end
export date_spent

#=================================
#   function Inform_maintainer
#=================================
function Inform_maintainer()
{ 
    touch ${MAIL_TEXT}
    echo "To: ${maintainerList}" > ${MAIL_TEXT}
    echo "Subject: ${PRJ_NAME} [${MAIL_DATE}] daily build Error report" >> ${MAIL_TEXT}
    echo 'Content-Type: text/html; charset="us-ascii"' >> ${MAIL_TEXT}
    echo "Cc: ${maintainerCCList}" >> ${MAIL_TEXT}
    echo "" >> ${MAIL_TEXT}
    echo "<html>" >> ${MAIL_TEXT}
    echo "Hi maintainer," >> ${MAIL_TEXT}
    echo "<br><br>Failed Log as below" >> ${MAIL_TEXT}
    echo "<br>***********************************************************</br>" >> ${MAIL_TEXT}
    echo "[${PRJ_NAME}] $1 " >> ${MAIL_TEXT}
    echo "<br>***********************************************************</br>" >> ${MAIL_TEXT}
    echo "<br>Best Regards,</br>" >> ${MAIL_TEXT}
    echo "${PRJ_NAME} Auto Daily Build Script." >> ${MAIL_TEXT}
    echo "</html>" >> ${MAIL_TEXT} 
    /usr/sbin/sendmail ${maintainerList} -c ${maintainerCCList} < ${MAIL_TEXT}
    rm -rf ${MAIL_TEXT}
}

#========================================
#   Maintain latest N days' folders only
#========================================
cd ${LOCAL_FTP_PATH}
N=`ls -1|grep -e '[0-9]'|wc -l`
if [ ${N} -gt ${Keep_N} ]; then
echo "Removing old Backup."
ls -1 | grep -e '[0-9]' | sort -nr | tail -`expr ${N} - ${Keep_N}` | xargs sudo rm -rf
echo "Finished"
fi
cd -

#=========================
#   Perforce Login
#=========================
unset P4PORT
unset P4USER
unset P4CLIENT
if [ -z "${P4PORT}" ] ; then
    P4PORT=ssl:lbrt-perforce.emersonnetworkpower.com:1666
fi

if [ -z "${P4USER}" ] ; then
    P4USER=${P4_USER}
fi

if [ -z "${P4CLIENT}" ] ; then
    P4CLIENT=AVCT
fi
export P4PORT
export P4USER
export P4CLIENT

echo 'yes' | p4 trust
echo ${P4_PASSWORD} | p4 login
while [[ $? == 1 ]]
do
sleep 60
echo "P4 Login Failed, Retry"
echo ${P4_PASSWORD} | p4 login
done


#============================================
#   Mail context setting -- RPC2
#============================================

touch ${MAIL_TEXT}
echo "To: ${mailList}" > ${MAIL_TEXT}
echo "Subject: ${PRJ_NAME} [${MAIL_DATE}] daily build report" >> ${MAIL_TEXT}
echo 'Content-Type: text/html; charset="us-ascii"' >> ${MAIL_TEXT}
echo "Cc: ${ccList}" >> ${MAIL_TEXT}
echo "" >> ${MAIL_TEXT}
echo "<html>" >> ${MAIL_TEXT}
echo "Hi all, " >> ${MAIL_TEXT}
echo "<br><br>${PRJ_NAME} Auto daily build image has been built and available on the server. </br>" >> ${MAIL_TEXT}


#=========================
#   Checkout code
#=========================
PRJ_Revision=`p4 changes -m 1 //ENP/Solutions/Projects/Synthesis/RPC-2000/${RPC2_BRANCH}/... | awk '{print $2}'`
echo "<br>" >> ${MAIL_TEXT}
echo "********** Checkout Log **********</br>" >> ${MAIL_TEXT}
# delete old folder
rm -rf ${DAILYBUILD_FOLDER}
if [[ -d ${CACHE_FOLDER} ]]; then
    # if CACHE_FOLDER exist, copy source code from it then do p4 sync.
    rsync -ar ${CACHE_FOLDER}/ ${DAILYBUILD_FOLDER}
    # call update script do p4 sync
    ${UPDATE_SCRIPT} ${RPC2_BRANCH} ${DAILYBUILD_FOLDER} ${WORKSPACE} ${P4_USER}
    # update cache
    rsync -ar --delete ${DAILYBUILD_FOLDER}/ ${CACHE_FOLDER}
    # copy update log to ${MAIL_TEXT}
    if [[ -e ${DAILYBUILD_FOLDER}/update.log ]]; then
        echo " run p4 sync log as below </br>" >> ${MAIL_TEXT}
        while IFS='' read -r line || [[ -n "$line" ]]; do
        echo "     $line<br>" >> ${MAIL_TEXT}
        done < ${DAILYBUILD_FOLDER}/update.log
    else
        # Error, update.log not exist
        Inform_maintainer "${DAILYBUILD_FOLDER}/update.log not exist"
        exit 1
    fi
else
    #if CACHE_FOLDER not exist, need clone code from server
    date_begin=`date +%s`
    echo 'y'| activate -p rpc2k -b ${RPC2_BRANCH} -d ${DAILYBUILD_FOLDER}/ -c ${WORKSPACE} -u ${P4_USER} -g
    date_end=`date +%s`
    date_spent=$(date -d "00:00:00 $(( ${date_end} - ${date_begin} )) seconds" +"%H:%M:%S")    
    rsync -ar ${DAILYBUILD_FOLDER}/ ${CACHE_FOLDER}
    echo " Cache file not found, so checkout new code </br>" >> ${MAIL_TEXT}
    echo " Checkout code Duration time : ${date_spent}</br>" >> ${MAIL_TEXT}
fi
echo "<br><br>" >> ${MAIL_TEXT}

#=========================
#   Build code
#=========================
echo "********** Build Info **********</br>" >> ${MAIL_TEXT}
echo " Branch    : ${RPC2_BRANCH} </br>" >> ${MAIL_TEXT}
echo " Revision  : ${PRJ_Revision} </br>" >> ${MAIL_TEXT}
echo " WORKSPACE : ${WORKSPACE} </br>" >> ${MAIL_TEXT}
echo " Path of build image & log: </br>" >> ${MAIL_TEXT}
echo " <a href="${DAILY_IMAGE_FTP_FOLDER}">"${DAILY_IMAGE_FTP_FOLDER}"</a></br>" >> ${MAIL_TEXT}

# AVCT PATCH
cp -raf ${SCRIPT_FOLDER}/${AVCT_PATCH} ${DAILYBUILD_FOLDER}/.
cd ${DAILYBUILD_FOLDER}/${AVCT_PATCH} && sh patch.sh
date_begin=`date +%s`
START_TIME=`date '+%Y-%02m-%02d %02H:%02M:%02S TPE(GMT+8)'`
# Start build process
${BUILD_SCRIPT} ${RPC2_BRANCH} ${DAILYBUILD_FOLDER} ${WORKSPACE} ${P4_USER}
date_end=`date +%s`
date_spent=$(date -d "00:00:00 $(( ${date_end} - ${date_begin} )) seconds" +"%H:%M:%S")
# Create FTP daily folder
sudo mkdir -p ${DAILY_IMAGE_FOLDER}
if [[ -e ${DAILYBUILD_FOLDER}/build.log ]]; then
    sudo cp -raf ${DAILYBUILD_FOLDER}/build.log ${DAILY_IMAGE_FOLDER}/.
else
    # Error, build.log not exist
    Inform_maintainer "${DAILYBUILD_FOLDER}/build.log not exist"
fi
# check image exist
APPFWDBFILE=`ls ${IMAGE_FOLDER} | grep AppFwUpdt_DB.bin`
if [[ "${APPFWDBFILE}" != "" ]]; then
    echo "Build ${PRJ_NAME}[${RPC2_BRANCH}] daily image - <font color="blue"><b>SUCCESS! </b></font></br>" >> ${MAIL_TEXT}
    sed -i '/^Subject/s/report/ [SUCCESS] report/' ${MAIL_TEXT}
    echo "Build process Starting time : ${START_TIME}</br>" >> ${MAIL_TEXT}
    echo "Build process Duration time : ${date_spent}</br>" >> ${MAIL_TEXT}
    sudo cp -raf ${IMAGE_FOLDER}/* ${DAILY_IMAGE_FOLDER}/.
    if [[ ${PDU_IP} != "" ]]; then
        # test daily build firmware
        echo "<I>Image test result</I></br>" >> ${MAIL_TEXT}         
        FIRMWARE_FILE_NAME=`ls ${DAILY_IMAGE_FOLDER}/*AppFwUpdt_DB.bin | awk -F"/"  '{ print $NF}'`
        ssh-keygen -f ~/.ssh/known_hosts -R ${PDU_IP}
        ${FWUPDATE_SCRIPT} ${PDU_IP} ${LOCALIP} ${DAILY_IMAGE_FOLDER} ${FIRMWARE_FILE_NAME}
        if [[ $? == 0 ]]; then
            echo "Update...done (PDU IP ${PDU_IP})</br>" >> ${MAIL_TEXT}
            sleep 600
            ssh-keygen -f ~/.ssh/known_hosts -R ${PDU_IP}
            ${CHECKARRAYSIZE_SCRIPT} ${PDU_IP} 1
            if [[ $? == 0 ]]; then
                echo "Check receptacle state...done</br>" >> ${MAIL_TEXT}
            else
                echo "Check receptacle state...<font color="#FF0000">FAIL!</font></br>" >> ${MAIL_TEXT}
            fi
        else
            echo "Update...<font color="#FF0000">FAIL!</font></br>" >> ${MAIL_TEXT}
        fi
    fi
else
    echo "Build ${PRJ_NAME}[${RPC2_BRANCH}] daily image - <font color="#FF0000"><b>FAIL! </b></font></br>" >> ${MAIL_TEXT}
    sed -i '/^Subject/s/report/ [FAIL] report/' ${MAIL_TEXT}
    echo "Build process Starting time : ${START_TIME}</br>" >> ${MAIL_TEXT}
    echo "Build process Duration time : ${date_spent}</br>" >> ${MAIL_TEXT}
fi

echo "<br><br>" >> ${MAIL_TEXT}
echo "<br>Best Regards,</br>" >> ${MAIL_TEXT}
echo "${PRJ_NAME} Auto Daily Build Script." >> ${MAIL_TEXT}
echo "</html>" >> ${MAIL_TEXT} 
/usr/sbin/sendmail ${mailList} -c ${ccList} < ${MAIL_TEXT}
rm -rf ${MAIL_TEXT}


