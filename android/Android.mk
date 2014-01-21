LOCAL_PATH := external/bluetooth

# Retrieve BlueZ version from configure.ac file
BLUEZ_VERSION := $(shell grep ^AC_INIT $(LOCAL_PATH)/bluez/configure.ac | cpp -P -D'AC_INIT(_,v)=v')

# Specify pathmap for glib
pathmap_INCL += glib:external/bluetooth/glib

# Specify common compiler flags
BLUEZ_COMMON_CFLAGS := -DVERSION=\"$(BLUEZ_VERSION)\" \
	-DANDROID_STORAGEDIR=\"/data/misc/bluetooth\" \

# Disable warnings enabled by Android but not enabled in autotools build
BLUEZ_COMMON_CFLAGS += -Wno-pointer-arith -Wno-missing-field-initializers

#
# Android BlueZ daemon (bluetoothd)
#

include $(CLEAR_VARS)

LOCAL_SRC_FILES := \
	bluez/android/main.c \
	bluez/android/bluetooth.c \
	bluez/android/hidhost.c \
	bluez/android/socket.c \
	bluez/android/ipc.c \
	bluez/android/audio-ipc.c \
	bluez/android/avdtp.c \
	bluez/android/a2dp.c \
	bluez/android/pan.c \
	bluez/src/log.c \
	bluez/src/shared/mgmt.c \
	bluez/src/shared/util.c \
	bluez/src/shared/queue.c \
	bluez/src/shared/io-glib.c \
	bluez/src/sdpd-database.c \
	bluez/src/sdpd-service.c \
	bluez/src/sdpd-request.c \
	bluez/src/sdpd-server.c \
	bluez/src/uuid-helper.c \
	bluez/src/eir.c \
	bluez/lib/sdp.c \
	bluez/lib/bluetooth.c \
	bluez/lib/hci.c \
	bluez/btio/btio.c \
	bluez/src/sdp-client.c \
	bluez/profiles/network/bnep.c \

LOCAL_C_INCLUDES := \
	$(call include-path-for, glib) \
	$(call include-path-for, glib)/glib \

LOCAL_C_INCLUDES += \
	$(LOCAL_PATH)/bluez \
	$(LOCAL_PATH)/bluez/src \
	$(LOCAL_PATH)/bluez/lib \

LOCAL_CFLAGS := $(BLUEZ_COMMON_CFLAGS)

LOCAL_SHARED_LIBRARIES := \
	libglib \

lib_headers := \
	bluetooth.h \
	hci.h \
	hci_lib.h \
	l2cap.h \
	sdp_lib.h \
	sdp.h \
	rfcomm.h \
	sco.h \
	bnep.h \

$(shell mkdir -p $(LOCAL_PATH)/bluez/lib/bluetooth)

$(foreach file,$(lib_headers), $(shell ln -sf ../$(file) $(LOCAL_PATH)/bluez/lib/bluetooth/$(file)))

LOCAL_MODULE_TAGS := optional
LOCAL_MODULE := bluetoothd

include $(BUILD_EXECUTABLE)

#
# bluetooth.default.so HAL
#

include $(CLEAR_VARS)

LOCAL_SRC_FILES := \
	bluez/android/hal-ipc.c \
	bluez/android/hal-bluetooth.c \
	bluez/android/hal-sock.c \
	bluez/android/hal-hidhost.c \
	bluez/android/hal-pan.c \
	bluez/android/hal-a2dp.c \
	bluez/android/hal-utils.c \

LOCAL_C_INCLUDES += \
	$(call include-path-for, system-core) \
	$(call include-path-for, libhardware) \

LOCAL_SHARED_LIBRARIES := \
	libcutils \

LOCAL_CFLAGS := $(BLUEZ_COMMON_CFLAGS) \

LOCAL_MODULE := bluetooth.default
LOCAL_MODULE_PATH := $(TARGET_OUT_SHARED_LIBRARIES)/hw
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := SHARED_LIBRARIES
LOCAL_REQUIRED_MODULES := bluetoothd bluetoothd-snoop init.bluetooth.rc

include $(BUILD_SHARED_LIBRARY)

#
# haltest
#

include $(CLEAR_VARS)

LOCAL_SRC_FILES := \
	bluez/android/client/haltest.c \
	bluez/android/client/pollhandler.c \
	bluez/android/client/terminal.c \
	bluez/android/client/history.c \
	bluez/android/client/tabcompletion.c \
	bluez/android/client/if-audio.c \
	bluez/android/client/if-av.c \
	bluez/android/client/if-bt.c \
	bluez/android/client/if-hf.c \
	bluez/android/client/if-hh.c \
	bluez/android/client/if-pan.c \
	bluez/android/client/if-sock.c \
	bluez/android/client/if-gatt.c \
	bluez/android/hal-utils.c \

LOCAL_C_INCLUDES += \
	$(call include-path-for, system-core) \
	$(call include-path-for, libhardware) \

LOCAL_CFLAGS := $(BLUEZ_COMMON_CFLAGS)

LOCAL_SHARED_LIBRARIES := libhardware

LOCAL_MODULE_PATH := $(TARGET_OUT_OPTIONAL_EXECUTABLES)
LOCAL_MODULE_TAGS := debug
LOCAL_MODULE := haltest

include $(BUILD_EXECUTABLE)

#
# btmon
#

include $(CLEAR_VARS)

