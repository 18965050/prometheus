#!/bin/sh

PROMETHEUS_HOME=/opt/prometheus/prometheus-2.3.2
LOG_FILE=/root/log_prometheus.log

pgrep -f "prometheus --config"
if [ $? == 0 ]; then
  echo "进程存在，先干掉"
  pkill -f "prometheus --config"
  sleep 1
  pgrep -f "prometheus --config" && echo "进程关闭失败，仍然存在！！" || echo "进程已经关闭！"
else
  echo "进程不存在,直接启动"
fi

# 验证配置和告警文件是否正确
$PROMETHEUS_HOME/promtool check config /etc/prometheus/prometheus.yml
if [ $? != 0 ]; then
  echo "配置文件校验不通过, 请检查"
  exit 1
else
  echo "配置文件校验通过"
fi

$PROMETHEUS_HOME/promtool check rules /etc/prometheus/rules/*.yml
if [ $? != 0 ]; then
  echo "规则文件校验不通过, 请检查"
  exit 1
else
  echo "规则文件校验通过"
fi

nohup $PROMETHEUS_HOME/prometheus --config.file=/etc/prometheus/prometheus.yml \
--storage.tsdb.path=$PROMETHEUS_HOME/data \
--storage.tsdb.retention=15d \
--web.enable-lifecycle \
--web.enable-admin-api \
--web.external-url=http://pt.xyz.d/ > $LOG_FILE 2>&1 &

sleep 1
pgrep -f "prometheus --config" && echo "进程成功启动。。" || echo "进程启动失败！"
echo ""

cat $LOG_FILE
