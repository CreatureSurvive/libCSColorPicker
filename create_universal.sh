set -e

make

make SIMULATOR=1

lipo ./.theos/obj/iphone_simulator/libCSColorPicker.dylib ./.theos/obj/libCSColorPicker.dylib -output ./libCSColorPicker.dylib -create
# Creates a dylib that can be properly linked from tweaks targetting both simulator and real devices
