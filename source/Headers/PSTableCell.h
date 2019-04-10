//
// Created by CreatureSurvive on 3/17/17.
// Copyright (c) 2016 - 2019 CreatureCoding. All rights reserved.
//

@interface PSTableCell : UITableViewCell

@property (nonatomic, retain) PSSpecifier *specifier;

- (void)refreshCellContentsWithSpecifier:(PSSpecifier *)specifier;
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)identifier specifier:(PSSpecifier *)specifier;

@end