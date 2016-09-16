[root@ip6-6 iocuser]# yum info kmod-mrfioc2
Loaded plugins: fastestmirror, langpacks, versionlock
Loading mirror speeds from cached hostfile
Available Packages
Name        : kmod-mrfioc2
Arch        : x86_64
Version     : 1.0.0
Release     : 1
Size        : 8.0 k
Repo        : devenv-extras
Summary     : mrfioc2 kernel module
License     : GPL
Description : mrfioc2 kernel module



[root@ip6-6 iocuser]# modprobe mrf


[iocuser@ip6-6 ~]$ lsmod |grep mrf
mrf                    13496  0 
uio                    19259  1 mrf
parport                42348  3 mrf,ppdev,parport_pc

[iocuser@ip6-6 ~]$ ls -ltar /dev/uio0 
crw-rw-rw- 1 root root 247, 0 Sep 12 17:31 /dev/uio0


[iocuser@ip6-6 ~]$ lspci |grep Signal
16:09.0 Signal processing controller: PLX Technology, Inc. PCI9030 32-bit 33MHz PCI <-> IOBus Bridge (rev 01)


lspci -s ${var%$suffix} -vv


[root@ip6-6 iocuser]# lspci -s 16:09 -vv
16:09.0 Signal processing controller: PLX Technology, Inc. PCI9030 32-bit 33MHz PCI <-> IOBus Bridge (rev 01)
	Subsystem: Device 1a3e:20e6
	Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Interrupt: pin A routed to IRQ 17
	Region 0: Memory at f0910000 (32-bit, non-prefetchable) [size=128]
	Region 2: Memory at f0900000 (32-bit, non-prefetchable) [size=64K]
	Capabilities: [40] Power Management version 1
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [48] CompactPCI hot-swap <?>
	Capabilities: [4c] Vital Product Data
pcilib: sysfs_read_vpd: read failed: Connection timed out
		Not readable
	Kernel driver in use: mrf-pci



Stupid enough on the ICS wiki page to identify PCI bus address.

lspci |grep "Signal" 
has enough information for all of them
[root@ip6-6 iocuser]# lspci |grep 'Signal processing controller' | awk '{ print $1 }'
16:09.0

[root@ip6-6 iocuser]# lspci |grep 'Signal processing controller'
16:09.0 Signal processing controller: PLX Technology, Inc. " (rev 01)

[root@ip6-6 iocuser]# lspci -n |grep 16
16:09.0 1180: 10b5:9030 (rev 01)


Field 1 : 16:09.0  bus number(16):device number(09):function(0)
Field 2 : 1180     device class "Signal processing controller
Field 3 : 10b5     vendor ID "PLX Technology, Inc."  http://pci-ids.ucw.cz/read/PC/10b5
Field 4 : 9030     device ID "PCI9030 32-bit 33MHz PCI <-> IOBus Bridge" https://pci-ids.ucw.cz/read/PC/10b5/9030



ls /sys/bus/pci/devices/0000\:16\:09.0/



[root@ip6-6 icsem_scripts]# udevadm info --query=all /dev/uio* --attribute-walk

