```bash
$ git clone https://github.com/jeonghanlee/pciids

$ cd pciids/

$ lspci -nmmn  | grep -E "\<(1a3e)"
16:0c.0 "Signal processing controller [1180]" "PLX Technology, Inc. [10b5]" "PCI9030 32-bit 33MHz PCI <-> IOBus Bridge [9030]" -r01 "Unknown vendor [1a3e]" "Device [10e6]"
16:0e.0 "Signal processing controller [1180]" "PLX Technology, Inc. [10b5]" "PCI9030 32-bit 33MHz PCI <-> IOBus Bridge [9030]" -r01 "Unknown vendor [1a3e]" "Device [20dc]"

$ lspci -nmmn -i pci.ids | grep -E "\<(1a3e)"
16:0c.0 "Signal processing controller [1180]" "PLX Technology, Inc. [10b5]" "PCI9030 32-bit 33MHz PCI <-> IOBus Bridge [9030]" -r01 "Micro-Research Finland Oy [1a3e]" "CPCI Event Receiver 230 [10e6]"
16:0e.0 "Signal processing controller [1180]" "PLX Technology, Inc. [10b5]" "PCI9030 32-bit 33MHz PCI <-> IOBus Bridge [9030]" -r01 "Micro-Research Finland Oy [1a3e]" "CPCI Event Generator 220 [20dc]"
```


```bash
$ git clone https://github.com/jeonghanlee/icsem_scripts
$ cd icsem_scripts
$ 
$ bash mrf_boards_detect.bash 


------------ snip snip ------------


# ESS EPICS Environment
# iocsh -3.14.12.5 "e3_startup_script".cmd
# require mrfioc2,2.1.0

#--------------------------------------------------------

epicsEnvSet("SYS"       "edit_me")
epicsEnvSet("EVR"       "edit_me")
epicsEnvSet("EVR_BUS"   "0x16")
epicsEnvSet("EVR_DEV"   "0x0c")
epicsEnvSet("EVR_FUNC"  "0x0")
mrmEvgSetupPCI($(EVR), $(EVR_BUS), $(EVR_DEV), $(EVR_FUNC))
# --------------------------------------------------------

# dbLoadRecords example
# dbLoadRecords("edit_me", "DEVICE=$(EVR), SYS=$(SYS)")

------------ snip snip ------------



------------ snip snip ------------


# ESS EPICS Environment
# iocsh -3.14.12.5 "e3_startup_script".cmd
# require mrfioc2,2.1.0

#--------------------------------------------------------

epicsEnvSet("SYS"       "edit_me")
epicsEnvSet("EVG"       "edit_me")
epicsEnvSet("EVG_BUS"   "0x16")
epicsEnvSet("EVG_DEV"   "0x0e")
epicsEnvSet("EVG_FUNC"  "0x0")
mrmEvgSetupPCI($(EVG), $(EVG_BUS), $(EVG_DEV), $(EVG_FUNC))
# --------------------------------------------------------

# dbLoadRecords example
# dbLoadRecords("edit_me", "DEVICE=$(EVG), SYS=$(SYS)")

------------ snip snip ------------
```


Add EVG220 into mrmShared/linux
make install as a user

and make modules_install as sudo 
```
$ sudo su
[sudo] password for iocuser: 
[root@bodhi2 linux]# make modules_install
make -C /lib/modules/3.10.0-229.7.2.el7.x86_64/build M=/home/iocuser/gitsrc/m-epics-mrfioc2/mrmShared/linux modules_install
make[1]: Entering directory `/usr/src/kernels/3.10.0-229.7.2.el7.x86_64'
  INSTALL /home/iocuser/gitsrc/m-epics-mrfioc2/mrmShared/linux/mrf.ko
Can't read private key
  DEPMOD  3.10.0-229.7.2.el7.x86_64
make[1]: Leaving directory `/usr/src/kernels/3.10.0-229.7.2.el7.x86_64'
[root@bodhi2 linux]# lsmod |grep mrf
[root@bodhi2 linux]# modprobe mrf
[root@bodhi2 linux]# lsmod |grep mrf
mrf                    17592  0 
uio                    19259  1 mrf
parport                42348  3 mrf,ppdev,parport_pc
[root@bodhi2 linux]# ls -ltar /dev/ui*
crw-------. 1 root root  10, 223 Oct 20 17:46 /dev/uinput
crw-------. 1 root root 247,   1 Oct 31 14:59 /dev/uio1
crw-------. 1 root root 247,   0 Oct 31 14:59 /dev/uio0

```

At the same time, /var/log/messages

```
Oct 31 14:59:19 bodhi2 kernel: mrf: module verification failed: signature and/or required key missing - tainting kernel
Oct 31 14:59:19 bodhi2 kernel: mrf-pci 0000:16:0c.0: Attaching BAR0,2,3 of MRF
Oct 31 14:59:19 bodhi2 kernel: mrf-pci 0000:16:0c.0: GPIOC 00249412
Oct 31 14:59:19 bodhi2 kernel: mrf-pci 0000:16:0c.0: Emulating cable: Minimal
Oct 31 14:59:19 bodhi2 kernel: mrf-pci 0000:16:0c.0: MRF Setup complete
Oct 31 14:59:19 bodhi2 kernel: mrf-pci 0000:16:0e.0: Attaching BAR0,2,3 of MRF
Oct 31 14:59:19 bodhi2 kernel: mrf-pci 0000:16:0e.0: GPIOC 00249412
Oct 31 14:59:19 bodhi2 kernel: mrf-pci 0000:16:0e.0: Emulating cable: Minimal
Oct 31 14:59:19 bodhi2 kernel: mrf-pci 0000:16:0e.0: MRF Setup complete
```

One can check the module verification failed via https://www.kernel.org/doc/Documentation/module-signing.txt


git push to the main repository as 


https://bitbucket.org/europeanspallationsource/m-epics-mrfioc2/commits/ac3d20405ec6d16aba9f86f0203d7049e1a6fef8?at=master