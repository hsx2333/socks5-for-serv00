#!/bin/bash

USER=$(whoami)

# ===== 路径 =====
V2BX_PATH="/home/${USER}/1"

# ===== 启动命令 =====
CRON_V2BX="nohup ${V2BX_PATH}/V2bX server -c ${V2BX_PATH}/config.json >/dev/null 2>&1 &"

echo "检查并添加 V2bX 的 crontab 保活任务"

if [ -e "${V2BX_PATH}/config.json" ]; then

  # ---------- 开机自启 ----------
  (crontab -l | grep -F "@reboot pkill -kill -u ${USER} && ${CRON_V2BX}") || \
    (crontab -l; echo "@reboot pkill -kill -u ${USER} && ${CRON_V2BX}") | crontab -

  # ---------- V2bX 保活 ----------
  (crontab -l | grep -F "pgrep -x \"V2bX\"") || \
    (crontab -l; echo "*/12 * * * * pgrep -x \"V2bX\" > /dev/null || ${CRON_V2BX}") | crontab -

  echo "V2bX 保活任务已配置完成"

else
  echo "未找到 ${V2BX_PATH}/config.json，未添加 crontab"
fi

echo "致谢：hsx"
