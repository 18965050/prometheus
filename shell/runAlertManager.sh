#!/bin/sh

ALERT_MANAGER_HOME=/opt/alertmanager/alertmanager-0.15.2
LOG_FILE=/root/log_alertmanager.log

pgrep -f "alertmanager --config"
if [ $? == 0 ]; then
  echo "进程存在，先干掉"
  pkill -f "alertmanager --config"
  sleep 1
  pgrep -f "alertmanager --config" && echo "进程关闭失败，仍然存在！！" || echo "进程已经关闭！"
else
  echo "进程不存在,直接启动"
fi

$ALERT_MANAGER_HOME/amtool check-config /etc/prometheus/alertmanager.yml
if [ $? != 0 ]; then
  echo "配置文件校验不通过, 请检查配置文件"
  exit 1
else
  echo "配置文件校验通过"
fi

nohup $ALERT_MANAGER_HOME/alertmanager --config.file=/etc/prometheus/alertmanager.yml --storage.path=$ALERT_MANAGER_HOME/data --data.retention=120h --web.external-url=http://am.xyz.d/ > $LOG_FILE 2>&1 &

sleep 1
pgrep -f "alertmanager --config" && echo "进程成功启动。。" || echo "进程启动失败！"
echo ""

cat $LOG_FILE
