#  -*- mode: epics -*-
# $ iocsh test_evr-mtca-300.cmd

require mrfioc2,2.7.13

epicsEnvSet(       "SYS"     "MTCA425")

epicsEnvSet(       "EVR"        "EVR0")
epicsEnvSet(   "EVR_BUS"        "0x08")
epicsEnvSet(   "EVR_DEV"        "0x00")
epicsEnvSet(  "EVR_FUNC"         "0x0")
epicsEnvSet("EVR_DOMAIN"      "0x0000")
mrmEvrSetupPCI($(EVR), $(EVR_DOMAIN), $(EVR_BUS), $(EVR_DEV), $(EVR_FUNC))

dbLoadRecords("evr-mtca-300.db", "DEVICE=$(EVR), SYS=$(SYS), Link-Clk-SP=88.0525")


#Generate trigger signals
dbLoadRecords("evr-softEvent.template", "DEVICE=$(EVR), SYS=$(SYS), CODE=14, EVT=14")
dbLoadRecords("evr-pulserMap.template", "DEVICE=$(EVR), SYS=$(SYS), PID=0, F=Trig, ID=0, EVT=14")



iocInit

#
