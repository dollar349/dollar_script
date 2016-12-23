#!/bin/sh
# USER Config
TARGET_PDU_IP="126.4.10.89"
CONTROL_PDU_IP="126.4.10.96"
CONTROL_RECEPTACLE="1.B.7"

#POWER_XXX_WAIT_TIME unit is seconde
POWER_OFF_WAIT_TIME=90
POWER_ON_WAIT_TIME=300
#PWER_XXX_ERROR_CHECK_TIMES is 1 minute interval, if over it, this script will exit (1)
POWER_OFF_ERROR_CHECK_TIMES=5
POWER_ON_ERROR_CHECK_TIMES=5

PASSCOUNT=0
ERRCOUNT=0
LOG_FILE=RPC2_`date +%Y%02m%02d_%02H%02M%02S`.log

ssh-keygen -f ~/.ssh/known_hosts -R ${TARGET_PDU_IP}
ssh-keygen -f ~/.ssh/known_hosts -R ${CONTROL_PDU_IP}
#CURRENT_TIME=`date +%Y/%m/%d\ %H:%M:%S`
./check_array_size.sh ${TARGET_PDU_IP} 4
if [[ $? == 1 ]]; then
    echo "${TARGET_PDU_IP} array not ready"
    exit 1
fi
echo "###############  START TEST  ###############"
echo "`date +%Y/%m/%d\ %H:%M:%S` -- START Test" > ${LOG_FILE}
while [ 1 ]
do
        echo "Turn-Off receptacle ${CONTROL_RECEPTACLE}"
        echo "`date +%Y/%m/%d\ %H:%M:%S` -- 1.Turn-Off receptacle ${CONTROL_RECEPTACLE}" >> ${LOG_FILE}
        ./receptaclestate_ctl.sh ${CONTROL_PDU_IP} ${CONTROL_RECEPTACLE} Off
        sleep ${POWER_OFF_WAIT_TIME}
        echo "Check array"
        ERRCOUNT=0
        ./check_array_size.sh ${TARGET_PDU_IP} 2        
        while [[ $? == 0 ]]
        do
            echo "PDU array still alive"
            echo "`date +%Y/%m/%d\ %H:%M:%S` -- PDU array still alive" >> ${LOG_FILE}
            (( ERRCOUNT++ ))
            if (( ${ERRCOUNT} > ${POWER_OFF_ERROR_CHECK_TIMES} )); then
                echo "`date +%Y/%m/%d\ %H:%M:%S` -- Test Failed : PDU array still alive , PASS COUNT = ${PASSCOUNT}" >> ${LOG_FILE}
                exit 1;
            fi            
            sleep 60
            ./check_array_size.sh ${TARGET_PDU_IP} 2
        done
        echo "Turn-On receptacle ${CONTROL_RECEPTACLE}"
        echo "`date +%Y/%m/%d\ %H:%M:%S` -- Turn-On receptacle ${CONTROL_RECEPTACLE}" >> ${LOG_FILE}
        ./receptaclestate_ctl.sh ${CONTROL_PDU_IP} ${CONTROL_RECEPTACLE} On

        echo "Sleep ${POWER_ON_WAIT_TIME} & Check array return"
        sleep ${POWER_ON_WAIT_TIME}
        ERRCOUNT=0
        ./check_array_size.sh ${TARGET_PDU_IP} 4
        while [[ $? == 1 ]]
        do
            echo "PDU array not return"
            echo "`date +%Y/%m/%d\ %H:%M:%S` -- PDU array not return" >> ${LOG_FILE}
            (( ERRCOUNT++ ))
            if (( ${ERRCOUNT} > ${POWER_ON_ERROR_CHECK_TIMES} )); then
                echo "`date +%Y/%m/%d\ %H:%M:%S` -- Test Failed : PDU array not return , PASS COUNT = ${PASSCOUNT}" >> ${LOG_FILE}
                exit 1;
            fi               
            sleep 60
            ./check_array_size.sh ${TARGET_PDU_IP} 4
        done
       
        (( PASSCOUNT++ ))
        echo "PASS ${PASSCOUNT}"
        echo "`date +%Y/%m/%d\ %H:%M:%S` -- PASS ${PASSCOUNT}" >> ${LOG_FILE}
done


