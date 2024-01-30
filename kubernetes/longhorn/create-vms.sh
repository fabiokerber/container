#!/bin/bash

#ISO & VM_PATH SPECS
VM_PATH='VirtualBox VMs'
ISO_PATH='/tmp'
ISO_NAME='debian-12.4.0-amd64-netinst.iso'
ISO_URL='https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-12.4.0-amd64-netinst.iso'
FW_ISO_NAME='alpine-virt-3.18.4-x86_64.iso'
FW_ISO_URL='https://dl-cdn.alpinelinux.org/alpine/v3.18/releases/x86_64/alpine-virt-3.18.4-x86_64.iso'

#KMASTER SPECS
MS_NAME='kmaster-'
MS_COUNT=1
MS_PRC=2
MS_MEM=4096
MS_DSK=8192

#KWORKER SPECS
WK_NAME='kworker-'
WK_COUNT=3
WK_PRC=4
WK_MEM=4096
WK_DSK=40960

#FIREWALL-NFS SPECS
FW_NAME='firewall-nfs-'
FW_COUNT=1
FW_PRC=1
FW_MEM=512
FW_DSK=40960
FW_NET='wlp0s20f3'

#DOWNLOAD ISO's
wget -c "$ISO_URL" -O "$ISO_PATH"/"$ISO_NAME"
openssl sha1 "$ISO_PATH"/"$ISO_NAME"

wget -c "$FW_ISO_URL" -O "$ISO_PATH"/"$FW_ISO_NAME"
openssl sha1 "$ISO_PATH"/"$FW_ISO_NAME"

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
    VBoxManage createvm --name "$MS_NAME"$i.fks.lab --ostype Debian_64 --register
    VBoxManage modifyvm "$MS_NAME"$i.fks.lab --memory "$MS_MEM" --cpus "$MS_PRC" --graphicscontroller vmsvga --acpi on --pae off --hwvirtex on --nestedpaging on --rtcuseutc on --vram 16 --audio pulse --audiocontroller ac97 --accelerate3d off --accelerate2dvideo off --usb on --audioout off
    VBoxManage modifyvm "$MS_NAME"$i.fks.lab --boot1 dvd --boot2 disk --boot3 none --boot4 none
    VBoxManage modifyvm "$MS_NAME"$i.fks.lab --nic1 hostonly --hostonlyadapter1 vboxnet0 --nicpromisc1 allow-all
    VBoxManage storagectl "$MS_NAME"$i.fks.lab --name "IDE" --add ide
    VBoxManage storagectl "$MS_NAME"$i.fks.lab --name "SATA" --add sata
    VBoxManage storageattach "$MS_NAME"$i.fks.lab --storagectl "SATA" --port 0 --device 0 --type hdd --medium $HOME/"$VM_PATH"/"$MS_NAME"$i.fks.lab/"$MS_NAME"$i.fks.lab-1.vdi
    VBoxManage storageattach "$MS_NAME"$i.fks.lab --storagectl "IDE" --port 0 --device 0 --type dvddrive --medium "$ISO_PATH"/"$ISO_NAME"
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
    VBoxManage createhd --filename $HOME/"$VM_PATH"/"$WK_NAME"$i.fks.lab/"$WK_NAME"$i.fks.lab-2.vdi --size "$WK_DSK"
    VBoxManage createvm --name "$WK_NAME"$i.fks.lab --ostype Debian_64 --register
    VBoxManage modifyvm "$WK_NAME"$i.fks.lab --memory "$WK_MEM" --cpus "$WK_PRC" --graphicscontroller vmsvga --acpi on --pae off --hwvirtex on --nestedpaging on --rtcuseutc on --vram 16 --audio pulse --audiocontroller ac97 --accelerate3d off --accelerate2dvideo off --usb on --audioout off
    VBoxManage modifyvm "$WK_NAME"$i.fks.lab --boot1 dvd --boot2 disk --boot3 none --boot4 none
    VBoxManage modifyvm "$WK_NAME"$i.fks.lab --nic1 hostonly --hostonlyadapter1 vboxnet0 --nicpromisc1 allow-all
    VBoxManage storagectl "$WK_NAME"$i.fks.lab --name "IDE" --add ide
    VBoxManage storagectl "$WK_NAME"$i.fks.lab --name "SATA" --add sata
    VBoxManage storageattach "$WK_NAME"$i.fks.lab --storagectl "SATA" --port 0 --device 0 --type hdd --medium $HOME/"$VM_PATH"/"$WK_NAME"$i.fks.lab/"$WK_NAME"$i.fks.lab-1.vdi
    VBoxManage storageattach "$WK_NAME"$i.fks.lab --storagectl "SATA" --port 1 --device 0 --type hdd --medium $HOME/"$VM_PATH"/"$WK_NAME"$i.fks.lab/"$WK_NAME"$i.fks.lab-2.vdi
    VBoxManage storageattach "$WK_NAME"$i.fks.lab --storagectl "IDE" --port 0 --device 0 --type dvddrive --medium "$ISO_PATH"/"$ISO_NAME"
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
    VBoxManage modifyvm "$FW_NAME"$i.fks.lab --memory "$FW_MEM" --cpus "$FW_PRC" --graphicscontroller vmsvga --acpi on --pae off --hwvirtex on --nestedpaging on --rtcuseutc on --vram 16 --audio pulse --audiocontroller ac97 --accelerate3d off --accelerate2dvideo off --usb on --audioout off
    VBoxManage modifyvm "$FW_NAME"$i.fks.lab --boot1 dvd --boot2 disk --boot3 none --boot4 none
    VBoxManage modifyvm "$FW_NAME"$i.fks.lab --nic1 hostonly --hostonlyadapter1 vboxnet0 --nicpromisc1 allow-all
    VBoxManage modifyvm "$FW_NAME"$i.fks.lab --nic2 nat
    VBoxManage storagectl "$FW_NAME"$i.fks.lab --name "IDE" --add ide
    VBoxManage storagectl "$FW_NAME"$i.fks.lab --name "SATA" --add sata
    VBoxManage storageattach "$FW_NAME"$i.fks.lab --storagectl "SATA" --port 0 --device 0 --type hdd --medium $HOME/"$VM_PATH"/"$FW_NAME"$i.fks.lab/"$FW_NAME"$i.fks.lab-1.vdi
    VBoxManage storageattach "$FW_NAME"$i.fks.lab --storagectl "IDE" --port 0 --device 0 --type dvddrive --medium "$ISO_PATH"/"$FW_ISO_NAME"
    VBoxManage startvm "$FW_NAME"$i.fks.lab
done
