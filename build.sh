#!/bin/bash

# Import from paranoid
# Edit By Xilence2210

# get current path
reldir=`dirname $0`
cd $reldir
DIR=`pwd`

# Colorize and add text parameters
red=$(tput setaf 1)             #  red
grn=$(tput setaf 2)             #  green
cya=$(tput setaf 6)             #  cyan
txtbld=$(tput bold)             # Bold
bldred=${txtbld}$(tput setaf 1) #  red
bldgrn=${txtbld}$(tput setaf 2) #  green
bldblu=${txtbld}$(tput setaf 4) #  blue
bldcya=${txtbld}$(tput setaf 6) #  cyan
txtrst=$(tput sgr0)             # Reset

THREADS="16"
DEVICE="$1"
SYNC="$2"
EXTRAS="$3"

VLINE=67

if [ "mokee$DEVICE" == "mokee" ]
then
   clear
   echo " "
   echo "==================================================="
   echo " "
   echo " Mokee Build Script"
   echo " -------------------"
   echo " "
   echo " 请在使用前设置输出路径"
   echo " 使用'gedit mk'或者'vim mk'编辑脚本的"
   echo " 第 $VLINE 行，去掉#号并设置路径即可！"
   echo " "
   echo " 用法: './mk [Device] {Variable}'"
   echo "   Device - 设备名"
   echo "   Variable - 参数"
   echo "   参数如下："
   echo "      fix   :如果上次编译遇到错误，则使用此参数快速编译"
   echo "      clean :在开始编译前执行命令 'make installclean' "
   echo "      sync  :在开始编译前执行同步命令 'repo sync' "
   echo " "
   echo " 例如 './mk maguro sync clean'"
   echo " 则表示 '编译maguro，在开始前同步并清理'"
   echo " "
   echo " Usage: './mk [Device] {Variable}'"
   echo "   Device - your device name"
   echo "   Variable - functions"
   echo "      fix   :start build without any cleanning for fix build"
   echo "      clean :run 'make installclean' before build"
   echo "      sync  :run 'repo sync' before build"
   echo " "
   echo " e.g './mk maguro sync clean'"
   echo " "
   exit 0
fi

# if you set another OUT_DIR,set this before use.

OUT_DIR=~/MOKEE_KK/out/target/product/$DEVICE
if [ "mk$OUT_DIR" == "mk" ]
then
   echo -e "请设置编译输出路径在该脚本的$VLINE行！"
   echo -e "please specify correct OUT_DIR in THIS SCRIPT at line $VLINE !"
   exit 0
elif [ ! -d "$OUT_DIR" ]
then
   mkdir -p $OUT_DIR
fi 

# we don't allow scrollback buffer
echo -e '\0033\0143'
clear

echo -e "${cya}Building ${bldcya}Mokee Open Source Project ${txtrst}";

# setup environment
echo -e "${bldblu}Setting up environment ${txtrst}"
export MK_BUILD_PATH=~/Rom/FULL
# export MK_OTA_INPUT=~/Desktop/Out/FULL
. build/envsetup.sh

# lunch device
echo -e ""
echo -e "${bldblu}Lunching device ${txtrst}"
lunch mk_$DEVICE-userdebug

fix_count=0
# excute with vars
echo -e ""
for var in $* ; do
if [ "$var" == "sync" ]
then
   echo -e "${bldblu}Fetching latest sources ${txtrst}"
   if [ -d "$ADDON" ]
   then
      echo -e "fetching add-on repo"
      echo -e "change this at script line 28"
      cd $ADDON
      git pull
      cd $DIR
      echo -e "=============================================="
   fi
   repo sync
   echo -e ""
elif [ "$var" == "clean" ]
then
   echo -e "${bldblu}Clearing previous build info ${txtrst}"
   mka installclean
elif [ "$var" == "fix" ]
then
   echo -e "skip for remove build.prop"
   fix_count=1
fi
done
if [ "$fix_count" == "0" ]
then
   echo -e "removing build.prop"
   rm -f $OUT_DIR/system/build.prop
fi

echo -e ""
echo -e "${bldblu}Starting compilation ${txtrst}"

# get time of startup
res1=$(date +%s.%N)

# start compilation
mka bacon
echo -e ""

# finished? get elapsed time
res2=$(date +%s.%N)
echo "${bldgrn}Total time elapsed: ${txtrst}${grn}$(echo "($res2 - $res1) / 60"|bc ) minutes ($(echo "$res2 - $res1"|bc ) seconds) ${txtrst}"

# make a alarm
echo $'\a'
