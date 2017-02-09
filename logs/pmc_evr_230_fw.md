# Log to reflash the MRF PMC EVR 230 FW and EEPROM




```
iocuser@localhost: icsem_scripts (master)$ bash mrf_setup.bash show

We've found the MRF boards as follows:
--------------------------------------
09:00.0 "Signal processing controller [1180]" "PLX Technology, Inc. [10b5]" "PCI9030 32-bit 33MHz PCI <-> IOBus Bridge [9030]" -r01 "Micro-Research Finland Oy [1a3e]" "CPCI Event Receiver 230 [10e6]"

iocuser@localhost: icsem_scripts (master)$ 

iocuser@localhost: icsem_scripts (master)$ iocsh pmc-evr-230/test_evr-pmc-230.cmd
/opt/epics/bases/base-3.15.4/bin/centos7-x86_64/softIoc -D /opt/epics/bases/base-3.15.4/dbd/softIoc.dbd /tmp/iocsh.startup.2684
#date="Wed Feb  8 17:45:10 CET 2017"
#user="iocuser"
#PWD="/home/iocuser/ics_gitsrc/icsem_scripts"
#EPICSVERSION="3.15.4"
#EPICS_HOST_ARCH="centos7-x86_64"
#SHELLBOX=""
#EPICS_CA_ADDR_LIST=""
#EPICS_MODULE_INCLUDE_PATH=".:/usr/lib64:/usr/lib:/lib64:/lib"
dlload         /opt/epics/modules/environment/1.8.2/3.15.4/lib/centos7-x86_64/libenvironment.so
dbLoadDatabase /opt/epics/modules/environment/1.8.2/3.15.4/dbd/environment.dbd
environment_registerRecordDeviceDriver
< "pmc-evr-230/test_evr-pmc-230.cmd"
#  -*- mode: epics -*-
# $ iocsh test_evr-pmc-300.cmd
require mrfioc2,2.7.13
require: mrfioc2 depends on devlib2 (2.7+).
require: Loading library /opt/epics/modules/devlib2/2.7.0/3.15.4/lib/centos7-x86_64/libdevlib2.so.
require: Loading /opt/epics/modules/devlib2/2.7.0/3.15.4/dbd/devlib2.dbd.
require: Calling devlib2_registerRecordDeviceDriver function.
require: Loading library /opt/epics/modules/mrfioc2/2.7.13/3.15.4/lib/centos7-x86_64/libmrfioc2.so.
require: Adding /opt/epics/modules/mrfioc2/2.7.13/db.
require: Adding /opt/epics/modules/mrfioc2/2.7.13/startup.
require: Loading /opt/epics/modules/mrfioc2/2.7.13/3.15.4/dbd/mrfioc2.dbd.
require: Calling mrfioc2_registerRecordDeviceDriver function.
epicsEnvSet(       "SYS"        "PMC")
epicsEnvSet(       "EVR"        "EVR0")
epicsEnvSet(   "EVR_BUS"        "0x09")
epicsEnvSet(   "EVR_DEV"        "0x00")
epicsEnvSet(  "EVR_FUNC"         "0x0")
epicsEnvSet("EVR_DOMAIN"      "0x0000")
mrmEvrSetupPCI(EVR0, 0x0000, 0x09, 0x00, 0x0)
Device EVR0 9:0.0
Using IRQ 16
FPGA version 0x00000000
Found type 0 which does not correspond to EVR type 0x1.
Firmware version: 00000000
dbLoadRecords("evr-cpci-230.db", "DEVICE=EVR0, SYS=PMC, Link-Clk-SP=88.0525")
iocInit
Starting iocInit
############################################################################
## EPICS R3.15.4-2016-05 $$Date$$
## EPICS Base built May 31 2016
############################################################################




[root@localhost pmc-evr]# cd mrf_pci_driver/
[root@localhost mrf_pci_driver]# make
make -C /lib/modules/3.10.0-229.7.2.el7.x86_64/build M=/home/iocuser/ics_gitsrc/mrf/pmc-evr/mrf_pci_driver modules
make[1]: Entering directory `/usr/src/kernels/3.10.0-229.7.2.el7.x86_64'
  Building modules, stage 2.
  MODPOST 2 modules
make[1]: Leaving directory `/usr/src/kernels/3.10.0-229.7.2.el7.x86_64'
[root@localhost mrf_pci_driver]# make modules_install
make -C /lib/modules/3.10.0-229.7.2.el7.x86_64/build M=/home/iocuser/ics_gitsrc/mrf/pmc-evr/mrf_pci_driver modules_install
make[1]: Entering directory `/usr/src/kernels/3.10.0-229.7.2.el7.x86_64'
  INSTALL /home/iocuser/ics_gitsrc/mrf/pmc-evr/mrf_pci_driver/pci_mrfevg.ko
Can't read private key
  INSTALL /home/iocuser/ics_gitsrc/mrf/pmc-evr/mrf_pci_driver/pci_mrfevr.ko
Can't read private key
  DEPMOD  3.10.0-229.7.2.el7.x86_64
