//
// Created by CreatureSurvive on 3/17/17.
// Copyright (c) 2016 - 2019 CreatureCoding. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreFoundation/CoreFoundation.h>

#import <Categories/UIColor+CSColorPicker.h>
#import <Categories/NSString+CSColorPicker.h>

#ifdef __cplusplus
extern "C" {
#endif

UIColor *colorFromHexString(NSString *hexString);
NSString *hexStringFromColor(UIColor *color);
BOOL isValidHexString(NSString *hexString);

#ifdef __cplusplus
}
#endif
