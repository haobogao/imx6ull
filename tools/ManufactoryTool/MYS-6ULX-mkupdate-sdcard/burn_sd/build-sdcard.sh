#!/bin/sh
# This file used for build a sdcard file to programming files to NAND storage
# This file feference the meta-fsl-arm/classes/image_types_fsl.bbclass.


FLASH_TYPE="none"

while getopts "p:d:s:enc:t:h" arg
do
    case $arg in
        p)
            MACHINE="$OPTARG"
            ;;
        d)
            UPDATE_DIR="$OPTARG"
            ;;
        s)
            DDR_SIZE="$OPTARG"
            ;;
        e)
            FLASH_TYPE="emmc"
            ;;
        n)
            FLASH_TYPE="nand"
            ;;
        t)
            FILE_TAG="$OPTARG"
            ;;
        h)
            echo "-p <mys6ull | mys6ul | myd-y6ull | myd-y6ul> you need choose an platform"
            echo "-d < target image dir > target image dir path"
            echo "-e < eMMC Flash >"
            echo "-n < NAND Flash >"
            echo "-t < tagname > append name as tag on output filename"
            exit 1
            ;;
        ?)
            echo "unkonw argument"
        exit 1
        ;;
    esac
done

if [ $# -lt 4 ]
then
	echo "need platform and update dir"
	exit
fi

if [ -f "firmware/Manifest" ]
then
	echo "Load Firmware Manifest"
	. firmware/Manifest
else
	echo "The directory firmware or file firmware/Manifest does not exist!!!"
	exit 1
fi

IMAGE_BOOTLOADER="u-boot"
FIRMWARE_DIR="firmware"
WORKDIR="."

# update system firmware
if [ ${MACHINE} = "mys6ull" ]
then
    if [ ${FLASH_TYPE} = "nand" ]
	then
		BOOT_SCRIPTS="${FW_MYS6ULL_BOOT_SCRIPT_NAND}:boot.scr"
		KERNEL_DEVICETREE="${FW_MYS6ULL_DEVICETREE_NAND}"
	elif [ ${FLASH_TYPE} = "emmc" ]
	then
		KERNEL_DEVICETREE="${FW_MYS6ULL_DEVICETREE_EMMC}"
		BOOT_SCRIPTS="${FW_MYS6ULL_BOOT_SCRIPT_EMMC_DDR512}:boot.scr"
	fi
elif [ ${MACHINE} = "mys6ul" ]
then
	if [ ${FLASH_TYPE} = "nand" ]
	then
		BOOT_SCRIPTS="${FW_MYS6UL_BOOT_SCRIPT_NAND}:boot.scr"
		KERNEL_DEVICETREE="${FW_MYS6UL_DEVICETREE_NAND}"
	elif [ ${FLASH_TYPE} = "emmc" ]
	then
		BOOT_SCRIPTS="${FW_MYS6UL_BOOT_SCRIPT_EMMC}:boot.scr"
		KERNEL_DEVICETREE="${FW_MYS6UL_DEVICETREE_EMMC}"
	fi
elif [ ${MACHINE} = "myd-y6ull" ]
then
	if [ ${FLASH_TYPE} = "nand" ]
	then
		BOOT_SCRIPTS="${FW_MYD_Y6ULL_BOOT_SCRIPT_NAND}:boot.scr"
		KERNEL_DEVICETREE="${FW_MYD_Y6ULL_DEVICETREE_NAND}"
	elif [ ${FLASH_TYPE} = "emmc" ]
	then
		BOOT_SCRIPTS="${FW_MYD_Y6ULL_BOOT_SCRIPT_EMMC}:boot.scr"
		KERNEL_DEVICETREE="${FW_MYD_Y6ULL_DEVICETREE_EMMC}"
	fi
elif [ ${MACHINE} = "myt-y6ull" ]
then
	if [ ${FLASH_TYPE} = "nand" ]
	then
		BOOT_SCRIPTS="${FW_MYT_Y6ULL_BOOT_SCRIPT_NAND}:boot.scr"
		KERNEL_DEVICETREE="${FW_MYT_Y6ULL_DEVICETREE_NAND}"
	elif [ ${FLASH_TYPE} = "emmc" ]
	then
		BOOT_SCRIPTS="${FW_MYT_Y6ULL_BOOT_SCRIPT_EMMC}:boot.scr"
		KERNEL_DEVICETREE="${FW_MYT_Y6ULL_DEVICETREE_EMMC}"
	fi
elif [ ${MACHINE} = "myd-y6ul" ]
then
	if [ ${FLASH_TYPE} = "nand" ]
	then
		BOOT_SCRIPTS="${FW_MYD_Y6UL_BOOT_SCRIPT_NAND}:boot.scr"
		KERNEL_DEVICETREE="${FW_MYD_Y6UL_DEVICETREE_NAND}"
	elif [ ${FLASH_TYPE} = "emmc" ]
	then
		BOOT_SCRIPTS="${FW_MYD_Y6UL_BOOT_SCRIPT_EMMC}:boot.scr"
		KERNEL_DEVICETREE="${FW_MYD_Y6UL_DEVICETREE_EMMC}"
	fi
elif [ ${MACHINE} = "myt-y6ul" ]
then
	if [ ${FLASH_TYPE} = "nand" ]
	then
		BOOT_SCRIPTS="${FW_MYT_Y6UL_BOOT_SCRIPT_NAND}:boot.scr"
		KERNEL_DEVICETREE="${FW_MYT_Y6UL_DEVICETREE_NAND}"
	elif [ ${FLASH_TYPE} = "emmc" ]
	then
		BOOT_SCRIPTS="${FW_MYT_Y6UL_BOOT_SCRIPT_EMMC}:boot.scr"
		KERNEL_DEVICETREE="${FW_MYT_Y6UL_DEVICETREE_EMMC}"
	fi
fi

KERNEL_IMAGETYPE="${FW_KERNEL_IMAGE}"
#SDCARD_ROOTFS="myir-image-update-mys6ull14x14-20170501014430.rootfs.ext4"
#SDCARD_ROOTFS="myir-image-update-mys6ull14x14-20170719014828.rootfs.ext4"
UBOOT_SUFFIX="imx"
UBOOT_SUFFIX_SDCARD="${UBOOT_SUFFIX}"

# Boot partition volume id
BOOTDD_VOLUME_ID="Boot${MACHINE}"

# Boot partition size [in KiB]
# set 500MB, because MYS6ULx board default has 256MB nand
BOOT_SPACE="512000"

TIMESTAMP=`date +%Y%m%d%H%m%S`

# Set alignment to 4MB [in KiB]
IMAGE_ROOTFS_ALIGNMENT="4096"
IMAGE_NAME="update"

if [ -z "${FILE_TAG}" ]
then
	SDCARD="${MACHINE}-${IMAGE_NAME}-${FLASH_TYPE}-${TIMESTAMP}.rootfs.sdcard"
else
	SDCARD="${MACHINE}-${IMAGE_NAME}-${FLASH_TYPE}-${FILE_TAG}-${TIMESTAMP}.rootfs.sdcard"
fi

# Set update system rootfs size [in KB]
# set 100MB
ROOTFS_SIZE="102400"

echo "----- Build Info"
if [ ${MACHINE} = "mys6ull" ]
then
	echo "MACHINE is MYS-6ULX-IOT"
elif [ ${MACHINE} = "mys6ul" ]
then
	echo "MACHINE is MYS-6ULX-IND"
fi
echo "Flash type is $FLASH_TYPE"
echo "DDR size is $DDR_SIZE"
echo "Output file is ${SDCARD}"
echo "Target file update dir is $UPDATE_DIR"
echo "-----"


# Programming directory
# you need put need programming files to this directory,
# include u-boot, dtb, zImage and ext4 format of rootfs file

SDCARD_GENERATION_COMMAND="generate_imx_sdcard"

#
# Generate the boot image with the boot scripts and required Device Tree
# files
_generate_boot_image() {
	local boot_part=$1

	# Create boot partition image
	BOOT_BLOCKS=$(LC_ALL=C parted -s ${SDCARD} unit b print \
	                  | awk "/ $boot_part / { print substr(\$4, 1, length(\$4 -1)) / 1024 }")

	# mkdosfs will sometimes use FAT16 when it is not appropriate,
	# resulting in a boot failure from SYSLINUX. Use FAT32 for
	# images larger than 512MB, otherwise let mkdosfs decide.
	if [ $(expr $BOOT_BLOCKS / 1024) -gt 512 ]; then
		FATSIZE="-F 32"
	fi

	rm -f ${WORKDIR}/boot.img
	mkfs.vfat -n "${BOOTDD_VOLUME_ID}" -S 512 ${FATSIZE} -C ${WORKDIR}/boot.img $BOOT_BLOCKS

	mcopy -i ${WORKDIR}/boot.img -s ${FIRMWARE_DIR}/${KERNEL_IMAGETYPE} ::/${KERNEL_IMAGETYPE}
	mcopy -i ${WORKDIR}/boot.img -s ${FIRMWARE_DIR}/${FW_SYSTEM} ::/${FW_SYSTEM}
	# Copy boot scripts
	for item in ${BOOT_SCRIPTS}; do
		src=`echo $item | awk -F':' '{ print $1 }'`
		dst=`echo $item | awk -F':' '{ print $2 }'`

		mcopy -i ${WORKDIR}/boot.img -s ${FIRMWARE_DIR}/$src ::/$dst
	done

	# Copy device tree file
	if test -n "${KERNEL_DEVICETREE}"; then
		for DTS_FILE in ${KERNEL_DEVICETREE}; do
			if [ -e "${FIRMWARE_DIR}/${DTS_FILE}" ]; then
				mcopy -i ${WORKDIR}/boot.img -s ${FIRMWARE_DIR}/${DTS_FILE} ::/${DTS_FILE}
			else
				echo "${DTS_FILE} does not exist."
			fi
		done
	fi

	# Copy target programming files to 'mfg-tools' directory
	if test -n "${UPDATE_DIR}"; then
		mcopy -i ${WORKDIR}/boot.img -s ${UPDATE_DIR} ::/mfg-images
	fi

}

#
# Create an image that can by written onto a SD card using dd for use
# with i.MX SoC family
#
# External variables needed:
#   ${SDCARD_ROOTFS}    - the rootfs image to incorporate
#   ${IMAGE_BOOTLOADER} - bootloader to use {u-boot, barebox}
#
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
generate_imx_sdcard () {
	# Create partition table
	parted -s ${SDCARD} mklabel msdos
	parted -s ${SDCARD} unit KiB mkpart primary fat32 ${IMAGE_ROOTFS_ALIGNMENT} $(expr ${IMAGE_ROOTFS_ALIGNMENT} \+ ${BOOT_SPACE_ALIGNED})
	#parted -s ${SDCARD} unit KiB mkpart primary $(expr  ${IMAGE_ROOTFS_ALIGNMENT} \+ ${BOOT_SPACE_ALIGNED}) $(expr ${IMAGE_ROOTFS_ALIGNMENT} \+ ${BOOT_SPACE_ALIGNED} \+ $ROOTFS_SIZE)
	parted ${SDCARD} print

	dd if=${FIRMWARE_DIR}/u-boot-${MACHINE}-${FLASH_TYPE}-ddr${DDR_SIZE}.${UBOOT_SUFFIX_SDCARD} of=${SDCARD} conv=notrunc seek=2 bs=512

	_generate_boot_image 1

	# Burn Partition
	dd if=${WORKDIR}/boot.img of=${SDCARD} conv=notrunc,fsync seek=1 bs=$(expr ${IMAGE_ROOTFS_ALIGNMENT} \* 1024)
	#dd if=${FIRMWARE_DIR}/${SDCARD_ROOTFS} of=${SDCARD} conv=notrunc,fsync seek=1 bs=$(expr ${BOOT_SPACE_ALIGNED} \* 1024 + ${IMAGE_ROOTFS_ALIGNMENT} \* 1024)
}

IMAGE_CMD_sdcard () {

	# Align boot partition and calculate total SD card image size
	BOOT_SPACE_ALIGNED=$(expr ${BOOT_SPACE} + ${IMAGE_ROOTFS_ALIGNMENT} - 1)
	BOOT_SPACE_ALIGNED=$(expr ${BOOT_SPACE_ALIGNED} - ${BOOT_SPACE_ALIGNED} % ${IMAGE_ROOTFS_ALIGNMENT})
	SDCARD_SIZE=$(expr ${IMAGE_ROOTFS_ALIGNMENT} + ${BOOT_SPACE_ALIGNED} + $ROOTFS_SIZE + ${IMAGE_ROOTFS_ALIGNMENT})

	# Initialize a sparse file
	dd if=/dev/zero of=${SDCARD} bs=1 count=0 seek=$(expr 1024 \* ${SDCARD_SIZE})

	${SDCARD_GENERATION_COMMAND}
	gzip ${SDCARD}
}

IMAGE_CMD_sdcard