make[1]: Leaving directory `/usr/src/kernels/3.10.0-229.7.2.el7.x86_64'
[root@localhost mrf_pci_driver]# depmod -a
[root@localhost mrf_pci_driver]# sh module_load 
Found 0 Event Generators.
Creating device nodes...
Found 1 Event Receivers.
Creating device nodes...
Creating nodes /dev/era[0-3] for major 247chgrp: invalid group: ‘mrf’
[root@localhost mrf_pci_driver]# emacs module_load 
^Z
[1]+  Stopped                 emacs module_load
[root@localhost mrf_pci_driver]# ls /dev/era*
/dev/era0  /dev/era1  /dev/era2  /dev/era3
[root@localhost mrf_pci_driver]# cat /dev/era0
PCI9030 EEPROM Contents
S/N: E322039     

0x9030 Device ID
0x10b5 Vendor ID
0x0290 PCI Status
0x0000 PCI Command
0x1180 Class Code
0x0001 Class Code / Revision
0x10e6 Subsystem ID
0x1a3e Subsystem Vendor ID
0x0000 MSB New Capability Pointer
0x0040 LSB New Capability Pointer
0x0000 (Maximum Latency and Minimum Grant are not loadable)
0x0100 Interrupt Pin (Interrupt Line Routing is not loadable)
0x4801 MSW of Power Management Capabilities
0x4801 LSW of Power Management Next Capability Pointer
0x0000 MSW of Power Management Data / PMCSR Brdge Support Extension
0x0000 LSW of Power Management Control / Status
0x0000 MSW of Hot Swap Control / Status
0x4c06 LSW of Hot Swap Next Capability Pointer / Hot Swap Control
0x0000 PCI Vital Product Data Address
0x0003 PCI Vital Product Data Next Capability Pointer
0x0fff MSW of Local Address Space 0 Range
0x0000 LSW of Local Address Space 0 Range
0x0000 MSW of Local Address Space 1 Range
0x0000 LSW of Local Address Space 1 Range
0x0000 MSW of Local Address Space 2 Range
0x0000 LSW of Local Address Space 2 Range
0x0000 MSW of Local Address Space 3 Range
0x0000 LSW of Local Address Space 3 Range
0x0000 MSW of Expansion ROM Range
0x0000 LSW of Expansion ROM Range
0x0000 MSW of Local Address Space 0 Local Base Address (Remap)
0x0001 LSW of Local Address Space 0 Local Base Address (Remap)
0x0000 MSW of Local Address Space 1 Local Base Address (Remap)
0x0000 LSW of Local Address Space 1 Local Base Address (Remap)
0x0000 MSW of Local Address Space 2 Local Base Address (Remap)
0x0000 LSW of Local Address Space 2 Local Base Address (Remap)
0x0000 MSW of Local Address Space 3 Local Base Address (Remap)
0x0000 LSW of Local Address Space 3 Local Base Address (Remap)
0x0010 MSW of Expansion ROM Local Base Address (Remap)
0x0000 LSW of Expansion ROM Local Base Address (Remap)
0x0080 MSW of Local Address Space 0 Bus Region Descriptor
0x0002 LSW of Local Address Space 0 Bus Region Descriptor
0x0080 MSW of Local Address Space 1 Bus Region Descriptor
0x0000 LSW of Local Address Space 1 Bus Region Descriptor
0x0080 MSW of Local Address Space 2 Bus Region Descriptor
0x0000 LSW of Local Address Space 2 Bus Region Descriptor
0x0080 MSW of Local Address Space 3 Bus Region Descriptor
0x0000 LSW of Local Address Space 3 Bus Region Descriptor
0x0080 MSW of Expansion ROM Bus Region Descriptor
0x0000 LSW of Expansion ROM Bus Region Descriptor
0x0000 MSW of Chip Select 0 Base Address
0x1001 LSW of Chip Select 0 Base Address
0x0000 MSW of Chip Select 1 Base Address
0x0000 LSW of Chip Select 1 Base Address
0x0000 MSW of Chip Select 2 Base Address
0x0000 LSW of Chip Select 2 Base Address
0x0000 MSW of Chip Select 3 Base Address
0x0000 LSW of Chip Select 3 Base Address
0x0030 Serial EEPROM Write-Protected Address Boundary
0x0012 LSW of Interrupt Control/Status
0x0078 MSW of PCI Target Response, Serial EEPROM, and Initialization Control
0x1100 LSW of PCI Target Response, Serial EEPROM, and Initialization Control
0x0024 MSW of General Purpose I/O Control
0x9900 LSW of General Purpose I/O Control
0x0000 MSW of Hidden 1 Power Management Data Select
0x0000 LSW of Hidden 1 Power Management Data Select
0x0000 MSW of Hidden 2 Power Management Data Select
0x0000 LSW of Hidden 2 Power Management Data Select
0x4533 S/N 0
0x3232 S/N 2
0x3033 S/N 4
0x3900 S/N 6
0xffff S/N 8
0xffff S/N A
[root@localhost mrf_pci_driver]# ls

Complete!
[root@localhost pmc-evr]# ls
mrf_pci_driver  mrf_pci_driver.160324.tar.gz  PMC-EVR-230-11000007.bit
[root@localhost pmc-evr]# dd if=PMC-EVR-230-11000007.bit of=/dev/era1 
767+1 records in
767+1 records out
392870 bytes (393 kB) copied, 24.1927 s, 16.2 kB/s
[root@localhost pmc-evr]# 
Message from syslogd@localhost at Feb  8 18:09:58 ...
 kernel:Disabling IRQ #16

[root@localhost pmc-evr]# sh module_unload
sh: module_unload: No such file or directory
[root@localhost pmc-evr]# ls
mrf_pci_driver  mrf_pci_driver.160324.tar.gz  PMC-EVR-230-11000007.bit
[root@localhost pmc-evr]# cd mrf_pci_driver/
[root@localhost mrf_pci_driver]# sh module_unload
Unloading modules
Removing device nodes
[root@localhost mrf_pci_driver]# reboot



iocuser@localhost: icsem_scripts (master)$ bash mrf_setup.bash show

We've found the MRF boards as follows:
--------------------------------------
09:00.0 "Signal processing controller [1180]" "PLX Technology, Inc. [10b5]" "PCI9030 32-bit 33MHz PCI <-> IOBus Bridge [9030]" -r01 "Micro-Research Finland Oy [1a3e]" "CPCI Event Receiver 230 [10e6]"

iocuser@localhost: icsem_scripts (master)$ ls
bash_functions  cpci-evg-230     LICENSE  m-epics-mrfioc2                       mrf_env.conf          mrf_setup.bash  pcie-evr-300dc  README.md  tests
cpci-evg-220    git_commands.md  logs     m-epics-mrfioc2_2017Feb06-1639-21CET  mrf_epicsEnvSet.bash  mtca-evr-300    pmc-evr-230     scripts    vme-evg-230
iocuser@localhost: icsem_scripts (master)$ bash mrf_epicsEnvSet.bash 


>>>>>>>>>>>>>>>>>>> snip snip >>>>>>>>>>>>>>>>>>>

# ESS EPICS Environment

#
# iocsh -3.14.12.5 "e3_startup_script".cmd
# require mrfioc2,edit_me

epicsEnvSet(       "SYS"     "edit_me")
epicsEnvSet(       "EVR"     "edit_me")
epicsEnvSet(   "EVR_BUS"        "0x09")
epicsEnvSet(   "EVR_DEV"        "0x00")
epicsEnvSet(  "EVR_FUNC"         "0x0")
epicsEnvSet("EVR_DOMAIN"      "0x0000")

mrmEvrSetupPCI($(EVR), $(EVR_DOMAIN), $(EVR_BUS), $(EVR_DEV), $(EVR_FUNC))

# dbLoadRecords example
# dbLoadRecords("edit_me", "DEVICE=$(EVR), SYS=$(SYS)")

<<<<<<<<<<<<<<<<<<< snip snip <<<<<<<<<<<<<<<<<<<

iocuser@localhost: icsem_scripts (master)$ iocsh pmc-evr-230/test_evr-pmc-230.cmd
/opt/epics/bases/base-3.15.4/bin/centos7-x86_64/softIoc -D /opt/epics/bases/base-3.15.4/dbd/softIoc.dbd /tmp/iocsh.startup.2345
#date="Wed Feb  8 18:14:41 CET 2017"
#user="iocuser"
#PWD="/home/iocuser/ics_gitsrc/icsem_scripts"
#EPICSVERSION="3.15.4"
#EPICS_HOST_ARCH="centos7-x86_64"
#SHELLBOX=""
#EPICS_CA_ADDR_LIST=""
#EPICS_MODULE_INCLUDE_PATH=".:/usr/lib64:/usr/lib:/lib64:/lib"
dlload         /opt/epics/modules/environment/1.8.2/3.15.4/lib/centos7-x86_64/libenvironment.so
dbLoadDatabase /opt/epics/modules/environment/1.8.2/3.15.4/dbd/environment.dbd
environment_registerRecordDeviceDriver
< "pmc-evr-230/test_evr-pmc-230.cmd"
#  -*- mode: epics -*-
# $ iocsh test_evr-pmc-300.cmd
require mrfioc2,2.7.13
require: mrfioc2 depends on devlib2 (2.7+).
require: Loading library /opt/epics/modules/devlib2/2.7.0/3.15.4/lib/centos7-x86_64/libdevlib2.so.
require: Loading /opt/epics/modules/devlib2/2.7.0/3.15.4/dbd/devlib2.dbd.
require: Calling devlib2_registerRecordDeviceDriver function.
require: Loading library /opt/epics/modules/mrfioc2/2.7.13/3.15.4/lib/centos7-x86_64/libmrfioc2.so.
require: Adding /opt/epics/modules/mrfioc2/2.7.13/db.
require: Adding /opt/epics/modules/mrfioc2/2.7.13/startup.
require: Loading /opt/epics/modules/mrfioc2/2.7.13/3.15.4/dbd/mrfioc2.dbd.
require: Calling mrfioc2_registerRecordDeviceDriver function.
epicsEnvSet(       "SYS"        "PMC")
epicsEnvSet(       "EVR"        "EVR0")
epicsEnvSet(   "EVR_BUS"        "0x09")
epicsEnvSet(   "EVR_DEV"        "0x00")
epicsEnvSet(  "EVR_FUNC"         "0x0")
epicsEnvSet("EVR_DOMAIN"      "0x0000")
mrmEvrSetupPCI(EVR0, 0x0000, 0x09, 0x00, 0x0)
Device EVR0 9:0.0
Using IRQ 16
FPGA version 0x11000007
Firmware version: 00000007
Could not read SFP transceiver type. EVR0:SFP0 readouts INVALID!
	First 4 bytes of SFP EEPROM: ff ff ff ff
Flash access: Timeout reached while waiting for transmitter to be empty!
PMC: Out FP:3 FPUNIV:0 RB:16 IFP:1 GPIO:0
dbLoadRecords("evr-cpci-230.db", "DEVICE=EVR0, SYS=PMC, Link-Clk-SP=88.0525")
iocInit
Starting iocInit
############################################################################
## EPICS R3.15.4-2016-05 $$Date$$
## EPICS Base built May 31 2016
############################################################################
PMC-EVR0:FPIn1-Edge-Sel: failed to find object 'EVR0:FPIn1'
PMC-EVR0:FPIn1-Lvl-Sel: failed to find object 'EVR0:FPIn1'
PMC-EVR0:FrontUnivOut0-Ena-SP: failed to find object 'EVR0:FrontUnivOut0'
PMC-EVR0:FrontUnivOut1-Ena-SP: failed to find object 'EVR0:FrontUnivOut1'
PMC-EVR0:FrontUnivOut2-Ena-SP: failed to find object 'EVR0:FrontUnivOut2'
PMC-EVR0:FrontUnivOut3-Ena-SP: failed to find object 'EVR0:FrontUnivOut3'
PMC-EVR0:FPIn1-DBus-Sel: failed to find object 'EVR0:FPIn1'
PMC-EVR0:FPIn1-Trig-Back-Sel: failed to find object 'EVR0:FPIn1'
PMC-EVR0:FPIn1-Trig-Ext-Sel: failed to find object 'EVR0:FPIn1'
PMC-EVR0:FrontUnivOut0-Src-RB: failed to find object 'EVR0:FrontUnivOut0'
PMC-EVR0:FrontUnivOut0-Src2-RB: failed to find object 'EVR0:FrontUnivOut0'
PMC-EVR0:FrontUnivOut1-Src-RB: failed to find object 'EVR0:FrontUnivOut1'
PMC-EVR0:FrontUnivOut1-Src2-RB: failed to find object 'EVR0:FrontUnivOut1'
PMC-EVR0:FrontUnivOut2-Src-RB: failed to find object 'EVR0:FrontUnivOut2'
PMC-EVR0:FrontUnivOut2-Src2-RB: failed to find object 'EVR0:FrontUnivOut2'
PMC-EVR0:FrontUnivOut3-Src-RB: failed to find object 'EVR0:FrontUnivOut3'
PMC-EVR0:FrontUnivOut3-Src2-RB: failed to find object 'EVR0:FrontUnivOut3'
PMC-EVR0:FPIn1-State-I: failed to find object 'EVR0:FPIn1'
PMC-EVR0:FPIn1-Code-Back-SP: failed to find object 'EVR0:FPIn1'
PMC-EVR0:FPIn1-Code-Ext-SP: failed to find object 'EVR0:FPIn1'
PMC-EVR0:FrontUnivOut0-Src-SP: failed to find object 'EVR0:FrontUnivOut0'
PMC-EVR0:FrontUnivOut0-Src2-SP: failed to find object 'EVR0:FrontUnivOut0'
PMC-EVR0:FrontUnivOut1-Src-SP: failed to find object 'EVR0:FrontUnivOut1'
PMC-EVR0:FrontUnivOut1-Src2-SP: failed to find object 'EVR0:FrontUnivOut1'
PMC-EVR0:FrontUnivOut2-Src-SP: failed to find object 'EVR0:FrontUnivOut2'
PMC-EVR0:FrontUnivOut2-Src2-SP: failed to find object 'EVR0:FrontUnivOut2'
PMC-EVR0:FrontUnivOut3-Src-SP: failed to find object 'EVR0:FrontUnivOut3'
PMC-EVR0:FrontUnivOut3-Src2-SP: failed to find object 'EVR0:FrontUnivOut3'
PMC-EVR0:Time-Src-Sel_: read error: TS Clock rate invalid
Set EVR clock 88052500.000000
Warning: Duplicate EPICS CA Address list entry "10.4.3.255:5065" discarded
iocRun: All initialization complete
epicsEnvSet IOCSH_PS1,"localhost> "
localhost> 
```



