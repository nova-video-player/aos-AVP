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
DAV1D_DIR := native/dav1d-android-builder
OPUS_DIR := native/opus-android-builder
OPENSSL_DIR := native/openssl-android-builder

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
		REPO_TOP_DIR=$(REPO_TOP_DIR) BUILD=$(BUILD) NDK_APP_ABI="$(NDK_APP_ABI)" ASAN="$(asan)" android_ndk=$(android_ndk) $(android_ndk)/ndk-build $(ndk_debug) $(ndk_v) $(ndk_jobs) -C $(1); \
	fi;

native_clean_$(1):
	@if [ -d $(1) ];then \
		$(android_ndk)/ndk-build -C $(1) clean; \
		rm -rf $(1)/obj; \
		rm -rf $(1)/libs/*/*; \
	fi;
endef

all: AVP/android-cmdline-tools AVP/android-ndk AVP/android-cmake AVP/android-others
	cd Video; ANDROID_SDK_ROOT=$(android_sdk) PATH="$(android_sdk)/cmdline-tools/latest/bin:$(android_sdk)/cmdline-tools/bin:$(android_sdk)/tools/bin:$(PATH)" ./gradlew aND

full: AVP/android-cmdline-tools AVP/android-ndk AVP/android-cmake AVP/android-others
	cd Video; ANDROID_SDK_ROOT=$(android_sdk) PATH="$(android_sdk)/cmdline-tools/latest/bin:$(android_sdk)/cmdline-tools/bin:$(android_sdk)/tools/bin:$(PATH)" ./gradlew -PadultScrape -Psponsor aMD

ndk_ver := 23

AVP/android-setup:
	echo "installing android sdk/ndk/etc... dependencies"
	PATH=$(android_sdk)/cmdline-tools/latest/bin:$(android_sdk)/cmdline-tools/bin:$(android_sdk)/tools/bin:$$PATH
	yes | $(WHICHSDKMANAGER) 'cmdline-tools;latest' 'ndk;23.1.7779620' 'cmake;3.18.1' platform-tools 'build-tools;30.0.3' > /dev/null

AVP/android-ndk:
	echo "installing android ndk..."
	PATH=$(android_sdk)/cmdline-tools/latest/bin:$(android_sdk)/cmdline-tools/bin:$(android_sdk)/tools/bin:$$PATH
	yes | $(WHICHSDKMANAGER) '$(shell $(WHICHSDKMANAGER) --list | grep ndk\;$(ndk_ver) | sed 's/^.*\(ndk;$(ndk_ver)\.[0-9\.]*\) .*$$/\1/g' | tail -n 1)' > /dev/null

AVP/android-cmdline-tools:
	echo "installing android cmdline-tools..."
	PATH=$(android_sdk)/cmdline-tools/latest/bin:$(android_sdk)/cmdline-tools/bin:$(android_sdk)/tools/bin:$$PATH
	yes | $(WHICHSDKMANAGER) 'cmdline-tools;latest' > /dev/null

AVP/android-cmake:
	echo "installing android cmake..."
	PATH=$(android_sdk)/cmdline-tools/latest/bin:$(android_sdk)/cmdline-tools/bin:$(android_sdk)/tools/bin:$$PATH
	yes | $(WHICHSDKMANAGER) '$(shell $(WHICHSDKMANAGER) --list | grep cmake | sed "s/^.*\(cmake;[0-9\.]*\).*$$/\1/g" | head -n 1)' > /dev/null

AVP/android-others:
	echo "installing android buildtools..."
	yes | $(WHICHSDKMANAGER) platform-tools 'build-tools;30.0.3' > /dev/null

$(foreach PKG,$(NATIVE_LIST),$(eval $(call gen_native_build,$(PKG))))

.PHONY: $(phony_rules)

define cp_ffmpeg_libs
	@if [ "$(NDK_CPU_ARM_NEON)" = "1" ];then \
		mkdir -p $(1)/libs/armeabi-v7a; \
		cp $(DAV1D_DIR)/build-armeabi-v7a/src/libdav1d.so $(1)/libs/armeabi-v7a/libdav1d.so; \
		cp $(OPUS_DIR)/lib/armeabi-v7a/libopus.so $(1)/libs/armeabi-v7a/libopus.so; \
		cp -r $(FFMPEG_DIR)/dist-$(2)-armeabi-v7a/lib/*so $(1)/libs/armeabi-v7a; \
	fi;
	@if [ "$(NDK_CPU_X86)" = "1" ];then \
		mkdir -p $(1)/libs/x86; \
		cp $(DAV1D_DIR)/build-x86/src/libdav1d.so $(1)/libs/x86/libdav1d.so; \
		cp $(OPUS_DIR)/lib/x86/libopus.so $(1)/libs/x86/libopus.so; \
		cp -r $(FFMPEG_DIR)/dist-$(2)-x86/lib/*so $(1)/libs/x86; \
	fi
	@if [ "$(NDK_CPU_ARM_64)" = "1" ];then \
		mkdir -p $(1)/libs/arm64-v8a; \
		cp $(DAV1D_DIR)/build-arm64-v8a/src/libdav1d.so $(1)/libs/arm64-v8a/libdav1d.so; \
		cp $(OPUS_DIR)/lib/arm64-v8a/libopus.so $(1)/libs/arm64-v8a/libopus.so; \
		cp -r $(FFMPEG_DIR)/dist-$(2)-arm64-v8a/lib/*so $(1)/libs/arm64-v8a; \
	fi
	@if [ "$(NDK_CPU_X86_64)" = "1" ];then \
		mkdir -p $(1)/libs/x86_64; \
		cp $(DAV1D_DIR)/build-x86_64/src/libdav1d.so $(1)/libs/x86_64/libdav1d.so; \
		cp $(OPUS_DIR)/lib/x86_64/libopus.so $(1)/libs/x86_64/libopus.so; \
		cp -r $(FFMPEG_DIR)/dist-$(2)-x86_64/lib/*so $(1)/libs/x86_64; \
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

clean_prebuilt:
	rm -rf native/torrentd/libs
	rm -rf $(FFMPEG_DIR)/dist-*
	rm -rf $(DAV1D_DIR)/build-*
	rm -rf $(OPUS_DIR)/lib/*
	rm -rf $(OPENSSL_DIR)/dist-*
	rm -rf MediaLib/libs/trakt-java.jar
	rm -rf MediaLib/libs/cling-*-2.1.2.jar
	rm -rf MediaLib/libs/seamless-*-1.1.2.jar
	rm -rf FileCoreLibrary/libs/jcifs-ng.jar

$(FFMPEG_DIR)/dist-full-arm64-v8a/lib/libavcodec.so:
	make native_build_native/ffmpeg-android-builder

native_avos_base: $(FFMPEG_DIR)/dist-full-arm64-v8a/lib/libavcodec.so
	$(call cp_ffmpeg_libs,MediaLib,base)
	$(call make_avos,MediaLib,base)

native_avos_full: native_build_native/ffmpeg-android-builder
	$(call cp_ffmpeg_libs,MediaLib,full)
	$(call make_avos,MediaLib,full)

native_build_native/ffmpeg-android-builder: native_build_native/dav1d-android-builder native_build_native/opus-android-builder native_build_native/openssl-android-builder
	cd native/ffmpeg-android-builder; REPO_TOP_DIR=$(REPO_TOP_DIR) bash bootstrap_avp_ffmpeg.sh

native_build_native/dav1d-android-builder:
	cd native/dav1d-android-builder; REPO_TOP_DIR=$(REPO_TOP_DIR) bash bootstrap_avp_dav1d.sh

native_build_native/opus-android-builder:
	cd native/opus-android-builder; REPO_TOP_DIR=$(REPO_TOP_DIR) bash build.sh

native_build_native/openssl-android-builder:
	cd native/openssl-android-builder; REPO_TOP_DIR=$(REPO_TOP_DIR) bash bootstrap.sh

native_build_native/torrentd: native_build_native/boost native_build_native/libtorrent

native_build_native/boost:
	cd native/boost; REPO_TOP_DIR=$(REPO_TOP_DIR) bash bootstrap_avp_boost.sh

native_build_native/libtorrent:
	cd native/libtorrent-android-builder; REPO_TOP_DIR=$(REPO_TOP_DIR) bash bootstrap_libtorrent.sh

native/torrentd/libs/arm64-v8a/torrentd:
	make native_build_native/torrentd
native_torrentd: native/torrentd/libs/arm64-v8a/torrentd
	rm -f MediaLib/libs/armeabi/libtorrentd.so ;\
	for i in armeabi-v7a arm64-v8a x86 x86_64;do \
		mkdir -p MediaLib/libs/$$i ;\
		cp native/torrentd/libs/$$i/torrentd MediaLib/libs/$$i/libtorrentd.so ;\
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
