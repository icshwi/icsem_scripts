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
# Shell  : setpcieEvr300DC.bash
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


# maybe better to write files directly into a dictory.

function print_st() {

    local func_name=${FUNCNAME[*]}
    ini_func ${func_name}

    local domain=${1}
    local bus=${2}
    local device=${3}
    local fucntion=${4}

    declare system="ICS-PCIEEVR-300"

    declare epics_db="evr-pcie-300DC.db";
    declare mrf_device="EVR0";


    # # printf "\n\n%s\n\n" "------------ snip snip ------------";
    # # printf "%s\n" "# This file should be used with EPICS base 3.14.12.5 and mrfioc2 2.1.0";
    # # printf "%s\n" "# With current EEE 1.8.2, the proper command is ";
    # # printf "%s\n" "# $ iocsh -3.14.12.5 cpci-evg-230_0.cmd";

    # # printf "\nrequire mrfioc2,2.1.0\n\n";

    # # printf "epicsEnvSet("\"SYS\""             "\"%s\"")\n"   "$system"; 
    # # printf "epicsEnvSet("\"EVR\""             "\"%s\"")\n"   "$mrf_device"
    # # printf "epicsEnvSet("\"EVR_PCIDOMAIN"    "\"0x%s\"")\n" "$domain";
    # # printf "epicsEnvSet("\"EVR_PCIBUS\""      "\"0x%s\"")\n" "$bus";
    # # printf "epicsEnvSet("\"EVR_PCIDEVICE\""   "\"0x%s\"")\n" "$device";
    # # printf "epicsEnvSet("\"EVR_PCIFUNCTION\"" "\"0x%s\"")\n" "$function";

    # # printf "%s\n" "mrmEvrSetupPCI("$\(EVR\)", "$\(EVR_PCIDOMAIN\)",  "$\(EVR_PCIBUS\)", "$\(EVR_PCIDEVICE\)", "$\(EVR_PCIFUNCTION\)")";
    # # printf "\ndbLoadRecords(\"%s\", \"EVR=\$(EVR), SYS=\$(SYS)\")" "$epics_db"
    # # printf "\n\n%s\n\n" "------------ snip snip ------------";

    # printf "You should run this via the following command : \niocsh -3.14.12.5 cpci-evg-230_0.cmd\n";

    printf "\n\n%s\n\n" "------------ snip snip ------------";
    printf "%s\n" "# This file should be used with EPICS base 3.15.4 and mrfioc2 2.7.13";
    printf "%s\n" "# With current EEE 1.8.2, the proper command is ";
    printf "%s\n" "# $iocsh pcie-evr-300dc_0.cmd";
    printf "# or\n%s\n" "# $  -3.15.4 pcie-evr-300dc_0.cmd";
    printf "\nrequire mrfioc2,2.7.13\n\n";
    printf "epicsEnvSet("\"SYS\""             "\"%s\"")\n"   "$system"; 
    printf "epicsEnvSet("\"EVR\""             "\"%s\"")\n"   "$mrf_device"
    printf "epicsEnvSet("\"EVR_PCIDOMAIN\""    "\"0x%s\"")\n" "$domain";
    printf "epicsEnvSet("\"EVR_PCIBUS\""      "\"0x%s\"")\n" "$bus";
    printf "epicsEnvSet("\"EVR_PCIDEVICE\""   "\"0x%s\"")\n" "$device";
    printf "epicsEnvSet("\"EVR_PCIFUNCTION\"" "\"0x%s\"")\n" "$function";

    printf "%s\n" "mrmEvgSetupPCI("$\(EVR\)", "$\(EVR_PCIDOMAIN\)","$\(EVR_PCIBUS\)", "$\(EVR_PCIDEVICE\)", "$\(EVR_PCIFUNCTION\)")";
    printf "\ndbLoadRecords(\"%s\", \"DEVICE=\$(EVR), SYS=\$(SYS)\")" "$epics_db"
    printf "\n\n%s\n\n" "------------ snip snip ------------";

    printf "You should run this via the following command : \niocsh cpci-evg-230_0.cmd\n";
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




for info in "${INFO_list[@]}"
do
    printf "%2s: %s\n" "$index" "$info"
    let "index = $index + 1"
done

var=$(lspci |grep '7011' | awk '{ print $1 }')

bus=$(echo $var | cut -d: -f1)
device=$(echo $var | cut -d: -f2 | cut -d. -f1)
function=$(echo $var | cut -d. -f2)
echo $var
echo "bus      " $bus
echo "device   " $device
echo "function " $function

print_st "0" "${bus}" "${device}" "${function}"

exit
