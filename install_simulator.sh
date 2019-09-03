set -e

make SIMULATOR=1

THEOS_OBJ_DIR=./.theos/obj/iphone_simulator

#install libCSColorPicker into all additionally installed simulators

for runtime in /Library/Developer/CoreSimulator/Profiles/Runtimes/*
do
  if [ -d "$runtime" ]; then
    echo "Installing libCSColorPicker to $runtime"
    SIMULATOR_ROOT=$runtime/Contents/Resources/RuntimeRoot
    SIMULATOR_LIB_PATH=$SIMULATOR_ROOT/usr/lib

    if [ -d "$SIMULATOR_LIB_PATH" ]; then
      sudo rm -rf "$SIMULATOR_LIB_PATH/libCSColorPicker.dylib" ||:
    	sudo cp -rf "$THEOS_OBJ_DIR/libCSColorPicker.dylib" "$SIMULATOR_LIB_PATH"
    fi
  fi
done

#install libCSColorPicker into the simulator that ships with Xcode

for SIMULATOR_ROOT in /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/Library/CoreSimulator/Profiles/Runtimes/iOS.simruntime/Contents/Resources/RuntimeRoot /Applications/Xcode-beta.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/Library/CoreSimulator/Profiles/Runtimes/iOS.simruntime/Contents/Resources/RuntimeRoot /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Library/Developer/CoreSimulator/Profiles/Runtimes/iOS.simruntime/Contents/Resources/RuntimeRoot /Applications/Xcode-beta.app/Contents/Developer/Platforms/iPhoneOS.platform/Library/Developer/CoreSimulator/Profiles/Runtimes/iOS.simruntime/Contents/Resources/RuntimeRoot
do
  if [ -d "$SIMULATOR_ROOT" ]; then
    echo "Installing libCSColorPicker to $SIMULATOR_ROOT"
    SIMULATOR_LIB_PATH=$SIMULATOR_ROOT/usr/lib

    if [ -d "$SIMULATOR_LIB_PATH" ]; then
      sudo rm -rf "$SIMULATOR_LIB_PATH/libCSColorPicker.dylib" ||:
    	sudo cp -rf "$THEOS_OBJ_DIR/libCSColorPicker.dylib" "$SIMULATOR_LIB_PATH"
    fi
  fi
done
