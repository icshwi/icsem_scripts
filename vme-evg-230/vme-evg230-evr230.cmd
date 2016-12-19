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
epicsEnvSet("EVG_VMESLOT"     "6")

epicsEnvSet("EVR"          "EVR0")
epicsEnvSet("EVR_VMESLOT"     "3")
epicsEnvSet("EVR_VMEBASE"     "0x3000000")
epicsEnvSet("EVR_VMELEVEL"    "4")
epicsEnvSet("EVR_VMEVECTOR"   "0x28")


mrmEvgSetupVME($(EVG), $(EVG_VMESLOT), 0x100000, 1, 0x01)    
# Fake timestamp source for testing without real hardware timestamp source (e.g., GPS recevier)
mrmEvgSoftTime($(EVG))

mrmEvrSetupVME($(EVR), $(EVR_VMESLOT), $(EVR_VMEBASE), $(EVR_VMELEVEL), $(EVR_VMEVECTOR))


# ESS ICS Definition
epicsEnvSet("HWEVT"    "14")
epicsEnvSet("EVTFREQ"  "14")
epicsEnvSet("EPICSEVT" "14")

# Fake Timestamp
epicsEnvSet("EVRTSE"   "-2")

# Don't change HBEVT 
epicsEnvSet("HBEVT"   "122")
# One can change, but don't change it.
epicsEnvSet("HBFREQ"    "1")


# --------------------------------------------------------
# Set Heart Beat Event (Evtcode, Fre, TrigSrc7) (122, 1, 1)
# Set 14 Hz      Event (Evtcode, Fre, TrigSrc0) (14, 14, 1)
# 
dbLoadRecords("evg-vme-230.db", "DEVICE=$(EVG), SYS=$(SYS), TrigEvt7-EvtCode-SP=$(HBEVT), Mxc2-Frequency-SP=$(HBFREQ), Mxc2-TrigSrc7-SP=1, TrigEvt0-EvtCode-SP=$(HWEVT), Mxc0-Frequency-SP=$(EVTFREQ), Mxc0-TrigSrc0-SP=1, SoftEvt-Enable-Sel=1")

dbLoadRecords("evr-vme-230.db", "DEVICE=$(EVR), SYS=$(SYS)")
#Generate trigger signals
# Time Stamping on EVR
dbLoadRecords("evr-softEvent.template", "DEVICE=$(EVR), SYS=$(SYS), CODE=$(EPICSEVT), EVT=$(HWEVT)")
# Trigger Output on EVR
dbLoadRecords("evr-pulserMap.template", "DEVICE=$(EVR), SYS=$(SYS), PID=0, F=Trig, ID=0, EVT=$(HWEVT)")



iocInit


# EVR
# make the timestamp available to other equipment (e.g., data acquisition)
dbpf $(SYS)-$(EVR):Time-I.TSE  $(EVRTSE)

# Which EVNT should we use? I guess the EPICS EventNumber EPICSEVT
dbpf $(SYS)-$(EVR):Time-I.EVNT $(EPICSEVT)


dbl > $(IOC).pvlist

sleep(5)

# Mandatory if Fake timestamp source for testing without real hardware timestamp source (e.g., GPS recevier)
#


dbpf $(SYS)-$(EVG):SyncTimestamp-Cmd 1