Udevadm info starts with the device specified by the devpath and then
walks up the chain of parent devices. It prints for every device
found, all possible attributes in the udev rules key format.
A rule to match, can be composed by the attributes of the device
and the attributes from one single parent device.

  looking at device '/devices/pci0000:00/0000:00:1e.0/0000:16:09.0/uio/uio0':
    KERNEL=="uio0"
    SUBSYSTEM=="uio"
    DRIVER==""
    ATTR{name}=="mrf-pci"
    ATTR{event}=="0"
    ATTR{version}=="1"

  looking at parent device '/devices/pci0000:00/0000:00:1e.0/0000:16:09.0':
    KERNELS=="0000:16:09.0"
    SUBSYSTEMS=="pci"
    DRIVERS=="mrf-pci"
    ATTRS{irq}=="17"
    ATTRS{subsystem_vendor}=="0x1a3e"
    ATTRS{broken_parity_status}=="0"
    ATTRS{class}=="0x118000"
    ATTRS{consistent_dma_mask_bits}=="32"
    ATTRS{dma_mask_bits}=="32"
    ATTRS{local_cpus}=="f"
    ATTRS{device}=="0x9030"
    ATTRS{enable}=="1"
    ATTRS{msi_bus}==""
    ATTRS{local_cpulist}=="0-3"
    ATTRS{vendor}=="0x10b5"
    ATTRS{subsystem_device}=="0x20e6"
    ATTRS{numa_node}=="-1"
    ATTRS{d3cold_allowed}=="1"

  looking at parent device '/devices/pci0000:00/0000:00:1e.0':
    KERNELS=="0000:00:1e.0"
    SUBSYSTEMS=="pci"
    DRIVERS==""
    ATTRS{irq}=="0"
    ATTRS{subsystem_vendor}=="0x0000"
    ATTRS{broken_parity_status}=="0"
    ATTRS{class}=="0x060401"
    ATTRS{consistent_dma_mask_bits}=="32"
    ATTRS{dma_mask_bits}=="32"
    ATTRS{local_cpus}=="f"
    ATTRS{device}=="0x2448"
    ATTRS{enable}=="1"
    ATTRS{msi_bus}=="1"
    ATTRS{local_cpulist}=="0-3"
    ATTRS{vendor}=="0x8086"
    ATTRS{subsystem_device}=="0x0000"
    ATTRS{numa_node}=="-1"
    ATTRS{d3cold_allowed}=="0"

  looking at parent device '/devices/pci0000:00':
    KERNELS=="pci0000:00"
    SUBSYSTEMS==""
    DRIVERS==""


Put the rule : mrf in /etc/modules-load.d/mrf.conf to load the mrf module at boot time.

[iocuser@ip6-6 icsem_scripts]$ cat /etc/modules-load.d/mrf.conf 
mrf


Put the rule : SUBSYSTEM=="uio", ATTR{name}=="mrf-pci", MODE="0660" in /etc/udev/rules.d/mrf.rules to be accessible via an user.


[iocuser@ip6-6 icsem_scripts]$ cat /etc/udev/rules.d/mrf.rules 
SUBSYSTEM=="uio", ATTR{name}=="mrf-pci", MODE="0660"
[iocuser@ip6-6 icsem_scripts]$ 



Reboot

[iocuser@ip6-6 ~]$ lsmod |grep mrf
mrf                    13496  0 
uio                    19259  1 mrf
parport                42348  3 mrf,ppdev,parport_pc
[iocuser@ip6-6 ~]$ 

[iocuser@ip6-6 ~]$ modinfo mrf
filename:       /lib/modules/3.10.0-229.7.2.el7.x86_64/extra/mrf.ko
author:         Michael Davidsaver <mdavidsaver@bnl.gov>
version:        1
license:        GPL v2
rhelversion:    7.1
srcversion:     413C2B392FB742253E61904
depends:        parport,uio
vermagic:       3.10.0-229.7.2.el7.x86_64 SMP mod_unload modversions 
parm:           cable:Name of JTAG parallel port cable to emulate (charp)
parm:           interfaceversion:User space interface version (int)
[iocuser@ip6-6 ~]$

# This returns bus, device, and function of ONLY a EVG card
We have to test with muntiple cards in a system (EVG and EVR)

[iocuser@ip6-6 icsem_scripts]$ bash setcpciEvg230.bash
[iocuser@ip6-6 icsem_scripts]$ bash setcpciEvg230.bash
 0: 3.10.0-229.7.2.el7.x86_64
 1: CentOS Linux release 7.1.1503 (Core) 
 2: /opt/epics/modules/environment/1.8.2/3.15.4/bin/centos7-x86_64
 3: /opt/epics/modules/environment/1.8.2/3.15.4/bin/centos7-x86_64/iocsh
 4: /opt/epics/bases/base-3.15.4
16:09.0
bus       16
device    09
function  0

>>>> You are entering in : print_st


------------ snip snip ------------

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

------------ snip snip ------------

You should run this via the following command : 
iocsh -3.14.12.5 cpci-evg-230_0.cmd


------------ snip snip ------------

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

------------ snip snip ------------

You should run this via the following command : 
iocsh cpci-evg-230_0.cmd
<<<< You are leaving from print_st


Start with 3.14.12.5



