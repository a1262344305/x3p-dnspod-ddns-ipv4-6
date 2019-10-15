#!/bin/sh
mount -o remount,rw /
export PATH=/bin:/sbin:/usr/bin:/usr/sbin

function menu_install(){
echo -e "  DnsPod Ddns一键安装脚本
  ---- By:方块君 ----

  (1) 安装 DnsPod Ddns
  (2) 卸载 DnsPod Ddns
  (3) 退出
 "
 numsr
}

function menu_uinstall(){
echo -e "  DnsPod Ddns一键安装脚本
  ---- By:方块君 ----

  (1) 安装 DnsPod Ddns(已安装)
  (2) 卸载 DnsPod Ddns
  (3) 退出
 "
 numsr
}
function numsr(){
echo && stty erase '^H' && read -p "请输入数字 [1-3]：" num
case "$num" in
	1)
	Install
	;;
	2)
	Uninstall
	;;
	2)
	quit
	;;
esac
}
function Install(){
read -p "是否为Ipv6:[yes或no]" ipv64

if [ ipv64 == "no" ];then
	Installv4
fi
cp /etc/nginx/onespace.conf /etc/nginx/onespace.conf.bak
read -p "是否要绑定域名:[默认空]" cs
read -p "ipv6端口:[默认80]" port
if [ -z "$cs" ];then
	port = "80"
fi
if [ -z "$cs" ];then
	sed -i "s/listen 80;/listen 80;\r\n    listen [::]:$port;\r\n    ipv6only=on;/g" /etc/nginx/onespace.conf
else
	sed -i "s/listen 80;/listen 80;\r\n    listen [::]:$port;\r\n    ipv6only=on;\r\n    server_name $cs;/g" /etc/nginx/onespace.conf
fi
wget -c https://raw.githubusercontent.com/Squaregentleman/x3p-dnspod-ddns-ipv4-6/master/ddns_ipv6.py -O ddns.py
read -p "Id:[Id]" id
if [ -z "$id" ];then
	echo "id不能为空！"
	exit
else
	sed -i "s/loginid/$id/g" ddns.py
fi
read -p "Token:" token
if [ -z "$token" ];then
	echo "token不能为空！"
	exit
else
	sed -i "s/logintoken/$token/g" ddns.py
fi
read -p "是否要绑定域名:[默认空]" rid
if [ -z "$rid" ];then
	echo "域名ID不能为空！"
	exit
else
	sed -i "s/rid/$rid/g" ddns.py
fi
read -p "子域名ID:" puid
if [ -z "$puid" ];then
	echo "子域名ID不能为空！"
	exit
else
	sed -i "s/puid/$puid/g" ddns.py
fi
read -p "二级域名:[默认www]:" eym
if [ -z "$cs" ];then
	sed -i "s/eym/www/g" ddns.py
else
	sed -i "s/eym/$eym/g" ddns.py
fi
cp ddns.py /etc/ddns.py
cp /etc/init.d/rcS /etc/init.d/rcS.bak
echo "nohup python /etc/ddns.py > /tmp/ddnsout.txt 2>&1 &" >> /etc/init.d/rcS
read -p "按回车重启,不重启请按Ctrl-C" var
reboot -f
}
function Installv4(){
wget -c https://raw.githubusercontent.com/Squaregentleman/x3p-dnspod-ddns-ipv4-6/master/ddns_ipv4.py -O ddns.py
read -p "Id:[Id]" id
if [ -z "$id" ];then
	echo "id不能为空！"
	exit
else
	sed -i "s/loginid/$id/g" ddns.py
fi
read -p "Token:" token
if [ -z "$token" ];then
	echo "token不能为空！"
	exit
else
	sed -i "s/logintoken/$token/g" ddns.py
fi
read -p "域名ID:" rid
if [ -z "$rid" ];then
	echo "域名ID不能为空！"
	exit
else
	sed -i "s/rid/$rid/g" ddns.py
fi
read -p "子域名ID:" puid
if [ -z "$puid" ];then
	echo "子域名ID不能为空！"
	exit
else
	sed -i "s/puid/$puid/g" ddns.py
fi
read -p "ipv6端口:[默认80]" puid
if [ -z "$puid" ];then
	echo "子域名ID不能为空！"
	exit
else
	sed -i "s/puid/$puid/g" ddns.py
fi
cp ddns.py /etc/ddns.py
cp /etc/init.d/rcS /etc/init.d/rcS.bak
echo "nohup python /etc/ddns.py > /tmp/ddnsout.txt 2>&1 &" >> /etc/init.d/rcS
read -p "按回车重启,不重启请按Ctrl-C" var
reboot -f
}
function Uninstall(){
	pkill -９ python
	rm -rf $myFile
	cd /etc/nginx/
	rm -rf onespace.conf
	mv onespace.conf.bak onespace.conf
	cd /etc/init.d/
	mv rcS.bak rcS
	quit
}
function quit(){
	exit 1
}

myFile="/etc/ddns.py"
if [ ! -e "$myFile" ]; then
menu_install
fi
menu_uinstall
