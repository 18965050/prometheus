#!/bin/sh

BLACKBOX_EXPORTER_HOME=/opt/prometheus/exporters/blackbox_exporter_current
LOG_FILE=/root/log_blackbox_exporter.log

pgrep -f "blackbox_exporter -config"
if [ $? == 0 ]; then
  echo "进程存在，先干掉"
  pkill -f "blackbox_exporter --config"
  sleep 1
  pgrep -f "blackbox_exporter --config" && echo "进程关闭失败，仍然存在！！" || echo "进程已经关闭！"
else
  echo "进程不存在,直接启动"
fi

nohup $BLACKBOX_EXPORTER_HOME/blackbox_exporter --config.file=/etc/prometheus/exporters/blackbox.yml > $LOG_FILE 2>&1 &

sleep 1
pgrep -f "blackbox_exporter --config" && echo "进程成功启动。。" || echo "进程启动失败！"
echo ""

cat $LOG_FILE
