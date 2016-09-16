# This file should be used with EPICS base 3.14.12.5 and mrfioc2 2.1.0
# With current EEE 1.8.2, the proper command is 
# $ iocsh -3.14.12.5 cpci-evg-230_0.cmd

require mrfioc2,2.1.0

epicsEnvSet("SYS"             "ICS-CPCIEVG-230")
epicsEnvSet("EVG"             "EVG0")
epicsEnvSet("EVG_PCIBUS"      "0x16")
epicsEnvSet("EVG_PCIDEVICE"   "0x09")
epicsEnvSet("EVG_PCIFUNCTION" "0x0")
mrmEvgSetupPCI($(EVG), $(EVG_PCIBUS), $(EVG_PCIDEVICE), $(EVG_PCIFUNCTION))

dbLoadRecords("evg-cpci.db", "EVG=$(EVG), SYS=$(SYS)")


iocInit

#

# ICS-CPCIEVG-230-EVG0:TrigEvt0-EvtCode-SP
# ICS-CPCIEVG-230-EVG0:Mxc0-TrigSrc0-SP
# ICS-CPCIEVG-230-EVG0:Mxc0-Frequency-SP
# ICS-CPCIEVG-230-EVG0:SoftEvt-Enable-Sel

dbpf $(SYS)-$(EVG):TrigEvt0-EvtCode-SP 14
dbpf $(SYS)-$(EVG):Mxc0-Frequency-SP 14
dbpf $(SYS)-$(EVG):Mxc0-TrigSrc0-SP 1

dbpf $(SYS)-$(EVG):SoftEvt-Enable-Sel 1