#!/bin/bash
ROOT_PATH=`pwd`
THREAD=`cat /proc/cpuinfo |grep "processor"|wc -l`  

UBOOT_CONFIG=mys_imx6ull_14x14_nand_defconfig
KERNEL_CONFIG=mys_imx6_defconfig

ECHO_VAR(){
	echo   Project root directory: $ROOT_PATH
	echo   uboot defconfig: $UBOOT_CONFIG 
	echo   kernel defconfig :$KERNEL_CONFIG 
	echo   make thread : $THREAD 
}


ECHO_VAR
