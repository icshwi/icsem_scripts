# This file should be used with EPICS base 3.15.4 and mrfioc2 2.7.13
# With current EEE 1.8.2, the proper command is 
# $ iocsh cpci-evg-230_0.cmd
# or
# $ iocsh -3.15.4 cpci-evg-230_0.cmd

require mrfioc2,2.7.13

epicsEnvSet("SYS"             "ICS-CPCIEVG-230")
epicsEnvSet("EVG"             "EVG0")
epicsEnvSet("EVG_PCIBUS"      "0x16")
epicsEnvSet("EVG_PCIDEVICE"   "0x09")
epicsEnvSet("EVG_PCIFUNCTION" "0x0")
mrmEvgSetupPCI($(EVG), $(EVG_PCIBUS), $(EVG_PCIDEVICE), $(EVG_PCIFUNCTION))

dbLoadRecords("evg-cpci.db", "DEVICE=$(EVG), SYS=$(SYS)")

dbLoadRecords("evgSoftSeq.template",  "DEVICE=$(EVG), SYS=$(SYS), SEQNUM=1, NELM=3")
