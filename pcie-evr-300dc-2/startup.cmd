# 2.7.13 + 3.15.4 does NOT work
# 2.7.13 + 3.14.12.5 does work
# 2.1.0  + 3.15.4 does not work
# 2.1.0  + 3.14.12.5 does work
# 
#require mrfioc2,2.1.0
require mrfioc2,2.7.13

epicsEnvSet("SYS"             "testDC")
epicsEnvSet("EVR"             "EVR0")
epicsEnvSet("EVR_PCIDOMAIN"   "0x0")
epicsEnvSet("EVR_PCIBUS"      "0x1")
epicsEnvSet("EVR_PCIDEVICE"   "0x0")
epicsEnvSet("EVR_PCIFUNCTION" "0x0")

# 3.15.4 with 2.7.13 

# don't change, 2.7.13 is mandatory
#

mrmEvrSetupPCI($(EVR), $(EVR_PCIDOMAIN), $(EVR_PCIBUS), $(EVR_PCIDEVICE), $(EVR_PCIFUNCTION))

dbLoadRecords("evr-pcie-300.db", "DEVICE=$(EVR), SYS=$(SYS), Link-Clk-SP=88.0525")


# what is this template doing here? what purpose? which system actually need this?

# dbLoadRecords("evr-softEvent.template", "DEVICE=$(EVR), SYS=$(SYS), EVT=14, CODE=14")
# what is this template doing here? what purpose? which system actually need this?
#dbLoadRecords("evr-pulserMap.template", "DEVICE=$(EVR), SYS=$(SYS), PID=0, F=Trig, ID=0, EVT=14")
#dbLoadRecords("evr-pulserMap.template", "DEVICE=$(EVR), SYS=$(SYS), PID=1, F=Trig, ID=0, EVT=14")

iocInit
#dbpf $(SYS)-$(EVR):FrontUnivOut2-Src-SP 0
#dbpf $(SYS)-$(EVR):Pul0-Evt-Trig0-SP 14
#dbpf $(SYS)-$(EVR):Pul0-Width-SP 10000

