#!/bin/bash

#ISO & VM_PATH SPECS
VM_PATH='VirtualBox VMs'
ISO_PATH='/tmp'
ISO_NAME='alpine-virt-3.17.2-x86_64.iso'
ISO_URL='https://dl-cdn.alpinelinux.org/alpine/v3.17/releases/x86_64/alpine-virt-3.17.2-x86_64.iso'

#KMASTER SPECS
MS_NAME='kmaster'
MS_COUNT=1
MS_PRC=2
MS_MEM=1024
MS_DSK=4096

#KWORKER SPECS
WK_NAME='kworker'
WK_COUNT=2
WK_PRC=4
WK_MEM=2048
WK_DSK=8096

#FIREWALL SPECS
FW_NAME='firewall'
FW_COUNT=1
FW_PRC=1
FW_MEM=256
FW_DSK=2048
FW_NET='wlp0s20f3'

#GRAFANA SPECS
GR_NAME='grafana'
GR_COUNT=1
GR_PRC=2
GR_MEM=2048
GR_DSK=4096

#DOWNLOAD ISO
wget -c -O "$ISO_PATH"/"$ISO_NAME" "$ISO_URL"
openssl sha1 "$ISO_PATH"/"$ISO_NAME"

#CREATE KMASTER
for i in $(seq 1 $MS_COUNT)
do
    VBoxManage controlvm "$MS_NAME"$i.fks.lab poweroff 2>/dev/null
    sleep 3
    VBoxManage unregistervm --delete "$MS_NAME"$i.fks.lab 2>/dev/null
    sleep 3
    rm -rf $HOME/"$VM_PATH"/"$MS_NAME"$i.fks.lab 2>/dev/null
    mkdir $HOME/"$VM_PATH"/"$MS_NAME"$i.fks.lab 2>/dev/null
    VBoxManage createhd --filename $HOME/"$VM_PATH"/"$MS_NAME"$i.fks.lab/"$MS_NAME"$i.fks.lab-1.vdi --size "$MS_DSK"
    VBoxManage createvm --name "$MS_NAME"$i.fks.lab --ostype Linux_64 --register
    VBoxManage modifyvm "$MS_NAME"$i.fks.lab --memory "$MS_MEM" --cpus "$MS_PRC" --graphicscontroller vmsvga --acpi on --pae off --hwvirtex on --nestedpaging on --rtcuseutc on --vram 16 --audio none --accelerate3d off --accelerate2dvideo off --usb on
    VBoxManage modifyvm "$MS_NAME"$i.fks.lab --boot1 dvd --boot2 disk --boot3 none --boot4 none
    VBoxManage modifyvm "$MS_NAME"$i.fks.lab --nic1 hostonly --hostonlyadapter1 vboxnet0 --nicpromisc1 allow-all
    VBoxManage storagectl "$MS_NAME"$i.fks.lab --name "IDE" --add ide
    VBoxManage storagectl "$MS_NAME"$i.fks.lab --name "SATA" --add sata
    VBoxManage storageattach "$MS_NAME"$i.fks.lab --storagectl "SATA" --port 0 --device 0 --type hdd --medium $HOME/"$VM_PATH"/"$MS_NAME"$i.fks.lab/"$MS_NAME"$i.fks.lab-1.vdi
    VBoxManage storageattach "$MS_NAME"$i.fks.lab --storagectl "IDE" --port 1 --device 0 --type dvddrive --medium "$ISO_PATH"/"$ISO_NAME"
    VBoxManage startvm "$MS_NAME"$i.fks.lab
done

#CREATE KWORKER
for i in $(seq 1 $WK_COUNT)
do
    VBoxManage controlvm "$WK_NAME"$i.fks.lab poweroff 2>/dev/null
    sleep 3
    VBoxManage unregistervm --delete "$WK_NAME"$i.fks.lab 2>/dev/null
    sleep 3
    rm -rf $HOME/"$VM_PATH"/"$WK_NAME"$i.fks.lab 2>/dev/null
    mkdir $HOME/"$VM_PATH"/"$WK_NAME"$i.fks.lab 2>/dev/null
    VBoxManage createhd --filename $HOME/"$VM_PATH"/"$WK_NAME"$i.fks.lab/"$WK_NAME"$i.fks.lab-1.vdi --size "$WK_DSK"
    VBoxManage createvm --name "$WK_NAME"$i.fks.lab --ostype Linux_64 --register
    VBoxManage modifyvm "$WK_NAME"$i.fks.lab --memory "$WK_MEM" --cpus "$WK_PRC" --graphicscontroller vmsvga --acpi on --pae off --hwvirtex on --nestedpaging on --rtcuseutc on --vram 16 --audio none --accelerate3d off --accelerate2dvideo off --usb on
    VBoxManage modifyvm "$WK_NAME"$i.fks.lab --boot1 dvd --boot2 disk --boot3 none --boot4 none
    VBoxManage modifyvm "$WK_NAME"$i.fks.lab --nic1 hostonly --hostonlyadapter1 vboxnet0 --nicpromisc1 allow-all
    VBoxManage storagectl "$WK_NAME"$i.fks.lab --name "IDE" --add ide
    VBoxManage storagectl "$WK_NAME"$i.fks.lab --name "SATA" --add sata
    VBoxManage storageattach "$WK_NAME"$i.fks.lab --storagectl "SATA" --port 0 --device 0 --type hdd --medium $HOME/"$VM_PATH"/"$WK_NAME"$i.fks.lab/"$WK_NAME"$i.fks.lab-1.vdi
    VBoxManage storageattach "$WK_NAME"$i.fks.lab --storagectl "IDE" --port 1 --device 0 --type dvddrive --medium "$ISO_PATH"/"$ISO_NAME"
    VBoxManage startvm "$WK_NAME"$i.fks.lab
