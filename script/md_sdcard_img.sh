#!/bin/sh
# write by haobo to make a sd card bootable img
#												haobo@2019年5月14日

#dest image Name
DEST_IMAGE_NAME="boot.img"
TIMESTAMP=`date +%Y%m%d%H%m%S`

# The disk layout used is:
#
#    0                      -> IMAGE_ROOTFS_ALIGNMENT         - reserved to bootloader (not partitioned)
#    IMAGE_ROOTFS_ALIGNMENT -> BOOT_SPACE                     - kernel and other data
#    BOOT_SPACE             -> SDIMG_SIZE                     - rootfs
#
#                                                     Default Free space = 1.3x
#                                                     Use IMAGE_OVERHEAD_FACTOR to add more space
#                                                     <--------->
#            4MiB               8MiB           SDIMG_ROOTFS                    4MiB
# <-----------------------> <----------> <----------------------> <------------------------------>
#  ------------------------ ------------ ------------------------ -------------------------------
# | IMAGE_ROOTFS_ALIGNMENT | BOOT_SPACE | ROOTFS_SIZE            |     IMAGE_ROOTFS_ALIGNMENT    |
#  ------------------------ ------------ ------------------------ -------------------------------
# ^                        ^            ^                        ^                               ^
# |                        |            |                        |                               |
# 0                      4096     4MiB +  8MiB       4MiB +  8Mib + SDIMG_ROOTFS   4MiB +  8MiB + SDIMG_ROOTFS + 4MiB
BOOT_SPACE="512000"
IMAGE_ROOTFS_ALIGNMENT="4096"
BOOT_SPACE_ALIGNED=$(expr ${BOOT_SPACE} + ${IMAGE_ROOTFS_ALIGNMENT} - 1)
BOOT_SPACE_ALIGNED=$(expr ${BOOT_SPACE_ALIGNED} - ${BOOT_SPACE_ALIGNED} % ${IMAGE_ROOTFS_ALIGNMENT})
SDCARD_SIZE=$(expr ${IMAGE_ROOTFS_ALIGNMENT} + ${BOOT_SPACE_ALIGNED} + $ROOTFS_SIZE + ${IMAGE_ROOTFS_ALIGNMENT})

gen_sdcard(){
	parted -s ${DEST_IMAGE_NAME} mklabel msdos
	parted -s ${DEST_IMAGE_NAME} unit KiB mkpart primary fat32 ${IMAGE_ROOTFS_ALIGNMENT} $(expr ${IMAGE_ROOTFS_ALIGNMENT} \+ ${BOOT_SPACE_ALIGNED})
	parted ${DEST_IMAGE_NAME} print
	dd if=./u-boot.imx of=${DEST_IMAGE_NAME} conv=notrunc seek=2 bs=512
}


#初始化一个空的镜像文件
dd if=/dev/zero of=${DEST_IMAGE_NAME} bs=1 count=0 seek=$(expr 1024 \* ${SDCARD_SIZE})

gen_sdcard