I setup the PMC-EVR-230 used in VME system, put it on the MTCA carrier, and check it through...


```
08:00.0 "Signal processing controller [1180]" "PLX Technology, Inc. [10b5]" "PCI9030 32-bit 33MHz PCI <-> IOBus Bridge [9030]" -r01 "Micro-Research Finland Oy [1a3e]" "PMC  Event Receiver 230 [11e6]"
```

They actually return the proper device ID, identified as PMC Event Receiver 230. Unfornately, I couldn't find any information for the Cosylab firmware in the ESS wiki. 


Maybe EEPROM issue? or not.


Actually, "firmware reflashing PMC EVR 230" returns the following

```
0a:00.0 "Signal processing controller [1180]" "PLX Technology, Inc. [10b5]" "PCI9030 32-bit 33MHz PCI <-> IOBus Bridge [9030]" -r01 "Micro-Research Finland Oy [1a3e]" "CPCI Event Receiver 230 [10e6]"
```

The working MRF pmc-evr-230 with a SFP transceiver returns in EPICS IOC as

```
iocuser@localhost: icsem_scripts (master)$ iocsh pmc-evr-230/test_evr-pmc-230.cmd
/opt/epics/bases/base-3.15.4/bin/centos7-x86_64/softIoc -D /opt/epics/bases/base-3.15.4/dbd/softIoc.dbd /tmp/iocsh.startup.4315
#date="Thu Feb  9 11:35:27 CET 2017"
#user="iocuser"
#PWD="/home/iocuser/ics_gitsrc/icsem_scripts"
#EPICSVERSION="3.15.4"
#EPICS_HOST_ARCH="centos7-x86_64"
#SHELLBOX=""
#EPICS_CA_ADDR_LIST=""
#EPICS_MODULE_INCLUDE_PATH=".:/usr/lib64:/usr/lib:/lib64:/lib"
dlload         /opt/epics/modules/environment/1.8.2/3.15.4/lib/centos7-x86_64/libenvironment.so
dbLoadDatabase /opt/epics/modules/environment/1.8.2/3.15.4/dbd/environment.dbd
environment_registerRecordDeviceDriver
< "pmc-evr-230/test_evr-pmc-230.cmd"
#  -*- mode: epics -*-
# $ iocsh test_evr-pmc-230.cmd
require mrfioc2,2.7.13
require: mrfioc2 depends on devlib2 (2.7+).
require: Loading library /opt/epics/modules/devlib2/2.7.0/3.15.4/lib/centos7-x86_64/libdevlib2.so.
require: Loading /opt/epics/modules/devlib2/2.7.0/3.15.4/dbd/devlib2.dbd.
require: Calling devlib2_registerRecordDeviceDriver function.
require: Loading library /opt/epics/modules/mrfioc2/2.7.13/3.15.4/lib/centos7-x86_64/libmrfioc2.so.
require: Adding /opt/epics/modules/mrfioc2/2.7.13/db.
require: Adding /opt/epics/modules/mrfioc2/2.7.13/startup.
require: Loading /opt/epics/modules/mrfioc2/2.7.13/3.15.4/dbd/mrfioc2.dbd.
require: Calling mrfioc2_registerRecordDeviceDriver function.
epicsEnvSet(       "SYS"        "PMC")
epicsEnvSet(       "EVR"        "EVR0")
epicsEnvSet(   "EVR_BUS"        "0x0a")
epicsEnvSet(   "EVR_DEV"        "0x00")
epicsEnvSet(  "EVR_FUNC"         "0x0")
epicsEnvSet("EVR_DOMAIN"      "0x0000")
mrmEvrSetupPCI(EVR0, 0x0000, 0x0a, 0x00, 0x0)
Device EVR0 a:0.0
Using IRQ 16
FPGA version 0x11000007
Firmware version: 00000007
Found EVR0:SFP0 SFP transceiver
Flash access: Timeout reached while waiting for transmitter to be empty!
PMC: Out FP:3 FPUNIV:0 RB:16 IFP:1 GPIO:0
dbLoadRecords("evr-pmc-230.db", "DEVICE=EVR0, SYS=PMC, Link-Clk-SP=88.0525")
iocInit
Starting iocInit
############################################################################
## EPICS R3.15.4-2016-05 $$Date$$
## EPICS Base built May 31 2016
############################################################################
Set EVR clock 88052500.000000
PMC-EVR0:FrontOut0-Src2-SP: read error: Hardware does not support second output source selection
PMC-EVR0:FrontOut1-Src2-SP: read error: Hardware does not support second output source selection
PMC-EVR0:FrontOut2-Src2-SP: read error: Hardware does not support second output source selection
PMC-EVR0:RearUniv0-Src2-SP: read error: Hardware does not support second output source selection
PMC-EVR0:RearUniv1-Src2-SP: read error: Hardware does not support second output source selection
PMC-EVR0:RearUniv10-Src2-SP: read error: Hardware does not support second output source selection
PMC-EVR0:RearUniv11-Src2-SP: read error: Hardware does not support second output source selection
PMC-EVR0:RearUniv12-Src2-SP: read error: Hardware does not support second output source selection
PMC-EVR0:RearUniv13-Src2-SP: read error: Hardware does not support second output source selection
PMC-EVR0:RearUniv14-Src2-SP: read error: Hardware does not support second output source selection
PMC-EVR0:RearUniv15-Src2-SP: read error: Hardware does not support second output source selection
PMC-EVR0:RearUniv2-Src2-SP: read error: Hardware does not support second output source selection
PMC-EVR0:RearUniv3-Src2-SP: read error: Hardware does not support second output source selection
PMC-EVR0:RearUniv4-Src2-SP: read error: Hardware does not support second output source selection
PMC-EVR0:RearUniv5-Src2-SP: read error: Hardware does not support second output source selection
PMC-EVR0:RearUniv6-Src2-SP: read error: Hardware does not support second output source selection
PMC-EVR0:RearUniv7-Src2-SP: read error: Hardware does not support second output source selection
PMC-EVR0:RearUniv8-Src2-SP: read error: Hardware does not support second output source selection
PMC-EVR0:RearUniv9-Src2-SP: read error: Hardware does not support second output source selection
Warning: Duplicate EPICS CA Address list entry "10.4.3.255:5065" discarded
iocRun: All initialization complete
epicsEnvSet IOCSH_PS1,"localhost> "


```


