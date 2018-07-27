//
// Created by CreatureSurvive on 3/17/17.
// Copyright (c) 2018 CreatureCoding. All rights reserved.
//

@interface UIColor (CSColorPicker)

// returns a UIColor from the hex string eg [UIColor colorFromHexString:@"#FF0000"];
// if the hex string is invalid, returns red
// supported formats include 'RGB', 'ARGB', 'RRGGBB', 'AARRGGBB', 'RGB:0.500000', 'RRGGBB:0.500000'
// all formats work with or without #
+ (UIColor *)colorFromHexString:(NSString *)hexString;

// returns a NSString representation of a UIColor in hex format eg [UIColor hexStringFromColor:[UIColor redColor]]; outputs @"#FF0000"
+ (NSString *)hexStringFromColor:(UIColor *)color;

// returns a NSString representation of a UIColor in hex format eg [UIColor hexStringFromColor:[UIColor redColor] alpha:YES]; outputs @"#FF0000FF"
+ (NSString *)hexStringFromColor:(UIColor *)color alpha:(BOOL)include;

// returns the brightness of the color where black = 0.0 and white = 256.0
// credit goes to https://w3.org for the algorithm
+ (CGFloat)brightnessOfColor:(UIColor *)color;

// returns true if the color is light using brightnessOfColor > 0.5
+ (BOOL)isColorLight:(UIColor *)color;

// returns true if the string is a valid hex (will pass with or without #)
+ (BOOL)isValidHexString:(NSString *)hexStr;

// the alpha component the color instance
- (CGFloat)alpha;

// the red component the color instance
- (CGFloat)red;

// the green component the color instance
- (CGFloat)green;

// the blue component the color instance
- (CGFloat)blue;

// the hue component the color instance
- (CGFloat)hue;

// the saturation component the color instance
- (CGFloat)saturation;

// the brightness component the color instance
- (CGFloat)brightness;

@end
