#!/bin/bash

## 1. install go
function install_go {
	wget https://golang.org/dl/go1.16.3.linux-amd64.tar.gz
	rm -rf /usr/local/go && tar -C /usr/local -xzf go1.16.3.linux-amd64.tar.gz
	export PATH=$PATH:/usr/local/go/bin
}

## 2. install aquatone
function install_aquatone {
	sudo apt install gem
	gem install aquatone
}

## 3. install gobuster
function install_gobuster {
	sudo apt-get install gobuster
}

## 4. install assetfinder
function install_assetfinder {
	wget https://github.com/tomnomnom/assetfinder/releases/download/v0.1.1/assetfinder-linux-amd64-0.1.1.tgz
	tar xzvf assetfinder-linux-amd64-0.1.1.tgz
	mv assetfinder /usr/bin/
	rm assetfinder-linux-amd64-0.1.1.tgz
}

## 5. install httprobe
function install_httprobe {
	wget https://github.com/tomnomnom/httprobe/releases/download/v0.1.2/httprobe-linux-amd64-0.1.2.tgz
	tar zxvf httprobe-linux-amd64-0.1.2.tgz
	mv httprobe /usr/bin/
	rm httprobe-linux-amd64-0.1.2.tgz
}

## 6. install subfinder
function install_subfinder {
	wget https://github.com/projectdiscovery/subfinder/releases/download/v2.4.7/subfinder_2.4.7_linux_amd64.tar.gz
	tar subfinder_2.4.7_linux_amd64.tar.gz
	mv subfinder /usr/bin
	rm subfinder_2.4.7_linux_amd64.tar.gz
}

## 7. install sublist3r
function install_sublist3r {
	mkdir -p /opt/tools/sublist3r
	git clone https://github.com/aboul3la/Sublist3r.git /opt/tools/sublist3r
	# double check
	pip3 install -r /opt/tools/sublist3r/requirements.txt
	python3 /opt/tools/sublist3r/setup.py
}

## 8. install lookup.py
function install_lookup {
	git clone https://github.com/shellbr3ak/dns-lookup /opt/tools/
}

## 9. install amass
function install_amass {
	sudo apt update
	sudo apt install snapd
	sudo snap install amass
}

## 10. install SecLists
function install_seclist {
	wget -c https://github.com/danielmiessler/SecLists/archive/master.zip -O SecList.zip
	unzip SecList.zip -d /opt
	rm SecList.zip
}

## 11. install Banner {
	sudo apt install figlet
}

## main
install_go
install_gobuster
install_assetfinder
install_httprobe
install_subfinder
install_sublist3r
install_lookup
install_amass
install_seclist
