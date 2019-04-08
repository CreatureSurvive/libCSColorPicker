# libCSColorPicker

---

A simplistic yet powerful color picker for use in PreferenceLoader preference bundles. Supports iOS 9 - 11, other iOS versions have not been tested.

Best when used with [libCSPreference](https://creaturesurvive.github.io/repo/cydia/libcspreferences/depiction/) but also works fine on it's own.

### Install Instructions

---

* Place CSColorPicker folder in the vendor/include directory of your Theos installation.
* Place libCSColorPicker.dylib in the /lib directory of your Theos installation.
* Thats it.



### Usage Instructions

---

* Lets start with the Makefile and get libCSColorPicker properly linked to your project, to do so you can simply add this to your Makefile `MyAwsomeTweak_LDFLAGS += -lCSColorPicker`. Here is an example makefile for a project using libCSColorPicker:

```makefile
ARCHS = arm64
TARGET = iphone:clang:11.2:latest

GO_EASY_ON_ME = 1
FINALPACKAGE = 1
DEBUG = 0

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = MyAwesomeTweak
$(TWEAK_NAME)_FILES = Tweak.xm
$(TWEAK_NAME)_CFLAGS +=  -fobjc-arc
$(TWEAK_NAME)_LDFLAGS += -lCSColorPicker

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += preferences
include $(THEOS_MAKE_PATH)/aggregate.mk

after-install::
	install.exec "killall -9 SpringBoard"
```



Now lets take a look at the usage within your your Tweak.xm

```objective-c
#include <CSColorPicker/CSColorPicker.h>
#define PLIST_PATH @"/User/Library/Preferences/com.creaturecoding.MyAwesomeTweak.plist"

// lets set up a simple means of fetching values from out preferences
// NOTE: this is just an example, you should cache the preference dictionary 
// if you plan to use this in a tweak
inline NSString *StringForPreferenceKey(NSString *key) {
    NSDictionary *prefs = [NSDictionary dictionaryWithContentsOfFile:PLIST_PATH] ? : [NSDictionary new];
    return prefs[key];
}

%hook MyAwsomeView

// lets change the background color of MyAwsomeView using the color set in our preferences
- (void)setBackgroundColor:(UIColor *)color {
	// libCSColorPicker extendes the UIColor class so that usage is familiar
	// you can also use the C method hexStringFromColor(UIColor *color);
    color = [UIColor colorFromHexString:StringForPreferenceKey(@"k_myAwesomeBackgroundColor)];

   // lets see what else we can do with libCSColorPicker
   // outputs FF0000 assuming out color is red
   NSString *hex = [UIColor hexStringFromColor:color];
   NSLog(hex); 
   
   // and now with the alpha channel included
   // outputs FFFF0000 assuming out color is red with an alpha value of 1
   // supported formats include 'RGB', 'ARGB', 'RRGGBB', 'AARRGGBB', 'RGB:0.25', 'RRGGBB:0.25'
   NSString *hex = [UIColor hexStringFromColor:color alpha:YES];
   NSLog(hex); 
   
   // we can also validate our hex string if we need 
   BOOL valid = [UIColor isValidHexString:@"FFFFFF"];
}

- (void)setGradienView {
	// get an array of CGColors from a preference value, the value is a comma separated string of hex colors eg" FFFFFF,000000,111111
	NSArray<id> *gradientColors = [StringForPreferenceKey(@"k_myAwesomeBackgroundGradient) gradientStringCGColors];

	CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.view.bounds;

	// left to right gradient
    gradient.startPoint = CGPointMake(0, 0.5);
    gradient.endPoint = CGPointMake(1, 0.5);

	// set the gradient colors
	gradient.colors = gradientColors;

	// add the gradient to the view
	[self.view addSublayer:gradient];

	// if upi need an array of UIColors instead of CGColors use:
	NSArray<UIColor *> ui_colors = [StringForPreferenceKey(@"k_myAwesomeBackgroundGradient) gradientStringColors]; 
}

%end
```



* Now lets look at how we can set this up in our preferences to use the color picker. Once again lets start with the makefile by adding `MyAwesomeTweakPrefs_LDFLAGS += -lCSColorPicker` Here is an example makefile for a preferences using libCSColorPicker:

```
ARCHS = arm64
TARGET = iphone:clang:11.2:latest

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = MyAwsomeTweak
$(BUNDLE_NAME)_FILES = $(wildcard *.m)
$(BUNDLE_NAME)_INSTALL_PATH = /Library/PreferenceBundles
$(BUNDLE_NAME)_FRAMEWORKS = UIKit
$(BUNDLE_NAME)_PRIVATE_FRAMEWORKS = Preferences
$(BUNDLE_NAME)_LDFLAGS += -lCSColorPicker

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/MyAwesomeTweak.plist$(ECHO_END)


```



* Now all thats left is to add it to one of our preferences plists like the Root.plist and set up the specifier.

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
	<dict>
        <key>title</key>
		<string>MyAwesomeTweak</string>
		
		<key>items</key>
		<array>

			<!-- color cell specifier -->
			<dict>
				<key>PostNotification</key>
				<string>com.creaturecoding.MyAwsomeTweak.prefsChanged</string> 
				<key>cell</key>
				<string>PSLinkCell</string>
				<key>cellClass</key>
				<string>CSColorDisplayCell</string>
				<key>defaults</key>
				<string>com.creaturecoding.MyAwsomeTweak</string>
				<key>defaultsPath</key>
				<string>/Library/PreferenceBundles/MyAwesomeTweak.bundle</string>
				<key>key</key>
				<string>k_myAwesomeBackgroundColor</string>
				<key>label</key>
				<string>My Awsome Background Color</string>
                <key>fallback</key>
                <string>FFFFFF</string>
				<key>alpha</key>
				<false/>
			</dict>

			<!-- gradient cell specifier -->
			<dict>
				<key>PostNotification</key>
				<string>com.creaturecoding.MyAwsomeTweak.prefsChanged</string> 
				<key>cell</key>
				<string>PSLinkCell</string>
				<key>cellClass</key>
				<string>CSGradientDisplayCell</string>
				<key>defaults</key>
				<string>com.creaturecoding.MyAwsomeTweak</string>
				<key>defaultsPath</key>
				<string>/Library/PreferenceBundles/MyAwesomeTweak.bundle</string>
				<key>key</key>
				<string>k_myAwesomeBackgroundGradient</string>
				<key>label</key>
				<string>My Awsome Background Gradient</string>
                <key>fallback</key>
                <string>FFFFFF,000000</string>
				<key>alpha</key>
				<false/>
			</dict>
		</array>
	</dict>
</plist>
```

if you want to use defaultsPath instead of fallback to set default colors, then create a plist named `defaults.plist` in your preferences Resource folder and add an entry for each color like so:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
	<dict>
		<!-- default color for key -->
		<key>k_myAwesomeBackgroundColor</key>
		<string>FFFFFF</string>

		<!-- default gradient for key -->
		<key>k_myAwesomeBackgroundGradient</key>
		<string>FFFFFF,000000</string>
	</dict>
</plis
```



Thats it, libCSColorPicker is ready to use in your project.

### Specifier configuration

---

* 'cell' is required and should to be set to `PSLinkCell` to function properly
*  'cellClass' is required and should be set to `CSColorDisplayCell`
* 'defaults' is required and should be the name of your preferences of your preferences plist in `/User/Library/Preferences`
* 'defaultsPath' is optional, if provided it should point to your tweaks preference bundle. this allows you to store a `defaults.plist` in the resource folder of your preferences that will store default color values for your tweak.
* 'fallback' is optional and if you have no value set in your preferences .plist, or defaultsPath, then this value will be used (NOTE: if none of these values are provided the color will default to RED or FF0000)
* 'alpha' is optional and will default to true if not provided, it is responsible for disabling the alpha slider in the color picker, and all colors will have an alpha of 1