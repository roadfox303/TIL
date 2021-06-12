##### ssh接続を許可
- /etc/ssh/sshd_config
  - オリジナルのssh設定はコメントアウトのままで。下部に追記。
```
Port 22
PermitRooting no
PasswordAuthentication yes
```

##### sshを起動
```
# systemctl start sshd.service

起動を確認
# systemctl status sshd.service
```

##### パスワードでのsshログインを許可
- サーバ設定の変更は、実行前に必ずバックアップを取っておく。
```
[ec2-user@ip-10-0-1-10 ~]# cd /etc/ssh/
[ec2-user@ip-10-0-1-10 ssh]# cp -p sshd_config sshd_config_yyyymmdd
[ec2-user@ip-10-0-1-10 ssh]# vi sshd_config
PubkeyAuthentication yes　に変更。

[ec2-user@ip-10-0-1-10 ssh]systemctl restart sshd.service

[ec2-user@ip-10-0-1-10 ~]# useradd ユーザー名
[ec2-user@ip-10-0-1-10 ~]# passwd パスワード
```

##### Firewallの設定 (httpのサービスに対して解放する例)
```
# firewall-cmd --zone=public --add-service=http --permanent
# firewall-cmd --reload

# firewall-cmd --list-all
```
