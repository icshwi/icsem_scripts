# This file should be used with EPICS base 3.15.4 and mrfioc2 2.7.13
# With current EEE 1.8.2, the proper command is 
# $ iocsh -3.14.12.5 cpci-evg-220_14Hz.cmd
# iocsh -3.14.12.5 cpci-evg-220/cpci-evg-220_14Hz.cmd 

require mrfioc2,iocuser


epicsEnvSet("SYS"       "ICS-CPCI")
epicsEnvSet("EVG"       "EVG220")
epicsEnvSet("EVG_BUS"   "0x16")
epicsEnvSet("EVG_DEV"   "0x0e")
epicsEnvSet("EVG_FUNC"  "0x0")
mrmEvgSetupPCI($(EVG), $(EVG_BUS), $(EVG_DEV), $(EVG_FUNC))
# --------------------------------------------------------
# dbLoadRecords example
dbLoadRecords("evg-cpci.db", "DEVICE=$(EVG), SYS=$(SYS)")


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


mrmEvgSoftTime("$(EVG)")
sleep(5)
dbpf $(SYS)-$(EVG):SyncTimestamp-Cmd 1



dbl > cpci-evg-220/cpci-evg-220.pvlist