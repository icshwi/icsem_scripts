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
# Date   : Wednesday, November 16 13:34:01 CET 2016
# version : 0.0.1


SYSDEV=$1

if [ -z "$1" ]; then
    printf "\n";
    printf "usage: %16s \"input\"\n\n" "$0"
    printf "       %32s\n\n" "(SYS)-(DEVICE)"
    printf "       %32s\n\n" "e.g. DG-EVG"

    exit 1;
fi


fw_version=$(caget -0x $SYSDEV:FwVer-I) 
sw_version=$(caget $SYSDEV:SwVer-I)


printf "MRF HW  FW version %s\n" "$fw_version" ;
printf "mrfioc2 SW version %s\n" "$sw_version";
printf "\n";


declare -a evg_pvlist=();
declare -a evr_pvlist=();

evg_pvlist+="TrigEvt0-EvtCode-RB  TrigEvt1-EvtCode-RB TrigEvt2-EvtCode-RB TrigEvt3-EvtCode-RB TrigEvt4-EvtCode-RB  TrigEvt5-EvtCode-RB TrigEvt6-EvtCode-RB TrigEvt7-EvtCode-RB";
evg_pvlist+=" "
evg_pvlist+="TrigEvt0-Enable-RB TrigEvt1-Enable-RB TrigEvt2-Enable-RB TrigEvt3-Enable-RB TrigEvt4-Enable-RB TrigEvt5-Enable-RB TrigEvt6-Enable-RB TrigEvt7-Enable-RB";
evg_pvlist+=" ";
evg_pvlist+="EvtClk-Frequency-RB Mxc0-Frequency-RB Mxc1-Frequency-RB Mxc2-Frequency-RB Mxc3-Frequency-RB Mxc4-Frequency-RB  Mxc5-Frequency-RB Mxc6-Frequency-RB Mxc7-Frequency-RB"
evg_pvlist+=" "
evg_pvlist+="Mxc0-Polarity-RB Mxc1-Polarity-RB Mxc2-Polarity-RB Mxc3-Polarity-RB Mxc4-Polarity-RB Mxc5-Polarity-RB Mxc6-Polarity-RB Mxc7-Polarity-RB"
evg_pvlist+=" ";
evg_pvlist+="Mxc0-Status-RB Mxc1-Status-RB Mxc2-Status-RB Mxc3-Status-RB Mxc4-Status-RB Mxc5-Status-RB Mxc6-Status-RB Mxc7-Status-RB"
evg_pvlist+=" ";
evg_pvlist+="SoftEvt-Enable-RB SoftEvt-EvtCode-RB SoftSeqEnable-RB SoftSeqMask-RB"
evg_pvlist+=" ";
evg_pvlist+="EvtClk-FracSynFreq-RB EvtClk-Frequency-RB EvtClk-RFFreq-RB  EvtClk-PLL-Sts EvtClk-RFDiv-RB EvtClk-PLL-Bandwidth-RB EvtClk-Source-RB"
evg_pvlist+=" ";
evg_pvlist+="SFP0-PowerVCC-I SFP0-Pwr-RX-I SFP0-Pwr-TX-I SFP0-Speed-Link-I  SFP0-T-I SFP0-BitRate-lower-I SFP0-BitRate-upper-I SFP0-LinkLength-50fiber-I SFP0-LinkLength-62fiber-I SFP0-LinkLength-9fiber-I  SFP0-LinkLength-copper-I SFP0-Status-I SFP0-Date-Manu-I SFP0-Part-I SFP0-Rev-I SFP0-Serial-I SFP0-Vendor-I";
evg_pvlist+=" ";
evg_pvlist+="SyncTimestamp-Cmd Timestamp-RB DbusStatus-RB";


 
evr_pvlist+="HwType-I"
evr_pvlist+=" ";
evr_pvlist+="Link-Sts Link-Clk-I Link-Clk-SP Link-ClkPeriod-I"
evr_pvlist+=" ";
evr_pvlist+="Time-Div-I Time-I Time-Clock-I Time-Src-Sel Time-Valid-Sts"
evr_pvlist+=" ";
evr_pvlist+="SFP0-PowerVCC-I SFP0-Pwr-RX-I SFP0-Pwr-TX-I SFP0-Speed-Link-I SFP0-T-I SFP0-BitRate-lower-I SFP0-BitRate-upper-I SFP0-LinkLength-50fiber-I SFP0-LinkLength-62fiber-I  SFP0-LinkLength-9fiber-I SFP0-LinkLength-copper-I SFP0-Status-I SFP0-Date-Manu-I SFP0-Part-I SFP0-Rev-I SFP0-Serial-I SFP0-Vendor-I"
evr_pvlist+=" "
evr_pvlist+="CG-Sts Event-14-Cnt-I Pos-I"
evr_pvlist+=" "
evr_pvlist+="Cnt-FIFOEvt-I Cnt-FIFOLoop-I Cnt-HwOflw-I Cnt-IRQ-I Cnt-LinkTimo-I Cnt-RxErr-I Cnt-SwOflw-I"


string="$SYSDEV";
substring="EVG"


if test "${string#*$substring}" != "$string"; then
    for pv in $evg_pvlist; do
	caget $SYSDEV:$pv;
    done
else
    for pv in $evr_pvlist; do
	caget $SYSDEV:$pv;
    done
fi

