#VERBOSE=1
ndk_jobs :=
#ndk_v := NDK_TOOLCHAIN_VERSION=4.9
AVOS_NATIVE_DEPS :=
JAVA_DEPS :=
build_type :=
prev_build_type = $(shell cat $(AVOS_DIR)/obj/build_type 2>/dev/null)

phony_rules :=
native_rules :=
native_clean_rules :=

android_sdk := $(shell readlink -f AVP/android-sdk)
android_ndk := $(shell readlink -f AVP/android-ndk)

ifneq (,$(ANDROID_SDK))
android_sdk := $(ANDROID_SDK)
endif

ifneq (,$(ANDROID_HOME))
android_sdk := $(ANDROID_HOME)
endif

ifneq (,$(ANDROID_NDK))
android_ndk := $(ANDROID_NDK)
endif

ndk_debug :=

ifeq (,$(NDK_CPU_ARM_NEON))
NDK_CPU_ARM_NEON = 1
endif
ifeq (,$(NDK_CPU_ARM_NO_NEON))
NDK_CPU_ARM_NO_NEON = 0
endif
ifeq (,$(NDK_CPU_X86))
NDK_CPU_X86 = 1
endif
ifeq (,$(NDK_CPU_MIPS))
NDK_CPU_MIPS = 0
endif
ifeq (,$(NDK_CPU_ARM_64))
NDK_CPU_ARM_64= 0
endif
ifeq (,$(NDK_CPU_X86_64))
NDK_CPU_X86_64 = 0
endif
ifeq (,$(NDK_CPU_MIPS_64))
NDK_CPU_MIPS_64 = 0
endif


NDK_APP_ABI :=
ifeq ($(NDK_CPU_ARM_NEON),1)
NDK_APP_ABI += armeabi-v7a
endif
ifeq ($(NDK_CPU_ARM_NO_NEON),1)
NDK_APP_ABI += armeabi
endif
ifeq ($(NDK_CPU_X86),1)
NDK_APP_ABI += x86
endif
ifeq ($(NDK_CPU_MIPS),1)
NDK_APP_ABI += mips
endif
ifeq ($(NDK_CPU_ARM_64),1)
NDK_APP_ABI += arm64-v8a
endif
ifeq ($(NDK_CPU_X86_64),1)
NDK_APP_ABI += x86_64
endif
ifeq ($(NDK_CPU_MIPS_64),1)
NDK_APP_ABI += mips64
endif

REPO_TOP_DIR := $(shell pwd)
BUILD_ANDROID_LIBS := $(REPO_TOP_DIR)/native/android-libs/ndkbuild.mk
AVOS_DIR := native/avos
FFMPEG_DIR := native/ffmpeg-android-builder

NATIVE_PKG_LIST := \
	FileCoreLibrary \
	native/torrentd \
	native/libyuv \
	native/libnativehelper

$(foreach PKG,$(NATIVE_PKG_LIST),$(eval PKG_EXTRA_DEPS_$(PKG) := native_build_$(PKG)))

NATIVE_LIST := $(NATIVE_PKG_LIST) \
	$(AVOS_DIR)

NATIVE_CLEAN_DEPS_$(AVOS_DIR) := \
	native/avos/jni/Android.mk \
	native/avos/codecs.mk \
	native/avos/main.mk \
	native/avos/ndkbuild.mk \
	native/avos/avos_config_android.mk \
	native/avos/common.mk \
	native/avos/sound.mk \
	native/avos/fb.mk

ifeq (1,$(VERBOSE))
	ndk_v += V=1
endif

ifeq (,$(MAKE_JOBS))
	ndk_jobs = -j 12
else
	ndk_jobs = -j $(MAKE_JOBS)
endif

ifneq (,$(NDK_DEBUG))
	ndk_debug := NDK_DEBUG=$(NDK_DEBUG)
endif

ifeq (DEBUG,$(BUILD))
	build_type := debug
endif
ifeq (RELEASE,$(BUILD))
	build_type := release
endif
ifeq (,$(build_type))
	BUILD := DEBUG
	build_type := debug
endif

define gen_native_build

