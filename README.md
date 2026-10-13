
[uboot-partition-jdcloud-re-ss-01]: /storage/uboot-partition/jdcloud-re-ss-01/
[uboot-partition-jdcloud-re-cs-02]: /storage/uboot-partition/jdcloud-re-cs-02/
[uboot-partition-jdcloud-re-cs-07]: /storage/uboot-partition/jdcloud-re-cs-07/
[uboot-partition-redmi-ax5-jdcloud]: /storage/uboot-partition/redmi-ax5-jdcloud/

<div align="center">

  ### ZeroWrt-Firmware

  本项目基于 [VIKINGYFY/OpenWRT-CI](https://github.com/VIKINGYFY/OpenWRT-CI) 开发

  支持系列: QUALCOMMAX, MEDIATEK, ROCKCHIP, X86

  ### 核心介绍

  ZeroWrt 固件极为精简，追求按需安装，探索前沿技术

  ### 自研算法

  虚拟算法：采用动态分析技术识别所需内核模块

  更新算法：自动更新部分软件包至最新版本

  ### 注意事项

  注: 以下设备请先刷对应的 U-Boot 和 GPT，再刷固件

  | 设备名称 | 内核大小 | U-Boot & Partition |
  | :---: | :---: | :---: |
  | jdcloud-re-ss-01 | 12M | [uboot-partition][uboot-partition-jdcloud-re-ss-01] |
  | jdcloud-re-cs-02 | 12M | [uboot-partition][uboot-partition-jdcloud-re-cs-02] |
  | jdcloud-re-cs-07 | 12M | [uboot-partition][uboot-partition-jdcloud-re-cs-07] |
  | redmi-ax5-jdcloud | 12M | [uboot-partition][uboot-partition-redmi-ax5-jdcloud] |

  \--------------------------------------------------

  ### 软件包下载

  [zero-dream/zerowrt-package](https://github.com/zero-dream/zerowrt-package)

  ### U-Boot 下载

  #### 高通版-沉心

  [chenxin527/uboot-qsdk12.5-build](https://github.com/chenxin527/uboot-qsdk12.5-build)

  #### 高通版-小猪

  [1980490718/u-boot-2016](https://github.com/1980490718/u-boot-2016)

  #### 联发科-全新版

  [VIKINGYFY/UBOOT-CI/releases](https://github.com/VIKINGYFY/UBOOT-CI/releases)

  #### 联发科-官方版

  [drive.wrt.moe/uboot/mediatek](https://drive.wrt.moe/uboot/mediatek)

  \--------------------------------------------------

  ### Fork 注意事项

  项目包含闭源的虚拟算法和自动更新算法

  Fork 仓库编译时，闭源算法不会被正确运行

  由于固件本身非常精简，很适合基于此项目二次开发

</div>
