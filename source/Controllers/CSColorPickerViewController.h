//
// Created by CreatureSurvive on 3/17/17.
// Copyright (c) 2016 - 2019 CreatureCoding. All rights reserved.
//

#import <Headers/PSSpecifier.h>
#import <Controls/CSColorSlider.h>
#import <Headers/PSViewController.h>
#import <Categories/UIColor+CSColorPicker.h>
#import <Categories/NSString+CSColorPicker.h>
#import <Views/CSColorPickerBackgroundView.h>
#import <Views/CSGradientSelection.h>

@interface NSUserDefaults (Private)
- (void)setObject:(id)object forKey:(NSString *)key inDomain:(NSString *)domain;
@end

@interface CSColorPickerViewController : PSViewController

@property (nonatomic, strong) UIView *colorPickerContainerView;
@property (nonatomic, strong) UILabel *colorInformationLable;
@property (nonatomic, strong) UIImageView *colorTrackImageView;
@property (nonatomic, strong) CSColorPickerBackgroundView *colorPickerBackgroundView;
@property (nonatomic, strong) UIView *colorPickerPreviewView;
@property (nonatomic, strong) CSGradientSelection *gradientSelection;
@property (nonatomic, strong) UIVisualEffectView *topBackdrop;
@property (nonatomic, strong) UIVisualEffectView *bottomBackdrop;

@property (nonatomic, retain) CSColorSlider *colorPickerHueSlider;
@property (nonatomic, retain) CSColorSlider *colorPickerSaturationSlider;
@property (nonatomic, retain) CSColorSlider *colorPickerBrightnessSlider;
@property (nonatomic, retain) CSColorSlider *colorPickerAlphaSlider;

@property (nonatomic, retain) CSColorSlider *colorPickerRedSlider;
@property (nonatomic, retain) CSColorSlider *colorPickerGreenSlider;
@property (nonatomic, retain) CSColorSlider *colorPickerBlueSlider;

@property (nonatomic, assign) BOOL alphaEnabled;
@property (nonatomic, assign) BOOL isGradient;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, retain) NSMutableArray<UIColor *> *colors;

- (void)loadColorPickerView;
- (void)sliderDidChange:(CSColorSlider *)sender;
- (BOOL)isLandscape;

- (void)dismiss;

@end
