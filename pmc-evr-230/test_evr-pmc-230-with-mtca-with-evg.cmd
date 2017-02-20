#  -*- mode: epics -*-
# $ iocsh test_evr-pmc-230-with-mtca-with-evg.cmd


# This startup script is for the pmc-evr-230 with the ESS customized MTCA carrier board
# Please see in detail at https://confluence.esss.lu.se/pages/viewpage.action?pageId=24019200
#


require mrfioc2,2.7.13

epicsEnvSet(       "SYS"        "PMC-MTCA")

epicsEnvSet(       "EVR"        "EVR0")
epicsEnvSet(   "EVR_BUS"        "0x09")
epicsEnvSet(   "EVR_DEV"        "0x00")
epicsEnvSet(  "EVR_FUNC"         "0x0")
epicsEnvSet("EVR_DOMAIN"      "0x0000")

# ESS ICS Definition
epicsEnvSet("HWEVT"    "14")
epicsEnvSet("EPICSEVT" "14")

# Take Timestamp from device support (timing system)
epicsEnvSet("EVRTSE"   "-2")

mrmEvrSetupPCI($(EVR), $(EVR_DOMAIN), $(EVR_BUS), $(EVR_DEV), $(EVR_FUNC))

dbLoadRecords("evr-pmc-230.db", "DEVICE=$(EVR), SYS=$(SYS), Link-Clk-SP=88.0525, Pul0-Width-SP=10000, RearUniv0-Src-SP=0")

# Connection Map among EPICS PV, FPGA, and AMC Backplan
# 
# EPICS PV,  FPGA,    AMC Backplane
# RealUniv0, PMCIO11, RX_17
# RealUniv1, PMCI012, TX_17
# RealUniv2, PMCI013, RX_18
# RealUniv3, PMCI014, TX_18
# RealUniv4, PMCI015, RX_19
# RealUniv5, PMCI016, TX_19
# RealUniv6, PMCI017, RX_20
# RealUniv7, PMCI018, TX_20

#Generate trigger signals
# Time Stamping on EVR
dbLoadRecords("evr-softEvent.template", "DEVICE=$(EVR), SYS=$(SYS), CODE=$(EPICSEVT), EVT=$(HWEVT)")

# Trigger Output on EVR
dbLoadRecords("evr-pulserMap.template", "DEVICE=$(EVR), SYS=$(SYS), PID=0, F=Trig, ID=0, EVT=$(HWEVT)")


iocInit






