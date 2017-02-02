#  -*- mode: epics -*-
# iocsh test_evg-vme-230.cmd


require pev,0.1.2
require mrfioc2,2.7.13


epicsEnvSet("SYS"         "test")
epicsEnvSet("EVG"         "EVG0")
epicsEnvSet("EVG_VMESLOT"    "5")

mrmEvgSetupVME($(EVG), $(EVG_VMESLOT), 0x100000, 1, 0x01)

# Fake timestamp source for testing without real hardware timestamp source (e.g., GPS recevier)
mrmEvgSoftTime($(EVG))

# ESS ICS Definition
epicsEnvSet("HWEVT"    "14")
epicsEnvSet("EVTFREQ"  "14")

# Don't change HBEVT 
epicsEnvSet("HBEVT"   "122")
# One can change, but don't change it.
epicsEnvSet("HBFREQ"    "1")

# --------------------------------------------------------
# Set Heart Beat Event (Evtcode, Fre, TrigSrc7) (122, 1, 1)
# Set 14 Hz      Event (Evtcode, Fre, TrigSrc0) (14, 14, 1)
# 
dbLoadRecords("evg-vme-230.db", "DEVICE=$(EVG), SYS=$(SYS), EvtClk-FracSynFreq-SP=88.0525, TrigEvt7-EvtCode-SP=$(HBEVT), Mxc2-Frequency-SP=$(HBFREQ), Mxc2-TrigSrc7-SP=1, TrigEvt0-EvtCode-SP=$(HWEVT), Mxc0-Frequency-SP=$(EVTFREQ), Mxc0-TrigSrc0-SP=1, SoftEvt-Enable-Sel=1")

# Load the sequencer db
dbLoadRecords("evgSoftSeq.template", "DEVICE=$(EVG), SYS=$(SYS), SEQNUM=1, NELM=3")


iocInit

sleep(5)

# Mandatory if Fake timestamp source for testing without real hardware timestamp source (e.g., GPS recevier)
dbpf $(SYS)-$(EVG):SyncTimestamp-Cmd 1

