#!/bin/bash

service_disable=`svcs -a |egrep 'gdm|keyserv|nis|ldap\/client|ktkt_warn|gss|rmvolmgr|smserver|smb|autofs|http|mpxioupgrade|kadmin|krb5kdc|krb5_prop|nfs\/server|nfs\/status|nfs\/nlockmgr|mapid|fedfs\-client|cbd|telnet|ftp\:default|rarp\:default|relay\:ipv4|relay\:ipv6|server\/ipv4|server\/ipv6|dns\/server|dns\/client|udp6\:default|schedule\:def|in-lpd\:default|ipp\-listener\:default|net\-snmp\:default|tname\:default|shell\:default|shell\:kshell|login\:eklogin|login\:klogin|login\:rlogin|rexec\:default|comsat\:default|talk\:default|finger\:default|\/time\:stream|\/time\:dgram|\/echo\:stream|\/echo\:dgram|\/discard\:stream|\/discard\:dgram|\/daytime\:stream|\/daytime\:dgram|\/chargen\:stream|\/chargen\:dgram|\/swat\:default|\/rquota\:default|\/rusers\:default|\/spray\:default|\/wall\:default|\/rstat\:default|\/rex\:default|\/ocfserv\:default|\/xfs\:default|\/power\:default|\/slp\:default|\/consadm\:default|\/smtp\:sendmail\:default'`

all_disable=`echo "$service_disable" |wc -l`
count_disable=`echo "$service_disable" |grep disabled |wc -l`
count_other_disable=`echo "$service_disable" |grep -v disabled |wc -l`

echo "=========Verifikasi Hardening Solaris========"
echo "D. SYSTEM SECURITY CONFIGURATION"
echo "1. Disable Unnecessary Services ($all_disable Services)"
echo -e "Success :\e[032;1m $count_disable \e[0m"
echo -e "Failed  :\e[031;1m $count_other_disable \e[0m"
other_disable=`echo "$service_disable" |grep -v disabled`
echo -e "\e[031;1m$other_disable \e[0m"
echo ""

service_enable=`svcs -a |egrep '\/rpc\/bind|ntp'`

all_enable=`echo "$service_enable" |wc -l`
count_enable=`echo "$service_enable" |grep -v online |wc -l`
count_other_enable=`echo "$service_enable" |grep -v online |wc -l`

echo "2. Enable Required Services ($all_enable Service)"
echo -e "Success :\e[032;1m $count_enable \e[0m"
echo -e "Failed  :\e[031;1m $count_other_enable \e[0m"
other_enable=`echo "$service_enable" |grep -v online`
echo -e "\e[031;1m$other_enable \e[0m"
echo ""

warning_banner=`cat /etc/issue`
banner="PERINGATAN: Anda akan melakukan akses terhadap komputer yang dilindungi sesuai dengan UU ITE Indonesia. Penggunaan akses yang tidak terotorisasi ke komputer atau program atau data yang dilindungi akan dikenakan sanksi sesuai dengan Undang-Undang yang berlaku."

echo "3. System Warning Banner"
if [ "$warning_banner" == "$banner" ]
then
        echo "Banner  :\e[032;1m Ok \e[0m"
else
        echo "Banner  :\e[031;1m Failed \e[0m"
fi
echo ""

echo "4. OS Version"
version=`uname -a`
version_ok="SunOS solaris 5.11 11.4.0.15.0 i86pc i386 i86pc"
if [ "$version" == "$version_ok" ]
then
        echo -e "OS Version :\e[032;1m Up-to-date \e[0m"
        echo -e "\e[032;1m$version \e[0m"
else
        echo -e "OS Version :\e[031 Old-version \e[0m"
        echo -e "\e[031;1m$version \e[0m"
fi

echo ""
echo "E. AUTHENTICATION AND ACCOUNT MANAGEMENT"
echo "1. Password Control"
max_weeks_existing=`cat /etc/default/passwd |grep "MAXWEEKS="`
max_weeks="MAXWEEKS=4"
if [ "$max_weeks_existing" == "$max_weeks" ]
then
        result_max_weeks=1