native_rules += native_build_$(1)
native_clean_rules += native_clean_$(1)

ifeq (,NATIVE_CLEAN_DEPS_$(1))
NATIVE_CLEAN_DEPS_$(1):=
endif

$(1)/obj/clean: $(NATIVE_CLEAN_DEPS_$(1))
	@if [ -d "$(1)/obj" ]; then \
		echo "mk changed; force clean"; \
		make native_clean_$(1); \
	fi;

native_build_$(1): $(1)/obj/clean
	@if [ -n "$(prev_build_type)" -a "$(prev_build_type)" != "$(build_type)" ];then \
		echo "BUILD type changed; force clean"; \
		make native_clean_$(1); \
	fi;
	@if [ -d $(1) ];then \
		mkdir -p $(1)/obj; \
		echo $(build_type) > $(1)/obj/build_type; \
		touch $(1)/obj/clean; \
		REPO_TOP_DIR=$(REPO_TOP_DIR) BUILD=$(BUILD) BUILD_ANDROID_LIBS=$(BUILD_ANDROID_LIBS) NDK_APP_ABI="$(NDK_APP_ABI)" android_ndk=$(android_ndk) $(android_ndk)/ndk-build $(ndk_debug) $(ndk_v) $(ndk_jobs) -C $(1); \
	fi;

