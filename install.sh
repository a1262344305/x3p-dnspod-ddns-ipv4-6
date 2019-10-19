#!/bin/sh
mount -o remount,rw /
export PATH=/bin:/sbin:/usr/bin:/usr/sbin

function menu_install(){
echo -e " Ddns一键安装脚本
  ---- By:方块君 ----

  (1) 安装 DnsPod Ddns
  (2) 安装 Fkj Ddns NEW!!
  (4) 退出
 "
 numsr
}

function menu_uinstall(){
echo -e " Ddns一键安装脚本
  ---- By:方块君 ----

  (1) 卸载安装
  (2) 修复配置(如果ipv6无法访问请尝试修复)
  (3) 退出
 "
 numsru
}
function numsru(){
echo && stty erase '^H' && read -p "请输入数字 [1-3]：" num
case "$num" in
	1)
	Uninstall
	;;
	2)
	cofxf
	;;
	3)
	quit
	;;
esac
}
function numsr(){
echo && stty erase '^H' && read -p "请输入数字 [1-3]：" num
case "$num" in
	1)
	Install
	;;
	2)
	Installv4
	;;
	3)
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
	wget -N --no-check-certificate https://raw.githubusercontent.com/Squaregentleman/x3p-dnspod-ddns-ipv4-6/master/dnspod_install.sh && chmod +x dnspod_install.sh && sh dnspod_install.sh
}
function Installv4(){
	wget -N --no-check-certificate https://raw.githubusercontent.com/Squaregentleman/x3p-dnspod-ddns-ipv4-6/master/nas_install.sh && chmod +x nas_install.sh && sh nas_install.sh
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
