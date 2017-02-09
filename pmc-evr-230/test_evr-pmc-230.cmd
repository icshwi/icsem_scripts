#  -*- mode: epics -*-
# $ iocsh test_evr-pmc-230.cmd

require mrfioc2,2.7.13

epicsEnvSet(       "SYS"        "PMC")

epicsEnvSet(       "EVR"        "EVR0")
epicsEnvSet(   "EVR_BUS"        "0x08")
epicsEnvSet(   "EVR_DEV"        "0x00")
epicsEnvSet(  "EVR_FUNC"         "0x0")
epicsEnvSet("EVR_DOMAIN"      "0x0000")

mrmEvrSetupPCI($(EVR), $(EVR_DOMAIN), $(EVR_BUS), $(EVR_DEV), $(EVR_FUNC))

dbLoadRecords("evr-pmc-230.db", "DEVICE=$(EVR), SYS=$(SYS), Link-Clk-SP=88.0525")

iocInit