"Reflashing MRF FW PMC EVR-230 from Cosylab FW" with and without a SFP transceiver 
returns the following through EPICS IOC:

```
iocuser@localhost: icsem_scripts (master)$ iocsh pmc-evr-230/test_evr-pmc-230-fw.cmd
/opt/epics/bases/base-3.15.4/bin/centos7-x86_64/softIoc -D /opt/epics/bases/base-3.15.4/dbd/softIoc.dbd /tmp/iocsh.startup.4495
#date="Thu Feb  9 11:37:05 CET 2017"
#user="iocuser"
#PWD="/home/iocuser/ics_gitsrc/icsem_scripts"
#EPICSVERSION="3.15.4"
#EPICS_HOST_ARCH="centos7-x86_64"
#SHELLBOX=""
#EPICS_CA_ADDR_LIST=""
#EPICS_MODULE_INCLUDE_PATH=".:/usr/lib64:/usr/lib:/lib64:/lib"
dlload         /opt/epics/modules/environment/1.8.2/3.15.4/lib/centos7-x86_64/libenvironment.so
dbLoadDatabase /opt/epics/modules/environment/1.8.2/3.15.4/dbd/environment.dbd
environment_registerRecordDeviceDriver
< "pmc-evr-230/test_evr-pmc-230-fw.cmd"
#  -*- mode: epics -*-
# $ iocsh test_evr-pmc-230.cmd
require mrfioc2,2.7.13
require: mrfioc2 depends on devlib2 (2.7+).
require: Loading library /opt/epics/modules/devlib2/2.7.0/3.15.4/lib/centos7-x86_64/libdevlib2.so.
require: Loading /opt/epics/modules/devlib2/2.7.0/3.15.4/dbd/devlib2.dbd.
require: Calling devlib2_registerRecordDeviceDriver function.
require: Loading library /opt/epics/modules/mrfioc2/2.7.13/3.15.4/lib/centos7-x86_64/libmrfioc2.so.
require: Adding /opt/epics/modules/mrfioc2/2.7.13/db.
require: Adding /opt/epics/modules/mrfioc2/2.7.13/startup.
require: Loading /opt/epics/modules/mrfioc2/2.7.13/3.15.4/dbd/mrfioc2.dbd.
require: Calling mrfioc2_registerRecordDeviceDriver function.
epicsEnvSet(       "SYS"        "PMC")
epicsEnvSet(       "EVR"        "EVR0")
epicsEnvSet(   "EVR_BUS"        "0x08")
epicsEnvSet(   "EVR_DEV"        "0x00")
epicsEnvSet(  "EVR_FUNC"         "0x0")
epicsEnvSet("EVR_DOMAIN"      "0x0000")
mrmEvrSetupPCI(EVR0, 0x0000, 0x08, 0x00, 0x0)
Device EVR0 8:0.0
Using IRQ 19
FPGA version 0x11000007
Firmware version: 00000007
Could not read SFP transceiver type. EVR0:SFP0 readouts INVALID!
	First 4 bytes of SFP EEPROM: ff ff ff ff
Flash access: Timeout reached while waiting for transmitter to be empty!
PMC: Out FP:3 FPUNIV:0 RB:16 IFP:1 GPIO:0
dbLoadRecords("evr-pmc-230.db", "DEVICE=EVR0, SYS=PMC, Link-Clk-SP=88.0525")
iocInit
Starting iocInit
############################################################################
## EPICS R3.15.4-2016-05 $$Date$$
## EPICS Base built May 31 2016
############################################################################
Set EVR clock 88052500.000000
PMC-EVR0:FrontOut0-Src2-SP: read error: Hardware does not support second output source selection
PMC-EVR0:FrontOut1-Src2-SP: read error: Hardware does not support second output source selection
PMC-EVR0:FrontOut2-Src2-SP: read error: Hardware does not support second output source selection
PMC-EVR0:RearUniv0-Src2-SP: read error: Hardware does not support second output source selection
PMC-EVR0:RearUniv1-Src2-SP: read error: Hardware does not support second output source selection
PMC-EVR0:RearUniv10-Src2-SP: read error: Hardware does not support second output source selection
PMC-EVR0:RearUniv11-Src2-SP: read error: Hardware does not support second output source selection
PMC-EVR0:RearUniv12-Src2-SP: read error: Hardware does not support second output source selection
PMC-EVR0:RearUniv13-Src2-SP: read error: Hardware does not support second output source selection
PMC-EVR0:RearUniv14-Src2-SP: read error: Hardware does not support second output source selection
PMC-EVR0:RearUniv15-Src2-SP: read error: Hardware does not support second output source selection
PMC-EVR0:RearUniv2-Src2-SP: read error: Hardware does not support second output source selection
PMC-EVR0:RearUniv3-Src2-SP: read error: Hardware does not support second output source selection
PMC-EVR0:RearUniv4-Src2-SP: read error: Hardware does not support second output source selection
PMC-EVR0:RearUniv5-Src2-SP: read error: Hardware does not support second output source selection
PMC-EVR0:RearUniv6-Src2-SP: read error: Hardware does not support second output source selection
PMC-EVR0:RearUniv7-Src2-SP: read error: Hardware does not support second output source selection
PMC-EVR0:RearUniv8-Src2-SP: read error: Hardware does not support second output source selection
PMC-EVR0:RearUniv9-Src2-SP: read error: Hardware does not support second output source selection
Warning: Duplicate EPICS CA Address list entry "10.4.3.255:5065" discarded
iocRun: All initialization complete
epicsEnvSet IOCSH_PS1,"localhost> "
localhost> isrThread 'PCIISR0000:08:00.0' missed 1 events
isrThread 'PCIISR0000:08:00.0' missed 2 events
isrThread 'PCIISR0000:08:00.0' missed 2 events



```

