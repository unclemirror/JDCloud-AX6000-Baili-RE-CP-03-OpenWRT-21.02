# 借助 GitHub Actions 的 OpenWrt 在线自动编译.

#### hanwckf大佬mt798x闭源仓库- [hanwckf/immortalwrt-mt798x](https://github.com/hanwckf/immortalwrt-mt798x).

#### 237大佬mt798x闭源仓库- [padavanonly/immortalwrt-mt798x](https://github.com/padavanonly/immortalwrt-mt798x).

#### hanwckf大佬mt798x uboot仓库- [hanwckf/bl-mt798x](https://github.com/hanwckf/bl-mt798x).

#### 加菲猫大佬刷机教程与固件仓库- [lgs2007m/Actions-OpenWrt](https://github.com/lgs2007m/Actions-OpenWrt).

### 刷砖也不怕！可以通过串口救砖：[MediaTek Filogic 系列路由器串口救砖教程](https://www.cnblogs.com/p123/p/18046679)

---
## JDCloud-AX6000-Baili workflow 手动运行可选项：
- Set LAN IP Address
- Choose WiFi Driver
- Choose Switch Driver
- [ ] Use luci-app-mtk wifi config
- [ ] Build luci-app-dockerman

- #### 说明
源码中的WAN、LAN地址顺序已修复并固定了WiFi MAC地址

- #### 1. Set LAN IP Address
设置LAN IP地址（路由器登录地址），默认192.168.1.1。 