else
        result_max_weeks=0
        echo -e "\e[031;1mCheck MAXWEEKS= in /etc/default/passwd \e[0m" > failed_password_control
fi
min_weeks_existing=`cat /etc/default/passwd |grep "MINWEEKS="`
min_weeks="MINWEEKS=1"
if [ "$min_weeks_existing" == "$min_weeks" ]
then
        result_min_weeks=1
else
        result_min_weeks=0
        echo -e "\e[031;1mCheck MINWEEKS= in /etc/default/passwd \e[0m" >> failed_password_control
fi
warn_weeks_existing=`cat /etc/default/passwd |grep "WARNWEEKS="`
warn_weeks="WARNWEEKS=1"
if [ "$warn_weeks_existing" == "$warn_weeks" ]
then
        result_warn_weeks=1
else
        result_warn_weeks=0
        echo -e "\e[031;1mCheck WARNWEEKS= in /etc/default/passwd \e[0m" >> failed_password_control
fi
passlength_existing=`cat /etc/default/passwd |grep "PASSLENGTH="`
passlength_="PASSLENGTH=8"
if [ "$passlength_existing" == "$passlength_" ]
then
        result_passlength=1
else
        result_passlength=0
        echo -e "\e[031;1mCheck PASSLEGTH= in /etc/default/passwd \e[0m" >> failed_password_control
fi
history_existing=`cat /etc/default/passwd |grep "HISTORY="`
history_="HISTORY=5"
if [ "$history_existing" == "$history_" ]
then
        result_history=1
else
        result_history=0
        echo -e "\e[031;1mCheck HISTORY= in /etc/default/passwd \e[0m" >> failed_password_control
fi
min_alpha_existing=`cat /etc/default/passwd |grep "MINALPHA="`
min_alpha="MINALPHA=1"
if [ "$history_existing" == "$history_" ]
then
        result_min_alpha=1
else
        result_min_alpha=0
        echo -e "\e[031;1mCheck MINALPHA= in /etc/default/passwd \e[0m" >> failed_password_control
fi
min_nonalpha_existing=`cat /etc/default/passwd |grep "MINNONALPHA="`
min_nonalpha="MINNONALPHA=1"
if [ "$min_nonalpha_existing" == "$min_nonalpha" ]
then
        result_min_nonalpha=1
else
        result_min_nonalpha=0
        echo -e "\e[031;1mCheck MINNONALPHA= in /etc/default/passwd \e[0m" >> failed_password_control
fi
min_upper_existing=`cat /etc/default/passwd |grep "MINUPPER="`
min_upper="MINUPPER=1"
if [ "$history_existing" == "$history_" ]
then
        result_min_upper=1
else
        result_min_upper=0
        echo -e "\e[031;1mCheck MINUPPER= in /etc/default/passwd \e[0m" >> failed_password_control
fi
min_lower_existing=`cat /etc/default/passwd |grep "MINLOWER="`
min_lower="MINLOWER=1"
if [ "$min_lower_existing" == "$min_lower" ]
then
        result_min_lower=1
else
        result_min_lower=0
        echo -e "\e[031;1mCheck MINLOWER= in /etc/default/passwd \e[0m" >> failed_password_control
fi
min_diff_existing=`cat /etc/default/passwd |grep "MINDIFF="`
min_diff="MINDIFF=2"
if [ "$min_diff_existing" == "$min_diff" ]
then
        result_min_diff=1
else
        result_min_diff=0
        echo -e "\e[031;1mCheck MINDIFF= in /etc/default/passwd \e[0m" >> failed_password_control
fi






let result_password_control_success=$result_max_weeks+$result_min_weeks+$result_warn_weeks+$result_passlength+$result_history+$result_min_alpha+$result_min_nonalpha+$result_min_upper+$result_min_diff
let result_password_control_failed=11-$result_password_control_success
echo -e "Success :\e[032;1m $result_password_control_success \e[0m"
echo -e "Failed  :\e[031;1m $result_password_control_failed \e[0m"
cat failed_password_control
rm failed_password_control
