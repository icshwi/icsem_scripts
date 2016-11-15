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
# version : 0.0.1

contains() {
    string="$1"
    substring="$2"
    if test "${string#*$substring}" != "$string"
    then
        return 0    # $substring is in $string
    else
        return 1    # $substring is not in $string
    fi
}

SYSDEV=$1

fw_version=$(caget -0x $SYSDEV:FwVer-I) 
sw_version=$(caget $SYSDEV:SwVer-I)


printf "MRF HW  FW version %s\n" "$fw_version" ;
printf "mrfioc2 SW version %s\n" "$sw_version";
printf "\n";



string="$SYSDEV";
substring="EVG"


if test "${string#*$substring}" != "$string"; then
    caget $SYSDEV:TrigEvt7-Enable-RB $SYSDEV:TrigEvt7-EvtCode-RB $SYSDEV:Mxc2-Frequency-RB $SYSDEV:Mxc2-TrigSrc7-SP
    caget $SYSDEV:TrigEvt0-Enable-RB $SYSDEV:TrigEvt0-EvtCode-RB $SYSDEV:Mxc0-Frequency-RB $SYSDEV:Mxc0-TrigSrc0-SP
    caget $SYSDEV:SoftEvt-Enable-Sel
else
    caget $SYSDEV:HwType-I
    caget $SYSDEV:Link-Sts $SYSDEV:Link-Clk-I 
    caget $SYSDEV:Time-Clock-I $SYSDEV:Link-Clk-SP
    caget $SYSDEV:SFP0-PowerVCC-I $SYSDEV:SFP0-Pwr-RX-I $SYSDEV:SFP0-Pwr-TX-I $SYSDEV:SFP0-Speed-Link-I $SYSDEV:SFP0-T-I
    caget $SYSDEV:SFP0-BitRate-lower-I $SYSDEV:SFP0-BitRate-upper-I $SYSDEV:SFP0-LinkLength-50fiber-I $SYSDEV:SFP0-LinkLength-62fiber-I $SYSDEV:SFP0-LinkLength-9fiber-I $SYSDEV:SFP0-LinkLength-copper-I $SYSDEV:SFP0-Status-I

    caget $SYSDEV:Time-Src-Sel
    caget $SYSDEV:CG-Sts 
    caget $SYSDEV:Pll-Sts
    caget $SYSDEV:Time-Valid-Sts
    caget $SYSDEV:Event-14-Cnt-I
fi

