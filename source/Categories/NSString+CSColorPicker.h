//
// Created by CreatureSurvive on 7/28/17.
// Copyright (c) 2018 CreatureCoding. All rights reserved.
//

@interface NSString (CSColorPicker)

// returns a UIColor from the hex string eg [UIColor colorFromHexString:@"#FF0000"];
// if the hex string is invalid, returns red
// supported formats include 'RGB', 'ARGB', 'RRGGBB', 'AARRGGBB', 'RGB:0.500000', 'RRGGBB:0.500000'
// all formats work with or without #
+ (UIColor *)colorFromHexString:(NSString *)hexString;

// returns true if the string is a valid hex (will pass with or without #)
+ (BOOL)isValidHexString:(NSString *)hexString;

// returns a string hex string representation of the string instance
- (UIColor *)hexColor;

// returns true if the string instance is a valid hex value
- (BOOL)validHex;

// returns an array of UIColors from a gradient hex array 
// eg: @"FF0000,00FF00,0000FF", or @"FF0000:0.500000,00FF00:0.500000,0000FF:0.500000" or @"FFFF0000,FF00FF00,FF0000FF"
- (NSArray<UIColor *> *)gradientStringColors;

// returns an array of CGColors for setting CAGradientLayer.colors property
// same usage as gradientStringColors
- (NSArray<id> *)gradientStringCGColors;

@end