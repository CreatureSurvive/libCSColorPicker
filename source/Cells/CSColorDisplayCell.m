//
// Created by CreatureSurvive on 3/17/17.
// Copyright (c) 2016 - 2019 CreatureCoding. All rights reserved.
//

#import <Cells/CSColorDisplayCell.h>
#import <Prefix.h>

@implementation CSColorDisplayCell

- (void)refreshCellContentsWithSpecifier:(PSSpecifier *)specifier {
    [super refreshCellContentsWithSpecifier:specifier];

    [self refreshCellWithColor:nil];
}

- (void)refreshCellWithColor:(UIColor *)color {
	
	if (!color) {
		color = [self previewColor];
	} else {
        [self.specifier setProperty:color.cscp_hexStringWithAlpha forKey:@"hexValue"];
        [self.specifier setProperty:color forKey:@"color"];
    }
	
	self.cellColorDisplay.backgroundColor = color;
	self.detailTextLabel.text = [NSString stringWithFormat:@"#%@", [color cscp_hexString]];
}

- (void)didMoveToSuperview {
    [super didMoveToSuperview];

    if (!self.specifier) {
        return;
    }

    [self refreshCellWithColor:nil];
}

- (UIColor *)previewColor {
    NSString *userPrefsPath, *defaultsPlistPath, *motuumLSDefaultsPath, *hex;
    NSDictionary *prefsDict, *defaultsDict;
    UIColor *color;

    userPrefsPath = [NSString stringWithFormat:@"/User/Library/Preferences/%@.plist", [self.specifier propertyForKey:@"defaults"]];
    defaultsPlistPath = [[NSBundle bundleWithPath:[self.specifier propertyForKey:@"defaultsPath"]] pathForResource:@"defaults" ofType:@"plist"];
    motuumLSDefaultsPath = [[NSBundle bundleWithPath:@"/Library/PreferenceBundles/motuumLS.bundle"] pathForResource:@"com.creaturesurvive.motuumls_defaults" ofType:@"plist"];

    if ((prefsDict = [NSDictionary dictionaryWithContentsOfFile:userPrefsPath])) {
        hex = prefsDict[[self.specifier propertyForKey:@"key"]];
    }

    if (!hex && (defaultsDict = [NSDictionary dictionaryWithContentsOfFile:defaultsPlistPath])) {
        hex = defaultsDict[[self.specifier propertyForKey:@"key"]];
    }

    if (!hex && (defaultsDict = [NSDictionary dictionaryWithContentsOfFile:motuumLSDefaultsPath])) {
        hex = defaultsDict[[self.specifier propertyForKey:@"key"]];
    }

    if (!hex) {
        hex = [self.specifier propertyForKey:@"fallback"] ? : @"FF0000";
    }

    color = [UIColor cscp_colorFromHexString:hex];    
    [self.specifier setProperty:hex forKey:@"hexValue"];
    [self.specifier setProperty:color forKey:@"color"];

    return color;
}

@end
