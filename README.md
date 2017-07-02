----------------------------------------------------------------------------------
Fate/Grand Order patch - based on AnyKernel2
----------------------------------------------------------------------------------
This patch update default.prop and build.prop to let android user with unrooted LineageOS based ROM to play Fate/Grand Order and possibly other app that detect "root".

The patch is device specific for now as different device have different boot partition and auto detect boot partition is not implemented for now.

Device with AVB or device that require extra step to sign boot image or mount system partition probably won't work and at worst you need to flash stock boot if it cause bootloop
