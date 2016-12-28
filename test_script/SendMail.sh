#!/bin/bash

export PATH=~/bin:/usr/sbin:/sbin:/usr/local/bin:$PATH

PRJ_NAME="RPC2"

ROOT_PATH=/home/dailybuild/
DAILY_BUILD=/home/chester/daily_build/icom-cms/
LOCAL_IMG_FOLDER=/home/chester/daily_image/icom-cms
DAILY_DATE=`date +%Y_%m_%d`
MAIL_DATE=`date +%Y/%m/%d`
IMAGE_FOLDER=/var/ftp/${PRJ_NAME}
LOCALIP=`ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1'`
FTP_PATH="ftp://${LOCALIP}/${PRJ_NAME}"

Keep_N=30



#=========================
#Mail list Setting
#=========================
#mailList=${mailList}" ""DL-AESS-ASIA-SE-FW2@Emerson.com"
mailList="Dollar.Wang@Emerson.com"

ccList=""


#============================================
#Mail context setting -- icom-cms
#============================================
cd ${ROOT_PATH}
touch mailTexticom
echo "To: ${mailList}" > mailTexticom
echo "Subject: ${PRJ_NAME} [${MAIL_DATE}] daily build report" >> mailTexticom
echo 'Content-Type: text/html; charset="us-ascii"' >> mailTexticom
echo "Cc: ${ccList}" >> mailTexticom
echo "" >> mailTexticom
echo "<html>" >> mailTexticom
echo "Hi all ," >> mailTexticom
echo "<br>${PRJ_NAME} Auto daily build image has been built and available on the server. </br>" >> mailTexticom

#============================================
#icom-cms build info
#============================================
echo "<br>*************************Build info**************************</br>" >> mailTexticom
#echo "Repostitory : <a href="https://npusgithub.emrsn.org/ConvergedSystems/icom-cms">"https://npusgithub.emrsn.org/ConvergedSystems/icom-cms"</a>" >> mailTexticom
#echo "<br>Commit Hash Tag = ${Commit_Hash_TAG}</br>" >> mailTexticom

#============================================
#icom-cms build and log path
#============================================
echo "<br>Path of build image & log:</br>" >> mailTexticom
echo "<a href="${FTP_PATH}">"${FTP_PATH}"</a>" >> mailTexticom

#============================================
#Check if icom-cms build success
#============================================
#cd ${LOCAL_IMG_FOLDER}/${DAILY_DATE}
#if [ -e avct-img_*.xbp ];then
#cd ${ROOT_PATH}
#echo "<br>Build icom-cms Master daily image - SUCCESS! </br>" >> mailTexticom
#echo "Build process Duration time : ${date_spent}" >> mailTexticom
#else
#cd ${ROOT_PATH}
#echo "<br>Build icom-cms Master daily image - FAIL! </br>" >> mailTexticom
#echo "Build process Duration time : ${date_spent}" >> mailTexticom
#fi
echo "<br>***********************************************************</br>" >> mailTexticom

#============================================
#coverity analysis info
#============================================
#cd ${ROOT_PATH}
#echo "<br>**********************Coverity analysis***********************</br>" >> mailTexticom
#echo "Coverity analysis Duration time : ${date_spent2} " >> mailTexticom
#echo "<br>***********************************************************</br>" >> mailTexticom

#============================================
#Total duration time
#============================================
#echo "<br>***********************************************************</br>" >> mailTexticom
#echo "Total Duration time : ${date_spent3}" >> mailTexticom
#echo "<br>***********************************************************</br>" >> mailTexticom

#============================================
#Coverity server Login account info
#============================================
#echo "<br>*****************Coverity server info*******************</br>" >> mailTexticom
#echo "Coverity server IP address: <a href="http://10.203.53.21:8080">"http://10.203.53.21:8080"</a>" >> mailTexticom
#echo "<br>Login UserName : Your Company Domain User Name</br>" >> mailTexticom
#echo "Password : Your Company Domain Password</br>" >> mailTexticom
#echo "Project Name : TPE icomcms </br>" >> mailTexticom
#echo "Stream Name : icomcms" >> mailTexticom
#echo "<br>****************************************************</br>" >> mailTexticom
echo "<br>Best Regards,</br>" >> mailTexticom
echo "${PRJ_NAME} Auto Daily Build Script." >> mailTexticom
echo "</html>" >> mailTexticom

#============================================
#Send mail to notify
#============================================
/usr/sbin/sendmail ${mailList} -c ${ccList} < mailTexticom
rm mailTexticom