done

#CREATE FIREWALL
for i in $(seq 1 $FW_COUNT)
do
    VBoxManage controlvm "$FW_NAME"$i.fks.lab poweroff 2>/dev/null
    sleep 3
    VBoxManage unregistervm --delete "$FW_NAME"$i.fks.lab 2>/dev/null
    sleep 3
    rm -rf $HOME/"$VM_PATH"/"$FW_NAME"$i.fks.lab 2>/dev/null
    mkdir $HOME/"$VM_PATH"/"$FW_NAME"$i.fks.lab 2>/dev/null
    VBoxManage createhd --filename $HOME/"$VM_PATH"/"$FW_NAME"$i.fks.lab/"$FW_NAME"$i.fks.lab-1.vdi --size "$FW_DSK"
    VBoxManage createvm --name "$FW_NAME"$i.fks.lab --ostype Linux_64 --register
    VBoxManage modifyvm "$FW_NAME"$i.fks.lab --memory "$FW_MEM" --cpus "$FW_PRC" --graphicscontroller vmsvga --acpi on --pae off --hwvirtex on --nestedpaging on --rtcuseutc on --vram 16 --audio none --accelerate3d off --accelerate2dvideo off --usb on
    VBoxManage modifyvm "$FW_NAME"$i.fks.lab --boot1 dvd --boot2 disk --boot3 none --boot4 none
    VBoxManage modifyvm "$FW_NAME"$i.fks.lab --nic1 hostonly --hostonlyadapter1 vboxnet0 --nicpromisc1 allow-all
    VBoxManage modifyvm "$FW_NAME"$i.fks.lab --nic2 nat
    VBoxManage storagectl "$FW_NAME"$i.fks.lab --name "IDE" --add ide
    VBoxManage storagectl "$FW_NAME"$i.fks.lab --name "SATA" --add sata
    VBoxManage storageattach "$FW_NAME"$i.fks.lab --storagectl "SATA" --port 0 --device 0 --type hdd --medium $HOME/"$VM_PATH"/"$FW_NAME"$i.fks.lab/"$FW_NAME"$i.fks.lab-1.vdi
    VBoxManage storageattach "$FW_NAME"$i.fks.lab --storagectl "IDE" --port 1 --device 0 --type dvddrive --medium "$ISO_PATH"/"$ISO_NAME"
    VBoxManage startvm "$FW_NAME"$i.fks.lab
done

#CREATE GRAFANA
for i in $(seq 1 $GR_COUNT)
do
    VBoxManage controlvm "$GR_NAME"$i.fks.lab poweroff 2>/dev/null
    sleep 3
    VBoxManage unregistervm --delete "$GR_NAME"$i.fks.lab 2>/dev/null
    sleep 3
    rm -rf $HOME/"$VM_PATH"/"$GR_NAME"$i.fks.lab 2>/dev/null
    mkdir $HOME/"$VM_PATH"/"$GR_NAME"$i.fks.lab 2>/dev/null
    VBoxManage createhd --filename $HOME/"$VM_PATH"/"$GR_NAME"$i.fks.lab/"$GR_NAME"$i.fks.lab-1.vdi --size "$GR_DSK"
    VBoxManage createvm --name "$GR_NAME"$i.fks.lab --ostype Linux_64 --register
    VBoxManage modifyvm "$GR_NAME"$i.fks.lab --memory "$GR_MEM" --cpus "$GR_PRC" --graphicscontroller vmsvga --acpi on --pae off --hwvirtex on --nestedpaging on --rtcuseutc on --vram 16 --audio none --accelerate3d off --accelerate2dvideo off --usb on
    VBoxManage modifyvm "$GR_NAME"$i.fks.lab --boot1 dvd --boot2 disk --boot3 none --boot4 none
    VBoxManage modifyvm "$GR_NAME"$i.fks.lab --nic1 hostonly --hostonlyadapter1 vboxnet0 --nicpromisc1 allow-all
    VBoxManage storagectl "$GR_NAME"$i.fks.lab --name "IDE" --add ide
    VBoxManage storagectl "$GR_NAME"$i.fks.lab --name "SATA" --add sata
    VBoxManage storageattach "$GR_NAME"$i.fks.lab --storagectl "SATA" --port 0 --device 0 --type hdd --medium $HOME/"$VM_PATH"/"$GR_NAME"$i.fks.lab/"$GR_NAME"$i.fks.lab-1.vdi
    VBoxManage storageattach "$GR_NAME"$i.fks.lab --storagectl "IDE" --port 1 --device 0 --type dvddrive --medium "$ISO_PATH"/"$ISO_NAME"
    VBoxManage startvm "$GR_NAME"$i.fks.lab
done