#  -*- mode: epics -*-
# $ iocsh test_evr-pmc-230.cmd

require mrfioc2,2.7.13

epicsEnvSet(       "SYS"        "PMC")

epicsEnvSet(       "EVR"        "EVR0")
epicsEnvSet(   "EVR_BUS"        "0x0d")
epicsEnvSet(   "EVR_DEV"        "0x00")
epicsEnvSet(  "EVR_FUNC"         "0x0")
epicsEnvSet("EVR_DOMAIN"      "0x0000")

# ESS ICS Definition
epicsEnvSet("HWEVT"    "14")
epicsEnvSet("EPICSEVT" "14")

# Take Timestamp from device support (timing system)
epicsEnvSet("EVRTSE"   "-2")

mrmEvrSetupPCI($(EVR), $(EVR_DOMAIN), $(EVR_BUS), $(EVR_DEV), $(EVR_FUNC))

dbLoadRecords("evr-pmc-230.db", "DEVICE=$(EVR), SYS=$(SYS), Link-Clk-SP=88.0525, FrontOut0-Src-SP=0, Pul0-Width-SP=10000, FrontOut2-Src-SP=1, Pul1-Width-SP=10000, Pul1-Delay-SP=20000")



#Generate trigger signals
# Time Stamping on EVR
dbLoadRecords("evr-softEvent.template", "DEVICE=$(EVR), SYS=$(SYS), CODE=$(EPICSEVT), EVT=$(HWEVT)")

#Generate trigger signals
dbLoadRecords("evr-softEvent.template", "DEVICE=$(EVR), SYS=$(SYS), CODE=1, EVT=1")
dbLoadRecords("evr-softEvent.template", "DEVICE=$(EVR), SYS=$(SYS), CODE=2, EVT=2")
dbLoadRecords("evr-softEvent.template", "DEVICE=$(EVR), SYS=$(SYS), CODE=3, EVT=3")

# Trigger Output on EVR
dbLoadRecords("evr-pulserMap.template", "DEVICE=$(EVR), SYS=$(SYS), PID=0, F=Trig, ID=0, EVT=$(HWEVT)")
dbLoadRecords("evr-pulserMap.template", "DEVICE=$(EVR), SYS=$(SYS), PID=1, F=Trig, ID=0, EVT=$(HWEVT)")



iocInit



