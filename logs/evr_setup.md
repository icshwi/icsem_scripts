## Make the ICS git source dir
```
[iocuser@localhost ~]$ mkdir ics_gitsrc
[iocuser@localhost ~]$ cd ics_gitsrc/
```


## PCI.IDS

* Cloning the sort of ESS customized PCI.IDS db
```
iocuser@localhost: ics_gitsrc$ git clone https://github.com/jeonghanlee/pciids
```



* Replace the pci.ids file
```
iocuser@localhost: pciids (master)$ bash replace-pciids.bash 
centos was determined.
[sudo] password for iocuser: 
```

* Check MRF products by the ventor's id (1a3e)
```
iocuser@localhost: pciids (master)$ lspci -nmmn | grep -E "\<(1a3e)"
05:00.0 "Signal processing controller [1180]" "Xilinx Corporation [10ee]" "XILINX PCI DEVICE [7011]" "Micro-Research Finland Oy [1a3e]" "MTCA Event Receiver 300 [132c]"
```
[iocuser@localhost ~]$ lspci -nmmn | grep -E "\<(1a3e)"
04:00.0 "Signal processing controller [1180]" "Xilinx Corporation [10ee]" "XILINX PCI DEVICE [7011]" "Micro-Research Finland Oy [1a3e]" "PCIE Event Receiver 300(DC) [172c]"
```

## Setup MRF environment

* Cloning ...
```
iocuser@localhost: ics_gitsrc$ git clone https://github.com/icshwi/icsem_scripts
```

* Check the following info

```
iocuser@localhost: icsem_scripts (master)$ bash mrf_setup.bash 

usage: mrf_setup.bash <arg>

          <arg> : info

          show  : show the found mrf boards information 

          pac   : mrf package from ESS (do not use now) 
                  We are working on this.... 

          src   : compile kernel module from git repository 
                  https://bitbucket.org/europeanspallationsource/m-epics-mrfioc2
                  tag name : ess-2-7

          rule : put only the mrf kernel and udev rules 

iocuser@localhost: icsem_scripts (master)$ bash mrf_setup.bash show

We've found the MRF boards as follows:
--------------------------------------
05:00.0 "Signal processing controller [1180]" "Xilinx Corporation [10ee]" "XILINX PCI DEVICE [7011]" "Micro-Research Finland Oy [1a3e]" "MTCA Event Receiver 300 [132c]"

iocuser@localhost: icsem_scripts (master)$ 

```


* Install kernel module
```
iocuser@localhost: icsem_scripts (master)$ bash mrf_setup.bash src
[sudo] password for iocuser: 

>>>> You are entering in  : git_compile_mrf

>>>> You are entering in  : git_clone
No git source repository in the expected location /home/iocuser/ics_gitsrc/icsem_scripts/m-epics-mrfioc2
Cloning into '/home/iocuser/ics_gitsrc/icsem_scripts/m-epics-mrfioc2'...
remote: Counting objects: 460, done.
remote: Compressing objects: 100% (364/364), done.
remote: Total 460 (delta 156), reused 246 (delta 84)
Receiving objects: 100% (460/460), 1.76 MiB | 1.34 MiB/s, done.
Resolving deltas: 100% (156/156), done.

