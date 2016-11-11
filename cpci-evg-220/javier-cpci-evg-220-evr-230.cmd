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

#For the sequence
dbLoadRecords("evgSoftSeq.template", "DEVICE=$(EVG), SYS=$(SYS), SEQNUM=1, NELM=3")


epicsEnvSet("EVR"        "EVR230")
epicsEnvSet("EVR_BUS"   "0x16")
epicsEnvSet("EVR_DEV"   "0x09")
epicsEnvSet("EVR_FUNC"  "0x0")
epicsEnvSet("EVR_DOMAIN"   "0x0000")
mrmEvrSetupPCI($(EVR), $(EVR_DOMAIN), $(EVR_BUS), $(EVR_DEV), $(EVR_FUNC))


# --------------------------------------------------------
# dbLoadRecords example
dbLoadRecords("evr-cpci-230.db", "DEVICE=$(EVR), SYS=$(SYS)")

#Generate trigger signals
dbLoadRecords("evr-softEvent.template", "DEVICE=$(EVR), SYS=$(SYS), CODE=14, EVT=14")
dbLoadRecords("evr-softEvent.template", "DEVICE=$(EVR), SYS=$(SYS), CODE=1, EVT=1")
dbLoadRecords("evr-softEvent.template", "DEVICE=$(EVR), SYS=$(SYS), CODE=2, EVT=2")
dbLoadRecords("evr-softEvent.template", "DEVICE=$(EVR), SYS=$(SYS), CODE=3, EVT=3")
dbLoadRecords("evr-pulserMap.template", "DEVICE=$(EVR), SYS=$(SYS), PID=0, F=Trig, ID=0, EVT=14")



iocInit

#

#ICS-CPCIEVG-230-EVG0:TrigEvt0-EvtCode-SP
#ICS-CPCIEVG-230-EVG0:Mxc0-TrigSrc0-SP
#ICS-CPCIEVG-230-EVG0:Mxc0-Frequency-SP
#ICS-CPCIEVG-230-EVG0:SoftEvt-Enable-Sel

#Set heart beat event
dbpf $(SYS)-$(EVG):TrigEvt7-EvtCode-SP 122
dbpf $(SYS)-$(EVG):Mxc2-Frequency-SP 1
dbpf $(SYS)-$(EVG):Mxc2-TrigSrc7-SP 1

#dbpf $(SYS)-$(EVG):TrigEvt0-EvtCode-SP 14
#dbpf $(SYS)-$(EVG):Mxc0-Frequency-SP 14
#dbpf $(SYS)-$(EVG):Mxc0-TrigSrc0-SP 1


#dbpf $(SYS)-$(EVG):SoftEvt-Enable-Sel 1


mrmEvgSoftTime("$(EVG)")
sleep(5)
dbpf $(SYS)-$(EVG):SyncTimestamp-Cmd 1



#dbl > cpci-evg-220/cpci-evg-220-evr-230.pvlist


# what does the following messages :

# ----Timestamping Error of -0.999860 Secs----
# TS reset w/ old or invalid seconds 581a18fb (581a18d1 00000000)
# dbpf ICS-CPCI-EVG220:SyncTimestamp-Cmd 1
# DBR_STRING:
# epicsEnvSet IOCSH_PS1,"bodhi2> "
# bodhi2> TS reset w/ old or invalid seconds 581a18fc (581a18fc 581a18fb)

# bodhi2> TS becomes valid after fault 581a1901