Two PMCs have the same firmware version, so I have to compare EEPROM as well.

## Next Step.......

1) unload mrfioc2 kernel
2) load mrf kernel
3) check their EEPROMs

```
[root@localhost mrf_pci_driver]# cat /dev/era0 > fwcosylab_pmcevr230_eeprom
[root@localhost mrf_pci_driver]# cat /dev/erb0 > fwmrf_pmcevr230_eeprom
[root@localhost mrf_pci_driver]# diff fwcosylab_pmcevr230_eeprom fwmrf_pmcevr230_eeprom 
2c2
< S/N: E322039     
---
> S/N: K083055     
10c10
< 0x10e6 Subsystem ID
---
> 0x11e6 Subsystem ID
44c44
< 0x0080 MSW of Local Address Space 0 Bus Region Descriptor
---
> 0x0180 MSW of Local Address Space 0 Bus Region Descriptor
63c63
< 0x0012 LSW of Interrupt Control/Status
---
> 0x0000 LSW of Interrupt Control/Status
72,75c72,75
< 0x4533 S/N 0
< 0x3232 S/N 2
< 0x3033 S/N 4
< 0x3900 S/N 6
---
> 0x4b30 S/N 0
> 0x3833 S/N 2
> 0x3035 S/N 4
> 0x3500 S/N 6


```

## Reflash ....  Reboot

```
[root@localhost mrf_pci_driver]# lsmod |grep mrf
pci_mrfevg             53648  0 
pci_mrfevr             53648  0 
mrf                    17592  0 
uio                    19259  1 mrf
parport                42348  1 mrf
[root@localhost mrf_pci_driver]# modprobe -r mrf
[root@localhost mrf_pci_driver]# lsmod |grep mrf
pci_mrfevg             53648  0 
pci_mrfevr             53648  0 
[root@localhost mrf_pci_driver]# modprobe -r pci_mrfevg
[root@localhost mrf_pci_driver]# modprobe -r pci_mrfevr
[root@localhost mrf_pci_driver]# lsmod |grep mrf
[root@localhost mrf_pci_driver]# sh module_load 
Found 0 Event Generators.
Creating device nodes...
Found 2 Event Receivers.
Creating device nodes...
Creating nodes /dev/era[0-3] for major 246chgrp: invalid group: ‘mrf’
Creating nodes /dev/erb[0-3] for major 247chgrp: invalid group: ‘mrf’
```


```
iocuser@localhost: icsem_scripts (master)$ bash mrf_setup.bash show

We've found the MRF boards as follows:
--------------------------------------
08:00.0 "Signal processing controller [1180]" "PLX Technology, Inc. [10b5]" "PCI9030 32-bit 33MHz PCI <-> IOBus Bridge [9030]" -r01 "Micro-Research Finland Oy [1a3e]" "PMC  Event Receiver 230 [11e6]"
0a:00.0 "Signal processing controller [1180]" "PLX Technology, Inc. [10b5]" "PCI9030 32-bit 33MHz PCI <-> IOBus Bridge [9030]" -r01 "Micro-Research Finland Oy [1a3e]" "CPCI Event Receiver 230 [10e6]"
```


```
[root@localhost mrf_pci_driver]# cat /dev/era0 |grep 11e6
[root@localhost mrf_pci_driver]# cat /dev/era0 |grep 10e6
0x10e6 Subsystem ID
[root@localhost mrf_pci_driver]# cat /dev/era0 > cosylab_fw_pmcevr230_eeprom
[root@localhost mrf_pci_driver]# cat /dev/erb
erb0  erb1  erb2  erb3  
[root@localhost mrf_pci_driver]# cat /dev/erb0 > mrf_fw_pmcevr230_eeprom
[root@localhost mrf_pci_driver]# diff cosylab_fw_pmcevr230_eeprom mrf_fw_pmcevr230_eeprom 
2c2
< S/N: E322039     
---
> S/N: K083055     
10c10
< 0x10e6 Subsystem ID
---
> 0x11e6 Subsystem ID
44c44
< 0x0080 MSW of Local Address Space 0 Bus Region Descriptor
---
> 0x0180 MSW of Local Address Space 0 Bus Region Descriptor
63c63
< 0x0012 LSW of Interrupt Control/Status
---
> 0x0000 LSW of Interrupt Control/Status
72,75c72,75
< 0x4533 S/N 0
< 0x3232 S/N 2
< 0x3033 S/N 4
< 0x3900 S/N 6
---
> 0x4b30 S/N 0
> 0x3833 S/N 2
> 0x3035 S/N 4
> 0x3500 S/N 6


[root@localhost mrf_pci_driver]# dd if=mrf_fw_pmcevr230_eeprom of=/dev/era0
6+1 records in
6+1 records out
3338 bytes (3.3 kB) copied, 1.48039 s, 2.3 kB/s
[root@localhost mrf_pci_driver]# 

```

