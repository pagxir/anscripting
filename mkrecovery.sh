# define android file name & kernel file name
MY_DIR=`pwd`
FILE=../out/target/product/Hi3716C
cd $MY_DIR
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
mkdir -p ./update
rm -rf $FILE/recovery
mkdir -p $FILE/recovery/root/etc
mkdir -p $FILE/recovery/root/tmp
cp -R $FILE/root  $FILE/recovery
cp -f ../bootable/recovery/etc/init.rc  $FILE/recovery/root/
cp -f $FILE/obj/EXECUTABLES/recovery_intermediates/recovery  $FILE/recovery/root/sbin/
cp -rf ../bootable/recovery/res  $FILE/recovery/root/
cp ./keys  $FILE/recovery/root/res/keys
cat $FILE/root/default.prop  $FILE/system/build.prop >$FILE/recovery/root/default.prop
#rm -rf $FILE/recovery/root/sbin/adbd

if   [  -e   .config ]
then
 echo ".config existed "
else
 make hi3716c-android-tv-recovery_defconfig
fi
make uImage -j64 CONFIG_INITRAMFS_SOURCE=$FILE/recovery/root
cp ./arch/arm/boot/uImage $FILE/recovery.img
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
mkdir -p update/file
cp ../out/host/linux-x86/framework/signapk.jar ./update/
cp ../build/target/product/security/testkey.x509.pem  ./update/
cp ../build/target/product/security/testkey.pk8  ./update/
#cp -rf $FILE/system ./update/file/
#cp -rf $FILE/data ./update/file/
echo "mkbootimg........."
cp -rf $FILE/system.yaffs2_2k1b ./update/file/system.img
cp -rf $FILE/userdata.yaffs2_2k1b ./update/file/userdata.img
#cp -rf $FILE/logo.img ./update/file/logo.img
#cp -rf $FILE/recovery.img ./update/file/recovery.img
#cp -rf fastboot-burn.bin ./update/file/fastboot.img
cp ../kernel/arch/arm/boot/uImage ./update/file/boot.img

echo "make update.zip........."
cp -rf $FILE/system/bin/updater ./META-INF/com/google/android/update-binary
cp -rf ./META-INF  ./update/file/
chmod -R 777 ./update

cd ./update/file/
#zip -ry sor_update.zip boot.img META-INF/ system/ data/
#zip -ry sor_update.zip boot.img META-INF/ system.img userdata.img logo.img recovery.img fastboot.img
zip -ry sor_update.zip boot.img META-INF/ system.img userdata.img
cp sor_update.zip ../
cd ../
echo "please wait ..........."
java -jar signapk.jar  -w  testkey.x509.pem  testkey.pk8 sor_update.zip update.zip

cp update.zip  ../$FILE
cd ../..
rm -rf ./kernel_recovery/update
echo " OK !"
