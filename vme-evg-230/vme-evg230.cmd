#  -*- mode: epics -*-
# This file should be used with EPICS base 3.14.12.5 and mrfioc2 (2.7.13)
#
# With current EEE 1.8.2, the proper command is 
#
# iocsh -3.14.12.5 vme-evg-230/vme-evg230-evr230.cmd
#

require pev,0.1.2
require mrfioc2,2.7.13


epicsEnvSet("IOC" "SD-TS-IOC")

epicsEnvSet("SYS"           "TS")
epicsEnvSet("EVG"         "EVG0")
epicsEnvSet("EVG_VMESLOT"     "5")


mrmEvgSetupVME($(EVG), $(EVG_VMESLOT), 0x100000, 1, 0x01)    
# Fake timestamp source for testing without real hardware timestamp source (e.g., GPS recevier)
mrmEvgSoftTime($(EVG))


# ESS ICS Definition
epicsEnvSet("HWEVT"    "14")
epicsEnvSet("EVTFREQ"  "14")
epicsEnvSet("EPICSEVT" "14")

# Don't change HBEVT 
epicsEnvSet("HBEVT"   "122")
# One can change, but don't change it.
epicsEnvSet("HBFREQ"    "1")


# --------------------------------------------------------
# Set Heart Beat Event (Evtcode, Fre, TrigSrc7) (122, 1, 1)
# Set 14 Hz      Event (Evtcode, Fre, TrigSrc0) (14, 14, 1)
# 
dbLoadRecords("evg-vme-230.db", "DEVICE=$(EVG), SYS=$(SYS), TrigEvt7-EvtCode-SP=$(HBEVT), Mxc2-Frequency-SP=$(HBFREQ), Mxc2-TrigSrc7-SP=1, TrigEvt0-EvtCode-SP=$(HWEVT), Mxc0-Frequency-SP=$(EVTFREQ), Mxc0-TrigSrc0-SP=1, SoftEvt-Enable-Sel=1")

iocInit


dbl > $(IOC).pvlist

sleep(5)

# Mandatory if Fake timestamp source for testing without real hardware timestamp source (e.g., GPS recevier)
#


dbpf $(SYS)-$(EVG):SyncTimestamp-Cmd 1
