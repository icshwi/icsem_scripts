#!/bin/bash
#
#  Copyright (c) 2016 Jeong Han Lee
#  Copyright (c) 2016 European Spallation Source ERIC
#
#  The program is free software: you can redistribute
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
# version : 0.2.1
#
# Generic : Global vaiables - readonly
#
declare -gr SC_SCRIPT="$(realpath "$0")"
declare -gr SC_SCRIPTNAME="$(basename "$SC_SCRIPT")"
declare -gr SC_TOP="$(dirname "$SC_SCRIPT")"
declare -gr SC_LOGDATE="$(date +%Y%b%d-%H%M-%S%Z)"

declare -ag INFO_list=()
declare -i  index=0

set -a
. ${SC_TOP}/mrf_env.conf
set +a

. ${SC_TOP}/bash_functions


function show_mrf_boards() {
    printf "\nWe've found the MRF boards as follows:";
    printf "\n--------------------------------------\n";
    lspci -nmmn | grep -E "\<(${PCI_VENDOR_ID_MRF})";
    printf "\n";
}


function git_cross_compile_mrf() {

    local func_name=${FUNCNAME[*]}; ini_func ${func_name};
    #
    #
    #    https://github.com/jeonghanlee/mrfioc2
    # This is the tentative repository, which I hacked based on
    # m-epics-mrfioc2

    local git_src_dir=${SC_TOP}/${GIT_SRC_NAME};
    local mrf_kersrc_dir=${git_src_dir}/mrmShared/linux;

    git_clone "${git_src_dir}" "${GIT_SRC_URL}" "${GIT_SRC_NAME}" "${GIT_TAG_NAME}";


    # We need the specified GIT HASH, because currently we have the mixed PCIE-EVR300DC
    # Device IDs (132c and 172c). Technically 132c is belong to MTCA EVR300.
    # In addtion, PCIE-EVR-300 also has 172C.
    #
    # https://bitbucket.org/europeanspallationsource/m-epics-mrfioc2/commits/65b4e79a2c8384ef3446c7337fd3d3f06574feb2
    #
    # Niklas Claesson  committed 65b4e79 Merge
    # 2017-01-27
    # Merged in han (pull request #2)

    pushd ${git_src_dir}
    git checkout "${GIT_HASH}"
    popd

    local arch=${ARCH}
    local cc=${CROSS_COMPILE}	
    local kerneldir=${KERNELDIR}
    local install_mod_path=${TARGET_ROOTFS}

    pushd ${mrf_kersrc_dir}
    ${SUDO_CMD} make ARCH=${arch} CROSS_COMPILE=${cc} KERNELDIR=${kerneldir} INSTALL_MOD_PATH=${install_mod_path} modules modules_install clean
    popd
    #
    end_func ${func_name};

}


function git_compile_mrf(){

    local func_name=${FUNCNAME[*]}; ini_func ${func_name};
    #
    #
    #    https://github.com/jeonghanlee/mrfioc2
    # This is the tentative repository, which I hacked based on
    # m-epics-mrfioc2

    local git_src_dir=${SC_TOP}/${GIT_SRC_NAME};
    local mrf_kersrc_dir=${git_src_dir}/mrmShared/linux;

    git_clone "${git_src_dir}" "${GIT_SRC_URL}" "${GIT_SRC_NAME}" "${GIT_TAG_NAME}";
 
    
    # We need the specified GIT HASH, because currently we have the mixed PCIE-EVR300DC
    # Device IDs (132c and 172c). Technically 132c is belong to MTCA EVR300.
    # In addtion, PCIE-EVR-300 also has 172C.
    # 
    # https://bitbucket.org/europeanspallationsource/m-epics-mrfioc2/commits/65b4e79a2c8384ef3446c7337fd3d3f06574feb2
    # 
    # Niklas Claesson  committed 65b4e79 Merge
    # 2017-01-27
    # Merged in han (pull request #2)

    pushd ${git_src_dir}
    git checkout "${GIT_HASH}"
    popd


    pushd ${mrf_kersrc_dir}
    ${SUDO_CMD} make modules modules_install clean
    popd
    #
    end_func ${func_name};
}

