# icsem_scripts
This repository may help users to follow up ICS engineering manual for many subsystem, especially timing system. The detailed instruction should be found in the corresponding manual per each subsystem. 

# Requirements

* CentOS 7.1 1503
* ESS Development Machine setup https://github.com/jeonghanlee/essdm_scripts

# Support Hardware

Please see mrf_env.conf 


# Scripts

## mrf\_setup.bash
This scripts will help to compile the mrf kernel module and its dependent packages, and load the kernel module into the Linux kernel. In addition, it will configure the mrf module in order to load the module at boot time. Moreover, it will create the proper udev rule for the subsystem uio in order to allow an user to access the mrf hardware correctly. 


```
usage: mrf_setup.bash <arg>

          arg   : explaination
          ---     ------------
          pac   : mrf package from ESS (do not use now) 
                  We are working on this.... 

          src   : compile kernel module from git repository 
                  tag name : han

          rules : put only the mrf kernel and udev rules 
```

## Commands
``` 
iocuser@ics-cpci2-cpu1:~/gitsrc/icsem_scripts (master)$ bash mrf_setup.bash src

We've found the MRF boards as follows:
10:09.0 "Signal processing controller [1180]" "PLX Technology, Inc. [10b5]" "PCI9030 32-bit 33MHz PCI <-> IOBus Bridge [9030]" -r01 "Micro-Research Finland Oy [1a3e]" "CPCI Event Receiver 230 [10e6]"
10:0d.0 "Signal processing controller [1180]" "PLX Technology, Inc. [10b5]" "PCI9030 32-bit 33MHz PCI <-> IOBus Bridge [9030]" -r01 "Micro-Research Finland Oy [1a3e]" "CPCI Event Generator 230 [20e6]"

[sudo] password for iocuser: 

>>>> You are entering in  : git_compile_mrf

<<<< You are leaving from : git_clone
~/gitsrc/icsem_scripts/m-epics-mrfioc2/mrmShared/linux ~/gitsrc/icsem_scripts
make -C /lib/modules/3.10.0-229.7.2.el7.x86_64/build M=/home/iocuser/gitsrc/icsem_scripts/m-epics-mrfioc2/mrmShared/linux modules
make[1]: Entering directory `/usr/src/kernels/3.10.0-229.7.2.el7.x86_64'
  CC [M]  /home/iocuser/gitsrc/icsem_scripts/m-epics-mrfioc2/mrmShared/linux/uio_mrf.o
  CC [M]  /home/iocuser/gitsrc/icsem_scripts/m-epics-mrfioc2/mrmShared/linux/jtag_mrf.o
  LD [M]  /home/iocuser/gitsrc/icsem_scripts/m-epics-mrfioc2/mrmShared/linux/mrf.o
  Building modules, stage 2.
  MODPOST 1 modules
  CC      /home/iocuser/gitsrc/icsem_scripts/m-epics-mrfioc2/mrmShared/linux/mrf.mod.o
  LD [M]  /home/iocuser/gitsrc/icsem_scripts/m-epics-mrfioc2/mrmShared/linux/mrf.ko
make[1]: Leaving directory `/usr/src/kernels/3.10.0-229.7.2.el7.x86_64'
make -C /lib/modules/3.10.0-229.7.2.el7.x86_64/build M=/home/iocuser/gitsrc/icsem_scripts/m-epics-mrfioc2/mrmShared/linux modules_install
make[1]: Entering directory `/usr/src/kernels/3.10.0-229.7.2.el7.x86_64'
  INSTALL /home/iocuser/gitsrc/icsem_scripts/m-epics-mrfioc2/mrmShared/linux/mrf.ko
Can't read private key
  DEPMOD  3.10.0-229.7.2.el7.x86_64
make[1]: Leaving directory `/usr/src/kernels/3.10.0-229.7.2.el7.x86_64'
make -C /lib/modules/3.10.0-229.7.2.el7.x86_64/build M=/home/iocuser/gitsrc/icsem_scripts/m-epics-mrfioc2/mrmShared/linux clean
make[1]: Entering directory `/usr/src/kernels/3.10.0-229.7.2.el7.x86_64'
  CLEAN   /home/iocuser/gitsrc/icsem_scripts/m-epics-mrfioc2/mrmShared/linux/.tmp_versions
  CLEAN   /home/iocuser/gitsrc/icsem_scripts/m-epics-mrfioc2/mrmShared/linux/Module.symvers
make[1]: Leaving directory `/usr/src/kernels/3.10.0-229.7.2.el7.x86_64'
~/gitsrc/icsem_scripts

<<<< You are leaving from : git_compile_mrf

>>>> You are entering in  : modprobe_mrf

<<<< You are leaving from : modprobe_mrf

>>>> You are entering in  : put_mrf_rule
Put the rule : mrf in /etc/modules-load.d/mrf.conf to load the mrf module at boot time.
mrf
<<<< You are leaving from : put_mrf_rule

>>>> You are entering in  : put_udev_rule
Put the rule : SUBSYSTEM=="uio", ATTR{name}=="mrf-pci", MODE="0666" in /etc/udev/rules.d/mrf.rules to be accessible via an user.
SUBSYSTEM=="uio", ATTR{name}=="mrf-pci", MODE="0666"
<<<< You are leaving from : put_udev_rule
 0: SCRPIT      : /home/iocuser/gitsrc/icsem_scripts/mrf_setup.bash
 1: SCRIPT NAME : mrf_setup.bash
 2: SCRIPT TOP  : /home/iocuser/gitsrc/icsem_scripts
 3: LOGDATE     : 2016Nov11-1507-48CET
 4: filename:       /lib/modules/3.10.0-229.7.2.el7.x86_64/extra/mrf.ko
author:         Michael Davidsaver <mdavidsaver@bnl.gov>
version:        1
license:        GPL v2
rhelversion:    7.1
srcversion:     9E849DD3775C8555B8B88BF
depends:        parport,uio
vermagic:       3.10.0-229.7.2.el7.x86_64 SMP mod_unload modversions 
parm:           cable:Name of JTAG parallel port cable to emulate (charp)
parm:           interfaceversion:User space interface version (int)
 5: mrf                    17592  0 
uio                    19259  1 mrf
parport                42348  3 mrf,ppdev,parport_pc
iocuser@ics-cpci2-cpu1:~/gitsrc/icsem_scripts (master)$


iocuser@ics-cpci2-cpu1:~/gitsrc/icsem_scripts (master)$ ls -ltar /dev/uio*
crw-rw-rw-. 1 root root 247, 0 Nov 11 15:08 /dev/uio0
crw-rw-rw-. 1 root root 247, 1 Nov 11 15:08 /dev/uio1
iocuser@ics-cpci2-cpu1:~/gitsrc/icsem_scripts (master)$

```

# Notice
There is the mrf kernel module package kmod-mrfioc2, but it doesn't work with the most recent HW. We are working on them slowly.