<<<< You are leaving from : git_clone
~/ics_gitsrc/icsem_scripts/m-epics-mrfioc2/mrmShared/linux ~/ics_gitsrc/icsem_scripts
make -C /lib/modules/3.10.0-229.7.2.el7.x86_64/build M=/home/iocuser/ics_gitsrc/icsem_scripts/m-epics-mrfioc2/mrmShared/linux modules
make[1]: Entering directory `/usr/src/kernels/3.10.0-229.7.2.el7.x86_64'
  CC [M]  /home/iocuser/ics_gitsrc/icsem_scripts/m-epics-mrfioc2/mrmShared/linux/uio_mrf.o
  CC [M]  /home/iocuser/ics_gitsrc/icsem_scripts/m-epics-mrfioc2/mrmShared/linux/jtag_mrf.o
  LD [M]  /home/iocuser/ics_gitsrc/icsem_scripts/m-epics-mrfioc2/mrmShared/linux/mrf.o
  Building modules, stage 2.
  MODPOST 1 modules
  CC      /home/iocuser/ics_gitsrc/icsem_scripts/m-epics-mrfioc2/mrmShared/linux/mrf.mod.o
  LD [M]  /home/iocuser/ics_gitsrc/icsem_scripts/m-epics-mrfioc2/mrmShared/linux/mrf.ko
make[1]: Leaving directory `/usr/src/kernels/3.10.0-229.7.2.el7.x86_64'
make -C /lib/modules/3.10.0-229.7.2.el7.x86_64/build M=/home/iocuser/ics_gitsrc/icsem_scripts/m-epics-mrfioc2/mrmShared/linux modules_install
make[1]: Entering directory `/usr/src/kernels/3.10.0-229.7.2.el7.x86_64'
  INSTALL /home/iocuser/ics_gitsrc/icsem_scripts/m-epics-mrfioc2/mrmShared/linux/mrf.ko
Can't read private key
  DEPMOD  3.10.0-229.7.2.el7.x86_64
make[1]: Leaving directory `/usr/src/kernels/3.10.0-229.7.2.el7.x86_64'
make -C /lib/modules/3.10.0-229.7.2.el7.x86_64/build M=/home/iocuser/ics_gitsrc/icsem_scripts/m-epics-mrfioc2/mrmShared/linux clean
make[1]: Entering directory `/usr/src/kernels/3.10.0-229.7.2.el7.x86_64'
  CLEAN   /home/iocuser/ics_gitsrc/icsem_scripts/m-epics-mrfioc2/mrmShared/linux/.tmp_versions
  CLEAN   /home/iocuser/ics_gitsrc/icsem_scripts/m-epics-mrfioc2/mrmShared/linux/Module.symvers
make[1]: Leaving directory `/usr/src/kernels/3.10.0-229.7.2.el7.x86_64'
~/ics_gitsrc/icsem_scripts

<<<< You are leaving from : git_compile_mrf

>>>> You are entering in  : modprobe_mrf

<<<< You are leaving from : modprobe_mrf

>>>> You are entering in  : put_mrf_rule
Put the rule : mrf in /etc/modules-load.d/mrf.conf to load the mrf module at boot time.
mrf
<<<< You are leaving from : put_mrf_rule

>>>> You are entering in  : put_udev_rule
Put the rule : KERNEL=="uio*", ATTR{name}=="mrf-pci", MODE="0666" in /etc/udev/rules.d/99-mrfioc2.rules to be accessible via an user.
KERNEL=="uio*", ATTR{name}=="mrf-pci", MODE="0666"
<<<< You are leaving from : put_udev_rule
 0: SCRPIT      : /home/iocuser/ics_gitsrc/icsem_scripts/mrf_setup.bash
 1: SCRIPT NAME : mrf_setup.bash
 2: SCRIPT TOP  : /home/iocuser/ics_gitsrc/icsem_scripts
 3: LOGDATE     : 2017Feb06-1435-02CET
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
parport                42348  1 mrf
iocuser@localhost: icsem_scripts (master)$ 
```

* Check kernel module information
```
iocuser@localhost: icsem_scripts (master)$ lsmod |grep mrf
mrf                    17592  0 
uio                    19259  1 mrf
parport                42348  1 mrf
iocuser@localhost: icsem_scripts (master)$ modinfo mrf
filename:       /lib/modules/3.10.0-229.7.2.el7.x86_64/extra/mrf.ko
author:         Michael Davidsaver <mdavidsaver@bnl.gov>
version:        1
license:        GPL v2
rhelversion:    7.1
srcversion:     9E849DD3775C8555B8B88BF
depends:        parport,uio
vermagic:       3.10.0-229.7.2.el7.x86_64 SMP mod_unload modversions 
parm:           cable:Name of JTAG parallel port cable to emulate (charp)
parm:           interfaceversion:User space interface version (int)
iocuser@localhost: icsem_scripts (master)$ 
```
* Check that the source version is the same as shown; it should be if these steps are followed as shown. Otherwise please inform ICS


## Get the EPICS environment settings for your EVR
```
iocuser@localhost: icsem_scripts (master)$ bash mrf_epicsEnvSet.bash 