### Reboot

Now, the board has the same device id as the mrf pmc-evr-230

```
iocuser@localhost: icsem_scripts (master)$ bash mrf_setup.bash show

We've found the MRF boards as follows:
--------------------------------------
08:00.0 "Signal processing controller [1180]" "PLX Technology, Inc. [10b5]" "PCI9030 32-bit 33MHz PCI <-> IOBus Bridge [9030]" -r01 "Micro-Research Finland Oy [1a3e]" "PMC  Event Receiver 230 [11e6]"
0a:00.0 "Signal processing controller [1180]" "PLX Technology, Inc. [10b5]" "PCI9030 32-bit 33MHz PCI <-> IOBus Bridge [9030]" -r01 "Micro-Research Finland Oy [1a3e]" "PMC  Event Receiver 230 [11e6]"
```

However, we have the same issue on IOC as

```
<<<<<<<<<<<<<<<<<<
FPGA version 0x11000007
Firmware version: 00000007
Could not read SFP transceiver type. EVR0:SFP0 readouts INVALID!
	First 4 bytes of SFP EEPROM: ff ff ff ff
Flash access: Timeout reached while waiting for transmitter to be empty!
PMC: Out FP:3 FPUNIV:0 RB:16 IFP:1 GPIO:0


>>>>>>>>>>>>>>>>
FPGA version 0x11000007
Firmware version: 00000007
Found EVR0:SFP0 SFP transceiver
Flash access: Timeout reached while waiting for transmitter to be empty!
PMC: Out FP:3 FPUNIV:0 RB:16 IFP:1 GPIO:0
```

Simmone is right, that error message is showed up if we run the IOC without SFP transceiver in SFP slot of PMC-EVR-230. With the MRF eeprom and the MRF FW, it works as normal. 

PMC-EVR-230 with the mrf eeprom and mrf firmware, with the SFP transceiver.

```
iocuser@localhost: icsem_scripts (master)$ iocsh pmc-evr-230/test_evr-pmc-230-fw.cmd
/opt/epics/bases/base-3.15.4/bin/centos7-x86_64/softIoc -D /opt/epics/bases/base-3.15.4/dbd/softIoc.dbd /tmp/iocsh.startup.3642
#date="Thu Feb  9 16:45:10 CET 2017"
#user="iocuser"
#PWD="/home/iocuser/ics_gitsrc/icsem_scripts"
#EPICSVERSION="3.15.4"
#EPICS_HOST_ARCH="centos7-x86_64"
#SHELLBOX=""
#EPICS_CA_ADDR_LIST=""
#EPICS_MODULE_INCLUDE_PATH=".:/usr/lib64:/usr/lib:/lib64:/lib"
dlload         /opt/epics/modules/environment/1.8.2/3.15.4/lib/centos7-x86_64/libenvironment.so
dbLoadDatabase /opt/epics/modules/environment/1.8.2/3.15.4/dbd/environment.dbd
environment_registerRecordDeviceDriver
< "pmc-evr-230/test_evr-pmc-230-fw.cmd"
#  -*- mode: epics -*-
# $ iocsh test_evr-pmc-230.cmd
require mrfioc2,2.7.13
require: mrfioc2 depends on devlib2 (2.7+).
require: Loading library /opt/epics/modules/devlib2/2.7.0/3.15.4/lib/centos7-x86_64/libdevlib2.so.
require: Loading /opt/epics/modules/devlib2/2.7.0/3.15.4/dbd/devlib2.dbd.
require: Calling devlib2_registerRecordDeviceDriver function.
require: Loading library /opt/epics/modules/mrfioc2/2.7.13/3.15.4/lib/centos7-x86_64/libmrfioc2.so.
require: Adding /opt/epics/modules/mrfioc2/2.7.13/db.
require: Adding /opt/epics/modules/mrfioc2/2.7.13/startup.
require: Loading /opt/epics/modules/mrfioc2/2.7.13/3.15.4/dbd/mrfioc2.dbd.
require: Calling mrfioc2_registerRecordDeviceDriver function.
epicsEnvSet(       "SYS"        "PMC")
epicsEnvSet(       "EVR"        "EVR0")
epicsEnvSet(   "EVR_BUS"        "0x0a")
epicsEnvSet(   "EVR_DEV"        "0x00")
epicsEnvSet(  "EVR_FUNC"         "0x0")
epicsEnvSet("EVR_DOMAIN"      "0x0000")
mrmEvrSetupPCI(EVR0, 0x0000, 0x0a, 0x00, 0x0)
Device EVR0 a:0.0
Using IRQ 16
FPGA version 0x11000007
Firmware version: 00000007
Found EVR0:SFP0 SFP transceiver
Flash access: Timeout reached while waiting for transmitter to be empty!
PMC: Out FP:3 FPUNIV:0 RB:16 IFP:1 GPIO:0
dbLoadRecords("evr-pmc-230.db", "DEVICE=EVR0, SYS=PMC, Link-Clk-SP=88.0525")
iocInit
Starting iocInit
############################################################################
## EPICS R3.15.4-2016-05 $$Date$$
## EPICS Base built May 31 2016
############################################################################
Set EVR clock 88052500.000000
PMC-EVR0:FrontOut0-Src2-SP: read error: Hardware does not support second output source selection
PMC-EVR0:FrontOut1-Src2-SP: read error: Hardware does not support second output source selection
PMC-EVR0:FrontOut2-Src2-SP: read error: Hardware does not support second output source selection
PMC-EVR0:RearUniv0-Src2-SP: read error: Hardware does not support second output source selection
PMC-EVR0:RearUniv1-Src2-SP: read error: Hardware does not support second output source selection
PMC-EVR0:RearUniv10-Src2-SP: read error: Hardware does not support second output source selection
PMC-EVR0:RearUniv11-Src2-SP: read error: Hardware does not support second output source selection
PMC-EVR0:RearUniv12-Src2-SP: read error: Hardware does not support second output source selection
PMC-EVR0:RearUniv13-Src2-SP: read error: Hardware does not support second output source selection
PMC-EVR0:RearUniv14-Src2-SP: read error: Hardware does not support second output source selection
PMC-EVR0:RearUniv15-Src2-SP: read error: Hardware does not support second output source selection
PMC-EVR0:RearUniv2-Src2-SP: read error: Hardware does not support second output source selection
PMC-EVR0:RearUniv3-Src2-SP: read error: Hardware does not support second output source selection
PMC-EVR0:RearUniv4-Src2-SP: read error: Hardware does not support second output source selection
PMC-EVR0:RearUniv5-Src2-SP: read error: Hardware does not support second output source selection
PMC-EVR0:RearUniv6-Src2-SP: read error: Hardware does not support second output source selection
PMC-EVR0:RearUniv7-Src2-SP: read error: Hardware does not support second output source selection
PMC-EVR0:RearUniv8-Src2-SP: read error: Hardware does not support second output source selection
PMC-EVR0:RearUniv9-Src2-SP: read error: Hardware does not support second output source selection
iocRun: All initialization complete
epicsEnvSet IOCSH_PS1,"localhost> "

```

PMC-EVR-230 with the mrf eeprom and mrf firmware, without the SFP transceiver.

