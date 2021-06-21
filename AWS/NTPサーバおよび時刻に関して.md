#### AWSでのNTP同期について
- VPCで実行されているインスタンスは、169.254.169.123（Amazon Time Sync service）を使用して時刻同期できる。Linux AMIでは初期設定にされている。
- 169.254.169.123 にはVPC外からの同期はできない。たとえばオンプレやAWS以外のクラウドサーバなど。
- 169.254.169.123 と同期したい場合は、169.254.169.123と同期しているVPC内のEC2インスタンスをNTPサーバとみなして同期すれば良い。
- NTPで同期していても時刻の表記（タイムゾーンなど）はサーバ各自の /etc/sysconfig/clock に基づいて表示される。

#### タイムゾーンの変更
```
■日時/タイムゾーンを確認
[ec2-user@ip-10-0-1-10 ~]$ date
2021年  6月 20日 日曜日 05:22:49 UTC

■タイムゾーン一覧
[ec2-user@ip-10-0-1-10 ~]$ ls /usr/share/zoneinfo

[ec2-user@ip-10-0-1-10 ~]$ sudo vi /etc/sysconfig/clock
---------vi----------
#ZONE="UTC"
ZONE="Japan"
UTC=true
---------------------

■設定を反映
[ec2-user@ip-10-0-1-10 ~]$ sudo ln -sf /usr/share/zoneinfo/Japan /etc/localtime
[ec2-user@ip-10-0-1-10 ~]$ sudo reboot

[ec2-user@ip-10-0-1-10 ~]$ date
2021年  6月 20日 日曜日 14:31:23 JST

# 再起動してもipアドレスは変わらないっぽい。
# 再起動には30秒~1分ほどかかる。
```

## 外部(VPC外)からの NTP同期
- ここでのNTPサーバとは 169.254.169.123 とNTP同期しているサーバを指す。
  - 53.45.6.700 と仮定する
- ここでのクライアントとはVPC外のサーバ（Amazon Time Sync servicと同期したい）を指す。
  - 12.34.5.800 と仮定する
1. クライアントのchrony.confで NTPサーバを指定。
- server xxx.xxx.xxx.xxx prefer iburst の部分にNTPサーバのIPを指定

```
[ec2-user@ip-12-34-5-800 ~]$ sudo vi /etc/chrony.conf
-----------vi------------
# use the Amazon Time Sync Service (if available)
# and allow for IPv6-only connections (via ULA)
server 53.45.6.700 prefer iburst minpoll 4 maxpoll 4
server fd00:ec2::123 auto_offline iburst minpoll 4 maxpoll 4
~~~~
-------------------------

[ec2-user@ip-12-34-5-800 ~]$ sudo service chronyd restart
```

2. NTPサーバでのアクセス許可。
- NTPサーバで、クライアントからの接続を許可

```
[ec2-user@ip-53-45-6-700 ~]$ sudo vi /etc/chrony.conf
-----------vi------------
# Allow NTP client access from local network.
allow 12.34.5.800/32
~~~~
-------------------------

[ec2-user@ip-53-45-6-700 ~]$ sudo systemctl restart chronyd
```

3. AWSコンソールでの設定
- NTPサーバにアタッチされたセキュリティグループに対して、クライアントのパブリックIPアドレスをインバウンド設定に追加する。（同じセキュリティグループに属している場合はプライベートIPだけでもよいが、今回は外部からの接続を想定した。）
  - NTP は UDPポートの123を使用する。
  - つまり タイプ：カスタムUDP、ポート：123、ソース：クライアントのパブリックIP　をインバウンドに追加する。

- 参考
https://dev.classmethod.jp/articles/time-sync-service-ec2-ntp/
