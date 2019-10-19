#!/bin/sh
mount -o remount,rw /
export PATH=/bin:/sbin:/usr/bin:/usr/sbin

function menu_install(){
echo -e "  DnsPod Ddns一键安装脚本
  ---- By:方块君 ----

  (1) 安装 DnsPod Ddns
  (2) 卸载 DnsPod Ddns
  (4) 退出
 "
 numsr
}

function menu_uinstall(){
echo -e "  DnsPod Ddns一键安装脚本
  ---- By:方块君 ----

  (1) 安装 DnsPod Ddns(已安装)
  (2) 卸载 DnsPod Ddns
  (3) 修复配置(如果ipv6无法访问请尝试修复)
  (3) 退出
 "
 numsr
}
function numsr(){
echo && stty erase '^H' && read -p "请输入数字 [1-4]：" num
case "$num" in
	1)
	Install
	;;
	2)
	Uninstall
	;;
	3)
	cofxf
	;;
	4)
	quit
	;;
esac
}
function cofxf(){
	read -p "是否要绑定域名:[默认空]" cs
	read -p "ipv6端口:[默认80]" port
	if [ -z "$port" ];then
	port=80
	fi
	cd /etc/nginx/
	rm -rf onespace.conf
	mv onespace.conf.bak onespace.conf
	if [ -z "$cs" ];then
		sed -i "s/listen 80;/listen 80;\r\n    listen [::]:$port; ipv6only=on;/g" /etc/nginx/onespace.conf
	else
		sed -i "s/listen 80;/listen 80;\r\n    listen [::]:$port ipv6only=on;\r\n    server_name $cs;/g" /etc/nginx/onespace.conf
	fi
	cp onespace.conf onespace.conf.bak
	quit
}
function Install(){
read -p "是否为Ipv6:[yes或no]" ipv64

if [ ipv64 == "no" ];then
	Installv4
fi
cp /etc/nginx/onespace.conf /etc/nginx/onespace.conf.bak
read -p "是否要绑定域名:[默认空]" cs
read -p "ipv6端口:[默认80]" port
if [ -z "$port" ];then
	port=80
fi
if [ -z "$cs" ];then
	sed -i "s/listen 80;/listen 80;\r\n    listen [::]:$port; ipv6only=on;/g" /etc/nginx/onespace.conf
else
	sed -i "s/listen 80;/listen 80;\r\n    listen [::]:$port ipv6only=on;\r\n    server_name $cs;/g" /etc/nginx/onespace.conf
fi
wget -c https://raw.githubusercontent.com/Squaregentleman/x3p-dnspod-ddns-ipv4-6/master/nas_ipv6.py -O ddns.py
read -p "Id:" id
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
cp ddns.py /etc/ddns.py
cp /etc/init.d/rcS /etc/init.d/rcS.bak
echo "
nohup python /etc/ddns.py > /tmp/ddnsout.txt 2>&1 &" >> /etc/init.d/rcS
read -p "按回车重启,不重启请按Ctrl-C" var
reboot -f
}
function Installv4(){
wget -c https://raw.githubusercontent.com/Squaregentleman/x3p-dnspod-ddns-ipv4-6/master/nas_ipv4.py -O ddns.py
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
cp ddns.py /etc/ddns.py
cp /etc/init.d/rcS /etc/init.d/rcS.bak
echo "
nohup python /etc/ddns.py > /tmp/ddnsout.txt 2>&1 &" >> /etc/init.d/rcS
read -p "按回车重启,不重启请按Ctrl-C" var
reboot -f
}
function Uninstall(){
	killall python
	rm -rf $myFile
	cd /etc/nginx/
	rm -rf onespace.conf
	mv onespace.conf.bak onespace.conf
	cd /etc/init.d/
	rm rcS
	mv rcS.bak rcS
	quit
}
function quit(){
	exit 1
}

myFile="/etc/ddns.py"
if [ ! -e "$myFile" ]; then
menu_install
else
menu_uinstall
fi