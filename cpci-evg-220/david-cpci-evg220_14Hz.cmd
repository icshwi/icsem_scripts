#  -*- mode: epics -*-
# This file should be used with EPICS base 3.15.4 and mrfioc2, iocuser (han branch)
# With current EEE 1.8.2, the proper command is 
#
#  iocsh -3.14.12.5 cpci-evg-220/david-cpci-evg220_14Hz.cmd

require mrfioc2,iocuser

epicsEnvSet("IOC"       "DG_TS-IOC")
epicsEnvSet("SYS"       "DG")

epicsEnvSet("EVG"       "EVG220")
epicsEnvSet("EVG_BUS"   "0x10")
epicsEnvSet("EVG_DEV"   "0x0d")
epicsEnvSet("EVG_FUNC"  "0x0")

mrmEvgSetupPCI($(EVG), $(EVG_BUS), $(EVG_DEV), $(EVG_FUNC))

# --------------------------------------------------------
# Set Heart Beat Event (Evtcode, Fre, TrigSrc7) (122,1,1)
# Set 14 Hz      Event (Evtcode, Fre, TrigSrc0) (14, 14, 1)
# 
dbLoadRecords("evg-cpci.db", "DEVICE=$(EVG), SYS=$(SYS), TrigEvt0-EvtCode-SP=122, Mxc2-Frequency-SP=1, Mxc2-TrigSrc7-SP=1, TrigEvt0-EvtCode-SP=14, Mxc0-Frequency-SP=14, Mxc0-TrigSrc0-SP=1, SoftEvt-Enable-Sel=1")

iocInit

mrmEvgSoftTime("$(EVG)")
sleep(5)
dbpf $(SYS)-$(EVG):SyncTimestamp-Cmd 1