```
iocuser@localhost: icsem_scripts (master)$ iocsh pmc-evr-230/test_evr-pmc-230-fw.cmd
/opt/epics/bases/base-3.15.4/bin/centos7-x86_64/softIoc -D /opt/epics/bases/base-3.15.4/dbd/softIoc.dbd /tmp/iocsh.startup.3693
#date="Thu Feb  9 16:45:33 CET 2017"
#user="iocuser"
#PWD="/home/iocuser/ics_gitsrc/icsem_scripts"
#EPICSVERSION="3.15.4"
#EPICS_HOST_ARCH="centos7-x86_64"
#SHELLBOX=""
#EPICS_CA_ADDR_LIST=""
#EPICS_MODULE_INCLUDE_PATH=".:/usr/lib64:/usr/lib:/lib64:/lib"
dlload         /opt/epics/modules/environment/1.8.2/3.15.4/lib/centos7-x86_64/libenvironment.so
dbLoadDatabase /opt/epics/modules/environment/1.8.2/3.15.4/dbd/environment.dbd
environment_registerRecordDeviceDriver
< "pmc-evr-230/test_evr-pmc-230-fw.cmd"
#  -*- mode: epics -*-
# $ iocsh test_evr-pmc-230.cmd
require mrfioc2,2.7.13
require: mrfioc2 depends on devlib2 (2.7+).
require: Loading library /opt/epics/modules/devlib2/2.7.0/3.15.4/lib/centos7-x86_64/libdevlib2.so.
require: Loading /opt/epics/modules/devlib2/2.7.0/3.15.4/dbd/devlib2.dbd.
require: Calling devlib2_registerRecordDeviceDriver function.
require: Loading library /opt/epics/modules/mrfioc2/2.7.13/3.15.4/lib/centos7-x86_64/libmrfioc2.so.
require: Adding /opt/epics/modules/mrfioc2/2.7.13/db.
require: Adding /opt/epics/modules/mrfioc2/2.7.13/startup.
require: Loading /opt/epics/modules/mrfioc2/2.7.13/3.15.4/dbd/mrfioc2.dbd.
require: Calling mrfioc2_registerRecordDeviceDriver function.
epicsEnvSet(       "SYS"        "PMC")
epicsEnvSet(       "EVR"        "EVR0")
epicsEnvSet(   "EVR_BUS"        "0x0a")
epicsEnvSet(   "EVR_DEV"        "0x00")
epicsEnvSet(  "EVR_FUNC"         "0x0")
epicsEnvSet("EVR_DOMAIN"      "0x0000")
mrmEvrSetupPCI(EVR0, 0x0000, 0x0a, 0x00, 0x0)
Device EVR0 a:0.0
Using IRQ 16
FPGA version 0x11000007
Firmware version: 00000007
Could not read SFP transceiver type. EVR0:SFP0 readouts INVALID!
	First 4 bytes of SFP EEPROM: ff ff ff ff
Flash access: Timeout reached while waiting for transmitter to be empty!
PMC: Out FP:3 FPUNIV:0 RB:16 IFP:1 GPIO:0
dbLoadRecords("evr-pmc-230.db", "DEVICE=EVR0, SYS=PMC, Link-Clk-SP=88.0525")
iocInit
Starting iocInit
############################################################################
## EPICS R3.15.4-2016-05 $$Date$$
## EPICS Base built May 31 2016
############################################################################
Set EVR clock 88052500.000000
PMC-EVR0:FrontOut0-Src2-SP: read error: Hardware does not support second output source selection
PMC-EVR0:FrontOut1-Src2-SP: read error: Hardware does not support second output source selection
PMC-EVR0:FrontOut2-Src2-SP: read error: Hardware does not support second output source selection
PMC-EVR0:RearUniv0-Src2-SP: read error: Hardware does not support second output source selection
PMC-EVR0:RearUniv1-Src2-SP: read error: Hardware does not support second output source selection
PMC-EVR0:RearUniv10-Src2-SP: read error: Hardware does not support second output source selection
PMC-EVR0:RearUniv11-Src2-SP: read error: Hardware does not support second output source selection
PMC-EVR0:RearUniv12-Src2-SP: read error: Hardware does not support second output source selection
PMC-EVR0:RearUniv13-Src2-SP: read error: Hardware does not support second output source selection
PMC-EVR0:RearUniv14-Src2-SP: read error: Hardware does not support second output source selection
PMC-EVR0:RearUniv15-Src2-SP: read error: Hardware does not support second output source selection
PMC-EVR0:RearUniv2-Src2-SP: read error: Hardware does not support second output source selection
PMC-EVR0:RearUniv3-Src2-SP: read error: Hardware does not support second output source selection
PMC-EVR0:RearUniv4-Src2-SP: read error: Hardware does not support second output source selection
PMC-EVR0:RearUniv5-Src2-SP: read error: Hardware does not support second output source selection
PMC-EVR0:RearUniv6-Src2-SP: read error: Hardware does not support second output source selection
PMC-EVR0:RearUniv7-Src2-SP: read error: Hardware does not support second output source selection
PMC-EVR0:RearUniv8-Src2-SP: read error: Hardware does not support second output source selection
PMC-EVR0:RearUniv9-Src2-SP: read error: Hardware does not support second output source selection
iocRun: All initialization complete
epicsEnvSet IOCSH_PS1,"localhost> "
localhost> 
```



## Revert yet another PMC-EVR-230 to the mrf fw and eeprom

ICS TAG-89

```
[root@localhost icsem_scripts]# bash mrf_setup.bash show

We've found the MRF boards as follows:
--------------------------------------
08:00.0 "Signal processing controller [1180]" "PLX Technology, Inc. [10b5]" "PCI9030 32-bit 33MHz PCI <-> IOBus Bridge [9030]" -r01 "Micro-Research Finland Oy [1a3e]" "PMC  Event Receiver 230 [11e6]"
0a:00.0 "Signal processing controller [1180]" "PLX Technology, Inc. [10b5]" "PCI9030 32-bit 33MHz PCI <-> IOBus Bridge [9030]" -r01 "Micro-Research Finland Oy [1a3e]" "CPCI Event Receiver 230 [10e6]"

[root@localhost icsem_scripts]# 
```

Remove the existent mrf kernel modules

```
[root@localhost icsem_scripts]# lsmod |grep mrf
pci_mrfevr             53648  0 
mrf                    17592  0 
uio                    19259  1 mrf
parport                42348  1 mrf
[root@localhost icsem_scripts]# modprobe -r mrf
[root@localhost icsem_scripts]# modprobe -r pci_mrfevr
[root@localhost icsem_scripts]# lsmod |grep mrf
[root@localhost icsem_scripts]# 
```

[root@localhost mrf_pci_driver]# sh module_load 
Found 0 Event Generators.
Creating device nodes...
Found 2 Event Receivers.
Creating device nodes...
Creating nodes /dev/era[0-3] for major 246chgrp: invalid group: ‘mrf’
Creating nodes /dev/erb[0-3] for major 247chgrp: invalid group: ‘mrf’
[root@localhost mrf_pci_driver]# 

[root@localhost mrf_pci_driver]#  cat /dev/era0 |grep 10e6
0x10e6 Subsystem ID


