# 借助 GitHub Actions 的 OpenWrt 在线自动编译.

#### hanwckf大佬mt798x闭源仓库- [hanwckf/immortalwrt-mt798x](https://github.com/hanwckf/immortalwrt-mt798x).

#### hanwckf大佬mt798x uboot仓库- [hanwckf/bl-mt798x](https://github.com/hanwckf/bl-mt798x).

#### 加菲猫大佬刷机教程与固件仓库- [lgs2007m/Actions-OpenWrt](https://github.com/lgs2007m/Actions-OpenWrt).

### 刷砖也不怕！可以通过串口救砖：[MediaTek Filogic 系列路由器串口救砖教程](https://www.cnblogs.com/p123/p/18046679)

---
## JDCloud-AX6000-Baili workflow 手动运行可选项：
- #### Set LAN IP Address
设置LAN IP地址（路由器登录地址），默认192.168.1.1。

---
## 关于脚本的一些说明
- #### 使用源码：https://github.com/hanwckf/immortalwrt-mt798x
- #### 使用分支：openwrt-21.02 内核版本：5.4.284
- #### 使用NekokeCore大佬修改的软件源和luci-theme-design主题
- #### 使用WiFi驱动v7.6.7.2-fw-20240823
- #### 使用GSW交换机驱动（非DSA）
- #### 使用hanwckf mtwifi-cfg原生luci无线配置工具
- #### 完全禁用ipv6，此举是防止DNS泄露的第一步，也是最重要的一步
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
### 感谢P3TERX的Actions-OpenWrt
- [P3TERX](https://github.com/P3TERX/Actions-OpenWrt)
[Read the details in my blog (in Chinese) | 中文教程](https://p3terx.com/archives/build-openwrt-with-github-actions.html)
