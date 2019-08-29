//
// Created by CreatureSurvive on 3/17/17.
// Copyright (c) 2016 - 2019 CreatureCoding. All rights reserved.
//

#import <Headers/PSSpecifier.h>
#import <Headers/PSTableCell.h>
#import <Headers/PSViewController.h>
#import <Controllers/CSColorPickerViewController.h>


@interface CSGradientDisplayCell : PSTableCell

@property (nonatomic, retain) UIView *cellColorDisplay;
@property (nonatomic, retain) CAGradientLayer *gradient;
@property (nonatomic, retain) NSMutableDictionary *options;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)identifier specifier:(PSSpecifier *)specifier;
- (void)refreshCellWithColors:(NSArray<UIColor *> *)newColors;

- (void)openColorPickerView;

@end
