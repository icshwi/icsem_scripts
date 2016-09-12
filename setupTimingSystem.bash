#!/bin/bash
#
#  Copyright (c) 2016 Jeong Han Lee
#  Copyright (c) 2016 European Spallation Source ERIC
#
#  The setTimingSystem.bash is free software: you can redistribute
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
# Shell  : setTimingSystem.bash
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


function ini_func() { printf "\n>>>> You are entering in : %s\n" "${1}"; }
function end_func() { printf "<<<< You are leaving from %s\n" "${1}"; }

function checkstr() {
    if [ -z "$1" ]; then
	printf "%s : input variable is not defined \n" "${FUNCNAME[*]}"
	exit 1;
    fi
}


declare -gr SUDO_CMD="sudo"


function yum_mrf(){
    
    local func_name=${FUNCNAME[*]}
    local mrfioc2_kernel_module_name="mrf"
    local mrfioc2_kernel_module="kmod-mrfioc2"

    ini_func ${func_name}
	
    checkstr ${SUDO_CMD}
    #    declare extra_package_list="emacs tree screen lightdm"

    ${SUDO_CMD} yum -y install ${mrfioc2_kernel_module}
    ${SUDO_CMD} modprobe ${mrfioc2_kernel_module_name}
    INFO_list+=("$(modinfo ${mrfioc2_kernel_module_name})")
    end_func ${func_name}
}

function print_st() {

    local func_name=${FUNCNAME[*]}
    ini_func ${func_name}
    
    local bus=${1}
    local device=${2}
    local fucntion=${3}
    declare system="testcPCI-EVG-230"

    printf "\n\n%s\n\n" "------------ snip snip ------------";

    printf "epicsEnvSet("\"SYS\""             "\"%s\"")\n"   "$system";  
    printf "epicsEnvSet("\"EVG_PCIBUS\""      "\"0x%s\"")\n" "$bus";
    printf "epicsEnvSet("\"EVG_PCIDEVICES\""  "\"0x%s\"")\n" "$device";
    printf "epicsEnvSet("\"EVG_PCIFUNCTION\"" "\"0x%s\"")\n" "$function";
    printf "\nrequire mrfioc2,2.1.0\n\n"
    printf "%s\n" "mrmEvgSetupPCI("$\(EVG\)", "$\(EVG_PCIBUS\)", "$\(EVG_PCIDEVICE\)", "$\(EVG_PCIFUNCTION\)")"

    printf "\n\n%s\n\n" "------------ snip snip ------------";
    
    end_func ${func_name}
}


declare -g INFO_kernel
declare -g INFO_system_release
declare -g INFO_eee_compiled
declare -g INFO_eee_iocsh
declare -g INFO_epics_base
declare -ag INFO_list
declare -i index=0

INFO_kernel="$(uname -r)"
INFO_system_release="$(cat /etc/system-release)"
INFO_eee_compiled="$(echo $EPICS_ENV_PATH)"
INFO_eee_iocsh="$(which iocsh)"
INFO_epics_base="$(echo $EPICS_BASE)"

#
# "${EXAMPLE}", so "---" are necessary to assign "space-have" string in a item in the array
#
INFO_list=("${INFO_kernel}" "${INFO_system_release}" "${INFO_eee_compiled}" "${INFO_eee_iocsh}" "${INFO_epics_base}")



${SUDO_CMD} -v

while [ true ];
do
    ${SUDO_CMD} -n /bin/true;
    sleep 60;
    kill -0 "$$" || exit;
done 2>/dev/null &


yum_mrf




for info in "${INFO_list[@]}"
do
    printf "%2s: %s\n" "$index" "$info"
    let "index = $index + 1"
done

var=$(lspci |grep 'Signal processing controller' | awk '{ print $1 }')

bus=$(echo $var | cut -d: -f1)
device=$(echo $var | cut -d: -f2 | cut -d. -f1)
function=$(echo $var | cut -d. -f2)
echo $var
echo "bus      " $bus
echo "device   " $device
echo "function " $function

print_st "${bus}" "${device}" "${function}"

exit
