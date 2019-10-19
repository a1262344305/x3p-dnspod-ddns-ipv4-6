#!/usr/bin/env python
# -*- coding:utf-8 -*-

import httplib
import urllib
import socket
import time
import ssl
ssl._create_default_https_context = ssl._create_unverified_context
ID=loginid
Token=logintoken
current_ip = None


def ddns(ip):
    headers = {"Content-type": "application/x-www-form-urlencoded", "Accept": "text/json"}
    conn = httplib.HTTPSConnection("nas.fkj233.cn")
    conn.request("GET", "/api/"+ID+","+Token+"/update/"+ip, , headers)

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
