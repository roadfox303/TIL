```
$ sudo yum install make
$ sudo yum install gcc
$ sudo yum install openssl openssl-devel readline readline-devel

$ sudo su -l

$ git clone https://github.com/sstephenson/rbenv.git rbenv
$ git clone https://github.com/sstephenson/ruby-build.git rbenv/plugin/ruby-build
$ rbenv/plugin/ruby-build/install.sh
$ vim /etc/profile.d/rbenv.sh

# /etc/profile.d/rbenv.sh
export RBENV_ROOT="/usr/local/rbenv"
export PATH="/usr/local/rbenv/bin:$PATH"
eval "$(rbenv init --no-rehash -)"

$ source /etc/profile.d/rbenv.sh
$ which rbenv
$ rbenv install 2.6.3

$ rbenv global 2.6.3
※これを指定しないとコマンドを使えない。

$ gem i -v 5.2.4.5 rails
```
