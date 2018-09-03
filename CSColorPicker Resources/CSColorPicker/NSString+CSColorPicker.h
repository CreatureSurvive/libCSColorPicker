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

@end