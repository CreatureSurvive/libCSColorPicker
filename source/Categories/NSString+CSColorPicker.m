//
// Created by CreatureSurvive on 7/28/17.
// Copyright (c) 2018 CreatureCoding. All rights reserved.
//

@implementation NSString (CSColorPicker)

+ (UIColor *)colorFromHexString:(NSString *)hexString {
    NSString *colorString = [[hexString stringByReplacingOccurrencesOfString:@"#" withString:@""] uppercaseString];
    CGFloat alpha, red, blue, green;

    if ([colorString rangeOfString:@":"].location != NSNotFound) {
        NSArray *stringComponents = [colorString componentsSeparatedByString:@":"];
        colorString = stringComponents[0];
        alpha = [stringComponents[1] floatValue] ? : 1.0f;
    }

    if (![self isValidHexString:colorString]) {
        return [UIColor colorWithRed:255.0f green:0.0f blue:0.0f alpha:alpha];
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

- (UIColor *)hexColor {
    return [NSString colorFromHexString:self];
}

- (BOOL)validHex {
    return [NSString isValidHexString:self];
}

- (NSArray<UIColor *> *)gradientStringColors {
    NSMutableArray<UIColor *> *colors = [NSMutableArray new];
    for (NSString *hex in [[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] componentsSeparatedByString:@","]) {
        [colors addObject:[hex hexColor]];
    }
    return colors.copy;
}

- (NSArray<id> *)gradientStringCGColors {
    NSMutableArray<id> *colors = [NSMutableArray new];
    for (NSString *hex in [[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] componentsSeparatedByString:@","]) {
        [colors addObject:(id)[hex hexColor].CGColor];
    }
    return colors.copy;
}

@end