ARCHS = 	armv7 armv7s arm64 arm64e
TARGET = 	iphone:clang:13.0:5.0

DEBUG = 			1
FINALPACKAGE = 		1
LEAN_AND_MEAN = 	1
GO_EASY_ON_ME = 	0

INSTALL_TARGET_PROCESSES = Preferences TweakSettings

include $(THEOS)/makefiles/common.mk

INCLUDES = $(THEOS_PROJECT_DIR)/source

LIBRARY_NAME 							= libCSColorPicker
$(LIBRARY_NAME)_FILES 					= $(wildcard source/*.m source/*/*.m)
$(LIBRARY_NAME)_FRAMEWORKS 				= UIKit CoreGraphics CoreFoundation
$(LIBRARY_NAME)_PRIVATE_FRAMEWORKS 		= Preferences
$(LIBRARY_NAME)_CFLAGS 					+= -fobjc-arc -I$(INCLUDES) -IPrefix.pch

include $(THEOS_MAKE_PATH)/library.mk

after-stage::
	$(ECHO_NOTHING)mkdir -p "$(THEOS_STAGING_DIR)/usr/include/CSColorPicker"$(ECHO_END)
	$(ECHO_NOTHING)cp "$(THEOS_PROJECT_DIR)/source/CSColorPicker.h" "$(THEOS_STAGING_DIR)/usr/include/CSColorPicker/CSColorPicker.h"$(ECHO_END)
	$(ECHO_NOTHING)cp "$(THEOS_PROJECT_DIR)/source/Categories/UIColor+CSColorPicker.h" "$(THEOS_STAGING_DIR)/usr/include/CSColorPicker/UIColor+CSColorPicker.h"$(ECHO_END)
	$(ECHO_NOTHING)cp "$(THEOS_PROJECT_DIR)/source/Categories/NSString+CSColorPicker.h" "$(THEOS_STAGING_DIR)/usr/include/CSColorPicker/NSString+CSColorPicker.h"$(ECHO_END)

	$(ECHO_NOTHING)mkdir -p "$(THEOS_PROJECT_DIR)/CSColorPicker Resources/CSColorPicker"$(ECHO_END)
	$(ECHO_NOTHING)cp "$(THEOS_STAGING_DIR)/usr/lib/libCSColorPicker.dylib" "$(THEOS_PROJECT_DIR)/CSColorPicker Resources/libCSColorPicker.dylib"$(ECHO_END)
	$(ECHO_NOTHING)cp "$(THEOS_PROJECT_DIR)/source/CSColorPicker.h" "$(THEOS_PROJECT_DIR)/CSColorPicker Resources/CSColorPicker/CSColorPicker.h"$(ECHO_END)
	$(ECHO_NOTHING)cp "$(THEOS_PROJECT_DIR)/source/Categories/UIColor+CSColorPicker.h" "$(THEOS_PROJECT_DIR)/CSColorPicker Resources/CSColorPicker/UIColor+CSColorPicker.h"$(ECHO_END)
	$(ECHO_NOTHING)cp "$(THEOS_PROJECT_DIR)/source/Categories/NSString+CSColorPicker.h" "$(THEOS_PROJECT_DIR)/CSColorPicker Resources/CSColorPicker/NSString+CSColorPicker.h"$(ECHO_END)
	$(ECHO_NOTHING)zip "$(THEOS_PROJECT_DIR)/CSColorPicker Resources.zip" "$(THEOS_PROJECT_DIR)/CSColorPicker Resources"$(ECHO_END)

	$(ECHO_NOTHING)mkdir -p "$(THEOS)/include/CSColorPicker"$(ECHO_END)
	$(ECHO_NOTHING)cp "$(THEOS_STAGING_DIR)/usr/lib/libCSColorPicker.dylib" "$(THEOS)/lib/libCSColorPicker.dylib"$(ECHO_END)
	$(ECHO_NOTHING)cp "$(THEOS_PROJECT_DIR)/source/CSColorPicker.h" "$(THEOS)/include/CSColorPicker/CSColorPicker.h"$(ECHO_END)
	$(ECHO_NOTHING)cp "$(THEOS_PROJECT_DIR)/source/Categories/UIColor+CSColorPicker.h" "$(THEOS)/include/CSColorPicker/UIColor+CSColorPicker.h"$(ECHO_END)
	$(ECHO_NOTHING)cp "$(THEOS_PROJECT_DIR)/source/Categories/NSString+CSColorPicker.h" "$(THEOS)/include/CSColorPicker/NSString+CSColorPicker.h"$(ECHO_END)
	