>>>>>>>>>>>>>>>>>>> snip snip >>>>>>>>>>>>>>>>>>>

# ESS EPICS Environment

#
# iocsh -3.14.12.5 "e3_startup_script".cmd
# require mrfioc2,edit_me

epicsEnvSet(       "SYS"     "edit_me")
epicsEnvSet(       "EVR"     "edit_me")
epicsEnvSet(   "EVR_BUS"        "0x05")
epicsEnvSet(   "EVR_DEV"        "0x00")
epicsEnvSet(  "EVR_FUNC"         "0x0")
epicsEnvSet("EVR_DOMAIN"      "0x0000")

mrmEvrSetupPCI($(EVR), $(EVR_DOMAIN), $(EVR_BUS), $(EVR_DEV), $(EVR_FUNC))

# dbLoadRecords example
# dbLoadRecords("edit_me", "DEVICE=$(EVR), SYS=$(SYS)")

<<<<<<<<<<<<<<<<<<< snip snip <<<<<<<<<<<<<<<<<<<

```

```
iocuser@localhost: icsem_scripts (master)$ cd mtca-evr-300/

iocuser@localhost: mtca-evr-300 (master)$ more  test_evr-mtca-300.cmd
#  -*- mode: epics -*-
# $ iocsh test_evr-mtca-300.cmd

require mrfioc2,2.7.13

epicsEnvSet(       "SYS"     "MTCA424")

epicsEnvSet(       "EVR"        "EVR0")
epicsEnvSet(   "EVR_BUS"        "0x05")
epicsEnvSet(   "EVR_DEV"        "0x00")
epicsEnvSet(  "EVR_FUNC"         "0x0")
epicsEnvSet("EVR_DOMAIN"      "0x0000")
mrmEvrSetupPCI($(EVR), $(EVR_DOMAIN), $(EVR_BUS), $(EVR_DEV), $(EVR_FUNC))

dbLoadRecords("evr-mtca-300.db", "DEVICE=$(EVR), SYS=$(SYS), Link-Clk-SP=88.0525")

iocInit


iocuser@localhost: mtca-evr-300 (master)$ iocsh test_evr-mtca-300.cmd
/opt/epics/bases/base-3.15.4/bin/centos7-x86_64/softIoc -D /opt/epics/bases/base-3.15.4/dbd/softIoc.dbd /tmp/iocsh.startup.4388
#date="Mon Feb  6 14:50:24 CET 2017"
#user="iocuser"
#PWD="/home/iocuser/ics_gitsrc/icsem_scripts/mtca-evr-300"
#EPICSVERSION="3.15.4"
#EPICS_HOST_ARCH="centos7-x86_64"
#SHELLBOX=""
#EPICS_CA_ADDR_LIST=""
#EPICS_MODULE_INCLUDE_PATH=".:/usr/lib64:/usr/lib:/lib64:/lib"
dlload         /opt/epics/modules/environment/1.8.2/3.15.4/lib/centos7-x86_64/libenvironment.so
dbLoadDatabase /opt/epics/modules/environment/1.8.2/3.15.4/dbd/environment.dbd
environment_registerRecordDeviceDriver
< "test_evr-mtca-300.cmd"
#  -*- mode: epics -*-
# $ iocsh test_evr-mtca-300.cmd
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
epicsEnvSet(       "SYS"     "MTCA424")
epicsEnvSet(       "EVR"        "EVR0")
epicsEnvSet(   "EVR_BUS"        "0x05")
epicsEnvSet(   "EVR_DEV"        "0x00")
epicsEnvSet(  "EVR_FUNC"         "0x0")
epicsEnvSet("EVR_DOMAIN"      "0x0000")
mrmEvrSetupPCI(EVR0, 0x0000, 0x05, 0x00, 0x0)
Device EVR0 5:0.0
Using IRQ 17
Setting magic LE number!
FPGA version 0x18000207
Firmware version: 00000207
Found EVR0:SFP0 SFP transceiver
Flash access: this form factor is not supported.
MTCA: Out FP:4 FPUNIV:16 RB:40 IFP:2 GPIO:0
dbLoadRecords("evr-mtca-300.db", "DEVICE=EVR0, SYS=MTCA424, Link-Clk-SP=88.0525")
iocInit
Starting iocInit
############################################################################
## EPICS R3.15.4-2016-05 $$Date$$
## EPICS Base built May 31 2016
############################################################################
MTCA424-EVR0:Time-Src-Sel_: read error: TS Clock rate invalid
Set EVR clock 88052500.000000
iocRun: All initialization complete
epicsEnvSet IOCSH_PS1,"localhost> "

