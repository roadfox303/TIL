- ログは　journald　がデータベースに(バイナリ形式で)保存し、 rsyslog がそれを受け取り、テキストファイルに書き込み永続化する。
- 再起動すると journald のデータは失われる。(保管期間の設定も可能)
- /var/log/boot.log のログ書き込みだけは、rsyslogでもなくjournaldでもない。気にしなくてOK。
- シスログサーバの構築にjournaldの存在は気にしなくてOK。
  - 別ホストから転送されてきたシステムログは journald のログデータベースには保存されない。

### 共通の設定
- ※このjournaldの設定は多分いらない
```
[ec2-user@ip-10-0-2-20 ~]$ sudo vim /etc/systemd/journald.conf
-----------vim-----------
[Journal]
#Storage=auto
#Compress=yes
#Seal=yes
#SplitMode=uid
#SyncIntervalSec=5m
RateLimitInterval=0
RateLimitBurst=0
# この二つのコメントアウトを外し、値を「0」に設定する。
-------------------------

[ec2-user@ip-10-0-2-20 ~]$ sudo systemctl restart systemd-journald

[ec2-user@ip-10-0-2-20 ~]$ sudo vim /etc/rsyslog.conf
-----------vim-----------
~~~~~~~
~~~~
$imjournalRatelimitInterval 0
$imjournalRatelimitBurst 0
#上記を末尾または、「$ModLoad imjournal」の下らへんに追記
-------------------------

[ec2-user@ip-10-0-2-20 ~]$ sudo systemctl restart rsyslog.service
```

### シスログサーバ（受信） の設定
```
# 踏み台サーバ > シスログサーバ にログイン
[ec2-user@ip-10-0-2-20 ~]$ sudo vim /etc/rsyslog.conf
-----------vim-----------
~~~~~~~
~~~~
<!-- $imjournalRatelimitInterval 0
$imjournalRatelimitBurst 0
#上記を末尾または、「$ModLoad imjournal」の下らへんに追記 -->
※この設定は多分いらない

# Provides UDP syslog reception
#$ModLoad imudp
#$UDPServerRun 514

# Provides TCP syslog reception
$ModLoad imtcp
$InputTCPServerRun 514
# ここのTCP関連のコメントアウトを外す

$AllowedSender TCP, 10.0.0.0/16
# 受信するクライアントを指定。この例ではプライベートIPで指定している。パブリックIP、ホスト名、ドメイン名でも良い。複数の場合はカンマで区切る。
~~~~~
~~
-------------------------

[ec2-user@ip-10-0-2-20 ~]$ sudo systemctl restart rsyslog
```

### クライアント（送信）の設定
```
[ec2-user@ip-10-0-1-10 ~]$ sudo vim /etc/rsyslog.conf
-----------vim-----------
~~~~~~~
~~~~
#### RULES ####

# Log all kernel messages to the console.
# Logging much else clutters up the screen.
#kern.*                                                 /dev/console

# Log anything (except mail) of level info or higher.
# Don't log private authentication messages!
*.info;mail.none;authpriv.none;cron.none @@10.0.2.20    /var/log/messages
# ここにシスログサーバ（送信先）を指定する。
# ※ポート番号を 514 から変更している場合、「192.0.2.10:1234」のようにポート番号を指定する。

# The authpriv file has restricted access.
authpriv.*                                              /var/log/secure

~~~~~

# ### begin forwarding rule ###
# The statement between the begin ... end define a SINGLE forwarding
# rule. They belong together, do NOT split them. If you create multiple
# forwarding rules, duplicate the whole block!
# Remote Logging (we use TCP for reliable delivery)
#
# An on-disk queue is created for this action. If the remote host is
# down, messages are spooled to disk and sent when it is up again.
$ActionQueueFileName fwdRule1 # unique name prefix for spool files
$ActionQueueMaxDiskSpace 1g   # 1gb space limit (use as much as possible)
$ActionQueueSaveOnShutdown on # save messages to disk on shutdown
$ActionQueueType LinkedList   # run asynchronously
$ActionResumeRetryCount -1    # infinite retries if host is down
# 上の５つのコメントアウトを外す。

# remote host is: name/ip:port, e.g. 192.168.0.1:514, port optional

local1.* @@10.0.2.20:514 #TCP
# シスログサーバ(ホスト)とポートを指定。

~~
-------------------------
[ec2-user@ip-10-0-1-10 ~]$ sudo systemctl restart rsyslog.service
```

### 受信の確認
- tail -f でログをリアルタイム表示できる。
```
[ec2-user@ip-10-0-2-20 ~]$ sudo tail -f /var/log/messages
```
