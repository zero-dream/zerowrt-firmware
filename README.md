### ZeroWrt-Firmware-CI

ZeroWrt 固件，由 ZeroDream 基于 VIKINGYFY 的 ImmortalWrt 源码进行开发

### 固件核心介绍

ZeroWrt 固件的初始软件包非常精简，通过自研的虚拟算法，内置了大量 Kernel Modules

可以安装绝大部分的 Openwrt 官方 Package，极少出现内核模块缺失的情况

### Fork 注意事项

本项目存在闭源的虚拟算法，Fork 的仓库在编译时不会添加部分配置

但是固件本身非常精简，可以基于此进行二次开发

### 目录简要说明

固件文件名的时间为开始编译的时间，方便核对上游源码的提交时间

zerodream ------ ZeroDream-CI 私有目录

hook ------ ZeroDream-CI 专用目录

application ------ 应用目录

config ------- 配置目录

script ------ 脚本目录

storage ------ 储存目录

openwrt ------ 数据覆盖目录

### 软件包下载

https://github.com/zero-dream/ZeroWrt-Package-CI

### 参考的项目

https://github.com/VIKINGYFY/OpenWRT-CI

https://github.com/davidtall/OpenWRT-CI