```

## Reboot and check that the module is loaded and the IOC correctly starts
```
iocuser@localhost: ~$ lsmod |grep mrf
mrf                    17592  0 
uio                    19259  1 mrf
parport                42348  1 mrf
iocuser@localhost: ~$ cd ics_gitsrc/icsem_scripts/mtca-evr-300/
iocuser@localhost: mtca-evr-300 (master)$ iocsh test_evr-mtca-300.cmd
/opt/epics/bases/base-3.15.4/bin/centos7-x86_64/softIoc -D /opt/epics/bases/base-3.15.4/dbd/softIoc.dbd /tmp/iocsh.startup.2998
#date="Mon Feb  6 15:10:42 CET 2017"
#user="iocuser"
#PWD="/home/iocuser/ics_gitsrc/icsem_scripts/mtca-evr-300"
#EPICSVERSION="3.15.4"
#EPICS_HOST_ARCH="centos7-x86_64"
#SHELLBOX=""
#EPICS_CA_ADDR_LIST=""
#EPICS_MODULE_INCLUDE_PATH=".:/usr/lib64:/usr/lib:/lib64:/lib"
dlload         /opt/epics/modules/environment/1.8.2/3.15.4/lib/centos7-x86_64/libenvironment.so
dbLoadDatabase /opt/epics/modules/environment/1.8.2/3.15.4/dbd/environment.dbd
environment_registerRecordDeviceDriver
< "test_evr-mtca-300.cmd"
#  -*- mode: epics -*-
# $ iocsh test_evr-mtca-300.cmd
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
epicsEnvSet(       "SYS"     "MTCA424")
epicsEnvSet(       "EVR"        "EVR0")
epicsEnvSet(   "EVR_BUS"        "0x05")
epicsEnvSet(   "EVR_DEV"        "0x00")
epicsEnvSet(  "EVR_FUNC"         "0x0")
epicsEnvSet("EVR_DOMAIN"      "0x0000")
mrmEvrSetupPCI(EVR0, 0x0000, 0x05, 0x00, 0x0)
Device EVR0 5:0.0
Using IRQ 17
Setting magic LE number!
FPGA version 0x18000207
Firmware version: 00000207
Found EVR0:SFP0 SFP transceiver
Flash access: this form factor is not supported.
MTCA: Out FP:4 FPUNIV:16 RB:40 IFP:2 GPIO:0
dbLoadRecords("evr-mtca-300.db", "DEVICE=EVR0, SYS=MTCA424, Link-Clk-SP=88.0525")
iocInit
Starting iocInit
############################################################################
## EPICS R3.15.4-2016-05 $$Date$$
## EPICS Base built May 31 2016
############################################################################
Set EVR clock 88052500.000000
iocRun: All initialization complete
epicsEnvSet IOCSH_PS1,"localhost> "
localhost> 




[iocuser@localhost icsem_scripts]$ bash mrf_epicsEnvSet.bash 


>>>>>>>>>>>>>>>>>>> snip snip >>>>>>>>>>>>>>>>>>>

# ESS EPICS Environment

#
# iocsh -3.14.12.5 "e3_startup_script".cmd
# require mrfioc2,edit_me

epicsEnvSet(       "SYS"     "edit_me")
epicsEnvSet(       "EVR"     "edit_me")
epicsEnvSet(   "EVR_BUS"        "0x04")
epicsEnvSet(   "EVR_DEV"        "0x00")
epicsEnvSet(  "EVR_FUNC"         "0x0")
epicsEnvSet("EVR_DOMAIN"      "0x0000")