- #### 2. Choose WiFi Driver
默认使用WiFi驱动版本v7.6.7.2-fw-20240823(recommend)。  
mt_wifi的firmware可选，warp默认使用v7.6.7.2配套的warp_20231229-5f71ec，firmware用驱动自带的，不可选。  
驱动版本v7.6.7.2-fw-default不建议使用，加菲猫大佬使用5G无线，电脑打CS2同时手机刷视频，CS2会延迟增高卡顿。  
根据网络和ChatGPT查询，加菲猫大佬的理解：  
mt_wifi是MediaTek的WiFi驱动程序，主要用于控制无线网络功能，提供WiFi协议栈支持、无线电控制、连接管理等。  
warp是MediaTek的WiFi Warp Accelerator加速框架，通常用于WiFi网络数据处理的加速。  
mt_wifi和warp中的固件（firmware）是驱动程序与无线芯片之间的中间层。它通常被加载到无线芯片中，以控制其硬件功能，管理无线协议并处理数据传输，会影响无线性能和稳定性。  
v7.6.7.2-fw-20240823(recommend) 推荐，使用[mtk-openwrt-feeds(20240823)](https://git01.mediatek.com/plugins/gitiles/openwrt/feeds/mtk-openwrt-feeds/+/0fdbc0e6d84bbc0216da2842a494bdf01f745c6c)  
v7.6.6.1-fw-20230808(recommend) 推荐，使用提取自TP-XDR6088固件的fw-20230808  
v7.6.7.2-fw-default 使用驱动包自带firmware fw-20231229  
v7.6.6.1-fw-default 使用驱动包自带firmware fw-20220906  
其他firmware可自行组合尝试：  
fw-20221208 使用mt7986-7.6.7.0-20221209-b9c02f-obj驱动包的fw-20221208  
fw-20230421 使用mtk-openwrt-feeds(20230421)的fw-20230421  
fw-20231024 使用mtk-openwrt-feeds(20231024)的fw-20231024  
```
# SSH查看内核版本
uname -a
# 查看WiFi驱动版本
iwpriv ra0 get_driverinfo
# 查看WiFi驱动mt_wifi mt7986 firmware版本
strings /lib/firmware/7986_WACPU_RAM_CODE_release.bin | grep -E '202[0-9]{6}'
strings /lib/firmware/mt7986_patch_e1_hdr.bin | grep -E '202[0-9]{6}'
strings /lib/firmware/mt7986_patch_e1_hdr_mt7975.bin | grep -E '202[0-9]{6}'
strings /lib/firmware/WIFI_RAM_CODE_MT7986.bin | grep -E '202[0-9]{6}'
strings /lib/firmware/WIFI_RAM_CODE_MT7986_MT7975.bin | grep -E '202[0-9]{6}'
# 查看WiFi驱动warp mt7986 firmware版本
strings /lib/firmware/7986_WOCPU0_RAM_CODE_release.bin | grep -E '202[0-9]{6}'
strings /lib/firmware/7986_WOCPU1_RAM_CODE_release.bin | grep -E '202[0-9]{6}'
```

- #### 3. Choose Switch Driver
默认使用DSA交换机驱动，可选GSW交换机驱动。  
GSW：Gigabit Switch swconfig 模式，有交换机配置插件，不过京东云百里AX6000的WAN是单独接CPU的2.5G PHY RTL8221B，不接在MT7531交换机上，所以WAN不支持在交换机配置插件中设置VLAN。  
DSA：Distributed Switch Architecture 分布式交换架构模式，DSA没有单独的交换机配置插件，但在“网口”-“接口”-“设备”选项卡中的br-lan设备中的网桥VLAN过滤中可以查看网口状态设置VLAN。  
百里原厂固件使用的是DSA，hanwckf大佬源码中百里的交换机驱动先前是DSA，听说在WAN、LAN互换时硬件加速可能失效，但是加菲猫大佬测试了是正常的。  
目前hanwckf大佬源码中百里已改为使用GSW，使用GSW在WAN、LAN互换时硬件加速正常，所以DSA、GSW随便用吧。  
两者具体区别可以参考OpenWrt社区资料：[converting-to-dsa](https://openwrt.org/docs/guide-user/network/dsa/converting-to-dsa) [dsa-mini-tutorial](https://openwrt.org/docs/guide-user/network/dsa/dsa-mini-tutorial) 

- #### 4. Use luci-app-mtk wifi config
该选项默认关闭，即按.config配置文件，使用mtwifi-cfg配置工具，需要使用旧的luci-app-mtk无线配置工具请打钩。  
mtwifi-cfg：为mtwifi设计的无线配置工具，兼容openwrt原生luci和netifd，可调整无线驱动的参数较少，配置界面美观友好。  
luci-app-mtk：源自mtk-sdk提供的配置工具，需要配合wifi-profile脚本使用，可调整无线驱动的几乎所有参数，配置界面较为简陋。
区别详见大佬的博客[mtwifi无线配置工具说明](https://cmi.hanwckf.top/p/immortalwrt-mt798x/#mtwifi%E6%97%A0%E7%BA%BF%E9%85%8D%E7%BD%AE%E5%B7%A5%E5%85%B7%E8%AF%B4%E6%98%8E)
.config配置文件中已设置使用mtwifi-cfg配置工具：  
CONFIG_PACKAGE_luci-app-mtwifi-cfg=y  
CONFIG_PACKAGE_luci-i18n-mtwifi-cfg-zh-cn=y  
CONFIG_PACKAGE_mtwifi-cfg=y  
CONFIG_PACKAGE_lua-cjson=y  

- #### 5. Build luci-app-dockerman
该选项默认关闭，即按.config配置文件编译固件，.config配置文件中未设置编译dockerman.  
需要编译dockerman请打钩，脚本会在.config中自动添加：  
CONFIG_PACKAGE_luci-app-dockerman=y  
CONFIG_PACKAGE_kmod-dm=y  
CONFIG_PACKAGE_kmod-br-netfilter=y  
CONFIG_PACKAGE_kmod-ikconfig=y  
CONFIG_PACKAGE_kmod-nf-ipvs=y  
CONFIG_PACKAGE_kmod-veth=y  

- #### Other
百里5G无线发射功率23dBm，2.4G发送功率25dBm。大佬们已研究出修改5G发射功率的方法。  
其中各个功率十六进制数据代表如下：  
23dBm x2A  
24dBm x2B  
25dBm x2C 或 x2D  
百里直接SSH使用下面命令，软修改（即不修改factory分区）5G为24dBm，修改好之后reboot重启即可。  
MT7986_ePAeLNA_EEPROM_AX6000.bin文件只在固件第一次启动时从factory复制出来，所以修改一次即可。  
```
hex_value='\x2B'
printf "$hex_value%.0s" {1..20} > /tmp/tmp.bin
dd if=/tmp/tmp.bin of=/lib/firmware/MT7986_ePAeLNA_EEPROM_AX6000.bin bs=1 seek=$((0x445)) conv=notrunc
```
当然也可以直接硬修改factory分区，使得以后每次刷新固件都不用再修改了。  
首先备份好原厂factory分区，然后修改MT7986_ePAeLNA_EEPROM_AX6000.bin并写入factory分区，再备份一次factory分区。  
自行到tmp下载保存好备份，然后reboot重启即可。  
```
hex_value='\x2B'
printf "$hex_value%.0s" {1..20} > /tmp/tmp.bin
dd if=$(blkid -t PARTLABEL=factory -o device) of=/tmp/mmcblk0px_factory_backup.bin conv=fsync
dd if=/tmp/tmp.bin of=/lib/firmware/MT7986_ePAeLNA_EEPROM_AX6000.bin bs=1 seek=$((0x445)) conv=notrunc
dd if=/tmp/tmp.bin of=$(blkid -t PARTLABEL=factory -o device) bs=1 seek=$((0x445)) conv=notrunc
dd if=$(blkid -t PARTLABEL=factory -o device) of=/tmp/mmcblk0px_factory.bin conv=fsync
```

---
## 关于脚本的一些说明
- #### 使用源码：https://github.com/hanwckf/immortalwrt-mt798x
- #### 使用分支：openwrt-21.02 内核版本：5.4.284
- #### 使用NekokeCore大佬修改的软件源和luci-theme-design主题
- #### 自动下载最新版本OpenClash与最新meta内核（master）
- #### 使用lmq8267大佬编译的luci-app-cloudflared，并自动下载最新的cloudflared二进制文件，存放路径/etc/client/cloudflared

---
## 感谢P3TERX的Actions-OpenWrt
- [P3TERX](https://github.com/P3TERX/Actions-OpenWrt)
[Read the details in my blog (in Chinese) | 中文教程](https://p3terx.com/archives/build-openwrt-with-github-actions.html)
