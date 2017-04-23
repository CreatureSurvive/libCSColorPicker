//
// Created by Dana Buehre on 3/17/17.
// Copyright (c) 2017 CreatureSurvive. All rights reserved.
//

#include "CSColorPicker.h"

extern "C" UIColor *colorFromHexStringWithFallback(NSString *hexString, NSString *fallback);
extern "C" UIColor *colorFromHexStringWithAlpha(NSString *hexString, CGFloat alpha);
extern "C" UIColor *colorFromHexString(NSString *hexString);
extern "C" BOOL isValidHexString(NSString *hexString);
extern "C" NSString *hexStringFromColor(UIColor *color);
extern "C" NSString *hexStringFromColorWithAlpha(UIColor *color);
extern "C" NSString *informationStringForColor(UIColor *color, BOOL wide);


UIColor *colorFromHexStringWithFallback(NSString *hexString, NSString *fallback) {
    NSString *hex = hexString && hexString.length > 0 ? hexString : fallback;

    return colorFromHexString(hex);
}

UIColor *colorFromHexStringWithAlpha(NSString *hexString, CGFloat alpha) {
    BOOL hasTag = [[hexString substringToIndex:1] isEqual:@ "#"];
    hexString = hasTag ? [hexString substringFromIndex : 1] : hexString;

    if (!isValidHexString(hexString)) {
        return [UIColor colorWithRed : 1 green : 0 blue : 0 alpha:alpha];
    }
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];

    [scanner scanHexInt: &rgbValue];

    return [UIColor colorWithRed: ((rgbValue & 0xFF0000) >> 16)/255.0f
green:      ((rgbValue & 0xFF00) >> 8)/255.0f
blue:       (rgbValue & 0xFF)/255.0f
alpha:      alpha];
}

UIColor *colorFromHexString(NSString *hexString) {
    CGFloat alpha = 1;
    NSString *color = @ "FF0000";

    if (hexString && hexString.length > 0) {

        NSArray *RGBA = [hexString componentsSeparatedByString:@ ":"];
        if ([hexString rangeOfString: @ ":"].location != NSNotFound) {

            alpha = RGBA[1] ? [RGBA[1] floatValue] : 1;
        }
        color = RGBA[0];
    }

    return colorFromHexStringWithAlpha(color, alpha);
}

BOOL isValidHexString(NSString *hexString) {
    NSCharacterSet *hexChars = [[NSCharacterSet characterSetWithCharactersInString:@ "0123456789ABCDEFabcdef"] invertedSet];
    return (NSNotFound == [hexString rangeOfCharacterFromSet:hexChars].location);
}

NSString *hexStringFromColor(UIColor *color) {

    CGFloat red, green, blue;
    [color getRed: &red green: &green blue: &blue alpha: nil];
    red = roundf(red * 255.0f);
    green = roundf(green * 255.0f);
    blue = roundf(blue * 255.0f);

    return [[[NSString alloc] initWithFormat: @ "%02x%02x%02x", (int)red, (int)green, (int)blue] uppercaseString];
}

NSString *hexStringFromColorWithAlpha(UIColor *color) {


    CGFloat red, green, blue, alpha;
    [color getRed: &red green: &green blue: &blue alpha: &alpha];
    red = roundf(red * 255.0f);
    green = roundf(green * 255.0f);
    blue = roundf(blue * 255.0f);

    return [[[NSString alloc] initWithFormat: @ "%02x%02x%02x:%f", (int)red, (int)green, (int)blue, alpha] uppercaseString];
}

NSString *informationStringForColor(UIColor *color, BOOL wide) {
    CGFloat h, s, b, r, g, bb;
    [color getHue: &h saturation: &s brightness: &b alpha: nil];
    [color getRed: &r green: &g blue: &bb alpha: nil];

    return wide ? [NSString stringWithFormat : @ "#%@\n\nR: %.f       H: %.f\nG: %.f       S: %.f\nB: %.f       B: %.f", hexStringFromColor(color), r * 255, h * 360, g * 255, s * 100, bb * 255, b * 100] :
           [NSString stringWithFormat: @ "#%@\n\nR: %.f\nG: %.f\nB: %.f\n\nH: %.f\nS: %.f\nB: %.f", hexStringFromColor(color), r * 255, g * 255, bb * 255, h * 360, s * 100, b * 100];
}

