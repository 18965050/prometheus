#!/bin/sh

export http_proxy=http://username:password@xxx.xxx.xxx.xxx:8080
export https_proxy=https://username:password@xxx.xxx.xxx.xxx:8080
export no_proxy=localhost,127.0.0.1

WEB_HOOK_HOME=/opt/webhook-dingtalk/webhook-dingtalk-0.3.0.linux-amd64
LOG_FILE=/root/log_webhook-dingtakl.log

pgrep -f "webhook-dingtalk"
if [ $? == 0 ]; then
  echo "进程存在，先干掉"
  pkill -f "webhook-dingtalk"
  sleep 1
  pgrep -f "webhook-dingtalk" && echo "进程关闭失败，仍然存在！！" || echo "进程已经关闭！"
else
  echo "进程不存在,直接启动"
fi

#nohup $WEB_HOOK_HOME/prometheus-webhook-dingtalk --ding.timeout=5s --web.listen-address=":8060" --template.file="/etc/prometheus/dingTalkTmpl/xyz.tmpl" --ding.profile="noodle1=https://oapi.dingtalk.com/robot/send?access_token=92d6d00665599a2c917aa7649679acc4b52d69da2fa970bbc0575836d57ba1aa" >$LOG_FILE 2>&1 &

nohup $WEB_HOOK_HOME/prometheus-webhook-dingtalk --ding.timeout=5s --web.listen-address=":8060" --template.file="/etc/prometheus/dingTalkTmpl/xyz.tmpl" \
--ding.profile="khanTest=https://oapi.dingtalk.com/robot/send?access_token=92d6d00665599a2c917aa7649679acc4b52d69da2fa970bbc0575836d57ba1aa" \
--ding.profile="lcgwebhook=https://oapi.dingtalk.com/robot/send?access_token=b4d37fe460e46e39c52aac96a1235b8c701ae964d8941a7a4af0a364be8bd3c6" \
--ding.profile="biz=https://oapi.dingtalk.com/robot/send?access_token=f7cb6ff14768cc1cc030a92ae1033ae8e349c0ec605798a6f30c898d354762c9" \
--ding.profile="dream=https://oapi.dingtalk.com/robot/send?access_token=ed4d80ed6ec89af986992caa46f5cbe21834719ba85e599bf5afe8ef9eb6985f" \
--ding.profile="dreamProd=https://oapi.dingtalk.com/robot/send?access_token=0a975d48dcac00938e4809b1c859037687e21536212c3bcacfca137604bd8fb6" \
 > $LOG_FILE 2>&1 &

sleep 1
pgrep -f "webhook-dingtalk" && echo "进程成功启动。。" || echo "进程启动失败！"
echo ""

cat $LOG_FILE
