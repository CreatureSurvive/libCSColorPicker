//
// Created by CreatureSurvive on 3/17/17.
// Copyright (c) 2018 CreatureCoding. All rights reserved.
//

#import <CoreFoundation/CoreFoundation.h>
#import <UIKit/UIKit.h>
#import "UIColor+CSColorPicker.h"
#import "NSString+CSColorPicker.h"

#ifdef __cplusplus
extern "C" {
#endif

UIColor *colorFromHexString(NSString *hexString);
NSString *hexStringFromColor(UIColor *color);
BOOL isValidHexString(NSString *hexString);

#ifdef __cplusplus
}
#endif
