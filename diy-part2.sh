#!/bin/bash
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#
# Copyright (c) 2019-2024 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#

# Modify default IP
#sed -i 's/192.168.1.1/192.168.50.5/g' package/base-files/files/bin/config_generate

# Modify default theme
#sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci/Makefile

# Modify hostname
#sed -i 's/OpenWrt/P3TERX-Router/g' package/base-files/files/bin/config_generate

##-----------------Del OAF old version------------------
rm -rf feeds/packages/net/open-app-filter >/dev/null 2>&1
rm -rf feeds/luci/applications/luci-app-appfilter >/dev/null 2>&1

##-----------------Add latest OpenClash meta core------------------
curl -sL -m 30 --retry 2 https://raw.githubusercontent.com/vernesong/OpenClash/core/master/meta/clash-linux-arm64.tar.gz -o /tmp/clash.tar.gz
tar zxvf /tmp/clash.tar.gz -C /tmp >/dev/null 2>&1
chmod +x /tmp/clash >/dev/null 2>&1
mkdir -p package/OpenClash/luci-app-openclash/root/etc/openclash/core
mv /tmp/clash package/OpenClash/luci-app-openclash/root/etc/openclash/core/clash_meta >/dev/null 2>&1
rm -rf /tmp/clash.tar.gz >/dev/null 2>&1

##-----------------Replace latest cloudflared------------------
rm -rf feeds/packages/net/cloudflared >/dev/null 2>&1
curl -sL -m 30 --retry 2 https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-arm64 -o /tmp/cloudflared
chmod +x /tmp/cloudflared >/dev/null 2>&1
mkdir -p package/CloudFlared/luci-app-cloudflared/root/etc/client
mv /tmp/cloudflared package/CloudFlared/luci-app-cloudflared/root/etc/client/cloudflared >/dev/null 2>&1

##-----------------Manually set CPU frequency for MT7986A-----------------
sed -i '/"mediatek"\/\*|\"mvebu"\/\*/{n; s/.*/\tcpu_freq="2.0GHz" ;;/}' package/emortal/autocore/files/generic/cpuinfo
