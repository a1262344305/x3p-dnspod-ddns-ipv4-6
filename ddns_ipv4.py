#!/usr/bin/env python
# -*- coding:utf-8 -*-

import httplib
import urllib
import socket
import time
import ssl
ssl._create_default_https_context = ssl._create_unverified_context
params = dict(
    login_token="11111,222222222222222222222",  # replace with your API token, see https://support.dnspod.cn/Kb/showarticle/tsid/227/
    format="json",
    domain_id=3333,  # 替换成你获取的
    record_id=4444,  # 替换成你获取的
    sub_domain="www",  # 替换成你的二级域名
    record_line="默认",
)
current_ip = None


def ddns(ip):
    params.update(dict(value=ip))
    headers = {"Content-type": "application/x-www-form-urlencoded", "Accept": "text/json"}
    conn = httplib.HTTPSConnection("dnsapi.cn")
    conn.request("POST", "/Record.Ddns", urllib.urlencode(params), headers)

    response = conn.getresponse()
    print(response.status, response.reason)
    data = response.read()
    print(data)
    conn.close()
    return response.status == 200


def getip():
    sock = socket.create_connection(('ns1.dnspod.net', 6666))
    ip = sock.recv(16)
    sock.close()
    return ip


if __name__ == '__main__':
    while True:
        try:
            ip = getip()
            print(ip)
            if current_ip != ip:
                if ddns(ip):
                    current_ip = ip
        except Exception, e:
            print(e)
            pass
        time.sleep(60) #更新频率 默认60秒更新一次