[root@localhost pmc-evr]# dd if=PMC-EVR-230-11000007.bit of=/dev/era1 
767+1 records in
767+1 records out
392870 bytes (393 kB) copied, 24.2158 s, 16.2 kB/s
[root@localhost pmc-evr]# 

[root@localhost pmc-evr]# dd if=mrf_fw_pmcevr230_eeprom of=/dev/era0
6+1 records in
6+1 records out
3338 bytes (3.3 kB) copied, 1.4797 s, 2.3 kB/s
[root@localhost pmc-evr]# 

### Reboot

```
iocuser@localhost: icsem_scripts (master)$ bash mrf_setup.bash show

We've found the MRF boards as follows:
--------------------------------------
0a:00.0 "Signal processing controller [1180]" "PLX Technology, Inc. [10b5]" "PCI9030 32-bit 33MHz PCI <-> IOBus Bridge [9030]" -r01 "Micro-Research Finland Oy [1a3e]" "PMC  Event Receiver 230 [11e6]"

iocuser@localhost: icsem_scripts (master)$ bash mrf_epicsEnvSet.bash 


>>>>>>>>>>>>>>>>>>> snip snip >>>>>>>>>>>>>>>>>>>

# ESS EPICS Environment

#
# iocsh -3.14.12.5 "e3_startup_script".cmd
# require mrfioc2,edit_me

epicsEnvSet(       "SYS"     "edit_me")
epicsEnvSet(       "EVR"     "edit_me")
epicsEnvSet(   "EVR_BUS"        "0x0a")
epicsEnvSet(   "EVR_DEV"        "0x00")
epicsEnvSet(  "EVR_FUNC"         "0x0")
epicsEnvSet("EVR_DOMAIN"      "0x0000")

mrmEvrSetupPCI($(EVR), $(EVR_DOMAIN), $(EVR_BUS), $(EVR_DEV), $(EVR_FUNC))

# dbLoadRecords example
# dbLoadRecords("edit_me", "DEVICE=$(EVR), SYS=$(SYS)")

<<<<<<<<<<<<<<<<<<< snip snip <<<<<<<<<<<<<<<<<<<


iocuser@localhost: icsem_scripts (master)$ iocsh pmc-evr-230/test_evr-pmc-230-fw.cmd
/opt/epics/bases/base-3.15.4/bin/centos7-x86_64/softIoc -D /opt/epics/bases/base-3.15.4/dbd/softIoc.dbd /tmp/iocsh.startup.2534
#date="Thu Feb  9 17:42:09 CET 2017"
#user="iocuser"
#PWD="/home/iocuser/ics_gitsrc/icsem_scripts"
#EPICSVERSION="3.15.4"
#EPICS_HOST_ARCH="centos7-x86_64"
#SHELLBOX=""
#EPICS_CA_ADDR_LIST=""
#EPICS_MODULE_INCLUDE_PATH=".:/usr/lib64:/usr/lib:/lib64:/lib"
dlload         /opt/epics/modules/environment/1.8.2/3.15.4/lib/centos7-x86_64/libenvironment.so
dbLoadDatabase /opt/epics/modules/environment/1.8.2/3.15.4/dbd/environment.dbd
environment_registerRecordDeviceDriver
< "pmc-evr-230/test_evr-pmc-230-fw.cmd"
#  -*- mode: epics -*-
# $ iocsh test_evr-pmc-230.cmd
require mrfioc2,2.7.13
require: mrfioc2 depends on devlib2 (2.7+).
require: Loading library /opt/epics/modules/devlib2/2.7.0/3.15.4/lib/centos7-x86_64/libdevlib2.so.
require: Loading /opt/epics/modules/devlib2/2.7.0/3.15.4/dbd/devlib2.dbd.
require: Calling devlib2_registerRecordDeviceDriver function.
require: Loading library /opt/epics/modules/mrfioc2/2.7.13/3.15.4/lib/centos7-x86_64/libmrfioc2.so.
require: Adding /opt/epics/modules/mrfioc2/2.7.13/db.
require: Adding /opt/epics/modules/mrfioc2/2.7.13/startup.
require: Loading /opt/epics/modules/mrfioc2/2.7.13/3.15.4/dbd/mrfioc2.dbd.
require: Calling mrfioc2_registerRecordDeviceDriver function.
epicsEnvSet(       "SYS"        "PMC")
epicsEnvSet(       "EVR"        "EVR0")
epicsEnvSet(   "EVR_BUS"        "0x0a")
epicsEnvSet(   "EVR_DEV"        "0x00")
epicsEnvSet(  "EVR_FUNC"         "0x0")
epicsEnvSet("EVR_DOMAIN"      "0x0000")
mrmEvrSetupPCI(EVR0, 0x0000, 0x0a, 0x00, 0x0)
Device EVR0 a:0.0
Using IRQ 16
FPGA version 0x11000007
Firmware version: 00000007
Found EVR0:SFP0 SFP transceiver
Flash access: Timeout reached while waiting for transmitter to be empty!
PMC: Out FP:3 FPUNIV:0 RB:16 IFP:1 GPIO:0
dbLoadRecords("evr-pmc-230.db", "DEVICE=EVR0, SYS=PMC, Link-Clk-SP=88.0525")
iocInit
Starting iocInit
############################################################################
## EPICS R3.15.4-2016-05 $$Date$$
## EPICS Base built May 31 2016
############################################################################
Set EVR clock 88052500.000000
PMC-EVR0:FrontOut0-Src2-SP: read error: Hardware does not support second output source selection
PMC-EVR0:FrontOut1-Src2-SP: read error: Hardware does not support second output source selection
PMC-EVR0:FrontOut2-Src2-SP: read error: Hardware does not support second output source selection
PMC-EVR0:RearUniv0-Src2-SP: read error: Hardware does not support second output source selection
PMC-EVR0:RearUniv1-Src2-SP: read error: Hardware does not support second output source selection
PMC-EVR0:RearUniv10-Src2-SP: read error: Hardware does not support second output source selection
PMC-EVR0:RearUniv11-Src2-SP: read error: Hardware does not support second output source selection
PMC-EVR0:RearUniv12-Src2-SP: read error: Hardware does not support second output source selection
PMC-EVR0:RearUniv13-Src2-SP: read error: Hardware does not support second output source selection
PMC-EVR0:RearUniv14-Src2-SP: read error: Hardware does not support second output source selection
PMC-EVR0:RearUniv15-Src2-SP: read error: Hardware does not support second output source selection
PMC-EVR0:RearUniv2-Src2-SP: read error: Hardware does not support second output source selection
PMC-EVR0:RearUniv3-Src2-SP: read error: Hardware does not support second output source selection
PMC-EVR0:RearUniv4-Src2-SP: read error: Hardware does not support second output source selection
PMC-EVR0:RearUniv5-Src2-SP: read error: Hardware does not support second output source selection
PMC-EVR0:RearUniv6-Src2-SP: read error: Hardware does not support second output source selection
PMC-EVR0:RearUniv7-Src2-SP: read error: Hardware does not support second output source selection
PMC-EVR0:RearUniv8-Src2-SP: read error: Hardware does not support second output source selection
PMC-EVR0:RearUniv9-Src2-SP: read error: Hardware does not support second output source selection
Warning: Duplicate EPICS CA Address list entry "10.4.3.255:5065" discarded
iocRun: All initialization complete
epicsEnvSet IOCSH_PS1,"localhost> "
localhost> 


```


