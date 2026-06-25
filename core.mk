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

os := $(shell echo $(shell uname -s) | tr '[:upper:]' '[:lower:]')

ifeq ($(os), darwin)
	readlink_prefix := g
	JAVA8 := $(shell /usr/libexec/java_home -v 1.8)
	JAVA11 := $(shell /usr/libexec/java_home -v 11)
	JAVA17 := $(shell /usr/libexec/java_home -v 17)
endif

ifeq ($(os), linux)
	JAVA8 := $(shell update-alternatives --list java | sed -nE -e 's/(.*java-8[^/]*).*/\1/p')
	JAVA11 := $(shell update-alternatives --list java | sed -nE -e 's/(.*java-11[^/]*).*/\1/p')
	JAVA17 := $(shell update-alternatives --list java | sed -nE -e 's/(.*java-17[^/]*).*/\1/p')
	ifeq (,$(JAVA8))
            JAVA8 := $(shell update-alternatives --list java | sed -nE -e 's/(.*jdk-8[^/]*).*/\1/p')
        endif
	ifeq (,$(JAVA11))
            JAVA11 := $(shell update-alternatives --list java | sed -nE -e 's/(.*jdk-11[^/]*).*/\1/p')
        endif
	ifeq (,$(JAVA17))
            JAVA17 := $(shell update-alternatives --list java | sed -nE -e 's/(.*jdk-17[^/]*).*/\1/p')
        endif
endif

READLINK := $(readlink_prefix)readlink

ifneq (,$(ANDROID_SDK))
android_sdk := $(ANDROID_SDK)
endif

ifneq (,$(ANDROID_HOME))
android_sdk := $(ANDROID_HOME)
endif

ifneq (,$(ANDROID_SDK_ROOT))
android_sdk := $(ANDROID_SDK_ROOT)
endif

$(info android_sdk is $(android_sdk))

WHICHSDKMANAGER := $(shell PATH=$(android_sdk)/cmdline-tools/latest/bin:$(android_sdk)/cmdline-tools/bin:$(android_sdk)/tools/bin:$$PATH which sdkmanager)
ifeq ($(WHICHSDKMANAGER), $(android_sdk)/tools/bin/sdkmanager)
  SDKMANAGER := yes | JAVA_HOME=$(JAVA8) $(android_sdk)/tools/bin/sdkmanager
endif
ifeq ($(WHICHSDKMANAGER), $(android_sdk)/cmdline-tools/bin/sdkmanager)
  SDKMANAGER := yes | JAVA_HOME=$(JAVA11) $(android_sdk)/cmdline-tools/bin/sdkmanager --sdk_root=$(android_sdk)
endif
ifeq ($(WHICHSDKMANAGER), $(android_sdk)/cmdline-tools/latest/bin/sdkmanager)
  SDKMANAGER := yes | JAVA_HOME=$(JAVA11) $(android_sdk)/cmdline-tools/latest/bin/sdkmanager
endif

