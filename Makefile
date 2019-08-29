SIMULATOR ?= 0

ifeq ($(SIMULATOR), 1)
ARCHS = i386 x86_64
TARGET = simulator:clang:12.1:9.0
else
ARCHS = armv7 armv7s arm64 arm64e
TARGET = iphone:clang:12.1.2:9.0
endif

GO_EASY_ON_ME = 	0
FINALPACKAGE = 		1
DEBUG = 			0

include $(THEOS)/makefiles/common.mk

INCLUDES = $(THEOS_PROJECT_DIR)/source

LIBRARY_NAME 							= libCSColorPicker
$(LIBRARY_NAME)_FILES 					= $(wildcard source/*.m source/*/*.m)
$(LIBRARY_NAME)_FRAMEWORKS 				= UIKit CoreGraphics CoreFoundation
$(LIBRARY_NAME)_PRIVATE_FRAMEWORKS 		= Preferences
$(LIBRARY_NAME)_CFLAGS 					+= -fobjc-arc -I$(INCLUDES) -IPrefix.pch

ifeq ($(SIMULATOR), 1)
$(LIBRARY_NAME)_CFLAGS += -D SIMULATOR=1
endif

after-install::
	install.exec "killall -9 Preferences"

include $(THEOS_MAKE_PATH)/library.mk
