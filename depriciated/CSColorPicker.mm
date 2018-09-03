//
// Created by CreatureSurvive on 3/17/17.
// Copyright (c) 2018 CreatureCoding. All rights reserved.
//

#include "CSColorPicker.h"

extern "C" UIColor *colorFromHexString(NSString *hexString);
extern "C" BOOL isValidHexString(NSString *hexString);
extern "C" NSString *hexStringFromColor(UIColor *color);

UIColor *colorFromHexString(NSString *hexString) {

    return [UIColor colorFromHexString:hexString];
}

BOOL isValidHexString(NSString *hexString) {

    return [UIColor isValidHexString:hexString];
}

NSString *hexStringFromColor(UIColor *color) {

    return [UIColor hexStringFromColor:color];
}
