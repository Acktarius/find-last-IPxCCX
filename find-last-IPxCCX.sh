#!/bin/bash
#This file is subject to BSD 3-Clause License
#Copyright (c) 2023, Acktarius
#list new ip plugged in after one minute
#get my Ip to know the local network scheme
IPADD=$(ip a | grep -w 'inet' | grep -v 127 | cut -d "/" -f 1 | tr -d " " | cut -c 5-)
#scanning
echo -ne "\n --- Scanning IPs of your local network     --- \n"
TOSCAN="$(echo "$IPADD" | cut -d "." -f 1,2,3 )."
for n in {2..254}; do
ping $TOSCAN$n -c 6 | grep '64 bytes' | cut -d " " -f 4 | tr -d ":" | awk '!seen[$0]++' >> /var/tmp/ipb.txt &
done
echo " --- Now you can plug and boot your CCX-BOX --- "
echo -ne "################# 60s left ##\r"
sleep 10
echo -ne "############## 50s left #####\r"
sleep 10
echo -ne "########### 40s left ########\r"
sleep 10
echo -ne "######## 30s left ###########\r"
sleep 10
echo -ne "##### 20s left ##############\r"
sleep 10
echo -ne "## 10s left #################\r"
sleep 10
echo -e " --- New scan of your local network         ---\n"
for n in {2..254}; do
ping $TOSCAN$n -c 4 | grep '64 bytes' | cut -d " " -f 4 | tr -d ":" | awk '!seen[$0]++' >> /var/tmp/ipa.txt &
done
sleep 1
wait
declare -a IPRESULT
IPRESULT=($(awk 'FNR==NR {a[$0]++; next} !($0 in a)' /var/tmp/ipb.txt /var/tmp/ipa.txt ))
echo -e "\t${#IPRESULT[*]} new IP detected : ${IPRESULT[*]}"
declare -a IPRESULTS
for IPP in "${IPRESULT[@]}"; do
	timeout 5 nc -zvn $IPP 3500 &>/dev/null
	if [[ $? -eq 0 ]]; then
	IPRESULTS+="$IPP"
	fi
done
echo -e "\t${#IPRESULTS[*]} of the new IP detected can listen Conceal-Assistant : \n ${IPRESULTS[*]} \n"
echo -ne " ---            Conclusion :                 ---"
case ${#IPRESULT[@]} in
	"0") echo -ne "\n ---                      no new IP detected ---\n";;
	*) case ${#IPRESULTS[@]} in
		"0") echo -ne "\n --- none of the new IP detected are         ---\n --- broadcasting on Conceal-Assistant port  ---\n";;
		*) for IPP in "${IPRESULTS[@]}"; do
		echo -ne "\n --- new IP detected : $IPP         ---\n"
		read -p "Would you like to access it with Conceal-Assistant (Y,n) ?" choice
		case "$choice" in
			Y|y) firefox http://$IPP:3500/ &>/dev/null & ;;
			N|n) echo "you can also try with : ssh <device_name>@$IPP";;
			*) echo "bad selection";;
		esac
		done
		;;
		esac
		;;
esac

rm /var/tmp/ip*.txt
exit