[iocuser@ip6-6 icsem_scripts]$ iocsh -3.14.12.5 cpci-evg-230/cpci-evg-230a_0.cmd 
/opt/epics/bases/base-3.14.12.5/bin/centos7-x86_64/softIoc -D /opt/epics/bases/base-3.14.12.5/dbd/softIoc.dbd /tmp/iocsh.startup.18668
#date="Fri Sep 16 11:41:09 CEST 2016"
#user="iocuser"
#PWD="/home/iocuser/gitsrc/icsem_scripts"
#EPICSVERSION="3.14.12.5"
#EPICS_HOST_ARCH="centos7-x86_64"
#SHELLBOX=""
#EPICS_CA_ADDR_LIST=""
#EPICS_MODULE_INCLUDE_PATH=".:/usr/lib64:/usr/lib:/lib64:/lib"
dlload         /opt/epics/modules/environment/1.8.2/3.14.12.5/lib/centos7-x86_64/libenvironment.so
dbLoadDatabase /opt/epics/modules/environment/1.8.2/3.14.12.5/dbd/environment.dbd
environment_registerRecordDeviceDriver
< "cpci-evg-230/cpci-evg-230a_0.cmd"
# This file should be used with EPICS base 3.14.12.5 and mrfioc2 2.1.0
# With current EEE 1.8.2, the proper command is 
# $ iocsh -3.14.12.5 cpci-evg-230_0.cmd
require mrfioc2,2.1.0
require: mrfioc2 depends on devlib2 (2.6+).
require: Loading library /opt/epics/modules/devlib2/2.7.0/3.14.12.5/lib/centos7-x86_64/libdevlib2.so.
require: Loading /opt/epics/modules/devlib2/2.7.0/3.14.12.5/dbd/devlib2.dbd.
require: Calling devlib2_registerRecordDeviceDriver function.
require: Loading library /opt/epics/modules/mrfioc2/2.1.0/3.14.12.5/lib/centos7-x86_64/libmrfioc2.so.
require: Adding /opt/epics/modules/mrfioc2/2.1.0/db.
require: Adding /opt/epics/modules/mrfioc2/2.1.0/startup.
require: Loading /opt/epics/modules/mrfioc2/2.1.0/3.14.12.5/dbd/mrfioc2.dbd.
require: Calling mrfioc2_registerRecordDeviceDriver function.
epicsEnvSet("SYS"             "ICS-CPCIEVG-230")
epicsEnvSet("EVG"             "EVG0")
epicsEnvSet("EVG_PCIBUS"      "0x16")
epicsEnvSet("EVG_PCIDEVICE"   "0x09")
epicsEnvSet("EVG_PCIFUNCTION" "0x0")
mrmEvgSetupPCI(EVG0, 0x16, 0x09, 0x0)
Device EVG0  22:9.0
Using IRQ 17
FPGA version: 20000005
Firmware version: 00000005
Sub-units:
 FrontInp: 2, FrontOut: 6
 UnivInp: 4, UnivOut: 4
 RearInp: 16
 Mxc: 8, Event triggers: 8, DBus bits: 8
Found EVG0:SFP0 EEPROM
PCI interrupt connected!
dbLoadRecords("evg-cpci.db", "EVG=EVG0, SYS=ICS-CPCIEVG-230")
iocInit
Starting iocInit
############################################################################
## EPICS R3.14.12.5-2015-08 $Date: Tue 2015-03-24 09:57:35 -0500$
## EPICS Base built Oct  9 2015
############################################################################
iocRun: All initialization complete
epicsEnvSet IOCSH_PS1,"ip6-6> "


EPICS 3.15.4


