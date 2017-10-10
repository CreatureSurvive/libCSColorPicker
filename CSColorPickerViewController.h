/**
 * @Author: Dana Buehre <creaturesurvive>
 * @Date:   18-03-2017 12:13:15
 * @Email:  dbuehre@me.com
 * @Filename: CSColorPickerViewController.h
 * @Last modified by:   creaturesurvive
 * @Last modified time: 08-09-2017 2:47:38
 * @Copyright: Copyright © 2014-2017 CreatureSurvive
 */


#import <Preferences/PSViewController.h>
#import <Preferences/PSListController.h>
#import "CSColorSlider.h"
#import "CSColorDisplayCell.h"
#import "PSSpecifier.h"
#import "CSColorPickerBackgroundView.h"
#import "UIColor+CSColorPicker.h"

@interface CSPListController : PSListController
- (void)refreshCellWithSpecifier:(PSSpecifier *)specifier;
@end


@interface CSColorPickerViewController : PSViewController

@property (nonatomic, assign) NSMutableDictionary *options;

@property (nonatomic, strong) UIView *colorPickerContainerView;
@property (nonatomic, strong) UILabel *colorInformationLable;
@property (nonatomic, strong) UIImageView *colorTrackImageView;
@property (nonatomic, strong) CSColorPickerBackgroundView *colorPickerBackgroundView;
@property (nonatomic, strong) UIView *colorPickerPreviewView;

@property (nonatomic, retain) CSColorSlider *colorPickerHueSlider;
@property (nonatomic, retain) CSColorSlider *colorPickerSaturationSlider;
@property (nonatomic, retain) CSColorSlider *colorPickerBrightnessSlider;
@property (nonatomic, retain) CSColorSlider *colorPickerAlphaSlider;

@property (nonatomic, retain) CSColorSlider *colorPickerRedSlider;
@property (nonatomic, retain) CSColorSlider *colorPickerGreenSlider;
@property (nonatomic, retain) CSColorSlider *colorPickerBlueSlider;

- (id)initForContentSize:(CGSize)size;
- (void)loadColorPickerView;
- (void)sliderDidChange:(CSColorSlider *)sender;
- (BOOL)isLandscape;

@end
