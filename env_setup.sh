#!/bin/bash

# Colorize and add text parameters
export red=$(tput setaf 1)             #  red
export grn=$(tput setaf 2)             #  green
export blu=$(tput setaf 4)             #  blue
export cya=$(tput setaf 6)             #  cyan
export txtbld=$(tput bold)             #  Bold
export bldred=${txtbld}$(tput setaf 1) #  red
export bldgrn=${txtbld}$(tput setaf 2) #  green
export bldblu=${txtbld}$(tput setaf 4) #  blue
export bldcya=${txtbld}$(tput setaf 6) #  cyan
export txtrst=$(tput sgr0)             #  Reset

echo "${bldcya}***** Clean up Environment before compile *****${txtrst}";

# Make clean source
read -t 5 -p "Make clean source, 5sec timeout (y/n)?";
if [ "$REPLY" == "y" ]; then
make clean;
make distclean;
make mrproper;
fi;

# clean ccache
read -t 5 -p "Clean ccache, 5sec timeout (y/n)?";
if [ "$REPLY" == "y" ]; then
ccache -c;
fi;

TARGET=$1
if [ "$TARGET" != "" ]; then
        echo "Starting your build for $TARGET"
else
        echo ""
        echo "You need to define your device target!"
        echo "example: build_kernel.sh N920C"
        echo "example: build_kernel.sh N920CD"
        echo "example: build_kernel.sh N920I"
        echo "example: build_kernel.sh N920P"
        echo "example: build_kernel.sh N920R4"
        echo "example: build_kernel.sh N920S"
        echo "example: build_kernel.sh N9200"
        echo "example: build_kernel.sh N9208_SEA"
        echo "example: build_kernel.sh N9208_TW"
        echo "example: build_kernel.sh N920T"
        exit 1
fi

# location
	export KERNELDIR=`readlink -f .`;

# check if ccache installed, if not install
if [ ! -e /usr/bin/ccache ]; then
	echo "You must install 'ccache' to continue.";
	sudo apt-get install ccache
fi

# check if xmllint installed, if not install
if [ ! -e /usr/bin/xmllint ]; then
	echo "You must install 'xmllint' to continue.";
	sudo apt-get install libxml2-utils
fi

# kernel
export ARCH=arm64;
export SUB_ARCH=arm64;
if [ "$TARGET" = "N920C" ] ; then
export KERNEL_CONFIG="SkyHigh_defconfig";
fi;
if [ "$TARGET" = "N920CD" ] ; then
export KERNEL_CONFIG="SkyHigh_SM-N920CD_MEA_defconfig";
fi;

if [ "$TARGET" = "N920I" ] ; then
export KERNEL_CONFIG="SkyHigh_SM-N920I_defconfig";
fi;

if [ "$TARGET" = "N920P" ] ; then
export KERNEL_CONFIG="SkyHigh_SM-N920P_Sprint_defconfig";
fi;

if [ "$TARGET" = "N920R4" ] ; then
export KERNEL_CONFIG="SkyHigh_SM-N920R4_USC_defconfig";
fi;

if [ "$TARGET" = "N920S" ] ; then
export KERNEL_CONFIG="SkyHigh_SM-N920S_defconfig";
fi;

if [ "$TARGET" = "N9200" ] ; then
export KERNEL_CONFIG="SkyHigh_SM-N9200_HK_defconfig";
fi;

if [ "$TARGET" = "N9208_SEA" ] ; then
export KERNEL_CONFIG="SkyHigh_SM-N9208_SEA_defconfig";
fi;

if [ "$TARGET" = "N9208_TW" ] ; then
export KERNEL_CONFIG="SkyHigh_SM-N9208_TW_defconfig";
fi;

if [ "$TARGET" = "N920T" ] ; then
export KERNEL_CONFIG="SkyHigh_tmo_defconfig";
fi;

# build script
export USER=`whoami`;
export TMPFILE=`mktemp -t`;

# system compiler
export CROSS_COMPILE=/home/upintheair/aarch64-linux-android-4.9/bin/aarch64-linux-android-

# CPU Core
export NUMBEROFCPUS=`grep 'processor' /proc/cpuinfo | wc -l`;