#!/bin/bash
#
#  Copyright (c) 2016 Jeong Han Lee
#  Copyright (c) 2016 European Spallation Source ERIC
#
#  The mrf_setup.bash is free software: you can redistribute
#  it and/or modify it under the terms of the GNU General Public License
#  as published by the Free Software Foundation, either version 2 of the
#  License, or any newer version.
#
#  This program is distributed in the hope that it will be useful, but WITHOUT
#  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
#  FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
#  more details.
#
#  You should have received a copy of the GNU General Public License along with
#  this program. If not, see https://www.gnu.org/licenses/gpl-2.0.txt
#
# Shell  : mrf_setup.bash
# Author : Jeong Han Lee
# email  : han.lee@esss.se
# Date   : 
# version : 0.1.2
#
# http://www.gnu.org/software/bash/manual/bashref.html#Bash-Builtins

# 
# PREFIX : SC_, so declare -p can show them in a place
# 
# Generic : Global vaiables - readonly
#
declare -gr SC_SCRIPT="$(realpath "$0")"
declare -gr SC_SCRIPTNAME="$(basename "$SC_SCRIPT")"
declare -gr SC_TOP="$(dirname "$SC_SCRIPT")"
declare -gr SC_LOGDATE="$(date +%Y%b%d-%H%M-%S%Z)"


# Generic : Redefine pushd and popd to reduce their output messages
# 
function pushd() { builtin pushd "$@" > /dev/null; }
function popd()  { builtin popd  "$@" > /dev/null; }


function ini_func() { printf "\n\n>>>> You are entering in the function %s\n" "${1}"; }
function end_func() { printf "<<<< You are leaving from the function %s\n\n" "${1}"; }

function checkstr() {
    if [ -z "$1" ]; then
	printf "%s : input variable is not defined \n" "${FUNCNAME[*]}"
	exit 1;
    fi
}


# Generic : Global variables for git_clone, git_selection, and others
# 
declare -g SC_SELECTED_GIT_SRC=""
declare -g SC_GIT_SRC_DIR=""
declare -g SC_GIT_SRC_NAME=""
declare -g SC_GIT_SRC_URL=""


declare -gr SUDO_CMD="sudo"
declare -ag INFO_list=()
declare -i index=0
declare -gr MODULES_LOAD_DIR="/etc/modules-load.d"
declare -gr UDEV_RULES_DIR="/etc/udev/rules.d"
declare -gr MRF_KMOD_NAME="mrf"

function printf_tee() {

    local input=${1};
    local target=${2};
    local command="";
    # If target exists, it will be overwritten.
    ${SUDO_CMD} printf "%s" "${input}" | ${SUDO_CMD} tee "${target}";
};

# Generic : git_clone
#
# Required Global Variable
# - SC_GIT_SRC_DIR  : Input
# - SC_LOGDATE      : Input
# - SC_GIT_SRC_URL  : Input
# - SC_GIT_SRC_NAME : Input
# 
function git_clone() {

    local func_name=${FUNCNAME[*]}
    ini_func ${func_name}

    checkstr ${SC_LOGDATE}
    checkstr ${SC_GIT_SRC_URL}
    checkstr ${SC_GIT_SRC_NAME}
    
    if [[ ! -d ${SC_GIT_SRC_DIR} ]]; then
	echo "No git source repository in the expected location ${SC_GIT_SRC_DIR}"
    else
	echo "Old git source repository in the expected location ${SC_GIT_SRC_DIR}"
	echo "The old one is renamed to ${SC_GIT_SRC_DIR}_${SC_LOGDATE}"
	mv  ${SC_GIT_SRC_DIR} ${SC_GIT_SRC_DIR}_${SC_LOGDATE}
    fi
    
    # Alwasy fresh cloning ..... in order to workaround any local 
    # modification in the repository, which was cloned before. 
    #
    git clone ${SC_GIT_SRC_URL}/${SC_GIT_SRC_NAME}

    end_func ${func_name}
}

