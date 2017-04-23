#import <Preferences/PSViewController.h>
#import "CSColorSlider.h"
#import "PSSpecifier.h"
#import "CSColorPickerBackgroundView.h"
#import "UIColor+CSColorPicker.h"


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
