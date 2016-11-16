#  -*- mode: epics -*-
# This file should be used with EPICS base 3.15.4 and mrfioc2 (han branch)
# With current EEE 1.8.2, the proper command is 
#
# iocsh -3.14.12.5 cpci-evg-220/david-cpci-evg220_14Hz-evr230.cmd
#
#
require mrfioc2,iocuser

epicsEnvSet(       "IOC"   "DG-TS-IOC")
epicsEnvSet(       "SYS"          "DG")

epicsEnvSet(       "EVG"         "EVG")
epicsEnvSet(   "EVG_BUS"        "0x10")
epicsEnvSet(   "EVG_DEV"        "0x0d")
epicsEnvSet(  "EVG_FUNC"         "0x0")

mrmEvgSetupPCI($(EVG), $(EVG_BUS), $(EVG_DEV), $(EVG_FUNC))

# Fake timestamp source for testing without real hardware timestamp source (e.g., GPS recevier)
mrmEvgSoftTime($(EVG))

epicsEnvSet(       "EVR0"        "EVR")
epicsEnvSet(   "EVR0_BUS"       "0x10")
epicsEnvSet(   "EVR0_DEV"       "0x09")
epicsEnvSet(  "EVR0_FUNC"        "0x0")
epicsEnvSet("EVR0_DOMAIN"     "0x0000")

mrmEvrSetupPCI($(EVR0), $(EVR0_DOMAIN), $(EVR0_BUS), $(EVR0_DEV), $(EVR0_FUNC))


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
dbLoadRecords("evg-cpci.db", "DEVICE=$(EVG), SYS=$(SYS), TrigEvt7-EvtCode-SP=$(HBEVT), Mxc2-Frequency-SP=$(HBFREQ), Mxc2-TrigSrc7-SP=1, TrigEvt0-EvtCode-SP=$(HWEVT), Mxc0-Frequency-SP=$(EVTFREQ), Mxc0-TrigSrc0-SP=1, SoftEvt-Enable-Sel=1")

dbLoadRecords("evr-cpci-230.db", "DEVICE=$(EVR0), SYS=$(SYS)")
#Generate trigger signals
# Time Stamping on EVR
dbLoadRecords("evr-softEvent.template", "DEVICE=$(EVR0), SYS=$(SYS), CODE=$(EPICSEVT), EVT=$(HWEVT)")

# Trigger Output on EVR
dbLoadRecords("evr-pulserMap.template", "DEVICE=$(EVR0), SYS=$(SYS), PID=0, F=Trig, ID=0, EVT=$(HWEVT)")

iocInit

# EVR
# make the timestamp available to other equipment (e.g., data acquisition)
dbpf $(SYS)-$(EVR0):Time-I.TSE  $(EVRTSE)

# Which EVNT should we use? I guess the EPICS EventNumber EPICSEVT
dbpf $(SYS)-$(EVR0):Time-I.EVNT $(EPICSEVT)

# Mandatory if Fake timestamp source for testing without real hardware timestamp source (e.g., GPS recevier)
#
dbpf $(SYS)-$(EVG):SyncTimestamp-Cmd 1


dbl > $(IOC)-$(SYS).pvlist