# Generic : git_selection
#
# 1.0.3 : Thursday, October  6 15:34:12 CEST 2016
#
# Require Global vairable
# - SC_SELECTED_GIT_SRC  : Output
#
function git_selection() {

    local func_name=${FUNCNAME[*]}; ini_func ${func_name}

    local git_ckoutcmd=""
    local checked_git_src=""

    
    declare -i index=0
    declare -i master_index=0
    declare -i list_size=0
    declare -i selected_one=0
    declare -a git_src_list=()

    
    local n_tags=${1};

    # no set n_tags, set default 10
    
    if [[ ${n_tags} -eq 0 ]]; then
	n_tags=10;
    fi

    git_src_list+=("master")

    # git_tags=$(git describe --tags `git rev-list --tags --max-count=${n_tags}`);
    # git_exitstatus=$?
    # if [ $git_exitstatus = 0 ]; then
    # 	#
    # 	# (${}) and ($(command))  are important to separate output as an indiviaul arrar
    # 	#
    # 	git_src_list+=(${git_tags});
    # else
    # 	# In case, No tags can describe, use git tag instead of git describe
    # 	#
    # 	# fatal: No tags can describe '7fce903a82d47dec92012664648cacebdacd88e1'.
    # 	# Try --always, or create some tags.
    # doesn't work for CentOS7
    #    git_src_list+=($(git tag -l --sort=-refname  | head -n${n_tags}))
    # fi

    git_src_list+=($(git tag -l | sort -r | head -n${n_tags}))
    
    for tag in "${git_src_list[@]}"
    do
	printf "%2s: git src %34s\n" "$index" "$tag"
	let "index = $index + 1"
    done
    
    echo -n "Select master or one of tags which can be built, followed by [ENTER]:"

    # don't wait for 3 characters 
    # read -e -n 2 line
    read -e line
   
    # convert a string to an integer?
    # do I need this? 
    # selected_one=${line/.*}

    # Without selection number, type [ENTER], 0 is selected as default.
    #
    selected_one=${line}
    
    let "list_size = ${#git_src_list[@]} - 1"
    
    if [[ "$selected_one" -gt "$list_size" ]]; then
	printf "\n>>> Please select one number smaller than %s\n" "${list_size}"
	exit 1;
    fi
    if [[ "$selected_one" -lt 0 ]]; then
	printf "\n>>> Please select one number larger than 0\n" 
	exit 1;
    fi

    SC_SELECTED_GIT_SRC="$(tr -d ' ' <<< ${git_src_list[line]})"
    
    printf "\n>>> Selected %34s --- \n" "${SC_SELECTED_GIT_SRC}"
 
    echo ""
    if [ "$selected_one" -ne "$master_index" ]; then
	git_ckoutcmd="git checkout tags/${SC_SELECTED_GIT_SRC}"
	$git_ckoutcmd
	checked_git_src="$(git describe --exact-match --tags)"
	checked_git_src="$(tr -d ' ' <<< ${checked_git_src})"
	
	printf "\n>>> Selected : %s --- \n>>> Checkout : %s --- \n" "${SC_SELECTED_GIT_SRC}" "${checked_git_src}"
	
	if [ "${SC_SELECTED_GIT_SRC}" != "${checked_git_src}" ]; then
	    echo "Something is not right, please check your git reposiotry"
	    exit 1
	fi
    else
	git_ckoutcmd="git checkout ${SC_SELECTED_GIT_SRC}"
	$git_ckoutcmd
    fi
    end_func ${func_name}
 
}



function git_compile_mrf(){
    local func_name=${FUNCNAME[*]};
    ini_func ${func_name};
    checkstr ${SUDO_CMD};
    #
    #
    #    https://github.com/jeonghanlee/mrfioc2
    # This is the tentative repository, which I hacked based on
    # m-epics-mrfioc2

    SC_GIT_SRC_NAME="m-epics-mrfioc2"
    SC_GIT_SRC_URL="https://bitbucket.org/europeanspallationsource"
#mnt mrf_irqcontrol(struct uio_info *info, s32 onoff)
#     ^
#cc1: some warnings being treated as errors
#make[2]: *** [/home/iocuser/gitsrc/icsem_scripts/m-epics-mrfioc2-ess/mrmShared/linux/uio_mrf.o] Error 1
#make[1]: *** [_module_/home/iocuser/gitsrc/icsem_scripts/m-epics-mrfioc2-ess/mrmShared/linux] Error 2
#make[1]: Leaving directory `/usr/src/kernels/3.10.0-229.7.2.el7.x86_64'
#make: *** [modules] Error 2

    SC_GIT_SRC_NAME="m-epics-mrfioc2"
    SC_GIT_SRC_URL="https://bitbucket.org/jeonghanlee"


#    SC_GIT_SRC_NAME="mrfioc2"
#    SC_GIT_SRC_URL="https://github.com//jeonghanlee"


    SC_GIT_SRC_DIR=${SC_TOP}/${SC_GIT_SRC_NAME}
    MRF_KERSRC_DIR="mrmShared/linux"
    #
    #
    git_clone
    #
    #
    pushd ${SC_GIT_SRC_DIR}/${MRF_KERSRC_DIR}
    ${SUDO_CMD} make modules modules_install clean
    
    popd
    #
    end_func ${func_name};
}

