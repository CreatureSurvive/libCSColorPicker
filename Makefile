GO_EASY_ON_ME = 1
FINALPACKAGE = 1
DEBUG = 0

ARCHS = armv7 armv7s arm64

TARGET = iphone:clang:10.1:latest

include $(THEOS)/makefiles/common.mk

LIBRARY_NAME = libCSColorPicker
libCSColorPicker_FILES = $(wildcard *.m *.mm)
libCSColorPicker_FRAMEWORKS = UIKit CoreGraphics CoreFoundation
libCSColorPicker_PRIVATE_FRAMEWORKS = Preferences
motuumLS_CFLAGS += -fobjc-arc

after-install::
	install.exec "killall -9 Preferences"

include $(THEOS_MAKE_PATH)/library.mk
