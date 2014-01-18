aptitude update && aptitude upgrade

aptitude install vim rsync lynx screen htop curl sudo ntp imagemagick libjpeg-progs optipng -y

dpkg-reconfigure tzdata

vim ~/.ssh/authorized_keys
  # Saulo
  ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC8MjHXA5EL+C0UKljgGKOr4dVjGEZpss6tPtX0zJBuFiH36mMIveePM/GTzVLC1sDJz0Ngqx6uY7H93VUJPbdajMc7KdVsaGQNQcbEAlCplGcjdsUqKra5KTaqOyzhFZHSHAtAwQtXoQoj/0Hwe6DSA65cOt+C/r/t77NalKkg5tX4yK2U3Pkh0IZe5pdUrkFaLbnsrTX55VMOG7kBLascPt6+K/j32R3LKKyH8hPXO8IqErws72v+Gb08flsrM8S8YYFLu5aHiwzH5LJPMDrIO2WhvYtRtWITTuj9uGVpmFHXUa4Qvg6bl1HDtePQkWcfc31SYAWnunneDROZZhlr saulo@saulo-voraz

  # Bini
  ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC6CQ8zgBq85rd5QgWvCqnLfTYpx9LYJkrWUB0HCPfDiwKpNF5euDMurdY9lPkSZ7HS290zwZMuD5kDq7RCRX/SWSZIJ50FpKr7QNpoiPAyMOFDmy3lteUk+P1g84aJsJOYq74fn7KWNw+vpO819sTRxI7yGe7b6eEv/z7UgF15vjc3DyJf7tBBwMJIUxUuSWKlReX2hu9sbPOjINzHaoi19c2sU73PY7zvUvx4NrWw6PdL93piAncp6DvlTZmPoYeoH0w3p+QcVpUfYq+N4LlzvwkteTbY+ODRl5LFOAP4fPLiSJpatqXLp2mCbkxAasThUZ21DfVspnGebmuM9/yn root@myhost

passwd
  # Set new password

vim ~/.bash_profile
  export PS1="\[\\033]0;\h\\007\]\u@\h [\w]# "
  export EDITOR="vim"

rm /etc/motd

vim /etc/vim/vimrc
  syntax on

vim /etc/ssh/sshd_config
  PasswordAuthentication no
  UsePAM no

# MaridDB
  aptitude install python-software-properties
  apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 0xcbcb082a1bb943db
  add-apt-repository 'deb http://ftp.osuosl.org/pub/mariadb/repo/10.0/debian wheezy main'

  aptitude update && aptitude install mariadb-server libmariadbclient-dev

  mysql -u root mysql -pC6rPqFNCLmWtU3T
    CREATE USER 'shoes'@'localhost' IDENTIFIED BY 'n8gHbrNanrUXajF2ea';
    GRANT ALL PRIVILEGES ON * . * TO  'shoes'@'localhost';
    CREATE USER 'shoes'@'%' IDENTIFIED BY 'n8gHbrNanrUXajF2ea';
    GRANT ALL PRIVILEGES ON *.* TO 'shoes'@'%';
    FLUSH PRIVILEGES;
    exit

# NodeJS
  aptitude install python g++ make checkinstall
  mkdir -p /usr/local/src && cd $_
  wget -N http://nodejs.org/dist/node-latest.tar.gz
  tar xzvf node-latest.tar.gz && cd node-v*
  ./configure
  sudo checkinstall -y --install=no --pkgversion 0.10.24  # Replace with current version number.
  sudo dpkg -i node_*

# Phantomjs
  aptitude install fontconfig
  cd /usr/local/src
  wget https://phantomjs.googlecode.com/files/phantomjs-1.9.2-linux-x86_64.tar.bz2
  tar -vxjf phantomjs-1.9.2-linux-x86_64.tar.bz2
  ln -sf /usr/local/src/phantomjs-1.9.2-linux-x86_64/bin/phantomjs /usr/local/bin/

# nginx
  aptitude install libpcre++-dev
  cd /usr/local/src
  wget http://nginx.org/download/nginx-1.4.4.tar.gz
  tar xzvf nginx-1.4.4.tar.gz && cd nginx-*
  ./configure --prefix=/usr/local/nginx --with-http_stub_status_module --with-http_spdy_module --with-http_gzip_static_module
  make
  make install
  ln -s /usr/local/nginx/sbin/nginx /usr/local/sbin/nginx

# redis
  aptitude install redis-server

# rvm
  curl -L get.rvm.io | bash -s stable
  rvm requirements

  vim /etc/rvmrc
    export rvm_trust_rvmrcs_flag=1
    export rvm_gemset_create_on_use_flag=1
    export rvm_project_rvmrc=1

  vim /etc/gemrc
    install: --no-rdoc --no-ri
    update: --no-rdoc --no-ri

  rvm install 2.1
  rvm --default 2.1
  rvm rvmrc warning ignore all.rvmrcs

  chmod +x $rvm_path/hooks/after_cd_bundler
  /usr/local/rvm/bin/rvm default do gem install bundler

adduser shoes
passwd -d shoes
usermod -a -G rvm shoes

---

su shoes

ssh-keygen -t rsa

vim ~/.bash_profile
  export PS1="\[\\033]0;\h\\007\]\u@\h [\w]# "
  export EDITOR="vim"
  export LS_OPTIONS='--color=auto'
  eval "`dircolors`"
  alias ls='ls $LS_OPTIONS'
  alias ll='ls $LS_OPTIONS -l'
  alias l='ls $LS_OPTIONS -lA'
  export LANGUAGE=en_US.UTF-8
  export LANG=en_US.UTF-8
  export LC_ALL=en_US.UTF-8
  export LC_CTYPE=en_US.UTF-8

vim ~/.ssh/authorized_keys