[iocuser@ip6-6 icsem_scripts]$ iocsh cpci-evg-230/cpci-evg-230b_0.cmd 
/opt/epics/bases/base-3.15.4/bin/centos7-x86_64/softIoc -D /opt/epics/bases/base-3.15.4/dbd/softIoc.dbd /tmp/iocsh.startup.18571
#date="Fri Sep 16 11:40:08 CEST 2016"
#user="iocuser"
#PWD="/home/iocuser/gitsrc/icsem_scripts"
#EPICSVERSION="3.15.4"
#EPICS_HOST_ARCH="centos7-x86_64"
#SHELLBOX=""
#EPICS_CA_ADDR_LIST=""
#EPICS_MODULE_INCLUDE_PATH=".:/usr/lib64:/usr/lib:/lib64:/lib"
dlload         /opt/epics/modules/environment/1.8.2/3.15.4/lib/centos7-x86_64/libenvironment.so
dbLoadDatabase /opt/epics/modules/environment/1.8.2/3.15.4/dbd/environment.dbd
environment_registerRecordDeviceDriver
< "cpci-evg-230/cpci-evg-230b_0.cmd"
# This file should be used with EPICS base 3.15.4 and mrfioc2 2.7.13
# With current EEE 1.8.2, the proper command is 
# $ iocsh cpci-evg-230_0.cmd
# or
# $ iocsh -3.15.4 cpci-evg-230_0.cmd
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
epicsEnvSet("SYS"             "ICS-CPCIEVG-230")
epicsEnvSet("EVG"             "EVG0")
epicsEnvSet("EVG_PCIBUS"      "0x16")
epicsEnvSet("EVG_PCIDEVICE"   "0x09")
epicsEnvSet("EVG_PCIFUNCTION" "0x0")
mrmEvgSetupPCI(EVG0, 0x16, 0x09, 0x0)
Device EVG0  16:9.0
Using IRQ 17
FPGA version: 20000005
Firmware version: 00000005
Sub-units:
 FrontInp: 2, FrontOut: 6
 UnivInp: 4, UnivOut: 4
 RearInp: 16
 RearOut: 0
 Mxc: 8, Event triggers: 8, DBus bits: 8
Found EVG0:SFP0 SFP transceiver
Flash access: Timeout reached while waiting for transmitter to be empty!
PCI interrupt connected!
dbLoadRecords("evg-cpci.db", "DEVICE=EVG0, SYS=ICS-CPCIEVG-230")
iocInit
Starting iocInit
############################################################################
## EPICS R3.15.4-2016-05 $$Date$$
## EPICS Base built May 31 2016
############################################################################
iocRun: All initialization complete
epicsEnvSet IOCSH_PS1,"ip6-6> "
ip6-6> 



/// # devPCIShow in devLib2


epicsEnvSet IOCSH_PS1,"ip6-6> "
ip6-6> devPCIShow
PCI 0000:00:00.0 IRQ 0
  vendor:device 8086:0044 rev 00
PCI 0000:00:01.0 IRQ 40
  vendor:device 8086:0045 rev 00
PCI 0000:00:02.0 IRQ 55
  vendor:device 8086:0046 rev 00
PCI 0000:00:19.0 IRQ 50
  vendor:device 8086:10ea rev 00
PCI 0000:00:1a.0 IRQ 16
  vendor:device 8086:3b3c rev 00
PCI 0000:00:1c.0 IRQ 16
  vendor:device 8086:3b42 rev 00
PCI 0000:00:1c.1 IRQ 17
  vendor:device 8086:3b44 rev 00
PCI 0000:00:1c.4 IRQ 16
  vendor:device 8086:3b4a rev 00
PCI 0000:00:1c.7 IRQ 19
  vendor:device 8086:3b50 rev 00
PCI 0000:00:1d.0 IRQ 23
  vendor:device 8086:3b34 rev 00
PCI 0000:00:1e.0 IRQ 0
  vendor:device 8086:2448 rev 00
PCI 0000:00:1f.0 IRQ 0
  vendor:device 8086:3b07 rev 00
PCI 0000:00:1f.2 IRQ 51
  vendor:device 8086:3b2f rev 00
PCI 0000:00:1f.3 IRQ 18
  vendor:device 8086:3b30 rev 00
PCI 0000:02:00.0 IRQ 41
  vendor:device 10b5:8614 rev 00
PCI 0000:03:01.0 IRQ 42
  vendor:device 10b5:8614 rev 00
PCI 0000:03:02.0 IRQ 43
  vendor:device 10b5:8614 rev 00
PCI 0000:03:05.0 IRQ 44
  vendor:device 10b5:8614 rev 00
PCI 0000:03:07.0 IRQ 45
  vendor:device 10b5:8614 rev 00
PCI 0000:03:09.0 IRQ 46
  vendor:device 10b5:8614 rev 00
PCI 0000:03:0a.0 IRQ 47
  vendor:device 10b5:8614 rev 00
PCI 0000:03:0c.0 IRQ 48
  vendor:device 10b5:8614 rev 00