ifneq ($(wildcard $(android_sdk)/ndk/.*),)
android_ndk := $(shell ls -d $(android_sdk)/ndk/* | sort -V | tail -n 1)
endif
$(info android_ndk is $(android_ndk))

# cmake path detection (latest installed cmake)
ifneq ($(wildcard $(android_sdk)/cmake/.*),)
android_cmake := $(shell ls -d $(android_sdk)/cmake/* | sort -V | tail -n 1)
endif
$(info android_cmake is $(android_cmake))

# NDK prebuilt and LLVM toolchain paths
# WARNING: x86_64 hardcoded, should be changed when NDK ships native arm64 prebuilt for Apple Silicon
ndk_host := prebuilt/$(os)-x86_64
ndk_prebuilt := $(android_ndk)/$(ndk_host)
ndk_llvm := $(android_ndk)/toolchains/llvm/$(ndk_host)

# export NDK environment variables
export ANDROID_NDK_HOME := $(android_ndk)
export ANDROID_NDK_ROOT := $(android_ndk)

# augment PATH with cmake, NDK prebuilt tools and LLVM toolchain
export PATH := $(android_cmake)/bin:$(ndk_llvm)/bin:$(ndk_prebuilt)/bin:$(android_sdk)/cmdline-tools/latest/bin:$(android_sdk)/cmdline-tools/bin:$(android_sdk)/tools/bin:$(shell echo $$PATH)

ifneq (,$(ASAN))
asan := $(ASAN)
endif

ndk_debug :=

ifeq (,$(NDK_CPU_ARM_NEON))
NDK_CPU_ARM_NEON = 1
endif
ifeq (,$(NDK_CPU_X86))
NDK_CPU_X86 = 1
endif
ifeq (,$(NDK_CPU_ARM_64))
NDK_CPU_ARM_64= 1
endif
ifeq (,$(NDK_CPU_X86_64))
NDK_CPU_X86_64 = 1
endif

NDK_APP_ABI :=
ifeq ($(NDK_CPU_ARM_NEON),1)
NDK_APP_ABI += armeabi-v7a
endif
ifeq ($(NDK_CPU_X86),1)
NDK_APP_ABI += x86
endif
ifeq ($(NDK_CPU_ARM_64),1)
NDK_APP_ABI += arm64-v8a
endif
ifeq ($(NDK_CPU_X86_64),1)
NDK_APP_ABI += x86_64
endif

REPO_TOP_DIR := $(shell pwd)
AVOS_DIR := native/avos
FFMPEG_DIR := native/ffmpeg-android-builder
FFMPEG_PREBUILT_DIR := native/prebuilt/ffmpeg
DAV1D_DIR := native/dav1d-android-builder
DAV1D_PREBUILT_DIR := native/prebuilt/dav1d
OPUS_DIR := native/opus-android-builder
OPUS_PREBUILT_DIR := native/prebuilt/opus
OPENSSL_DIR := native/openssl-android-builder
OPENSSL_PREBUILT_DIR := native/prebuilt/openssl
LIBMYSOFA_DIR := native/libmysofa-android-builder
LIBMYSOFA_PREBUILT_DIR := native/prebuilt/libmysofa
TORRENTD_PREBUILT_DIR := native/prebuilt/torrentd
FREETYPE_DIR := native/libfreetype-android-builder
FREETYPE_PREBUILT_DIR := native/prebuilt/freetype
FRIBIDI_DIR := native/libfribidi-android-builder
FRIBIDI_PREBUILT_DIR := native/prebuilt/fribidi
HARFBUZZ_DIR := native/harfbuzz-android-builder
HARFBUZZ_PREBUILT_DIR := native/prebuilt/harfbuzz
LIBASS_DIR := native/libass-android-builder
LIBASS_PREBUILT_DIR := native/prebuilt/libass
ZLIB_DIR := native/zlib-android-builder
ZLIB_PREBUILT_DIR := native/prebuilt/zlib
LIBPNG_DIR := native/libpng-android-builder
LIBPNG_PREBUILT_DIR := native/prebuilt/libpng
LIBXML2_DIR := native/libxml2-android-builder
LIBXML2_PREBUILT_DIR := native/prebuilt/libxml2
LIBUNIBREAK_DIR := native/libunibreak-android-builder
LIBUNIBREAK_PREBUILT_DIR := native/prebuilt/libunibreak
FONTCONFIG_DIR := native/fontconfig-android-builder
FONTCONFIG_PREBUILT_DIR := native/prebuilt/fontconfig

NATIVE_PKG_LIST := \
	FileCoreLibrary \
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
		REPO_TOP_DIR=$(REPO_TOP_DIR) BUILD=$(BUILD) NDK_APP_ABI="$(NDK_APP_ABI)" ASAN="$(asan)" android_ndk=$(android_ndk) $(android_ndk)/ndk-build $(ndk_debug) $(ndk_v) $(ndk_jobs) -C $(1); \
	fi;

native_clean_$(1):
	@if [ -d $(1) ];then \
		$(android_ndk)/ndk-build -C $(1) clean; \
		rm -rf $(1)/obj; \
		rm -rf $(1)/libs/*/*; \
	fi;
endef

all:
	cd Video; ANDROID_SDK_ROOT=$(android_sdk) ./gradlew aND

full:
	cd Video; ANDROID_SDK_ROOT=$(android_sdk) ./gradlew -PadultScrape -Psponsor aND

AVP/android-setup: AVP/android-cmdline-tools AVP/android-ndk AVP/android-cmake AVP/android-others

AVP/android-ndk:
	echo "installing android ndk..."
	#yes | $(WHICHSDKMANAGER) '$(shell $(WHICHSDKMANAGER) --list | grep ndk\;$(ndk_ver) | sed 's/^.*\(ndk;$(ndk_ver)\.[0-9\.]*\) .*$$/\1/g' | tail -n 1)' > /dev/null
	yes | $(WHICHSDKMANAGER) '$(shell $(WHICHSDKMANAGER) --list | grep "^  ndk;" | sed "s/^.*\(ndk;[0-9\.]*\).*/\1/g" | tail -n 1)' > /dev/null

AVP/android-cmdline-tools:
	#yes | $(WHICHSDKMANAGER) 'cmdline-tools;latest' > /dev/null
	@ver=$(shell $(WHICHSDKMANAGER) --list | grep "cmdline-tools;latest" | sed "s/[^|]*| *\([0-9\.]*\).*/\1/"); \
	if [ -d "$(android_sdk)/cmdline-tools/$$ver" ]; then \
		echo "android cmdline-tools $$ver already installed, skipping"; \
	else \
		echo "installing android cmdline-tools $$ver..."; \
		yes | $(WHICHSDKMANAGER) "cmdline-tools;$$ver" > /dev/null; \
	fi

AVP/android-cmake:
	#yes | $(WHICHSDKMANAGER) '$(shell $(WHICHSDKMANAGER) --list | grep cmake | sed "s/^.*\(cmake;[0-9\.]*\).*$$/\1/g" | head -n 1)' > /dev/null
	@echo "installing android cmake..."
	yes | $(WHICHSDKMANAGER) '$(shell $(WHICHSDKMANAGER) --list | grep "cmake;" | grep -v rc | grep -v alpha | sed "s/^.*\(cmake;[0-9\.]*\).*$$/\1/g" | sort -V | tail -n 1)' > /dev/null

AVP/android-others:
	#yes | $(WHICHSDKMANAGER) platform-tools 'build-tools;30.0.3' > /dev/null
	@echo "installing android buildtools..."
	yes | $(WHICHSDKMANAGER) platform-tools '$(shell $(WHICHSDKMANAGER) --list | grep "build-tools;" | grep -v rc | grep -v alpha | sed "s/^.*\(build-tools;[0-9\.]*\).*$$/\1/g" | sort -V | tail -n 1)' > /dev/null

$(foreach PKG,$(NATIVE_LIST),$(eval $(call gen_native_build,$(PKG))))

.PHONY: $(phony_rules)

define cp_ffmpeg_libs
	@if [ "$(NDK_CPU_ARM_NEON)" = "1" ];then \
		mkdir -p $(1)/libs/armeabi-v7a; \
		cp $(DAV1D_PREBUILT_DIR)/lib/armeabi-v7a/libdav1d.so $(1)/libs/armeabi-v7a/libdav1d.so; \
		cp $(OPUS_PREBUILT_DIR)/lib/armeabi-v7a/libopus.so $(1)/libs/armeabi-v7a/libopus.so; \
		cp $(LIBMYSOFA_PREBUILT_DIR)/lib/armeabi-v7a/libmysofa.so $(1)/libs/armeabi-v7a/libmysofa.so; \
		cp -r $(FFMPEG_PREBUILT_DIR)/dist-$(2)-armeabi-v7a/lib/*so $(1)/libs/armeabi-v7a; \
	fi;
	@if [ "$(NDK_CPU_X86)" = "1" ];then \
		mkdir -p $(1)/libs/x86; \
		cp $(DAV1D_PREBUILT_DIR)/lib/x86/libdav1d.so $(1)/libs/x86/libdav1d.so; \
		cp $(OPUS_PREBUILT_DIR)/lib/x86/libopus.so $(1)/libs/x86/libopus.so; \
		cp $(LIBMYSOFA_PREBUILT_DIR)/lib/x86/libmysofa.so $(1)/libs/x86/libmysofa.so; \
		cp -r $(FFMPEG_PREBUILT_DIR)/dist-$(2)-x86/lib/*so $(1)/libs/x86; \
	fi
	@if [ "$(NDK_CPU_ARM_64)" = "1" ];then \
		mkdir -p $(1)/libs/arm64-v8a; \
		cp $(DAV1D_PREBUILT_DIR)/lib/arm64-v8a/libdav1d.so $(1)/libs/arm64-v8a/libdav1d.so; \
		cp $(OPUS_PREBUILT_DIR)/lib/arm64-v8a/libopus.so $(1)/libs/arm64-v8a/libopus.so; \
		cp $(LIBMYSOFA_PREBUILT_DIR)/lib/arm64-v8a/libmysofa.so $(1)/libs/arm64-v8a/libmysofa.so; \
		cp -r $(FFMPEG_PREBUILT_DIR)/dist-$(2)-arm64-v8a/lib/*so $(1)/libs/arm64-v8a; \
	fi
	@if [ "$(NDK_CPU_X86_64)" = "1" ];then \
		mkdir -p $(1)/libs/x86_64; \
		cp $(DAV1D_PREBUILT_DIR)/lib/x86_64/libdav1d.so $(1)/libs/x86_64/libdav1d.so; \
		cp $(OPUS_PREBUILT_DIR)/lib/x86_64/libopus.so $(1)/libs/x86_64/libopus.so; \
		cp $(LIBMYSOFA_PREBUILT_DIR)/lib/x86_64/libmysofa.so $(1)/libs/x86_64/libmysofa.so; \
		cp -r $(FFMPEG_PREBUILT_DIR)/dist-$(2)-x86_64/lib/*so $(1)/libs/x86_64; \
	fi
endef

define make_avos
	MAKE_JOBS=$(MAKE_JOBS) BUILD=$(BUILD) $(ndk_debug) NDK_APP_ABI="$(NDK_APP_ABI)" LIBAV_CONFIG=$(2) make native_build_native/avos

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
	@if [ "$(NDK_CPU_ARM_64)" = "1" ];then \
		mkdir -p $(1)/libs/arm64-v8a; \
		cp -r $(AVOS_DIR)/libs/arm64-v8a/*so $(1)/libs/arm64-v8a; \
	fi
	@if [ "$(NDK_CPU_X86_64)" = "1" ];then \
		mkdir -p $(1)/libs/x86_64; \
		cp -r $(AVOS_DIR)/libs/x86_64/*so $(1)/libs/x86_64; \
	fi
endef

native_avos: native_build_native/avos

clean_native_build:
	rm -rf native/boost/boost-*
	rm -rf $(DAV1D_DIR)/build-*
	rm -rf $(FFMPEG_DIR)/ffmpeg.git
	rm -rf $(OPUS_DIR)/opus $(OPUS_DIR)/build-*
	rm -rf $(OPENSSL_DIR)/openssl.git
	rm -rf $(LIBMYSOFA_DIR)/libmysofa $(LIBMYSOFA_DIR)/build-*
	rm -rf native/libtorrent-android-builder/libtorrent
	rm -rf native/torrentd/obj
	rm -rf $(AVOS_DIR)/obj $(AVOS_DIR)/libs
	rm -rf native/libyuv/obj native/libyuv/libs
	rm -rf native/libnativehelper/obj native/libnativehelper/libs
	rm -rf $(FREETYPE_DIR)/freetype
	rm -rf $(FRIBIDI_DIR)/fribidi $(FRIBIDI_DIR)/build-* $(FRIBIDI_DIR)/meson-cross-*
	rm -rf $(HARFBUZZ_DIR)/harfbuzz $(HARFBUZZ_DIR)/build-* $(HARFBUZZ_DIR)/meson-cross-*
	rm -rf $(LIBASS_DIR)/libass
	rm -rf $(ZLIB_DIR)/zlib
	rm -rf $(LIBPNG_DIR)/libpng
	rm -rf $(LIBXML2_DIR)/libxml2
	rm -rf $(LIBUNIBREAK_DIR)/libunibreak
	rm -rf $(FONTCONFIG_DIR)/fontconfig

clean_prebuilt:
	rm -rf native/torrentd/obj
	rm -rf $(TORRENTD_PREBUILT_DIR)/libs
	rm -rf $(FFMPEG_PREBUILT_DIR)/dist-*
	rm -rf $(DAV1D_DIR)/build-*
	rm -rf $(DAV1D_PREBUILT_DIR)/lib/*
	rm -rf $(OPUS_DIR)/build-*
	rm -rf $(OPUS_PREBUILT_DIR)/lib/*
	rm -rf $(OPENSSL_PREBUILT_DIR)/dist-*
	rm -rf $(LIBMYSOFA_DIR)/build-*
	rm -rf $(LIBMYSOFA_PREBUILT_DIR)/lib/*
	rm -rf $(LIBMYSOFA_PREBUILT_DIR)/include/*
	rm -rf $(FREETYPE_PREBUILT_DIR)/*
	rm -rf $(FRIBIDI_PREBUILT_DIR)/*
	rm -rf $(HARFBUZZ_PREBUILT_DIR)/*
	rm -rf $(LIBASS_PREBUILT_DIR)/*
	rm -rf $(ZLIB_PREBUILT_DIR)/*
	rm -rf $(LIBPNG_PREBUILT_DIR)/*
	rm -rf $(LIBXML2_PREBUILT_DIR)/*
	rm -rf $(LIBUNIBREAK_PREBUILT_DIR)/*
	rm -rf $(FONTCONFIG_PREBUILT_DIR)/*
	rm -rf MediaLib/libs/trakt-java.jar
	rm -rf MediaLib/libs/cling-*-2.1.2.jar
	rm -rf MediaLib/libs/seamless-*-1.1.2.jar
	rm -rf FileCoreLibrary/libs/jcifs-ng.jar

$(FFMPEG_PREBUILT_DIR)/dist-full-arm64-v8a/lib/libavcodec.so:
	make native_build_native/ffmpeg-android-builder

native_avos_base: $(FFMPEG_PREBUILT_DIR)/dist-full-arm64-v8a/lib/libavcodec.so
	$(call cp_ffmpeg_libs,MediaLib,base)
	$(call make_avos,MediaLib,base)

native_avos_full: native_build_native/ffmpeg-android-builder
	$(call cp_ffmpeg_libs,MediaLib,full)
	$(call make_avos,MediaLib,full)

native_build_native/ffmpeg-android-builder: native_build_native/dav1d-android-builder native_build_native/opus-android-builder native_build_native/openssl-android-builder native_build_native/libmysofa-android-builder native_build_native/libass-android-builder
	cd native/ffmpeg-android-builder; REPO_TOP_DIR=$(REPO_TOP_DIR) bash bootstrap_avp_ffmpeg.sh

native_build_native/dav1d-android-builder:
	cd native/dav1d-android-builder; REPO_TOP_DIR=$(REPO_TOP_DIR) bash bootstrap_avp_dav1d.sh

native_build_native/opus-android-builder:
	cd native/opus-android-builder; REPO_TOP_DIR=$(REPO_TOP_DIR) bash build.sh

native_build_native/openssl-android-builder:
	cd native/openssl-android-builder; REPO_TOP_DIR=$(REPO_TOP_DIR) bash bootstrap.sh

native_build_native/libmysofa-android-builder:
	cd native/libmysofa-android-builder; REPO_TOP_DIR=$(REPO_TOP_DIR) bash build.sh

native_build_native/zlib-android-builder:
	cd native/zlib-android-builder; REPO_TOP_DIR=$(REPO_TOP_DIR) bash build.sh

native_build_native/libpng-android-builder: native_build_native/zlib-android-builder
	cd native/libpng-android-builder; REPO_TOP_DIR=$(REPO_TOP_DIR) bash build.sh

native_build_native/libxml2-android-builder: native_build_native/zlib-android-builder
	cd native/libxml2-android-builder; REPO_TOP_DIR=$(REPO_TOP_DIR) bash build.sh

native_build_native/libfreetype-android-builder: native_build_native/zlib-android-builder native_build_native/libpng-android-builder
	cd native/libfreetype-android-builder; REPO_TOP_DIR=$(REPO_TOP_DIR) bash build.sh

native_build_native/libfribidi-android-builder:
	cd native/libfribidi-android-builder; REPO_TOP_DIR=$(REPO_TOP_DIR) bash build.sh

native_build_native/harfbuzz-android-builder: native_build_native/libfreetype-android-builder
	cd native/harfbuzz-android-builder; REPO_TOP_DIR=$(REPO_TOP_DIR) bash build.sh

native_build_native/libunibreak-android-builder:
	cd native/libunibreak-android-builder; REPO_TOP_DIR=$(REPO_TOP_DIR) bash build.sh

native_build_native/fontconfig-android-builder: native_build_native/libfreetype-android-builder native_build_native/libxml2-android-builder
	cd native/fontconfig-android-builder; REPO_TOP_DIR=$(REPO_TOP_DIR) bash build.sh

native_build_native/libass-android-builder: native_build_native/libfreetype-android-builder native_build_native/libfribidi-android-builder native_build_native/harfbuzz-android-builder native_build_native/fontconfig-android-builder native_build_native/libunibreak-android-builder
	cd native/libass-android-builder; REPO_TOP_DIR=$(REPO_TOP_DIR) bash build.sh

native_build_native/torrentd: native_build_native/boost native_build_native/libtorrent
	@if [ -f $(TORRENTD_PREBUILT_DIR)/libs/arm64-v8a/torrentd ]; then \
		echo "torrentd already built, skipping"; \
	else \
		mkdir -p $(TORRENTD_PREBUILT_DIR)/libs; \
		REPO_TOP_DIR=$(REPO_TOP_DIR) BUILD=$(BUILD) NDK_APP_ABI="$(NDK_APP_ABI)" ASAN="$(asan)" android_ndk=$(android_ndk) $(android_ndk)/ndk-build $(ndk_debug) $(ndk_v) $(ndk_jobs) -C native/torrentd NDK_LIBS_OUT=$(REPO_TOP_DIR)/$(TORRENTD_PREBUILT_DIR)/libs; \
	fi

native_clean_native/torrentd:
	rm -rf native/torrentd/obj
	rm -rf $(TORRENTD_PREBUILT_DIR)/libs

native_build_native/boost:
	@if [ -f $(TORRENTD_PREBUILT_DIR)/libs/arm64-v8a/torrentd ]; then \
		echo "torrentd prebuilt exists, skipping boost"; \
	else \
		cd native/boost; REPO_TOP_DIR=$(REPO_TOP_DIR) bash bootstrap_avp_boost.sh; \
	fi

native_build_native/libtorrent:
	@if [ -f $(TORRENTD_PREBUILT_DIR)/libs/arm64-v8a/torrentd ]; then \
		echo "torrentd prebuilt exists, skipping libtorrent"; \
	else \
		cd native/libtorrent-android-builder; REPO_TOP_DIR=$(REPO_TOP_DIR) bash bootstrap_libtorrent.sh; \
	fi

native_torrentd: native_build_native/torrentd
	rm -f MediaLib/libs/armeabi/libtorrentd.so ;\
	for i in armeabi-v7a arm64-v8a x86 x86_64;do \
		mkdir -p MediaLib/libs/$$i ;\
		cp $(TORRENTD_PREBUILT_DIR)/libs/$$i/torrentd MediaLib/libs/$$i/libtorrentd.so ;\
	done

trakt-java: MediaLib/libs/trakt-java.jar

jcifs-ng: FileCoreLibrary/libs/jcifs-ng.jar

cling-objects = MediaLib/libs/cling-core-2.1.2.jar MediaLib/libs/cling-support-2.1.2.jar

seamless-objects = MediaLib/libs/seamless-util-1.1.2.jar MediaLib/libs/seamless-http-1.1.2.jar MediaLib/libs/seamless-xml-1.1.2.jar MediaLib/libs/seamless-swing-1.1.2.jar

seamless: $(seamless-objects)

cling: $(cling-objects)

MediaLib/libs/cling-core-2.1.2.jar:
MediaLib/libs/cling-support-2.1.2.jar:
	cd external/cling; JAVA_HOME="$(JAVA8)" mvn install -B -Dorg.slf4j.simpleLogger.log.org.apache.maven.cli.transfer.Slf4jMavenTransferListener=warn -Dmaven.source.skip -DskipTests -Dmaven.javadoc.skip=true && mv */target/cling*2.1.2.jar ../../MediaLib/libs
	
MediaLib/libs/seamless-util-1.1.2.jar:
MediaLib/libs/seamless-http-1.1.2.jar:
MediaLib/libs/seamless-xml-1.1.2.jar:
MediaLib/libs/seamless-swing-1.1.2.jar:
	cd external/seamless; JAVA_HOME="$(JAVA8)" mvn install -B -Dorg.slf4j.simpleLogger.log.org.apache.maven.cli.transfer.Slf4jMavenTransferListener=warn -Dmaven.source.skip -DskipTests -Dmaven.javadoc.skip=true && mv */target/seamless*1.1.2.jar ../../MediaLib/libs

FileCoreLibrary/libs/jcifs-ng.jar:
	cd external/jcifs-ng; mvn install -B -Dorg.slf4j.simpleLogger.log.org.apache.maven.cli.transfer.Slf4jMavenTransferListener=warn -Dmaven.source.skip --batch-mode -DskipTests -Dmaven.javadoc.skip=true -Dgpg.skip=true && mv ./target/jcifs-ng-*.jar ../../FileCoreLibrary/libs/jcifs-ng.jar

MediaLib/libs/trakt-java.jar:
	cd external/trakt-java; mvn install -B -Dorg.slf4j.simpleLogger.log.org.apache.maven.cli.transfer.Slf4jMavenTransferListener=warn -Dmaven.source.skip -DskipTests -Dmaven.javadoc.skip=true && mv ./target/trakt-java-*.jar ../../MediaLib/libs/trakt-java.jar

external_build: jcifs-ng seamless cling

external_clean: external_clean_jcifs-ng external_clean_cling external_clean_seamless

external_clean_jcifs-ng:
	cd external/jcifs-ng; mvn clean; rm -f ../../FileCoreLibrary/libs/jcifs-ng.jar

external_clean_trakt-java:
	cd external/trakt-java; mvn clean; rm -f ../../MediaLib/libs/trakt-java.jar

external_clean_cling:
	cd external/cling; mvn clean; rm -f ../../MediaLib/libs/cling*-2.1.2.jar

external_clean_seamless:
	cd external/seamless; mvn clean; rm -f ../../MediaLib/libs/seamless*-1.1.2.jar

native_libyuv: native_build_native/libyuv

native_libnativehelper: native_build_native/libnativehelper

native : $(native_rules)

native_clean: $(native_clean_rules)

clean: native_clean external_clean
