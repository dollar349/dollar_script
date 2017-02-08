#!/bin/bash
export PATH=~/bin:/usr/sbin:/sbin:/usr/local/bin:$PATH

#=========================
#   Mail list Setting
#=========================
COMPANY="Emerson.com"
#COMPANY="vertivco.com"
#mailList=${mailList}" ""DL-AESS-ASIA-SE-FW2@Emerson.com"
mailList="Dollar.Wang@${COMPANY}"

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
P4_USER="LinKen"
P4_PASSWORD="P@ssw0rd4"
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
echo ${P4_PASSWORD} | p4 login
done