PCI 0000:03:0e.0 IRQ 49
  vendor:device 10b5:8614 rev 00
PCI 0000:10:00.0 IRQ 17
  vendor:device 8086:10d3 rev 00
PCI 0000:12:00.0 IRQ 16
  vendor:device 197b:2362 rev 00
PCI 0000:14:00.0 IRQ 19
  vendor:device 8086:10d3 rev 00
PCI 0000:16:09.0 IRQ 17
  vendor:device 10b5:9030 rev 00
PCI 0000:ff:00.0 IRQ 0
  vendor:device 8086:2c62 rev 00
PCI 0000:ff:00.1 IRQ 0
  vendor:device 8086:2d01 rev 00
PCI 0000:ff:02.0 IRQ 0
  vendor:device 8086:2d10 rev 00
PCI 0000:ff:02.1 IRQ 0
  vendor:device 8086:2d11 rev 00
PCI 0000:ff:02.2 IRQ 0
  vendor:device 8086:2d12 rev 00
PCI 0000:ff:02.3 IRQ 0
  vendor:device 8086:2d13 rev 00
PCI 0000:0e:00.0 IRQ 16
  vendor:device 8086:10d3 rev 00
Matched 34 devices
ip6-6> 





PCI 0000:16:09.0 IRQ 17
  vendor:device 10b5:9030 rev 00


ip6-6> devPCIShow 9 0x10b5

PCI 0000:16:09.0 IRQ 17
  vendor:device 10b5:9030 rev 00
  subved:subdev 1a3e:20e6
  class 118000 generic signal processing controller
  driver mrf-pci
  BAR 0 32-bit MMIO    128 B
  BAR 2 32-bit MMIO     64 kB
Matched 10 devices







Step 0 :

[iocuser@ip6-6 ~]$ caget ICS-CPCIEVG-230-EVG0:FwVer-I
ICS-CPCIEVG-230-EVG0:FwVer-I   536870917


[iocuser@ip6-6 ~]$ caget ICS-CPCIEVG-230-EVG0:EvtClk-Frequency-RB
ICS-CPCIEVG-230-EVG0:EvtClk-Frequency-RB 124.916


Step 1 :

Somehow I don't understand this have mixed EVG and EVR


Step 2 :

[iocuser@ip6-6 icsem_scripts]$ iocsh -3.14.12.5 cpci-evg-230/cpci-evg-230a_2.cmd
/opt/epics/bases/base-3.14.12.5/bin/centos7-x86_64/softIoc -D /opt/epics/bases/base-3.14.12.5/dbd/softIoc.dbd /tmp/iocsh.startup.19999
#date="Fri Sep 16 12:04:31 CEST 2016"
#user="iocuser"
#PWD="/home/iocuser/gitsrc/icsem_scripts"
#EPICSVERSION="3.14.12.5"
#EPICS_HOST_ARCH="centos7-x86_64"
#SHELLBOX=""
#EPICS_CA_ADDR_LIST=""
#EPICS_MODULE_INCLUDE_PATH=".:/usr/lib64:/usr/lib:/lib64:/lib"
dlload         /opt/epics/modules/environment/1.8.2/3.14.12.5/lib/centos7-x86_64/libenvironment.so
dbLoadDatabase /opt/epics/modules/environment/1.8.2/3.14.12.5/dbd/environment.dbd
environment_registerRecordDeviceDriver
< "cpci-evg-230/cpci-evg-230a_2.cmd"
# This file should be used with EPICS base 3.14.12.5 and mrfioc2 2.1.0
# With current EEE 1.8.2, the proper command is 
# $ iocsh -3.14.12.5 cpci-evg-230_0.cmd
require mrfioc2,2.1.0
require: mrfioc2 depends on devlib2 (2.6+).
require: Loading library /opt/epics/modules/devlib2/2.7.0/3.14.12.5/lib/centos7-x86_64/libdevlib2.so.
require: Loading /opt/epics/modules/devlib2/2.7.0/3.14.12.5/dbd/devlib2.dbd.
require: Calling devlib2_registerRecordDeviceDriver function.
require: Loading library /opt/epics/modules/mrfioc2/2.1.0/3.14.12.5/lib/centos7-x86_64/libmrfioc2.so.
require: Adding /opt/epics/modules/mrfioc2/2.1.0/db.
require: Adding /opt/epics/modules/mrfioc2/2.1.0/startup.
require: Loading /opt/epics/modules/mrfioc2/2.1.0/3.14.12.5/dbd/mrfioc2.dbd.
require: Calling mrfioc2_registerRecordDeviceDriver function.
epicsEnvSet("SYS"             "ICS-CPCIEVG-230")
epicsEnvSet("EVG"             "EVG0")
epicsEnvSet("EVG_PCIBUS"      "0x16")
epicsEnvSet("EVG_PCIDEVICE"   "0x09")
epicsEnvSet("EVG_PCIFUNCTION" "0x0")
mrmEvgSetupPCI(EVG0, 0x16, 0x09, 0x0)
Device EVG0  22:9.0
Using IRQ 17
FPGA version: 20000005
Firmware version: 00000005
Sub-units:
 FrontInp: 2, FrontOut: 6
 UnivInp: 4, UnivOut: 4
 RearInp: 16
 Mxc: 8, Event triggers: 8, DBus bits: 8