function yum_install_mrf(){
    local func_name=${FUNCNAME[*]};
    local mrfioc2_kernel_module="kmod-mrfioc2";
    ini_func ${func_name};
    checkstr ${SUDO_CMD};
    
    ${SUDO_CMD} yum -y install ${mrfioc2_kernel_module};

    end_func ${func_name};
}

function modprobe_mrf(){
    
    local func_name=${FUNCNAME[*]};
    ini_func ${func_name};
    checkstr ${SUDO_CMD};

    ${SUDO_CMD} modprobe -r ${MRF_KMOD_NAME};
    ${SUDO_CMD} modprobe ${MRF_KMOD_NAME};

    INFO_list+=("$(modinfo ${MRF_KMOD_NAME})");
    INFO_list+=("$(lsmod |grep ${MRF_KMOD_NAME})");

    end_func ${func_name};
}

# put_mrf_rule and put_udev_rule have the same function except
# thier rule and target, so I may combine them together. But
# now it is better to be seperated functions.



function put_mrf_rule(){

    local func_name=${FUNCNAME[*]};
    local rule="";
    local target="";
    ini_func ${func_name};
    rule=${MRF_KMOD_NAME};
    target=${MODULES_LOAD_DIR}/${MRF_KMOD_NAME}.conf;
    printf "Put the rule : %s in %s to load the mrf module at boot time.\n" "$rule" "$target";
    printf_tee "$rule" "$target";

    end_func ${func_name}
}

function put_udev_rule(){

   local func_name=${FUNCNAME[*]};
   local rule="";
   local target="";
   ini_func ${func_name};

   # If ${MRF_KMOD_NAME}.rules exists, it will be overwritten.
   # can access the udev rules via udevadm info --query=all /dev/uio* --attribute-walk
   # 
   #   printf "Put mrf UDEV rule In ${UDEV_RULES_DIR} to be accessible via an user.\n"; 

   # It is not good to allow any user to access mrf timing hardware, 
   # but ICS don't have any group in an user who can access the HW
   # now 2016-Sep-13. It may be changed according to the future proper
   # group permission. 
   # 
   rule="SUBSYSTEM==\"uio\", ATTR{name}==\"mrf-pci\", MODE=\"0666\"";
   target="${UDEV_RULES_DIR}/${MRF_KMOD_NAME}.rules";
   printf "Put the rule : %s in %s to be accessible via an user.\n" "$rule" "$target";

   printf_tee "$rule" "$target";

   end_func ${func_name};
}


INFO_list+=("SCRPIT      : ${SC_SCRIPT}");
INFO_list+=("SCRIPT NAME : ${SC_SCRIPTNAME}");
INFO_list+=("SCRIPT TOP  : ${SC_TOP}");
INFO_list+=("LOGDATE     : ${SC_LOGDATE}");


DO="$1"

case "$DO" in     
    pac) 

	${SUDO_CMD} -v;
	yum_install_mrf;
	;;
    src)
	${SUDO_CMD} -v;
	git_compile_mrf;
	;;
    *) 	
	echo "">&2         
	echo "usage: $0 <arg>" >&2 
	echo ""
        echo "          arg     : explaination" >&2 
	echo ""        
	echo "          pac : mrf package from ESS (for cPCI 230, not 220) ">&2
        echo "" 
	echo "          src : compile kernel module from git repository (for PCIe) ">&2
    	echo >&2 	
	exit 0         
	;; 
esac


modprobe_mrf;

put_mrf_rule;

put_udev_rule;

for info in "${INFO_list[@]}"
do
    printf "%2s: %s\n" "$index" "$info";
    let "index = $index + 1";
done


exit
