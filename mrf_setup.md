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

