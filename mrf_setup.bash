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
# version : 0.1.0 
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


declare -gr SUDO_CMD="sudo"
declare -ag INFO_list=()
declare -i index=0
declare -gr MODULES_LOAD_DIR="/etc/modules-load.d"
declare -gr UDEV_RULES_DIR="/etc/udev/rules.d"
declare -gr MRF_KMOD_NAME="mrf"


function echo_tee() {

    local input=${1};
    local target=${2};
    local command="";
    # If target exists, it will be overwritten.
    ${SUDO_CMD} echo $input | ${SUDO_CMD} tee ${target}
};

function yum_install_mrf(){
    
    local func_name=${FUNCNAME[*]};
    local mrfioc2_kernel_module="kmod-mrfioc2";
    ini_func ${func_name};
    checkstr ${SUDO_CMD};

    ${SUDO_CMD} yum -y install ${mrfioc2_kernel_module};
    ${SUDO_CMD} modprobe ${MRF_KMOD_NAME};
    INFO_list+=("$(modinfo ${MRF_KMOD_NAME})");

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
    echo_tee "$rule" "$target";

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

   echo_tee "$rule" "$target";

   end_func ${func_name};
}

INFO_list+=("SCRPIT      : ${SC_SCRIPT}");
INFO_list+=("SCRIPT NAME : ${SC_SCRIPTNAME}");
INFO_list+=("SCRIPT TOP  : ${SC_TOP}");
INFO_list+=("LOGDATE     : ${SC_LOGDATE}");
${SUDO_CMD} -v;

yum_install_mrf;

put_mrf_rule;

put_udev_rule;

for info in "${INFO_list[@]}"
do
    printf "%2s: %s\n" "$index" "$info";
    let "index = $index + 1";
done


exit
