# AnyKernel2 Ramdisk Mod Script
# osm0sis @ xda-developers

## AnyKernel setup
# begin properties
properties() {
kernel.string=FGO Patch
do.devicecheck=1
do.modules=0
do.cleanup=1
do.cleanuponabort=0
device.name1=Z008
device.name2=
device.name3=
device.name4=
device.name5=
} # end properties

# shell variables
block=/dev/block/by-name/boot;
is_slot_device=0;


## AnyKernel methods (DO NOT CHANGE)
# import patching functions/variables - see for reference
. /tmp/anykernel/tools/ak2-core.sh;

#method to sign kernel
# dump boot
dump_zf2boot() {
  dd if=$block of=/tmp/anykernel/old_boot.img;
  /tmp/anykernel/tools/zf2_unmkbootimg /tmp/anykernel/old_boot.img;
  echo "BOOT REDUMPED TO /tmp!";
}

# append certificate and write image
write_zf2boot() {
  /tmp/anykernel/tools/zf2_mkbootimg --kernel kernel.gz --ramdisk initramfs.cpio.gz --cmdline "init=/init pci=noearly console=logk0 loglevel=0 vmalloc=256M androidboot.hardware=mofd_v1 watchdog.watchdog_thresh=60 androidboot.spid=xxxx:xxxx:xxxx:xxxx:xxxx:xxxx androidboot.serialno=01234567890123456789 gpt snd_pcm.maximum_substreams=8 ptrace.ptrace_can_access=1 panic=15 ip=50.0.0.2:50.0.0.1::255.255.255.0::usb0:on debug_locks=0 n_gsm.mux_base_conf=\"ttyACM0,0 ttyXMM0,1\" bootboost=1" --base 0x10000000 --pagesize 2048 --ramdisk_offset 0x01000000 --tags_offset 0x00000100 --second second.gz -o /tmp/anykernel/new_boot.img;

cat /tmp/anykernel/new_boot.img /tmp/anykernel/tools/zf2_boot.sig > /tmp/anykernel/zf2_boot.img;
dd if=/tmp/anykernel/zf2_boot.img of=$block;
echo "SIGNED";
}

## AnyKernel permissions
# set permissions for included ramdisk files
#chmod -R 755 $ramdisk
#chmod 644 $ramdisk/sbin/media_profiles.xml


ui_print "[#] Updating default.prop..."
## AnyKernel install
dump_boot;

# begin ramdisk changes

# update default.prop
patch_prop "default.prop" "ro.debuggable" "0"
patch_prop "default.prop" "persist.sys.usb.config" "mtp"

# end ramdisk changes

write_boot;

ui_print "[#] Done"
# signing boot
ui_print "[#] Signing boot..."
dump_zf2boot;
write_zf2boot;
ui_print "[#] Done"

# start system changes
ui_print "[#] Updating build.prop..."

patch_prop "/system/build.prop" "ro.build.type" "user"

ui_print "[#] Done"

## end install

