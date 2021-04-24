//
// Created by CreatureSurvive on 3/17/17.
// Copyright (c) 2016 - 2019 CreatureCoding. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PSViewController : UIViewController

@property (nonatomic, retain) PSSpecifier *specifier;

- (void)setParentController:(PSViewController *)controller;
- (PSViewController *)parentController;

@end