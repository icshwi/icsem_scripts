require mrfioc2,2.7.13

epicsEnvSet("SYS"               "EVR")
epicsEnvSet("DEVICE"            "MTCA")
epicsEnvSet("EVR_PCIDOMAIN"     "0x0")
epicsEnvSet("EVR_PCIBUS"        "0xa")
epicsEnvSet("EVR_PCIDEVICE"     "0x0")
epicsEnvSet("EVR_PCIFUNCTION"   "0x0")

mrmEvrSetupPCI($(DEVICE), $(EVR_PCIDOMAIN), $(EVR_PCIBUS), $(EVR_PCIDEVICE), $(EVR_PCIFUNCTION))
dbLoadRecords("evr-pmc-230.db", "DEVICE=$(DEVICE), SYS=$(SYS), Link-Clk-SP=88.0525")

# PULSE_START_EVENT = 2
dbLoadRecords("evr-softEvent.template", "DEVICE=$(DEVICE), SYS=$(SYS), EVT=2, CODE=14")
# MLVDS 1 (RearUniv1)
dbLoadRecords("evr-pulserMap.template", "DEVICE=$(DEVICE), SYS=$(SYS), PID=1, F=Trig, ID=0, EVT=2")

# PULSE_STOP_EVENT = 3
dbLoadRecords("evr-softEvent.template", "DEVICE=$(DEVICE), SYS=$(SYS), EVT=3, CODE=14")
# MLVDS 2 (RearUniv2)
dbLoadRecords("evr-pulserMap.template", "DEVICE=$(DEVICE), SYS=$(SYS), PID=2, F=Trig, ID=0, EVT=3")


iocInit()


# Disable Rear Universal Output 1
dbpf $(SYS)-$(DEVICE):RearUniv1-Ena-SP "Disabled"
# Map Rear Universal Output 1 to pulser 1
dbpf $(SYS)-$(DEVICE):RearUniv1-Src-SP 1
# Map pulser 1 to event 14
dbpf $(SYS)-$(DEVICE):Pul1-Evt-Trig0-SP 14
# Set pulser 1 width to 100 us
dbpf $(SYS)-$(DEVICE):Pul1-Width-SP 100
# Set the delay time of the pulser 1 to 0.3 ms
#dbpf $(SYS)-$(DEVICE):Pul1-Delay-SP 300
# event 2 received the SIS8300 will start the data acquisition
dbpf $(SYS)-$(DEVICE):RearUniv1-Ena-SP "Enabled"

# Disable Rear Universal Output 2
dbpf $(SYS)-$(DEVICE):RearUniv2-Ena-SP "Disabled"
# Map Rear Universal Output 2 to pulser 2
dbpf $(SYS)-$(DEVICE):RearUniv2-Src-SP 2
# Map pulser 2 to event 14
dbpf $(SYS)-$(DEVICE):Pul2-Evt-Trig0-SP 14
# Set pulser 2 width to 100 us
dbpf $(SYS)-$(DEVICE):Pul2-Width-SP 100
# Set the delay time of the pulser 2 to pulse width of 2.86 ms
dbpf $(SYS)-$(DEVICE):Pul2-Delay-SP 2860
# event 3 received the SIS8300 will stop the data acquisition
dbpf $(SYS)-$(DEVICE):RearUniv2-Ena-SP "Enabled"
