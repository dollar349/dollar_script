#!/bin/bash

SSMTP_CFG="ssmtp.conf"
mailList="dollar.wang@vertiv.com,ben.chuang@vertiv.com"
SENDER="DollarTest@Mytest"
MAIL_NAME="Dollar Title"
MAIL_TEXT="MailText"
ccList=""

#============================================
#   Mail config setting
#============================================
echo "#" > $SSMTP_CFG
echo "# SSMTP configuration file." >> $SSMTP_CFG
echo "#" >> $SSMTP_CFG
echo "MailHub=ap-smtp.int.vertivco.com" >> $SSMTP_CFG
echo "UseTLS=no" >> $SSMTP_CFG
echo "UseSTARTTLS=no" >> $SSMTP_CFG
echo "FromLineOverride=yes" >> $SSMTP_CFG

#============================================
#   Mail context setting 
#============================================
echo "To: ${mailList}" > ${MAIL_TEXT}
echo "Subject: [Dollar] Hello!!!" >> ${MAIL_TEXT}
echo 'Content-Type: text/html; charset="us-ascii"' >> ${MAIL_TEXT}
echo "Cc: ${ccList}" >> ${MAIL_TEXT}
echo "" >> ${MAIL_TEXT}
echo "<html>" >> ${MAIL_TEXT}
echo "My mail test:" >> ${MAIL_TEXT}
echo "<b style="color:#00FF00"> SUCCESS</b><br>" >> ${MAIL_TEXT}
echo "<tbody><table>" >> ${MAIL_TEXT}
echo "Send mail test <br>" >> ${MAIL_TEXT}
echo "<tbody><table>" >> ${MAIL_TEXT}
echo "<br>Best Regards,<br>" >> ${MAIL_TEXT}
echo "</html>" >> ${MAIL_TEXT}


/usr/sbin/ssmtp -F ${MAIL_NAME} -f ${SENDER} -C ${SSMTP_CFG} ${mailList} < ${MAIL_TEXT}

rm -rf ${SSMTP_CFG} ${MAIL_TEXT}
