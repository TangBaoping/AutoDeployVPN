#!/bin/bash

function installVPN5(){

	yum -y install make libpcap iptables gcc-c++ logrotate tar cpio perl pam tcp_wrappers
	rpm -ivh dkms-2.0.17.5-1.noarch.rpm
	rpm -ivh kernel_ppp_mppe-1.0.2-3dkms.noarch.rpm
	rpm -qa kernel_ppp_mppe
	rpm -Uvh ppp-2.4.4-9.0.rhel5.i386.rpm
	rpm -ivh pptpd-1.3.4-1.rhel5.1.i386.rpm
}


function installVPN6(){

	yum -y install make libpcap iptables gcc-c++ logrotate tar cpio perl pam tcp_wrappers
	rpm -ivh dkms-2.0.17.5-1.noarch.rpm
	rpm -ivh kernel_ppp_mppe-1.0.2-3dkms.noarch.rpm
	rpm -qa kernel_ppp_mppe
	rpm -Uvh ppp-2.4.5-17.0.rhel6.i686.rpm
	rpm -ivh pptpd-1.3.4-2.el6.i686.rpm
}

function setting(){
	mknod /dev/ppp c 108 0
	echo 1 > /proc/sys/net/ipv4/ip_forward
	echo "mknod /dev/ppp c 108 0" >> /etc/rc.local
	echo "echo 1 > /proc/sys/net/ipv4/ip_forward" >> /etc/rc.local
	echo "localip 172.16.36.1" >> /etc/pptpd.conf
	echo "remoteip 172.16.36.2-254" >> /etc/pptpd.conf
	echo "ms-dns 8.8.8.8" >> /etc/ppp/options.pptpd
	echo "ms-dns 8.8.4.4" >> /etc/ppp/options.pptpd

	pass=`openssl rand 6 -base64`
	if [ "$1" != "" ]
	then pass=$1
	fi

	echo "vpn pptpd ${pass} *" >> /etc/ppp/chap-secrets

	iptables -t nat -A POSTROUTING -s 172.16.36.0/24 -j SNAT --to-source `ifconfig  | grep 'inet addr:'| grep -v '127.0.0.1' | cut -d: -f2 | awk 'NR==1 { print $1}'`
	iptables -A FORWARD -p tcp --syn -s 172.16.36.0/24 -j TCPMSS --set-mss 1356
	service iptables save

	chkconfig iptables on
	chkconfig pptpd on

	service iptables start
	service pptpd start

	echo "================================================================================"
	echo "VPN service is installed, your VPN username is vpn,VPN password is ${pass}"
	echo "================================================================================"

}

function centos5(){
	echo "begin to install VPN services";
	#check wether vps suppot ppp and tun

	yum remove -y pptpd ppp
	iptables --flush POSTROUTING --table nat
	iptables --flush FORWARD
	rm -rf /etc/pptpd.conf
	rm -rf /etc/ppp

	arch=`uname -m`

	wget  http://linux.dell.com/dkms/permalink/dkms-2.0.17.5-1.noarch.rpm
	wget  https://acelnmp.googlecode.com/files/kernel_ppp_mppe-1.0.2-3dkms.noarch.rpm
	wget  https://acelnmp.googlecode.com/files/pptpd-1.3.4-1.rhel5.1.i386.rpm
	wget  https://fastlnmp.googlecode.com/files/ppp-2.4.4-9.0.rhel5.i386.rpm

	installVPN5
	setting

}

function centos6(){
	echo "begin to install VPN services";
	#check wether vps suppot ppp and tun

	yum remove -y pptpd ppp
	iptables --flush POSTROUTING --table nat
	iptables --flush FORWARD
	rm -rf /etc/pptpd.conf
	rm -rf /etc/ppp

	arch=`uname -m`

	wget  http://linux.dell.com/dkms/permalink/dkms-2.0.17.5-1.noarch.rpm
	wget  https://acelnmp.googlecode.com/files/kernel_ppp_mppe-1.0.2-3dkms.noarch.rpm
	wget  https://qiaodahai.googlecode.com/files/pptpd-1.3.4-2.el6.i686.rpm
	wget  https://logdns.googlecode.com/files/ppp-2.4.5-17.0.rhel6.i686.rpm

	installVPN6
	setting
}



function repaireVPN(){
	echo "begin to repaire VPN";
	mknod /dev/ppp c 108 0
	service iptables restart
	service pptpd start
}

function addVPNuser(){
	echo "input user name:"
	read username
	echo "input password:"
	read userpassword
	echo "${username} pptpd ${userpassword} *" >> /etc/ppp/chap-secrets
	service iptables restart
	service pptpd start
}

echo "please select your operation system"
echo "which do you want to?input the number."
echo "1. my system is centos5 32bit(only support 32bit)"
echo "2. my system is centos6 32bit or 64bit(they are support)"
echo "3. repaire VPN service"
echo "4. add VPN user"
read num

case "$num" in
[1] ) (centos5);;
[2] ) (centos6);;
[3] ) (repaireVPN);;
[4] ) (addVPNuser);;
*) echo "nothing,exit";;
esac
