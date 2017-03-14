# -*- mode: sh -*-
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
#  Author  : Jeong Han Lee
#  Email   : han.lee@esss.se
#  Date    : Friday, November 11 15:10:58 CET 2016
#  Version : 0.0.1


ROOT_UID=0 
E_NOTROOT=101
EXIST=1
NON_EXIST=0



function pushd() { builtin pushd "$@" > /dev/null; }
function popd()  { builtin popd  "$@" > /dev/null; }

function __ini_func() { printf "\n>>>> You are entering in  : %s\n" "${1}"; }
function __end_func() { printf "\n<<<< You are leaving from : %s\n" "${1}"; }

function __checkstr() {
    if [ -z "$1" ]; then
	printf "%s : input variable is not defined \n" "${FUNCNAME[*]}"
	exit 1;
    fi
}


function ini_func() { sleep 1; printf "\n>>>> You are entering in  : %s\n" "${1}"; }
function end_func() { sleep 1; printf "\n<<<< You are leaving from : %s\n" "${1}"; }

function checkstr() {
    if [ -z "$1" ]; then
	printf "%s : input variable is not defined \n" "${FUNCNAME[*]}"
	exit 1;
    fi
}


function printf_tee() {
    local input=${1};
    local target=${2};
    # If target exists, it will be overwritten.
    ${SUDO_CMD} printf "%s" "${input}" | ${SUDO_CMD} tee "${target}";
};


# Generic : git_clone
# 1.0.3 Tuesday, November  8 18:13:44 CET 2016
#
# Required Global Variable
# - SC_LOGDATE      : Input

function git_clone() {
    
    local func_name=${FUNCNAME[*]}; ini_func ${func_name};
    
    local git_src_dir=$1;
    local git_src_url=$2;
    local git_src_name=$3;
    local tag_name=$4;
    
    checkstr ${SC_LOGDATE};
    
    if [[ ! -d ${git_src_dir} ]]; then
	printf "No git source repository in the expected location %s\n" "${git_src_dir}";
    else
	printf "Old git source repository in the expected location %s\n" "${git_src_dir}";
	printf "The old one is renamed to %s_%s\n" "${git_src_dir}" "${SC_LOGDATE}";
	mv  ${git_src_dir} ${git_src_dir}_${SC_LOGDATE}
    fi
    
    # Alwasy fresh cloning ..... in order to workaround any local 
    # modification in the repository, which was cloned before. 
    #
    # we need the recursive option in order to build a web based viewer for Archappl
    if [ -z "$tag_name" ]; then
	git clone --recursive "${git_src_url}/${git_src_name}" "${git_src_dir}";
    else
	git clone --recursive -b "${tag_name}" --single-branch --depth 1 "${git_src_url}/${git_src_name}" "${git_src_dir}";
    fi

    end_func ${func_name};
}




function checkIfDir() {

    local dir=$1
    local result=""
    if [ ! -d "$dir" ]; then
	result=$NON_EXIST
	# doesn't exist
    else
	result=$EXIST
	# exist
    fi
    echo "${result}"

}

function checkIfFile() {

    local file=$1
    local result=""
    if [ ! -e "$file" ]; then
	result=$NON_EXIST
	# doesn't exist
    else
	result=$EXIST
	# exist
    fi
    echo "${result}"	 
}



function checkIfVar() {

    local var=$1
    local result=""
    if [ -z "$var" ]; then
	result=$NON_EXIST
	# doesn't exist
    else
	result=$EXIST
	# exist
    fi
    echo "${result}"	 
}




function cat_file () {
    local func_name=${FUNCNAME[*]}; __ini_func ${func_name};
    local file=$1

    cat $file
    __end_func ${func_name};
}


