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


