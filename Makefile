ARCHS = 	armv7 armv7s arm64 arm64e
TARGET = 	iphone:clang:13.0:5.0

GO_EASY_ON_ME = 	0
FINALPACKAGE = 		1
DEBUG = 			0

PREFIX = $(THEOS)/toolchains/xcode11.xctoolchain/usr/bin/
INSTALL_TARGET_PROCESSES = Preferences

include $(THEOS)/makefiles/common.mk

INCLUDES = $(THEOS_PROJECT_DIR)/source

LIBRARY_NAME 							= libCSColorPicker
$(LIBRARY_NAME)_FILES 					= $(wildcard source/*.m source/*/*.m)
$(LIBRARY_NAME)_FRAMEWORKS 				= UIKit CoreGraphics CoreFoundation
$(LIBRARY_NAME)_PRIVATE_FRAMEWORKS 		= Preferences
$(LIBRARY_NAME)_CFLAGS 					+= -fobjc-arc -I$(INCLUDES) -IPrefix.pch

include $(THEOS_MAKE_PATH)/library.mk

# SUBPROJECTS += lcpshim
# include $(THEOS_MAKE_PATH)/aggregate.mk
