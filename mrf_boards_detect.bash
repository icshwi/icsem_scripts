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
# Author : Jeong Han Lee
# email  : han.lee@esss.se
# Date   : 
# version : 0.1.1 
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

declare -gr PCI_VENDOR_ID_MRF="1a3e";
declare -gr PCI_DEVICE_ID_MRF_PMCEVR200="10c8";
declare -gr PCI_DEVICE_ID_MRF_PMCEVR230="11e6";
declare -gr PCI_DEVICE_ID_MRF_PXIEVR220="10dc";
declare -gr PCI_DEVICE_ID_MRF_PXIEVG220="20dc";
declare -gr PCI_DEVICE_ID_MRF_PXIEVR230="10e6";
declare -gr PCI_DEVICE_ID_MRF_PXIEVG230="20e6";
declare -gr PCI_DEVICE_ID_MRF_CPCIEVR300="152c";
declare -gr PCI_DEVICE_ID_MRF_PCIEEVR300="172c";
declare -gr PCI_DEVICE_ID_MRF_CPCIEVG300="252c";
declare -gr PCI_DEVICE_ID_MRF_PXIEEVR300="112c";
declare -gr PCI_DEVICE_ID_MRF_PXIEEVG300="212c";
declare -gr PCI_DEVICE_ID_MRF_CPCIEVRTG="192c";
declare -gr PCI_DEVICE_ID_MRF_CPCIFCT="30e6";
declare -gr PCI_DEVICE_ID_MRF_MTCAEVR300="132c";
declare -gr PCI_DEVICE_ID_MRF_MTCAEVG300="232c";

declare -ga mrf_device_list=();

function identify_mrf_boards(){

# declare -g ID_RELEASE=($(sed -n '/^ID=/p' /etc/os-release))
# RELEASE=${ID_RELEASE:3}
# RELEASE=${RELEASE//\"}
# 
    declare -i idx=0;

    mrf_device_list=("$(lspci -mmDn | grep -E "\<(${PCI_VENDOR_ID_MRF})")")
       
  
}


# [iocuser@ip6-6 icsem_scripts]$ lspci -nmm | grep -E "\<(1a3e)"
# 16:09.0 "1180" "10b5" "9030" -r01 "1a3e" "20e6"
# 16:0b.0 "1180" "10b5" "9030" -r01 "1a3e" "10e6"

# [iocuser@ip6-6 icsem_scripts]$ lspci -nmn | grep -E "\<(1a3e)"
# 16:09.0 "Signal processing controller [1180]" "PLX Technology, Inc. [10b5]" "PCI9030 32-bit 33MHz PCI <-> IOBus Bridge [9030]" -r01 "Micro-Research Finland Oy [1a3e]" "CPCI Event Generator 230 [20e6]"
# 16:0b.0 "Signal processing controller [1180]" "PLX Technology, Inc. [10b5]" "PCI9030 32-bit 33MHz PCI <-> IOBus Bridge [9030]" -r01 "Micro-Research Finland Oy [1a3e]" "CPCI Event Receiver 230 [10e6]"


# [iocuser@ip6-6 icsem_scripts]$ lspci -nmmn -i ../pciids/pci.ids | grep -E "\<(1a3e)"
# 16:09.0 "Signal processing controller [1180]" "PLX Technology, Inc. [10b5]" "PCI9030 32-bit 33MHz PCI <-> IOBus Bridge [9030]" -r01 "Micro-Research Finland Oy [1a3e]" "CPCI Event Generator 230 [20e6]"
# 16:0b.0 "Signal processing controller [1180]" "PLX Technology, Inc. [10b5]" "PCI9030 32-bit 33MHz PCI <-> IOBus Bridge [9030]" -r01 "Micro-Research Finland Oy [1a3e]" "CPCI Event Receiver 230 [10e6]"
# [iocuser@ip6-6 icsem_scripts]$ 

#[iocuser@ip6-6 icsem_scripts]$ lspci -nmmn   | grep -E "\<(1a3e)"
#16:09.0 "Signal processing controller [1180]" "PLX Technology, Inc. [10b5]" "PCI9030 32-bit 33MHz PCI <-> IOBus Bridge [9030]" -r01 "Micro-Research Finland Oy [1a3e]" "CPCI Event Generator 220 [20dc]"
#16:0c.0 "Signal processing controller [1180]" "PLX Technology, Inc. [10b5]" "PCI9030 32-bit 33MHz PCI <-> IOBus Bridge [9030]" -r01 "Micro-Research Finland Oy [1a3e]" "CPCI Event Receiver 230 [10e6]"
#16:0e.0 "Signal processing controller [1180]" "PLX Technology, Inc. [10b5]" "PCI9030 32-bit 33MHz PCI <-> IOBus Bridge [9030]" -r01 "Micro-Research Finland Oy [1a3e]" "CPCI Event Generator 230 [20e6]"

function print_array() {
    echo "$1" | while read a; \
	do
	echo $a; 
    done
}

function get_pci_info() {
    
    echo $1 | cut -d" " -f1;

}

identify_mrf_boards

declare -a cPCIEVG220_list=();
declare -a PMCEVR230_list=();
declare -a cPCIEVR230_list=();
declare -a cPCIEVG230_list=();
declare -a cPCIEVR300_list=();
declare -a PCIeEVR300_list=();
declare -a MTCAEVR300_list=();



echo "$mrf_device_list" | while read a; \
do 
 
    if [[ $a == *"$PCI_DEVICE_ID_MRF_PXIEVG220"* ]]; then
	printf "cPCI EVG220 is found at %s\n" "$a";
	cPCIEVG220_list+=$(get_pci_info $a);
	echo $cPCIEVG220_list;
    elif [[ $a == *"$PCI_DEVICE_ID_MRF_PMCEVR230"* ]]; then
    	printf "PMC EVR230 is found at $s\n" "$a";
    elif [[ $a == *"$PCI_DEVICE_ID_MRF_PXIEVR230"* ]]; then
    	printf "cPCI EVR230 is found at %s\n" "$a";
    elif [[ $a == *"$PCI_DEVICE_ID_MRF_PXIEVG230"* ]]; then
    	printf "cPCI EVG230 is found at %s\n" "$a";
    elif [[ $a == *"$PCI_DEVICE_ID_MRF_CPCIEVR300"* ]]; then
    	printf "cPCI EVR300 is found at $s\n" "$a";
    elif [[ $a == *"$PCI_DEVICE_ID_MRF_PCIEEVR300"* ]]; then
    	printf "PCIe EVR300 is found at %s\n" "$a";
    elif [[ $a == *"$PCI_DEVICE_ID_MRF_MTCAEVR300"* ]]; then
    	printf "MTCA EVR300 is found at %s\n" "$a";
    else
	printf "We don't have this model %s in our DB\n" "$a";
    fi
  
done

print_array $cPCIEVG220_list 

exit
