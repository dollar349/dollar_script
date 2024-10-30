#!/bin/bash

# 設定參數
TARGET="192.168.88.145"  # 測試目標 IP，可以更改為你要測試的目標
INTERVAL=1        # ping 的間隔秒數
TIMEOUT=1         # ping 的回應超時秒數

# 初始化變數
LOSS_COUNT=0
LAST_SUCCESS=$(date +%s)
TOTAL_TIME=0

echo "開始 ping 測試目標: $TARGET"
echo "如果中斷會記錄連線失敗的次數與經過時間"

while true; do
    # 執行 ping 指令，只 ping 一次並設定超時時間
    if ping -c 1 -W $TIMEOUT $TARGET > /dev/null; then
        # ping 成功
        echo "$(date): $TARGET 連線正常"
        LAST_SUCCESS=$(date +%s) # 記錄最後成功的時間
    else
        # ping 失敗
        echo "$(date): $TARGET 無回應，連線失敗"
        LOSS_COUNT=$((LOSS_COUNT + 1)) # 計算失敗次數
        CURRENT_TIME=$(date +%s)
        TIME_DIFF=$((CURRENT_TIME - LAST_SUCCESS))
        echo "從上次連線成功到現在已經中斷了 $TIME_DIFF 秒"
    fi

    # 等待設定的間隔時間再繼續下一次 ping
    sleep $INTERVAL
done

