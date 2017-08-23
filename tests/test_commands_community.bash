#!/bin/sh
#
#  Copyright (c) 2017 European Spallation Source ERIC
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
# Author : Javier Cereijo Garcia 
# email  :
# Date   : 
# version : 0.0.2
#
# 

# Automatic test of EVG and EVR
###
EVG=$1
EVR=$2
#Example: sh test_commands_community.bash TST{evg:1 TST{evr:4

# We can check the EVG and EVR link status and the link clock setting.
echo caget ${EVR}}Link-Sts
caget ${EVR}}Link-Sts
echo caget ${EVR}}Link:Clk-I
caget ${EVR}}Link:Clk-I
echo caget ${EVG}-EvtClk}Frequency-RB
caget ${EVG}-EvtClk}Frequency-RB

# Change the wrong clock setting on EVR, then we expect that the link status will be Fail.  
echo caput ${EVR}}Link:Clk-SP 100
caput ${EVR}}Link:Clk-SP 100
sleep 1
echo caget ${EVR}}Link:Clk-I
caget ${EVR}}Link:Clk-I
echo caget ${EVR}}Link-Sts
caget ${EVR}}Link-Sts

# There is a link heartbeat counter that gets updated aproximately every 1.3 s when the link is off. Camonitor it to check its functionality.
# echo camonitor ${EVR}}Cnt:LinkTimo-I
# (cmdpid=$BASHPID; (sleep 5; kill $cmdpid) & camonitor ${EVR}}Cnt:LinkTimo-I)
echo caget ${EVR}}Cnt:LinkTimo-I
caget ${EVR}}Cnt:LinkTimo-I
sleep 1.3
caget ${EVR}}Cnt:LinkTimo-I
sleep 1.3
caget ${EVR}}Cnt:LinkTimo-I
sleep 1.3
caget ${EVR}}Cnt:LinkTimo-I
sleep 1.3
caget ${EVR}}Cnt:LinkTimo-I

# Revert it back to the proper clock setting, and the link status will be OK.
echo caput ${EVR}}Link:Clk-SP 88.0525
caput ${EVR}}Link:Clk-SP 88.0525
sleep 1
echo caget ${EVR}}Link-Sts
caget ${EVR}}Link-Sts

# Monitor the Event counter with 14 and check the time difference between counters, e.g., 278 and 279, is 0.071429s, i.e., 14 Hz.
echo camonitor ${EVR}}EvtECnt-I
# Assuming TST{evr:4}EvtECnt-I is connected to TST{evr:4}EvtE-SP.OUT with @OBJ=EVR,Code=14 as default
#(cmdpid=$BASHPID; (sleep 3; kill $cmdpid) & exec camonitor ${EVR}}EvtECnt-I)

# # Enable the software event
# echo caput ${EVG}:SoftEvt-Enable-Sel "Enabled"
# caput ${EVG}:SoftEvt-Enable-Sel "Enabled"

# Prepape for next steps by setting event counters A-C to events 1-3
caput ${EVR}}EvtA-SP.OUT @OBJ=EVR,Code=1
caput ${EVR}}EvtB-SP.OUT @OBJ=EVR,Code=2
caput ${EVR}}EvtC-SP.OUT @OBJ=EVR,Code=3

#See number of counts
echo caget ${EVR}}EvtACnt-I
caget ${EVR}}EvtACnt-I

#Send the event from the EVG
echo caput ${EVG}-SoftEvt}EvtCode-SP 1
caput ${EVG}-SoftEvt}EvtCode-SP 1
sleep 10

#Count the event
echo caget ${EVR}}EvtACnt-I
caget ${EVR}}EvtACnt-I

# Change the width time of the pulse generator 0 from 10 ms to 50 ms
# Pulsers are called delay generators in community mrfioc2
echo caput ${EVR}-DlyGen:0}Width-SP 50000
caput ${EVR}-DlyGen:0}Width-SP 50000
sleep 10

# Revert
echo caput ${EVR}-DlyGen:0}Width-SP 10000
caput ${EVR}-DlyGen:0}Width-SP 10000

# In the EVG host, attach the soft sequence to a specific hardware sequence
echo ""
echo ""
echo "Soft Sequence is starting, without the sequence setup in an EVG"
echo "One can see many not found messages"
echo ""
echo ""