Found EVG0:SFP0 EEPROM
PCI interrupt connected!
dbLoadRecords("evg-cpci.db", "EVG=EVG0, SYS=ICS-CPCIEVG-230")
iocInit
Starting iocInit
############################################################################
## EPICS R3.14.12.5-2015-08 $Date: Tue 2015-03-24 09:57:35 -0500$
## EPICS Base built Oct  9 2015
############################################################################
iocRun: All initialization complete
epicsEnvSet IOCSH_PS1,"ip6-6> "
ip6-6> 



[iocuser@ip6-6 icsem_scripts]$ iocsh cpci-evg-230/cpci-evg-230b_2.cmd
/opt/epics/bases/base-3.15.4/bin/centos7-x86_64/softIoc -D /opt/epics/bases/base-3.15.4/dbd/softIoc.dbd /tmp/iocsh.startup.20045
#date="Fri Sep 16 12:04:56 CEST 2016"
#user="iocuser"
#PWD="/home/iocuser/gitsrc/icsem_scripts"
#EPICSVERSION="3.15.4"
#EPICS_HOST_ARCH="centos7-x86_64"
#SHELLBOX=""
#EPICS_CA_ADDR_LIST=""
#EPICS_MODULE_INCLUDE_PATH=".:/usr/lib64:/usr/lib:/lib64:/lib"
dlload         /opt/epics/modules/environment/1.8.2/3.15.4/lib/centos7-x86_64/libenvironment.so
dbLoadDatabase /opt/epics/modules/environment/1.8.2/3.15.4/dbd/environment.dbd
environment_registerRecordDeviceDriver
< "cpci-evg-230/cpci-evg-230b_2.cmd"
# This file should be used with EPICS base 3.15.4 and mrfioc2 2.7.13
# With current EEE 1.8.2, the proper command is 
# $ iocsh cpci-evg-230_0.cmd
# or
# $ iocsh -3.15.4 cpci-evg-230_0.cmd
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
epicsEnvSet("SYS"             "ICS-CPCIEVG-230")
epicsEnvSet("EVG"             "EVG0")
epicsEnvSet("EVG_PCIBUS"      "0x16")
epicsEnvSet("EVG_PCIDEVICE"   "0x09")
epicsEnvSet("EVG_PCIFUNCTION" "0x0")
mrmEvgSetupPCI(EVG0, 0x16, 0x09, 0x0)
Device EVG0  16:9.0
Using IRQ 17
FPGA version: 20000005
Firmware version: 00000005
Sub-units:
 FrontInp: 2, FrontOut: 6
 UnivInp: 4, UnivOut: 4
 RearInp: 16
 RearOut: 0
 Mxc: 8, Event triggers: 8, DBus bits: 8
Found EVG0:SFP0 SFP transceiver
Flash access: Timeout reached while waiting for transmitter to be empty!
PCI interrupt connected!
dbLoadRecords("evg-cpci.db", "DEVICE=EVG0, SYS=ICS-CPCIEVG-230")
dbLoadRecords("evgSoftSeq.template",  "DEVICE=EVG0, SYS=ICS-CPCIEVG-230, SEQNUM=1, NELM=3")
iocInit
Starting iocInit
############################################################################
## EPICS R3.15.4-2016-05 $$Date$$
## EPICS Base built May 31 2016
############################################################################
iocRun: All initialization complete
epicsEnvSet IOCSH_PS1,"ip6-6> "






