RELEASE				= 1
GO_EASY_ON_ME 		= 0

export TARGET 		= iphone:clang:13.0:13.0
export ARCHS 		= arm64 arm64e

ifeq ($(RELEASE), 1)
	BUILDNUMBER 		=
	FINALPACKAGE 		= 1
	BUILD_EXT 			=
	DEBUG 				= 1
	THEOS_PACKAGE_DIR 	= releases
else
	BUILDNUMBER 		= -$(VERSION.INC_BUILD_NUMBER)
	BUILDNUMBER			=
	FINALPACKAGE 		= 1
	BUILD_EXT 			= b
	DEBUG 				= 1
	THEOS_PACKAGE_DIR 	= debug
endif

PACKAGE_VERSION 		= $(THEOS_PACKAGE_BASE_VERSION)$(BUILDNUMBER)$(BUILD_EXT)

INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = StatusSelect

StatusSelect_FILES = Tweak.x
StatusSelect_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk

SUBPROJECTS += preferences
include $(THEOS_MAKE_PATH)/aggregate.mk