mrmEvrSetupPCI($(EVR), $(EVR_DOMAIN), $(EVR_BUS), $(EVR_DEV), $(EVR_FUNC))

# dbLoadRecords example
# dbLoadRecords("edit_me", "DEVICE=$(EVR), SYS=$(SYS)")

<<<<<<<<<<<<<<<<<<< snip snip <<<<<<<<<<<<<<<<<<<

[iocuser@localhost icsem_scripts]$ bash mrf_setup.bash show

We've found the MRF boards as follows:
--------------------------------------
04:00.0 "Signal processing controller [1180]" "Xilinx Corporation [10ee]" "XILINX PCI DEVICE [7011]" "Micro-Research Finland Oy [1a3e]" "MTCA Event Receiver 300 [132c]"

[iocuser@localhost icsem_scripts]$ ls
bash_functions  cpci-evg-230     LICENSE  m-epics-mrfioc2                       mrf_env.conf          mrf_setup.bash  pcie-evr-300dc        README.md  tests
cpci-evg-220    git_commands.md  logs     m-epics-mrfioc2_2017Feb06-1625-28CET  mrf_epicsEnvSet.bash  mtca-evr-300    pcie-evr-300dc-2-old  scripts    vme-evg-230
[iocuser@localhost icsem_scripts]$ cd pcie-evr-300dc
[iocuser@localhost pcie-evr-300dc]$ ls
test_evr-pcie-300dc.cmd  test_evr-pcie-300dc.cmd~
[iocuser@localhost pcie-evr-300dc]$ iocsh test_evr-pcie-300dc.cmd
/opt/epics/bases/base-3.15.4/bin/centos7-x86_64/softIoc -D /opt/epics/bases/base-3.15.4/dbd/softIoc.dbd /tmp/iocsh.startup.2356
#date="Mon Feb  6 16:29:26 CET 2017"
#user="iocuser"
#PWD="/home/iocuser/ics_gitsrc/icsem_scripts/pcie-evr-300dc"
#EPICSVERSION="3.15.4"
#EPICS_HOST_ARCH="centos7-x86_64"
#SHELLBOX=""
#EPICS_CA_ADDR_LIST=""
#EPICS_MODULE_INCLUDE_PATH=".:/usr/lib64:/usr/lib:/lib64:/lib"
dlload         /opt/epics/modules/environment/1.8.2/3.15.4/lib/centos7-x86_64/libenvironment.so
dbLoadDatabase /opt/epics/modules/environment/1.8.2/3.15.4/dbd/environment.dbd
environment_registerRecordDeviceDriver
< "test_evr-pcie-300dc.cmd"
#  -*- mode: epics -*-
# $ iocsh test_evr-mtca-300.cmd
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
epicsEnvSet(       "SYS"        "PCIE")
epicsEnvSet(       "EVR"        "EVR0")
epicsEnvSet(   "EVR_BUS"        "0x04")
epicsEnvSet(   "EVR_DEV"        "0x00")
epicsEnvSet(  "EVR_FUNC"         "0x0")
epicsEnvSet("EVR_DOMAIN"      "0x0000")
mrmEvrSetupPCI(EVR0, 0x0000, 0x04, 0x00, 0x0)
Device EVR0 4:0.0
Using IRQ 18
Setting magic LE number!
FPGA version 0x17000205
Firmware version: 00000205
Found EVR0:SFP0 SFP transceiver
PCIe: Out FP:0 FPUNIV:16 RB:0 IFP:0 GPIO:0
dbLoadRecords("evr-pcie-300.db", "DEVICE=EVR0, SYS=PCIE, Link-Clk-SP=88.0525")
iocInit
Starting iocInit
############################################################################
## EPICS R3.15.4-2016-05 $$Date$$
## EPICS Base built May 31 2016
############################################################################
PCIE-EVR0:Time-Src-Sel_: read error: TS Clock rate invalid
Set EVR clock 88052500.000000
iocRun: All initialization complete
epicsEnvSet IOCSH_PS1,"localhost> "
localhost> 


```

