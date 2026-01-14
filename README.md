
[uboot-partition-jdcloud-re-ss-01]: /storage/uboot-partition/jdcloud-re-ss-01/
[uboot-partition-jdcloud-re-cs-02]: /storage/uboot-partition/jdcloud-re-cs-02/
[uboot-partition-jdcloud-re-cs-07]: /storage/uboot-partition/jdcloud-re-cs-07/
[uboot-partition-redmi-ax5-jdcloud]: /storage/uboot-partition/redmi-ax5-jdcloud/

<div align="center">

  ### ZeroWrt-Firmware

  ZeroWrt 固件，由 ZeroDream 基于 ImmortalWrt 源码开发

  支持系列: QUALCOMMAX, MEDIATEK, ROCKCHIP, X86

  ### 核心介绍

  ZeroWrt 固件的初始软件包非常精简
  
  通过自研的虚拟算法，内置了大量的内核模块

  能够安装大部分的官方软件包，极少出现内核依赖缺失的问题

  ### 注意事项

  注: 以下设备请先刷对应的 U-Boot 和 GPT，再刷固件

  | 设备名称 | 内核大小 | U-Boot & Partition |
  | :---: | :---: | :---: |
  | jdcloud-re-ss-01 | 12M | [uboot-partition][uboot-partition-jdcloud-re-ss-01] |
  | jdcloud-re-cs-02 | 12M | [uboot-partition][uboot-partition-jdcloud-re-cs-02] |
  | jdcloud-re-cs-07 | 12M | [uboot-partition][uboot-partition-jdcloud-re-cs-07] |
  | redmi-ax5-jdcloud | 12M | [uboot-partition][uboot-partition-redmi-ax5-jdcloud] |

  ### 参考来源

  [VIKINGYFY/OpenWRT-CI](https://github.com/VIKINGYFY/OpenWRT-CI)

  \--------------------------------------------------

  ### 软件包下载

  [zero-dream/zerowrt-package](https://github.com/zero-dream/zerowrt-package)

  ### U-Boot 下载

  [高通: chenxin527/uboot-ipq60xx-emmc-build](https://github.com/chenxin527/uboot-ipq60xx-emmc-build)

  [联发科: uboot/mediatek](https://drive.wrt.moe/uboot/mediatek)

  \--------------------------------------------------

  ### Fork 注意事项

  项目存在闭源的虚拟算法，Fork 的仓库在编译时不会添加部分配置

  由于固件本身非常精简，可以基于项目进行二次开发

  ### 目录简要说明

  固件文件名的时间为开始编译的时间，方便核对上游源码的提交时间

  | 目录 | 作用 |
  | :---: | :---: |
  | zerodream | 私有目录，禁止修改 |
  | private | 私有目录，禁止修改 |
  | hook | Workflow 专用目录 |
  | application | 应用目录 |
  | config | 配置目录 |
  | script | 脚本目录 |
  | storage | 储存目录 |
  | backup | 备份目录 |
  | openwrt | 数据覆盖目录 |

</div>
