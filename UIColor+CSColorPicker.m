/**
 * @Author: Dana Buehre <creaturesurvive>
 * @Date:   18-03-2017 12:20:42
 * @Email:  dbuehre@me.com
 * @Filename: UIColor+CSColorPicker.m
 * @Last modified by:   creaturesurvive
 * @Last modified time: 21-09-2017 2:21:03
 * @Copyright: Copyright © 2014-2017 CreatureSurvive
 */


//
// Created by Dana Buehre on 3/17/17.
// Copyright (c) 2017 CreatureSurvive. All rights reserved.
//

#import "UIColor+CSColorPicker.h"

@implementation UIColor (CSColorPicker)

+ (NSString *)hexStringFromColor:(UIColor *)color {

    CGFloat red, green, blue;
    [color getRed:&red green:&green blue:&blue alpha:nil];
    red = roundf(red * 255.0f);
    green = roundf(green * 255.0f);
    blue = roundf(blue * 255.0f);

    return [[[NSString alloc] initWithFormat:@"%02x%02x%02x", (int)red, (int)green, (int)blue] uppercaseString];
}

+ (NSString *)hexStringFromColorWithAlpha:(UIColor *)color {


    CGFloat red, green, blue, alpha;
    [color getRed:&red green:&green blue:&blue alpha:&alpha];
    red = roundf(red * 255.0f);
    green = roundf(green * 255.0f);
    blue = roundf(blue * 255.0f);

    return [[[NSString alloc] initWithFormat:@"%02x%02x%02x:%f", (int)red, (int)green, (int)blue, alpha] uppercaseString];
}

+ (NSString *)informationStringForColor:(UIColor *)color wide:(BOOL)wide {
    CGFloat h, s, b, r, g, bb;
    [color getHue:&h saturation:&s brightness:&b alpha:nil];
    [color getRed:&r green:&g blue:&bb alpha:nil];
    if (wide) {
        return [NSString stringWithFormat:@"#%@\n\nR: %.f       H: %.f\nG: %.f       S: %.f\nB: %.f       B: %.f", [UIColor hexStringFromColor:color], r * 255, h * 360, g * 255, s * 100, bb * 255, b * 100];
    }
    return [NSString stringWithFormat:@"#%@\n\nR: %.f\nG: %.f\nB: %.f\n\nH: %.f\nS: %.f\nB: %.f", [UIColor hexStringFromColor:color], r * 255, g * 255, bb * 255, h * 360, s * 100, b * 100];
}

+ (CGFloat)brightnessOfColor:(UIColor *)color {
    const CGFloat *components = CGColorGetComponents(color.CGColor);
    CGFloat brightness = ((components[0] * 299) + (components[1] * 587) + (components[2] * 114)) / 1000;
    return brightness;
}

+ (UIColor *)colorFromHexString:(NSString *)hexString {
    CGFloat alpha = 1;
    NSString *color = @"FF0000";

    if (hexString && hexString.length > 0) {

        NSArray *RGBA = [hexString componentsSeparatedByString:@":"];
        if ([hexString rangeOfString:@":"].location != NSNotFound) {

            alpha = RGBA[1] ? [RGBA[1] floatValue] : 1;
        }
        color = RGBA[0];
    }

    return [UIColor colorFromHexString:color alpha:alpha];
}

+ (UIColor *)colorFromHexString:(NSString *)hexString fallbackString:(NSString *)fallback {

    CGFloat alpha = 1;
    NSString *color = @"FF0000", *hex;

    hex = hexString && hexString.length > 0 ? hexString : fallback;
    NSArray *RGBA = [hex componentsSeparatedByString:@":"];
    if ([hex rangeOfString:@":"].location != NSNotFound) {
        alpha = RGBA[1] ? [RGBA[1] floatValue] : 1;
    }
    color = RGBA[0];
    return [UIColor colorFromHexString:color alpha:alpha];


}

+ (UIColor *)colorFromHexString:(NSString *)hexString alpha:(CGFloat)alpha {

    BOOL hasTag = [[hexString substringToIndex:1] isEqual:@"#"];
    hexString = hasTag ? [hexString substringFromIndex:1] : hexString;

    if (![self isValidHexString:hexString]) {
        return [UIColor colorWithRed:1 green:0 blue:0 alpha:alpha];
    }
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    // [scanner setScanLocation:hasTag ? 1 : 0]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];

    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0f
                           green:((rgbValue & 0xFF00) >> 8)/255.0f
                            blue:(rgbValue & 0xFF)/255.0f
                           alpha:alpha];
}

+ (BOOL)isValidHexString:(NSString *)hexStr {
    NSCharacterSet *hexChars = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789ABCDEFabcdef"] invertedSet];
    return (NSNotFound == [hexStr rangeOfCharacterFromSet:hexChars].location);
}

- (UIColor *)adjustBrightnessByAmount:(CGFloat)amount {
    CGFloat h, s, b, a;
    if ([self getHue:&h saturation:&s brightness:&b alpha:&a])
        return [UIColor colorWithHue:h
                          saturation:s
                          brightness:MIN(b * amount, 1.0f)
                               alpha:a];
    return nil;
}

- (CGFloat)alpha {
    CGFloat a;
    [self getWhite:NULL alpha:&a];
    return a;
}

- (CGFloat)red {
    CGFloat r;
    [self getRed:&r green:NULL blue:NULL alpha:NULL];
    return r;
}

- (CGFloat)green {
    CGFloat g;
    [self getRed:NULL green:&g blue:NULL alpha:NULL];
    return g;
}

- (CGFloat)blue {
    CGFloat b;
    [self getRed:NULL green:NULL blue:&b alpha:NULL];
    return b;
}

- (CGFloat)hue {
    CGFloat h;
    [self getHue:&h saturation:NULL brightness:NULL alpha:NULL];
    return h;
}

- (CGFloat)saturation {
    CGFloat s;
    [self getHue:NULL saturation:&s brightness:NULL alpha:NULL];
    return s;
}

- (CGFloat)brightness {
    CGFloat b;
    [self getHue:NULL saturation:NULL brightness:&b alpha:NULL];
    return b;
}

@end