function yum_install_mrf(){

    local func_name=${FUNCNAME[*]}; ini_func ${func_name};
    local mrfioc2_kernel_module="kmod-mrfioc2";
    
    ${SUDO_CMD} yum -y install ${mrfioc2_kernel_module};

    end_func ${func_name};
}

function modprobe_mrf(){
    
    local func_name=${FUNCNAME[*]}; ini_func ${func_name};

    
    ${SUDO_CMD} modprobe -r ${MRF_KMOD_NAME};
    ${SUDO_CMD} modprobe ${MRF_KMOD_NAME};

    INFO_list+=("$(modinfo ${MRF_KMOD_NAME})");
    INFO_list+=("$(lsmod |grep ${MRF_KMOD_NAME})");

    end_func ${func_name};
}


function put_mrf_rule(){

    local func_name=${FUNCNAME[*]};  ini_func ${func_name};
    local target_rootfs=$1

    local module_load_dir="${target_rootfs}/etc/modules-load.d";

    local isDir=$(checkIfDir ${module_load_dir})
    if [[ $isDir -eq "$NON_EXIST" ]]; then
	mkdir -p ${module_load_dir};
    fi
    local rule=${MRF_KMOD_NAME};
    local target="${module_load_dir}/${MRF_KMOD_NAME}.conf";

    printf "Put the rule : %s in %s to load the mrf module at boot time.\n" "$rule" "$target";
    printf_tee "$rule" "$target";

    cat_file ${target};
	
    end_func ${func_name};
}


function put_udev_rule(){

    local func_name=${FUNCNAME[*]};  ini_func ${func_name};
    local target_rootfs=$1
    local udev_rules_dir="${target_rootfs}/etc/udev/rules.d"
    local rule="KERNEL==\"uio*\", ATTR{name}==\"mrf-pci\", MODE=\"0666\"";
    local target="${udev_rules_dir}/99-${MRF_KMOD_NAME}ioc2.rules";
 
    # If ${MRF_KMOD_NAME}.rules exists, it will be overwritten.
    # can access the udev rules via udevadm info --query=all /dev/uio* --attribute-walk
    # 
    #   printf "Put mrf UDEV rule In ${UDEV_RULES_DIR} to be accessible via an user.\n"; 
    
    # It is not good to allow any user to access mrf timing hardware, 
    # but ICS don't have any group in an user who can access the HW
    # now 2016-Sep-13. It may be changed according to the future proper
    # group permission. 
    # 
    printf "Put the rule : %s in %s to be accessible via an user.\n" "$rule" "$target";
    printf_tee "$rule" "$target";

    cat_file ${target}
    end_func ${func_name};
}


function put_rules() {
    local target_rootfs=$1
    put_mrf_rule ${target_rootfs} ;
    put_udev_rule ${target_rootfs} ;
}

function print_info() {
    
    for info in "${INFO_list[@]}"
    do
	printf "%2s: %s\n" "$index" "$info";
	let "index = $index + 1";
    done
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
	modprobe_mrf;
	put_rules;
	print_info;
	;;
    src)
	${SUDO_CMD} -v;
	git_compile_mrf;
	modprobe_mrf;
	put_rules;
	print_info;
	;;
    rule)
	${SUDO_CMD} -v;
	put_rules;
	print_info;
	;;
    show)
	show_mrf_boards;
	;;
    cc_src)
        ${SUDO_CMD} -v;
        git_cross_compile_mrf;
        put_rules ${TARGET_ROOTFS};
	;;
    *) 	
	echo "">&2         
	echo "usage: $0 <arg>">&2 
	echo ""
        echo "          <arg> : info">&2 
	echo ""
	echo "          show  : show the found mrf boards information ">&2
	echo ""
	echo "          pac   : mrf package from ESS (do not use now) ">&2
	echo "                  We are working on this.... ">&2
        echo "" 
	echo "          src   : compile kernel module from git repository ">&2
	echo "                  ${GIT_SRC_URL}/${GIT_SRC_NAME}">&2
	echo "                  tag name : ${GIT_TAG_NAME}">&2
	echo "" 
	echo "          rule : put only the mrf kernel and udev rules ">&2
    	echo "">&2 	
	exit 0         
	;; 
esac


exit
