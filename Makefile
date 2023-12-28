NDK=D:\Android\SDK\ndk\17.2.4988734\ndk-build.cmd
SHELL=powershell
ADB=D:\Android\SDK\platform-tools\adb.exe
Build:
	$(NDK) -j8
clean:obj
	$(NDK) clean
UP:
	$(SHELL) $(ADB) push .\libs\arm64-v8a\LibImGui /sdcard/TC/TC
	$(SHELL) $(ADB) push .\TC.sh /sdcard/TC/TC.sh
	$(SHELL) $(ADB) shell su -c sh /sdcard/TC/TC.sh root