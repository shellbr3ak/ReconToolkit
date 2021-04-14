#!/bin/bash

# Run the tools
function recon {
        mkdir $domain
	echo -e "\033[1;34m[!]\033[0m Enumerating Subdomains"
	echo -e "\033[1;33m[+]\033[0m Running AssetFinder"
        assetfinder -subs-only $domain | tee $domain/assetfinder.txt &>/dev/null
        echo -e "\033[1;33m[+]\033[0m Running Amass"
	amass enum -d $domain -o $domain/amass.txt &>/dev/null
	echo -e "\033[1;33m[+]\033[0m Running Sublist3r"
        sublist3r -d $domain -o $domain/sublister.txt &>/dev/null
	echo -e "\033[1;33m[+]\033[0m Running SubFinder"
        subfinder -d $domain -o $domain/subfinder.txt &>/dev/null
	echo -e "\033[1;33m[+]\033[0m Running GoBuster"
        gobuster dns -d $domain -w /opt/SecLists/Discovery/DNS/subdomains-top1million-110000.txt -o $domain/gobuster-1.txt -t 60 &>/dev/null
	echo -e "\033[1;33m[+]\033[0m Running GoBuster 2"
        gobuster dns -d $domain -w /opt/SecLists/Discovery/DNS/bitquark-subdomains-top100000.txt -o $domain/gobuster-2.txt -t 60 &>/dev/null
	echo -e "\033[1;33m[+]\033[0m Running Aquatone-Discover"
	aquatone-discover -d $domain
}

# Filter out results
filter(){
	echo -e "\033[1;34m[!]\033[0m Filtering The Results"
        cat $domain/gobuster-1.txt | sed 's/Found:\ //g' | grep -Ev '[A-Z]' > $domain/gobuster_1.txt
        cat $domain/gobuster-2.txt | sed 's/Found:\ //g' | grep -Ev '[A-Z]' > $domain/gobuster_2.txt
	rm $domain/gobuster-*
        cat $domain/sublister.txt  | sed 's/<BR>/\r\n/g' > $domain/sublist3r.txt
	rm $domain/sublister.txt
	cat ~/aquatone/$domain/hosts.txt| awk -F ',' '{print $1}' | sed 's/\.$//g' >  $domain/aquatone_hosts.txt
	cat $domain/* | sort -ibu > $domain/all_subdomains.txt
}

# Filter out active subdomains
check_active_domains(){
	echo -e "\033[1;34m[!]\033[0m Filtering Active Subdomains"
        python3 /opt/tools/lookup.py -f $domain/all_subdomains.txt &>/dev/null
	mv active_subdomains.txt $domain/
	mv dormant_subdomains.txt $domain/
}

# crawl for probes
do_probe() {
	echo -e "\033[1;33m[+]\033[0m Probing for active web services"
	cat $domain/active_subdomains.txt | httprobe > $domain/web_pages.txt
}

check_subdomain_takeover() {
	aquatone-takeover -d $domain
}

# Main Function
if [[ ! -z $1 ]]; then
        rm -rf $1
	domain=$1
	figlet SOCRadar-Recon
        recon $domain
        filter
        check_active_domains
	do_probe
	check_subdomain_takeover
else
        echo -e "Usage: ./script domain.com"
fi
