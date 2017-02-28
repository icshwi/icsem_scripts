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
# Shell  : sis_setup.bash
# Author : Jeong Han Lee
# email  : han.lee@esss.se
# Date   : Tuesday, February 28 15:23:05 CET 2017 
# version : 0.0.1
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
. ${SC_TOP}/sis_env.conf
set +a

. ${SC_TOP}/bash_functions


function show_sis_boards() {
    printf "\nWe've found the SIS boards as follows:";
    printf "\n--------------------------------------\n";
    lspci -nmmn | grep -E "\<(${PCI_VENDOR_ID_SIS})";
    printf "\n";
}

function git_compile_sis(){

    local func_name=${FUNCNAME[*]}; ini_func ${func_name};

    local git_src_dir=${SC_TOP}/${GIT_SRC_NAME};
    local sis_kersrc_dir=${git_src_dir}/src/main/c/driver;

    git_clone "${git_src_dir}" "${GIT_SRC_URL}" "${GIT_SRC_NAME}" "${GIT_TAG_NAME}";
 
    # pushd ${git_src_dir}
    # git checkout "${GIT_HASH}"
    # popd


    pushd ${sis_kersrc_dir}
    ${SUDO_CMD} make modules modules_install clean
    popd
    #
    end_func ${func_name};
}

function modprobe_sis(){
    
    local func_name=${FUNCNAME[*]}; ini_func ${func_name};

    
    ${SUDO_CMD} modprobe -r ${SIS_KMOD_NAME};
    ${SUDO_CMD} modprobe ${SIS_KMOD_NAME};

    INFO_list+=("$(modinfo ${SIS_KMOD_NAME})");
    INFO_list+=("$(lsmod |grep ${SIS_KMOD_NAME})");

    end_func ${func_name};
}


function put_sis_rule(){

    local func_name=${FUNCNAME[*]};  ini_func ${func_name};
    local module_load_dir="/etc/modules-load.d";
    local rule=${SIS_KMOD_NAME};
    local target="${module_load_dir}/${SIS_KMOD_NAME}.conf";

    printf "Put the rule : %s in %s to load the sis module at boot time.\n" "$rule" "$target";
    printf_tee "$rule" "$target";

    end_func ${func_name};
}


function put_udev_rule(){

    local func_name=${FUNCNAME[*]};  ini_func ${func_name};
    local udev_rules_dir="/etc/udev/rules.d"
    local rule="KERNEL==\"sis8300-[0-9]*\", NAME=\"%k\", MODE=\"0666\"";
    local target="${udev_rules_dir}/99-${SIS_KMOD_NAME}.rules";
 
    printf "Put the rule : %s in %s to be accessible via an user.\n" "$rule" "$target";
    printf_tee "$rule" "$target";
    end_func ${func_name};
}


function put_rules() {
    put_sis_rule;
    put_udev_rule;
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

    # pac) 
    # 	${SUDO_CMD} -v;
    # 	yum_install_sis;
    # 	modprobe_sis;
    # 	put_rules;
    # 	print_info;
    # 	;;
    src)
	${SUDO_CMD} -v;
	git_compile_sis;
	modprobe_sis;
	put_rules;
	print_info;
	;;
    rule)
	${SUDO_CMD} -v;
	put_rules;
	print_info;
	;;
    show)
	show_sis_boards;
	;;
    *) 	
	echo "">&2         
	echo "usage: $0 <arg>">&2 
	echo ""
        echo "          <arg> : info">&2 
	echo ""
	echo "          show  : show the found sis boards information ">&2
	echo ""
	echo "          src   : compile kernel module from git repository ">&2
	echo "                  ${GIT_SRC_URL}/${GIT_SRC_NAME}">&2
	echo "                  tag name : ${GIT_TAG_NAME}">&2
	echo "" 
	echo "          rule : put only the sis kernel and udev rules ">&2
    	echo "">&2 	
	exit 0         
	;; 
esac


exit
