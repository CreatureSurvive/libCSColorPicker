set -e

make SIMULATOR=1

THEOS_OBJ_DIR=./.theos/obj/iphone_simulator

#install PreferenceBundle into all additionally installed simulators

for runtime in /Library/Developer/CoreSimulator/Profiles/Runtimes/*
do
  echo "Installing libCSColorPicker to $runtime"

  SIMULATOR_ROOT=$runtime/Contents/Resources/RuntimeRoot
  SIMULATOR_LIB_PATH=$SIMULATOR_ROOT/usr/lib

  if [ -d "$SIMULATOR_LIB_PATH" ]; then
    sudo rm -rf "$SIMULATOR_LIB_PATH/libCSColorPicker.dylib" ||:
  	sudo cp -rf "$THEOS_OBJ_DIR/libCSColorPicker.dylib" "$SIMULATOR_LIB_PATH"
  fi
done

#install PreferenceBundle into the simulator that ships with Xcode

echo "Installing libCSColorPicker to /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/Library/CoreSimulator/Profiles/Runtimes/iOS.simruntime"

SIMULATOR_ROOT=/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/Library/CoreSimulator/Profiles/Runtimes/iOS.simruntime/Contents/Resources/RuntimeRoot
SIMULATOR_LIB_PATH=$SIMULATOR_ROOT/usr/lib

if [ -d "$SIMULATOR_LIB_PATH" ]; then
  sudo rm -rf "$SIMULATOR_LIB_PATH/libCSColorPicker.dylib" ||:
  sudo cp -rf "$THEOS_OBJ_DIR/libCSColorPicker.dylib" "$SIMULATOR_LIB_PATH"
fi
