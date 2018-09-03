//
// Created by CreatureSurvive on 3/17/17.
// Copyright (c) 2018 CreatureCoding. All rights reserved.
//

@interface PSViewController : UIViewController

@property (nonatomic, retain) PSSpecifier *specifier;

- (void)setParentController:(PSViewController *)controller;
- (PSViewController *)parentController;

@end