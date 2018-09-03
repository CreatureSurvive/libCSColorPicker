//
// Created by CreatureSurvive on 3/17/17.
// Copyright (c) 2018 CreatureCoding. All rights reserved.
//

#import "UIColor+CSColorPicker.h"

@implementation UIColor (CSColorPicker)

+ (UIColor *)colorFromHexString:(NSString *)hexString {

    NSString *colorString = [[hexString stringByReplacingOccurrencesOfString:@"#" withString:@""] uppercaseString];
    CGFloat alpha, red, blue, green;

    if ([colorString rangeOfString:@":"].location != NSNotFound) {
        NSArray *stringComponents = [colorString componentsSeparatedByString:@":"];
        colorString = stringComponents[0];
        alpha = [stringComponents[1] floatValue] ? : 1.0f;
    }

    if (![UIColor isValidHexString:colorString]) {
        return [UIColor redColor];
    }

    switch ([colorString length]) {
        case 3:
            alpha = 1.0f;
            red = [self colorComponentFrom:colorString start:0 length:1];
            green = [self colorComponentFrom:colorString start:1 length:1];
            blue = [self colorComponentFrom:colorString start:2 length:1];
            break;
        case 4:
            alpha = [self colorComponentFrom:colorString start:0 length:1];
            red = [self colorComponentFrom:colorString start:1 length:1];
            green = [self colorComponentFrom:colorString start:2 length:1];
            blue = [self colorComponentFrom:colorString start:3 length:1];
            break;
        case 6:
            alpha = 1.0f;
            red = [self colorComponentFrom:colorString start:0 length:2];
            green = [self colorComponentFrom:colorString start:2 length:2];
            blue = [self colorComponentFrom:colorString start:4 length:2];
            break;
        case 8:
            alpha = [self colorComponentFrom:colorString start:0 length:2];
            red = [self colorComponentFrom:colorString start:2 length:2];
            green = [self colorComponentFrom:colorString start:4 length:2];
            blue = [self colorComponentFrom:colorString start:6 length:2];
            break;
        default:
            alpha = 100.0f;
            red = green = blue = 255.0f;
            break;
    }
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

+ (CGFloat)colorComponentFrom:(NSString *)string start:(NSUInteger)start length:(NSUInteger)length {
    NSString *substring = [string substringWithRange:NSMakeRange(start, length)];
    NSString *fullHex = length == 2 ? substring : [NSString stringWithFormat:@"%@%@", substring, substring];
    unsigned hexComponent;
    [[NSScanner scannerWithString:fullHex] scanHexInt:&hexComponent];
    return hexComponent / 255.0;
}

+ (BOOL)isValidHexString:(NSString *)hexString {
    NSCharacterSet *hexChars = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789ABCDEFabcdef"] invertedSet];
    return (NSNotFound == [[[hexString stringByReplacingOccurrencesOfString:@"#" withString:@""] uppercaseString] rangeOfCharacterFromSet:hexChars].location);
}

+ (NSString *)hexStringFromColor:(UIColor *)color {

    CGFloat red, green, blue;
    [color getRed:&red green:&green blue:&blue alpha:nil];
    red = roundf(red * 255.0f);
    green = roundf(green * 255.0f);
    blue = roundf(blue * 255.0f);

    return [[NSString stringWithFormat:@"%02x%02x%02x", (int)red, (int)green, (int)blue] uppercaseString];
}

+ (NSString *)hexStringFromColor:(UIColor *)color alpha:(BOOL)include {

    CGFloat red, green, blue, alpha;
    [color getRed:&red green:&green blue:&blue alpha:&alpha];
    red = roundf(red * 255.0f);
    green = roundf(green * 255.0f);
    blue = roundf(blue * 255.0f);
    alpha = roundf(alpha * 255.0f);

    return include ? [[NSString stringWithFormat:@"%02x%02x%02x%02x", (int)alpha, (int)red, (int)green, (int)blue] uppercaseString] :
           [[NSString stringWithFormat:@"%02x%02x%02x", (int)red, (int)green, (int)blue] uppercaseString];
}

+ (CGFloat)brightnessOfColor:(UIColor *)color {
    CGFloat red = 0.0, green = 0.0, blue = 0.0, alpha = 0.0;
    [color getRed:&red green:&green blue:&blue alpha:&alpha];

    return (((red * 255) * 299) + ((green * 255) * 587) + ((blue * 255) * 114)) / 1000;
}

+ (BOOL)isColorLight:(UIColor *)color {

    return ([UIColor brightnessOfColor:color] >= 128.0);
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

- (NSString *)hexString {
    return [UIColor hexStringFromColor:self];
}

- (BOOL)light {
    return [UIColor isColorLight:self];
}

- (BOOL)dark {
    return ![UIColor isColorLight:self];
}

@end