native_clean_$(1):
	@if [ -d $(1) ];then \
		$(android_ndk)/ndk-build -C $(1) clean; \
		rm $(1)/obj -rf; \
		rm $(1)/libs/*/* -rf; \
	fi;
endef

all: AVP/android-ndk
	cd Video; ANDROID_HOME=$(android_sdk) ANDROID_NDK_HOME=$(android_ndk) ./gradlew aCLNPD

AVP/android-ndk:
	echo "downloading android ndk..."
	wget https://dl.google.com/android/repository/android-ndk-r15-linux-x86_64.zip
	unzip android-ndk-r15-linux-x86_64.zip -d AVP/
	rm -f android-ndk-r15-linux-x86_64.zip
	mv AVP/android-ndk-r15 AVP/android-ndk

$(foreach PKG,$(NATIVE_LIST),$(eval $(call gen_native_build,$(PKG))))

.PHONY: $(phony_rules)

define cp_ffmpeg_libs
	@if [ "$(NDK_CPU_ARM_NEON)" = "1" ];then \
		mkdir -p $(1)/libs/armeabi-v7a; \
		cp -r $(FFMPEG_DIR)/dist-$(2)-armeabi-v7a/lib/*so $(1)/libs/armeabi-v7a; \
	fi;
	@if [ "$(NDK_CPU_X86)" = "1" ];then \
		mkdir -p $(1)/libs/x86; \
		cp -r $(FFMPEG_DIR)/dist-$(2)-x86/lib/*so $(1)/libs/x86; \
	fi
	@if [ "$(NDK_CPU_MIPS)" = "1" ];then \
		mkdir -p $(1)/libs/mips; \
		cp -r $(FFMPEG_DIR)/dist-$(2)-mips/lib/*so $(1)/libs/mips; \
	fi
	@if [ "$(NDK_CPU_ARM_64)" = "1" ];then \
		mkdir -p $(1)/libs/arm64-v8a; \
		cp -r $(FFMPEG_DIR)/dist-$(2)-arm64-v8a/lib/*so $(1)/libs/arm64-v8a; \
	fi
	@if [ "$(NDK_CPU_X86_64)" = "1" ];then \
		mkdir -p $(1)/libs/x86_64; \
		cp -r $(FFMPEG_DIR)/dist-$(2)-x86_64/lib/*so $(1)/libs/x86_64; \
	fi
	@if [ "$(NDK_CPU_MIPS_64)" = "1" ];then \
		mkdir -p $(1)/libs/mips64; \
		cp -r $(FFMPEG_DIR)/ndk/dist-$(2)-mips64/lib/*so $(1)/libs/mips64; \
	fi
endef

define make_hacks
	@if [ "$(NDK_CPU_X86)" = "1" ];then \
		echo -----------------------------------------; \
		echo -----------------------------------------; \
		echo create fake _no_neon libs in $(1)/libs/x86 because Intel wants to see the exact same number of ARM and x86 libs otherwise it will Houdini us; \
		echo -----------------------------------------; \
		echo -----------------------------------------; \
		rm -f $(1)/libs/x86/*no_neon*;\
		for i in $(1)/libs/armeabi-v7a/*;do \
			touch $(1)/libs/x86/$$(basename $$i) ;\
		done ;\
		if [ "$$(ls $(1)/libs/x86 |wc -l)" != "$$(ls $(1)/libs/armeabi-v7a |wc -l)" ];then echo "Mismatching x86/armeabi-v7a libs"; 1;fi ;\
	fi
endef

define make_avos
	MAKE_JOBS=$(MAKE_JOBS) BUILD=$(BUILD) $(ndk_debug) BUILD_ANDROID_LIBS=$(BUILD_ANDROID_LIBS) NDK_APP_ABI="$(NDK_APP_ABI)" LIBAV_CONFIG=$(2) make native_build_native/avos

	@if [ "$(NDK_CPU_ARM_NEON)" = "1" ];then \
		mkdir -p $(1)/libs/armeabi-v7a; \
		cp -r $(AVOS_DIR)/libs/armeabi-v7a/*so $(1)/libs/armeabi-v7a; \
	fi
	@if [ "$(NDK_CPU_ARM_NO_NEON)" = "1" ];then \
		mkdir -p $(1)/libs/armeabi-v7a; \
		cp -r $(AVOS_DIR)/libs/armeabi/*no_neon.so $(1)/libs/armeabi-v7a; \
		cp $(AVOS_DIR)/libs/armeabi/libcputest.so $(1)/libs/armeabi-v7a; \
	fi
	@if [ "$(NDK_CPU_X86)" = "1" ];then \
		mkdir -p $(1)/libs/x86; \
		cp -r $(AVOS_DIR)/libs/x86/*so $(1)/libs/x86; \
	fi
	@if [ "$(NDK_CPU_MIPS)" = "1" ];then \
		mkdir -p $(1)/libs/mips; \
		cp -r $(AVOS_DIR)/libs/mips/*so $(1)/libs/mips; \
	fi
	@if [ "$(NDK_CPU_ARM_64)" = "1" ];then \
		mkdir -p $(1)/libs/arm64-v8a; \
		cp -r $(AVOS_DIR)/libs/arm64-v8a/*so $(1)/libs/arm64-v8a; \
	fi
	@if [ "$(NDK_CPU_X86_64)" = "1" ];then \
		mkdir -p $(1)/libs/x86_64; \
		cp -r $(AVOS_DIR)/libs/x86_64/*so $(1)/libs/x86_64; \
	fi
	@if [ "$(NDK_CPU_MIPS_64)" = "1" ];then \
		mkdir -p $(1)/libs/mips64; \
		cp -r $(AVOS_DIR)/libs/mips64/*so $(1)/libs/mips64; \
	fi
	$(call make_hacks,$(1),$(2))
endef

native_avos: native_build_native/avos

native_avos_base:
	$(call cp_ffmpeg_libs,MediaLib,base)
	$(call make_avos,MediaLib,base)

native_build_native/torrentd: native_build_native/boost native_build_native/libtorrent

native_build_native/boost:
	cd native/boost; android_ndk=$(android_ndk) REPO_TOP_DIR=$(REPO_TOP_DIR) bash build-android-all.sh

native_build_native/libtorrent:
	cd native/libtorrent; android_ndk=$(android_ndk) REPO_TOP_DIR=$(REPO_TOP_DIR) bash build-android-all.sh

native_torrentd: native_build_native/torrentd
	rm -f MediaLib/libs/armeabi/libtorrentd.so ;\
	for i in armeabi-v7a x86;do \
		mkdir -p MediaLib/libs/$$i ;\
		cp native/torrentd/libs/$$i/torrentd MediaLib/libs/$$i/libtorrentd.so ;\
	done

native_libyuv: native_build_native/libyuv

native_libnativehelper: native_build_native/libnativehelper

native : $(native_rules)

native_clean: $(native_clean_rules)

clean: native_clean

