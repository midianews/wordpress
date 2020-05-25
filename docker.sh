#!/bin/bash
chmod +x $0
timedatectl set-timezone "America/Sao_Paulo"
sed -i "s/GRUB_TIMEOUT=0/GRUB_TIMEOUT=10/" /etc/default/grub
update-grub2 &>/dev/null &
clear
export RED='\033[0;31m';export LIGHT_RED='\033[1;31m';export GREEN='\033[0;32m';export LIGHT_GREEN='\033[1;32m'
export ORANGE='\033[0;33m';export YELLOW='\033[1;33m';export BLUE='\033[0;34m';export LIGHT_BLUE='\033[1;34m'
export PURPLE='\033[0;35m';export LIGHT_PURPLE='\033[1;35m';export CYAN='\033[0;36m';export LIGHT_CYAN='\033[1;36m'
export LIGHT_GRAY='\033[0;37m';export WHITE='\033[1;37m';export DARK_GRAY='\033[1;30m';export NC='\033[0m' # No Color BLACK

#########################################################################
#       Nome : Script Instlação Docker Wordpress e Configuração         #
#       Data : 27/09/2019                                               #
#       Versão: 001                                                     #
#       Autor: Danton Junior                                            #
#########################################################################


SL='&>/dev/null &'
SLEEP="sleep 1"
DATA=$(date +%d%m%Y_%H%M%S)
BASHRC_FILE="$HOME/.bashrc"
APTU="apt-get -qqy update"
APTG="apt-get -qqy upgrade"
APTC="apt-get -qqy clean"
APTI="apt-get -qqy install"
SOURCES_LIST="/etc/apt/sources.list"

# 1- BASH FILE
#cp $BASHRC_FILE $BASHRC_FILE.$DATA.bkp

cat << 'EOF' > $BASHRC_FILE
ulimit -HSn 65536
echo never > /sys/kernel/mm/transparent_hugepage/enabled

PS1='${debian_chroot:+($debian_chroot)}\h:\w\$ '
umask 022
export LS_OPTIONS='--color=auto'
eval "`dircolors`"

alias ls='ls $LS_OPTIONS'
alias ll='ls $LS_OPTIONS -l'
alias l='ls $LS_OPTIONS -lA'

alias rm='rm -rf'
alias cp='cp -fra'
alias h='htop'
EOF
echo -e "${LIGHT_BLUE}${BASHRC_FILE} ->> OK\n${NC}"; $SLEEP

# 2- SOURCELIST
$APTU
echo -e "${ORANGE}Atualizando Programas ...${NC}"; $SLEEP
$APTG &>/dev/null &
echo -e "${YELLOW}Atualizado OK.\n${NC}"; $SLEEP

$APTI apt-transport-https bzip2 ca-certificates curl debconf-utils dirmngr dialog gnupg2 >/dev/null 2>&1
echo -e "${ORANGE}Instalando Programas ...${NC}"; $SLEEP
$APTI dnsutils git htop iftop lsb-release lsof man nano net-tools nmap perl pwgen ufw >/dev/null 2>&1
echo -e "${ORANGE}Instalando Programas ...${NC}"; $SLEEP
$APTI software-properties-common ssl-cert wget zip unzip webp jpegoptim optipng uglifyjs cleancss >/dev/null 2>&1
echo -e "${YELLOW}Instalado OK.\n${NC}"; $SLEEP

$APTC >/dev/null 2>&1
echo -e "${YELLOW}Limpeza OK.\n$NC"; $SLEEP

# 3- DOCKER
curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - >/dev/null 2>&1
cp $SOURCES_LIST $SOURCES_LIST.$DATA.bkp
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
curl -fsSL "https://github.com/docker/compose/releases/download/1.25.5/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
sed -i "/^$/d" $SOURCES_LIST
sed -i "/#/d" $SOURCES_LIST

echo -e "${ORANGE}Instalando DOCKER ...${NC}"; $SLEEP
$APTU
$APTI docker-ce docker-ce-cli containerd.io >/dev/null 2>&1
echo -e "${YELLOW}Instalado OK.\n${NC}"; $SLEEP
#docker version
#docker-compose --version

# 4- INSTALL WORPRESS
echo -e "${ORANGE}Instalando MARIADB + REDIS + MARIADB + OPENLITESPEED + PHPMYAMIN + WORDPRESS ...\n${NC}"; $SLEEP
rm -rf $HOME/ols*
git clone  --quiet https://github.com/litespeedtech/ols-docker-env.git

OLSDIR=$HOME/$(find . -type d -name "ols*" |  tr -d "./")
ENV=$OLSDIR/.env
YML=$OLSDIR/docker-compose.yml
IP=$(curl -LSs ifconfig.me)

#reboot
