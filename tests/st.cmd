#!./bin/linux-x86_64-debug/mrf

# This file must be in the community mrfioc2 top directory to work.

dbLoadDatabase("dbd/mrf.dbd")
mrf_registerRecordDeviceDriver(pdbbase)

mrmEvrSetupPCI("EVR","16:09.0")

dbLoadRecords("db/evr-cpci-230.db","SYS=TST, D=evr:4, EVR=EVR, FEVT=88.0525")

# 230
mrmEvgSetupPCI("EVG1", "16:0c.0")
# 220
# mrmEvgSetupPCI("EVG2", "16:0e.0")

dbLoadRecords("db/vme-evg230.db", "SYS=TST, D=evg:1, EVG=EVG1, FRF=352.21, FDIV=4, FEVT=88.0525")
# dbLoadRecords("db/vme-evg230.db", "SYS=TST, D=evg:2, EVG=EVG2")

# needed with software timestamp source w/o RT thread scheduling
var evrMrmTimeNSOverflowThreshold 100000

iocInit()

dbpf "TST{evg:1}1ppsInp-Sel" "Sys Clk"
dbpf TST{evg:1-TrigEvt:0}EvtCode-SP 14
dbpf TST{evg:1-TrigEvt:0}TrigSrc-Sel "Mxc0"
dbpf TST{evg:1-Mxc:0}Prescaler-SP 6289464


dbpf TST{evg:1-Mxc:7}Prescaler-SP 88052496
dbpf TST{evg:1-TrigEvt:7}EvtCode-SP 122
dbpf TST{evg:1-TrigEvt:7}TrigSrc-Sel "Mxc7"
dbpf TST{evr:4-DlyGen:0}Width-SP 10000
dbpf TST{evr:4-DlyGen:0}Evt:Trig0-SP 14
dbpf TST{evr:4-Out:FPUV0}Src:Pulse-SP "Pulser 0"
