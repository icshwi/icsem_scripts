#  -*- mode: epics -*-
# $ iocsh test_evr-mtca-300.cmd

require mrfioc2,2.7.13

epicsEnvSet(       "SYS"     "MTCA424")

epicsEnvSet(       "EVR"        "EVR0")
epicsEnvSet(   "EVR_BUS"        "0x07")
epicsEnvSet(   "EVR_DEV"        "0x00")
epicsEnvSet(  "EVR_FUNC"         "0x0")
epicsEnvSet("EVR_DOMAIN"      "0x0000")
mrmEvrSetupPCI($(EVR), $(EVR_DOMAIN), $(EVR_BUS), $(EVR_DEV), $(EVR_FUNC))

# ESS ICS Definition
epicsEnvSet("HWEVT"    "14")
epicsEnvSet("EPICSEVT" "14")

# Take Timestamp from device support (timing system)
epicsEnvSet("EVRTSE"   "-2")


# dbLoadRecords example
dbLoadRecords("evr-mtca-300.db", "DEVICE=$(EVR), SYS=$(SYS), Link-Clk-SP=88.0525, FrontOut0-Src-SP=0, Pul0-Width-SP=10000, FrontOut2-Src-SP=1, Pul1-Width-SP=10000, Pul1-Delay-SP=20000, RearUniv33-Ena-SP=0, RearUniv33-Src-SP=0")

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


#####

#require recsync
#dbLoadRecords(reccaster.db, "P=EVRTEST:recsync:")

#require sis8300

#epicsEnvSet("BUFSIZE", "1024")

#ndsCreateDevice("sis8300", "SIS8300", "FILE=/dev/sis8300-5")

#dbLoadRecords("sis8300.db", "PREFIX=EVRTEST:DAQ, ASYN_PORT=SIS8300, AI_NELM=1024")

#####


iocInit

# make the timestamp available to other equipment (e.g., data acquisition)
dbpf $(SYS)-$(EVR):Time-I.TSE  $(EVRTSE)

# select main epics evt (14 Hz - pulse frequency)
dbpf $(SYS)-$(EVR):Time-I.EVNT $(EPICSEVT)

# start css
# css --launcher.openFile "/opt/epics/modules/sis8300/1.12.1/opi/sis8300.opi Device2Macro=EVRTEST[\58]DAQ"

# enable the rearuniv33
# dbpf MTCA442-EVR0:RearUniv33-Ena-SP "Enabled"

