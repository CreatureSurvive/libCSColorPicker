//
// Created by Dana Buehre on 3/17/17.
// Copyright (c) 2017 CreatureSurvive. All rights reserved.
//
#import <CoreFoundation/CoreFoundation.h>
#import <UIKit/UIKit.h>

#ifdef __cplusplus /* If this is a C++ compiler, use C linkage */
extern "C" {
#endif

UIColor *colorFromHexStringWithFallback(NSString *hexString, NSString *fallback);

#ifdef __cplusplus /* If this is a C++ compiler, end C linkage */
}
#endif
