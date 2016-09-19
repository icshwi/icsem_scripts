# icsem_scripts
This repository may help users to follow up ICS engineering manual for many subsystem. The detailed instruction should be found in the corresponding manual per each subsystem. 

# Requirements

* CentOS 7.1 1503
* ESS Development Machine setup https://github.com/jeonghanlee/essdm_scripts

# Support Hardware

## MRF Products

* MRF PCIe-EVR-300DC
* MRF cPCI-EVR-230
* MRF MTCA-EVR-300 (in progress)


# Scripts

## mrf\_setup.bash
This scripts will help to compile the mrf kernel module and its dependent packages, and load the kernel module into the Linux kernel. In addition, it will configure the mrf module in order to load the module at boot time. Moreover, it will create the proper udev rule for the subsystem uio in order to allow an user to access the mrf hardware correctly. 

## Commands
``` 
[iocuser@ip7-186 icsem_scripts]$ bash mrf_setup.bash 


>>>> You are entering in the function git_compile_mrf


>>>> You are entering in the function git_clone
No git source repository in the expected location /home/iocuser/icsem_scripts/m-epics-mrfioc2
Cloning into 'm-epics-mrfioc2'...
remote: Counting objects: 7653, done.
remote: Compressing objects: 100% (2201/2201), done.
remote: Total 7653 (delta 5703), reused 7239 (delta 5410)
Receiving objects: 100% (7653/7653), 6.16 MiB | 2.86 MiB/s, done.
Resolving deltas: 100% (5703/5703), done.
<<<< You are leaving from the function git_clone

make -C /lib/modules/3.10.0-229.7.2.el7.x86_64/build M=/home/iocuser/icsem_scripts/m-epics-mrfioc2/mrmShared/linux modules 
make[1]: Entering directory `/usr/src/kernels/3.10.0-229.7.2.el7.x86_64'
  CC [M]  /home/iocuser/icsem_scripts/m-epics-mrfioc2/mrmShared/linux/uio_mrf.o
  CC [M]  /home/iocuser/icsem_scripts/m-epics-mrfioc2/mrmShared/linux/jtag_mrf.o
  LD [M]  /home/iocuser/icsem_scripts/m-epics-mrfioc2/mrmShared/linux/mrf.o
  Building modules, stage 2.
  MODPOST 1 modules
  CC      /home/iocuser/icsem_scripts/m-epics-mrfioc2/mrmShared/linux/mrf.mod.o
  LD [M]  /home/iocuser/icsem_scripts/m-epics-mrfioc2/mrmShared/linux/mrf.ko
make[1]: Leaving directory `/usr/src/kernels/3.10.0-229.7.2.el7.x86_64'
make -C /lib/modules/3.10.0-229.7.2.el7.x86_64/build M=/home/iocuser/icsem_scripts/m-epics-mrfioc2/mrmShared/linux modules_install 
make[1]: Entering directory `/usr/src/kernels/3.10.0-229.7.2.el7.x86_64'
  INSTALL /home/iocuser/icsem_scripts/m-epics-mrfioc2/mrmShared/linux/mrf.ko
Can't read private key
  DEPMOD  3.10.0-229.7.2.el7.x86_64
make[1]: Leaving directory `/usr/src/kernels/3.10.0-229.7.2.el7.x86_64'
make -C /lib/modules/3.10.0-229.7.2.el7.x86_64/build M=/home/iocuser/icsem_scripts/m-epics-mrfioc2/mrmShared/linux clean 
make[1]: Entering directory `/usr/src/kernels/3.10.0-229.7.2.el7.x86_64'
  CLEAN   /home/iocuser/icsem_scripts/m-epics-mrfioc2/mrmShared/linux/.tmp_versions
  CLEAN   /home/iocuser/icsem_scripts/m-epics-mrfioc2/mrmShared/linux/Module.symvers
make[1]: Leaving directory `/usr/src/kernels/3.10.0-229.7.2.el7.x86_64'
<<<< You are leaving from the function git_compile_mrf



>>>> You are entering in the function modprobe_mrf
<<<< You are leaving from the function modprobe_mrf



>>>> You are entering in the function put_mrf_rule
Put the rule : mrf in /etc/modules-load.d/mrf.conf to load the mrf module at boot time.
mrf
<<<< You are leaving from the function put_mrf_rule



>>>> You are entering in the function put_udev_rule
Put the rule : SUBSYSTEM=="uio", ATTR{name}=="mrf-pci", MODE="0666" in /etc/udev/rules.d/mrf.rules to be accessible via an user.
SUBSYSTEM=="uio", ATTR{name}=="mrf-pci", MODE="0666"
<<<< You are leaving from the function put_udev_rule

 0: SCRPIT      : /home/iocuser/icsem_scripts/mrf_setup.bash
 1: SCRIPT NAME : mrf_setup.bash
 2: SCRIPT TOP  : /home/iocuser/icsem_scripts
 3: LOGDATE     : 2016Sep19-1838-26CEST
 4: filename:       /lib/modules/3.10.0-229.7.2.el7.x86_64/extra/mrf.ko
author:         Michael Davidsaver <mdavidsaver@bnl.gov>
version:        1.0.1
license:        GPL v2
rhelversion:    7.1
srcversion:     59F05921D9DC9EE8699EA14
depends:        parport,uio
vermagic:       3.10.0-229.7.2.el7.x86_64 SMP mod_unload modversions 
parm:           cable:Name of JTAG parallel port cable to emulate (charp)
parm:           interfaceversion:User space interface version (int)
 5: mrf                    13496  0 
uio                    19259  1 mrf
parport                42348  1 mrf
[iocuser@ip7-186 icsem_scripts]$ 
```

# Notice
There is the mrf kernel module package kmod-mrfioc2, but it doesn't work with the most recent HW e.g., MRF PCIe-EVR-300DC, so I hacked the existent ESS ICS repository, to build the proper kernel module by myself. Please see https://bitbucket.org/jeonghanlee/m-epics-mrfioc2
