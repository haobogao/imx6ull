#!/bin/bash
ROOT = 


THREAD=16
UBOOT_CONFIG = "mys_imx6ull_14x14_nand_defconfig"
KERNEL_CONFIG ="make mys_imx6_defconfig"




#	UBOOT BUILD START!
#
make distclean
make $(UBOOT_CONFIG)
make -j$(THREAD)
if [ ! -d "../out" ]; then
  mkdir ../out
fi
if [ ! -f ./uboot.imx ]; then 
	echo "uboot make faild!"
fi

cp ./uboot.imx 





