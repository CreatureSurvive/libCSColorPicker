GO_EASY_ON_ME = 1
FINALPACKAGE = 1
DEBUG = 0

ARCHS = armv7 armv7s arm64

TARGET = iphone:clang:11.2:10.0

THEOS_DEVICE_IP = 192.168.86.160
THEOS_DEVICE_PORT = 2222

include $(THEOS)/makefiles/common.mk

LIBRARY_NAME = libCSColorPicker
$(LIBRARY_NAME)_FILES = $(wildcard *.m *.mm)
$(LIBRARY_NAME)_FRAMEWORKS = UIKit CoreGraphics CoreFoundation
$(LIBRARY_NAME)_PRIVATE_FRAMEWORKS = Preferences
$(LIBRARY_NAME)_CFLAGS += -fobjc-arc

after-install::
	install.exec "killall -9 Preferences"

include $(THEOS_MAKE_PATH)/library.mk
