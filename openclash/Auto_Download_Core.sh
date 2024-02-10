#!/bin/bash

ARCH_1 = uname -m
echo "Current Arch: $ARCH_1"

echo "Start YACD Download !"

yacd="https://github.com/taamarin/yacd-meta/archive/gh-pages.zip"
mkdir -p usr/share/openclash/ui
if wget --no-check-certificate -nv $yacd -O usr/share/openclash/ui/yacd.zip; then
   unzip -qq usr/share/openclash/ui/yacd.zip -d usr/share/openclash/ui && rm usr/share/openclash/ui/yacd.zip
   if mv usr/share/openclash/ui/yacd* usr/share/openclash/ui/yacd.new; then 
     echo "YACD Dashboard download successfully."
   fi
else
   echo "Failed to download YACD Dashboard"
fi

echo "Start Clash Core Download !"
#core download url
clash="https://github.com/vernesong/OpenClash/raw/core/master/dev/clash-linux-$ARCH_1.tar.gz"
clash_meta="$(meta_api="https://api.github.com/repos/MetaCubeX/mihomo/releases/latest" && meta_file="mihomo-linux-$ARCH_1" && curl -s ${meta_api} | grep "browser_download_url" | grep -oE "https.*${meta_file}-v[0-9]+\.[0-9]+\.[0-9]+\.gz" | head -n 1)"
clash_tun="https://github.com/vernesong/OpenClash/raw/core/master/premium/$(curl -s "https://github.com/vernesong/OpenClash/tree/core/master/premium" | grep -o "clash-linux-$ARCH_1-[0-9]*\.[0-9]*\.[0-9]*-[0-9]*-[a-zA-Z0-9]*\.gz" | awk 'NR==1 {print $1}')"
clash_meta_17="https://github.com/MetaCubeX/mihomo/releases/download/v1.17.0/mihomo-linux-$ARCH_1-v1.17.0.gz"

mkdir -p etc/openclash/core
cd etc/openclash/core || { echo "Clash core path does not exist!"; exit 1; }
echo "Downloading clash.tar.gz..."
if wget --no-check-certificate -nv -O clash.tar.gz $clash; then
   tar -zxf clash.tar.gz
   rm clash.tar.gz
   echo "clash.tar.gz downloaded and extracted successfully."
else
   echo "Failed to download clash.tar.gz."
fi
   
echo "Downloading clash_meta.gz..."
#if wget --no-check-certificate -nv -O clash_meta.gz $clash_meta; then
if wget --no-check-certificate -nv -O clash_meta.gz $clash_meta_17; then
   gzip -d clash_meta.gz
   echo "clash_meta.gz downloaded successfully."
else
   echo "Failed to download clash_meta.gz."
fi
   
echo "Downloading clash_tun.gz..."
if wget --no-check-certificate -nv -O clash_tun.gz $clash_tun; then
   gzip -d clash_tun.gz
   echo "clash_tun.gz downloaded successfully."
else
   echo "Failed to download clash_tun.gz."
fi

echo "All Core Downloaded succesfully"
