# # This file should be used with EPICS base 3.15.4 and mrfioc2 2.7.13
# # With current EEE 1.8.2, the proper command is 
# # $ iocsh pcie-evr-300dc_0.cmd
# # or
# # $ iocsh -3.15.4 pcie-evr-300dc_0.cmd

require mrfioc2,2.7.13

epicsEnvSet("SYS"             "ICS-PCIE-300");
epicsEnvSet("EVR"             "EVR0");
epicsEnvSet("EVR_PCIDOMAIN"    "0x0");
epicsEnvSet("EVR_PCIBUS"      "0x01");
epicsEnvSet("EVR_PCIDEVICE"   "0x00");
epicsEnvSet("EVR_PCIFUNCTION" "0x0");
mrmEvrSetupPCI($(EVR), $(EVR_PCIDOMAIN),$(EVR_PCIBUS), $(EVR_PCIDEVICE), $(EVR_PCIFUNCTION));

dbLoadTemplate("./evr-pcie-300DC-han.substitutions", "DEVICE=$(EVR), SYS=$(SYS)");