echo caput ${EVG}-SoftSeq:0}Unload-Cmd 1
caput ${EVG}-SoftSeq:0}Unload-Cmd 1
echo caput ${EVG}-SoftSeq:0}Load-Cmd 1
caput ${EVG}-SoftSeq:0}Load-Cmd 1

# Set engineering units for the timestamping
echo caput ${EVG}-SoftSeq:0}TsResolution-Sel Sec
caput ${EVG}-SoftSeq:0}TsResolution-Sel Sec

# Set the trigger source for the sequence as software and enable it
echo caput ${EVG}-SoftSeq:0}TrigSrc:0-Sel Software
caput ${EVG}-SoftSeq:0}TrigSrc:0-Sel Software
echo caput ${EVG}-SoftSeq:0}RunMode-Sel Normal
caput ${EVG}-SoftSeq:0}RunMode-Sel Normal
echo caput ${EVG}-SoftSeq:0}Enable-Cmd 1
caput ${EVG}-SoftSeq:0}Enable-Cmd 1

# Set up the sequence content, corresponding timestamps and masks
# The timestamps are specified in milliseconds, as set before
echo caput -a ${EVG}-SoftSeq:0}EvtCode-SP 4 1 2 3 127
caput -a ${EVG}-SoftSeq:0}EvtCode-SP 4 1 2 3 127
echo caput -a ${EVG}-SoftSeq:0}Timestamp-SP 4 1 2 3 4
caput -a ${EVG}-SoftSeq:0}Timestamp-SP 4 1 2 3 4

# Commit the sequence to hardware
echo caput ${EVG}-SoftSeq:0}Commit-Cmd 1
caput ${EVG}-SoftSeq:0}Commit-Cmd 1

# In the EVR host, set the record to get timestamp from system time (OS clock)
echo caput ${EVR}}EvtA-SP.TSE 0
caput ${EVR}}EvtA-SP.TSE 0
echo caput ${EVR}}EvtB-SP.TSE 0
caput ${EVR}}EvtB-SP.TSE 0
echo caput ${EVR}}EvtC-SP.TSE 0
caput ${EVR}}EvtC-SP.TSE 0

# Monitor the reception of the events
#(cmdpid=$BASHPID; (sleep 15; kill $cmdpid) & exec camonitor ${EVR}:Event-1-Cnt-I ${EVR}:Event-2-Cnt-I ${EVR}:Event-3-Cnt-I)

# On the EVG host, trigger the sequence
echo caget ${EVR}}EvtACnt-I ${EVR}}EvtBCnt-I ${EVR}}EvtCCnt-I
caget ${EVR}}EvtACnt-I ${EVR}}EvtBCnt-I ${EVR}}EvtCCnt-I
echo caput ${EVG}-SoftSeq:0}SoftTrig-Cmd 1
caput ${EVG}-SoftSeq:0}SoftTrig-Cmd 1
sleep 5
echo caget ${EVR}}EvtACnt-I ${EVR}}EvtBCnt-I ${EVR}}EvtCCnt-I
caget ${EVR}}EvtACnt-I ${EVR}}EvtBCnt-I ${EVR}}EvtCCnt-I
echo caput ${EVG}-SoftSeq:0}SoftTrig-Cmd 1
caput ${EVG}-SoftSeq:0}SoftTrig-Cmd 1
sleep 5
echo caget ${EVR}}EvtACnt-I ${EVR}}EvtBCnt-I ${EVR}}EvtCCnt-I
caget ${EVR}}EvtACnt-I ${EVR}}EvtBCnt-I ${EVR}}EvtCCnt-I
echo caput ${EVG}-SoftSeq:0}SoftTrig-Cmd 1
caput ${EVG}-SoftSeq:0}SoftTrig-Cmd 1
sleep 5
echo caget ${EVR}}EvtACnt-I ${EVR}}EvtBCnt-I ${EVR}}EvtCCnt-I
caget ${EVR}}EvtACnt-I ${EVR}}EvtBCnt-I ${EVR}}EvtCCnt-I



# Watch closely to the graph in the CSS OPI screen when enabling Rear Universal Output 33, since in the next event 14 received the SIS8300 will start the data acquisition; since it is not connected, the data acquired is just 0
#caput EVRTEST-EVRMTCA:RearUniv33-Ena-SP "Enabled"


