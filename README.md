### ZeroWrt-Firmware

本仓库修改自: [VIKINGYFY/OpenWRT-CI](https://github.com/VIKINGYFY/OpenWRT-CI)

ZeroWrt 固件，由 ZeroDream 基于 ImmortalWrt 源码开发

### 固件核心介绍

ZeroWrt 固件的初始软件包非常精简，通过自研的虚拟算法，内置了大量的内核模块

能够安装大部分的官方软件包，极少出现内核依赖缺失的问题

### 固件简要说明

固件每天早上 4 点自动编译

支持的系列: QUALCOMMAX, MEDIATEK, ROCKCHIP, X86

修改内核大小 (12M): jdcloud_re-ss-01, jdcloud_re-cs-02, jdcloud_re-cs-07, redmi_ax5-jdcloud

### 软件包下载

https://github.com/zero-dream/zerowrt-package

### U-Boot

高通版: https://github.com/chenxin527/uboot-ipq60xx-emmc-build

联发科版: https://drive.wrt.moe/uboot/mediatek

---

### Fork 注意事项

项目存在闭源的虚拟算法，Fork 的仓库在编译时不会添加部分配置

由于固件本身非常精简，可以基于项目进行二次开发

### 目录简要说明

固件文件名的时间为开始编译的时间，方便核对上游源码的提交时间

zerodream ------ ZeroDream 私有目录

hook ------ Workflow 专用目录

application ------ 应用目录

config ------- 配置目录

script ------ 脚本目录

storage ------ 储存目录

backup ------ 备份目录

openwrt ------ 数据覆盖目录
