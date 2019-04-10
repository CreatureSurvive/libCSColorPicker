ARCHS = armv7 armv7s arm64 arm64e
TARGET = iphone:clang:11.2:5.0

GO_EASY_ON_ME = 0
FINALPACKAGE = 1
DEBUG = 0

include $(THEOS)/makefiles/common.mk

INCLUDES = $(THEOS_PROJECT_DIR)/source

LIBRARY_NAME 							= libCSColorPicker
$(LIBRARY_NAME)_FILES 					= $(wildcard source/*.m source/*/*.m)
$(LIBRARY_NAME)_FRAMEWORKS 				= UIKit CoreGraphics CoreFoundation
$(LIBRARY_NAME)_PRIVATE_FRAMEWORKS 		= Preferences
$(LIBRARY_NAME)_CFLAGS 					+= -fobjc-arc -I$(INCLUDES) -IPrefix.pch

after-install::
	install.exec "killall -9 Preferences"

include $(THEOS_MAKE_PATH)/library.mk