LOCAL_SRC_FILES := \
	bluez/monitor/main.c \
	bluez/monitor/mainloop.c \
	bluez/monitor/display.c \
	bluez/monitor/hcidump.c \
	bluez/monitor/btsnoop.c \
	bluez/monitor/control.c \
	bluez/monitor/packet.c \
	bluez/monitor/l2cap.c \
	bluez/monitor/uuid.c \
	bluez/monitor/sdp.c \
	bluez/monitor/vendor.c \
	bluez/monitor/lmp.c \
	bluez/monitor/crc.c \
	bluez/monitor/ll.c \
	bluez/monitor/hwdb.c \
	bluez/monitor/ellisys.c \
	bluez/monitor/analyze.c \
	bluez/src/shared/util.c \
	bluez/src/shared/queue.c \
	bluez/lib/hci.c \
	bluez/lib/bluetooth.c \

LOCAL_C_INCLUDES := \
	$(LOCAL_PATH)/bluez \
	$(LOCAL_PATH)/bluez/lib \
	$(LOCAL_PATH)/bluez/src/shared \

LOCAL_CFLAGS := $(BLUEZ_COMMON_CFLAGS)

LOCAL_MODULE_PATH := $(TARGET_OUT_OPTIONAL_EXECUTABLES)
LOCAL_MODULE_TAGS := debug
LOCAL_MODULE := btmon

include $(BUILD_EXECUTABLE)

#
# btproxy
#

include $(CLEAR_VARS)

LOCAL_SRC_FILES := \
	bluez/tools/btproxy.c \
	bluez/monitor/mainloop.c \
	bluez/src/shared/util.c \

LOCAL_C_INCLUDES := \
	$(LOCAL_PATH)/bluez \
	$(LOCAL_PATH)/bluez/src/shared \

LOCAL_CFLAGS := $(BLUEZ_COMMON_CFLAGS)

LOCAL_MODULE_PATH := $(TARGET_OUT_OPTIONAL_EXECUTABLES)
LOCAL_MODULE_TAGS := debug
LOCAL_MODULE := btproxy

include $(BUILD_EXECUTABLE)

#
# A2DP audio
#

include $(CLEAR_VARS)

LOCAL_SRC_FILES := bluez/android/hal-audio.c

LOCAL_C_INCLUDES = \
	$(call include-path-for, system-core) \
	$(call include-path-for, libhardware) \

LOCAL_SHARED_LIBRARIES := \
	libcutils \

LOCAL_CFLAGS := $(BLUEZ_COMMON_CFLAGS) \

LOCAL_MODULE_PATH := $(TARGET_OUT_SHARED_LIBRARIES)/hw
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE := audio.a2dp.default

include $(BUILD_SHARED_LIBRARY)

#
# l2cap-test
#

include $(CLEAR_VARS)

LOCAL_SRC_FILES := \
	bluez/tools/l2test.c \
	bluez/lib/bluetooth.c \
	bluez/lib/hci.c \

LOCAL_C_INCLUDES := \
	$(LOCAL_PATH)/bluez \
	$(LOCAL_PATH)/bluez/lib \
	$(LOCAL_PATH)/bluez/src/shared \

LOCAL_CFLAGS := $(BLUEZ_COMMON_CFLAGS)

LOCAL_MODULE_PATH := $(TARGET_OUT_OPTIONAL_EXECUTABLES)
LOCAL_MODULE_TAGS := debug
LOCAL_MODULE := l2test

include $(BUILD_EXECUTABLE)

#
# bluetoothd-snoop
#

include $(CLEAR_VARS)

LOCAL_SRC_FILES := \
	bluez/android/bluetoothd-snoop.c \
	bluez/monitor/mainloop.c \
	bluez/src/shared/btsnoop.c \

LOCAL_C_INCLUDES := \
	$(LOCAL_PATH)/bluez \
	$(LOCAL_PATH)/bluez/lib \

LOCAL_CFLAGS := $(BLUEZ_COMMON_CFLAGS)

LOCAL_MODULE_TAGS := optional
LOCAL_MODULE := bluetoothd-snoop

include $(BUILD_EXECUTABLE)

#
# init.bluetooth.rc
#

include $(CLEAR_VARS)

LOCAL_MODULE := init.bluetooth.rc
LOCAL_MODULE_CLASS := ETC
LOCAL_SRC_FILES := bluez/android/$(LOCAL_MODULE)
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_PATH := $(TARGET_ROOT_OUT)

include $(BUILD_PREBUILT)

#
# btmgmt
#

include $(CLEAR_VARS)

LOCAL_SRC_FILES := \
	bluez/tools/btmgmt.c \
	bluez/lib/bluetooth.c \
	bluez/lib/sdp.c \
	bluez/monitor/mainloop.c \
	bluez/src/shared/io-mainloop.c \
	bluez/src/shared/mgmt.c \
	bluez/src/shared/queue.c \
	bluez/src/shared/util.c \
	bluez/src/uuid-helper.c \

LOCAL_C_INCLUDES := \
	$(LOCAL_PATH)/bluez \
	$(LOCAL_PATH)/bluez/src \
	$(LOCAL_PATH)/bluez/lib \

LOCAL_CFLAGS := $(BLUEZ_COMMON_CFLAGS)

LOCAL_MODULE_PATH := $(TARGET_OUT_OPTIONAL_EXECUTABLES)
LOCAL_MODULE_TAGS := debug
LOCAL_MODULE := btmgmt

include $(BUILD_EXECUTABLE)

#
# l2ping
#

include $(CLEAR_VARS)

LOCAL_SRC_FILES := \
	bluez/tools/l2ping.c \
	bluez/lib/bluetooth.c \
	bluez/lib/hci.c \

LOCAL_C_INCLUDES := \
	$(LOCAL_PATH)/bluez/lib \

LOCAL_CFLAGS := $(BLUEZ_COMMON_CFLAGS)

LOCAL_MODULE_PATH := $(TARGET_OUT_OPTIONAL_EXECUTABLES)
LOCAL_MODULE_TAGS := debug
LOCAL_MODULE := l2ping

include $(BUILD_EXECUTABLE)
