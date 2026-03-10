#!/bin/bash

USER=$(whoami)

# ===== 路径 =====
V2BX_PATH="/home/${USER}/1"
V2NODE_PATH="/home/${USER}/2"

# ===== 启动命令 =====
CRON_V2BX="nohup ${V2BX_PATH}/V2bX server -c ${V2BX_PATH}/config.json >/dev/null 2>&1 &"
CRON_V2NODE="nohup ${V2NODE_PATH}/v2node server -c ${V2NODE_PATH}/config.json >/dev/null 2>&1 &"

echo "检查并添加V2bX v2node的任务"

# ===== 同时存在配置文件才启用 =====
if [ -e "${V2BX_PATH}/config.json" ] && [ -e "${V2NODE_PATH}/config.json" ]; then

  # ---------- 开机自启 ----------
  (crontab -l | grep -F "@reboot pkill -kill -u ${USER} && ${CRON_V2BX} && ${CRON_V2NODE}") || \
    (crontab -l; echo "@reboot pkill -kill -u ${USER} && ${CRON_V2BX} && ${CRON_V2NODE}") | crontab -

  # ---------- V2bX 保活 ----------
  (crontab -l | grep -F "pgrep -x \"V2bX\"") || \
    (crontab -l; echo "*/12 * * * * pgrep -x \"V2bX\" > /dev/null || ${CRON_V2BX}") | crontab -

  # ---------- v2node 保活 ----------
  (crontab -l | grep -F "pgrep -x \"v2node\"") || \
    (crontab -l; echo "*/12 * * * * pgrep -x \"v2node\" > /dev/null || ${CRON_V2NODE}") | crontab -

else
  echo "缺少 config.json，未添加 crontab"
fi

echo "致谢：hsx"