ip6-6> dbpf ICS-CPCIEVG-230-EVG0:TrigEvt0-EvtCode-SP 14
DBR_LONG:           14        0xe                 
ip6-6> dbpf ICS-CPCIEVG-230-EVG0:Mxc0-Frequency-SP 14
DBR_DOUBLE:         14                  
ip6-6> dbpf ICS-CPCIEVG-230-EVG0:Mxc0-TrigSrc0-SP 1
DBR_STRING:          "Set"    
ip6-6> dbpf ICS-CPCIEVG-230-EVG0:SoftEvt-Enable-Sel 1
DBR_STRING:          "Enabled"          
ip6-6> 


[iocuser@ip6-6 ~]$ caput ICS-CPCIEVG-230-EVG0:TrigEvt0-EvtCode-SP 1
Old : ICS-CPCIEVG-230-EVG0:TrigEvt0-EvtCode-SP 14
New : ICS-CPCIEVG-230-EVG0:TrigEvt0-EvtCode-SP 1
[iocuser@ip6-6 ~]$ caput ICS-CPCIEVG-230-EVG0:Mxc0-Frequency-SP  1
Old : ICS-CPCIEVG-230-EVG0:Mxc0-Frequency-SP 14
New : ICS-CPCIEVG-230-EVG0:Mxc0-Frequency-SP 1
[iocuser@ip6-6 ~]$ caput ICS-CPCIEVG-230-EVG0:Mxc0-Frequency-SP  2
Old : ICS-CPCIEVG-230-EVG0:Mxc0-Frequency-SP 1
New : ICS-CPCIEVG-230-EVG0:Mxc0-Frequency-SP 2
[iocuser@ip6-6 ~]$ caput ICS-CPCIEVG-230-EVG0:Mxc0-Frequency-SP  3
Old : ICS-CPCIEVG-230-EVG0:Mxc0-Frequency-SP 2
New : ICS-CPCIEVG-230-EVG0:Mxc0-Frequency-SP 3
[iocuser@ip6-6 ~]$ caput ICS-CPCIEVG-230-EVG0:Mxc0-Frequency-SP  4
Old : ICS-CPCIEVG-230-EVG0:Mxc0-Frequency-SP 3
New : ICS-CPCIEVG-230-EVG0:Mxc0-Frequency-SP 4
[iocuser@ip6-6 ~]$ caput ICS-CPCIEVG-230-EVG0:Mxc0-Frequency-SP  5
Old : ICS-CPCIEVG-230-EVG0:Mxc0-Frequency-SP 4
New : ICS-CPCIEVG-230-EVG0:Mxc0-Frequency-SP 5
[iocuser@ip6-6 ~]$ caput ICS-CPCIEVG-230-EVG0:Mxc0-Frequency-SP  60
Old : ICS-CPCIEVG-230-EVG0:Mxc0-Frequency-SP 5
New : ICS-CPCIEVG-230-EVG0:Mxc0-Frequency-SP 60
[iocuser@ip6-6 ~]$ caput ICS-CPCIEVG-230-EVG0:Mxc0-Frequency-SP  15
Old : ICS-CPCIEVG-230-EVG0:Mxc0-Frequency-SP 60
New : ICS-CPCIEVG-230-EVG0:Mxc0-Frequency-SP 15
[iocuser@ip6-6 ~]$ caput ICS-CPCIEVG-230-EVG0:Mxc0-Frequency-SP  14
Old : ICS-CPCIEVG-230-EVG0:Mxc0-Frequency-SP 15
New : ICS-CPCIEVG-230-EVG0:Mxc0-Frequency-SP 14
[iocuser@ip6-6 ~]$ caput ICS-CPCIEVG-230-EVG0:Mxc0-Frequency-SP  14
Old : ICS-CPCIEVG-230-EVG0:Mxc0-Frequency-SP 14
New : ICS-CPCIEVG-230-EVG0:Mxc0-Frequency-SP 14
[iocuser@ip6-6 ~]$ 


