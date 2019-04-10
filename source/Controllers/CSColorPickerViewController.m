//
// Created by CreatureSurvive on 3/17/17.
// Copyright (c) 2016 - 2019 CreatureCoding. All rights reserved.
//

#import <Controllers/CSColorPickerViewController.h>

#define SLIDER_HEIGHT 40.0
#define GRADIENT_HEIGHT 50.0
#define ALERT_TITLE @"Set Hex Color"
#define ALERT_MESSAGE @"supported formats: 'RGB' 'ARGB' 'RRGGBB' 'AARRGGBB' 'RGB:0.25' 'RRGGBB:0.25'"
#define ALERT_COPY @"Copy Color"
#define ALERT_SET @"Set Color"
#define ALERT_PASTEBOARD @"Set From PasteBoard"
#define ALERT_CANCEL @"Cancel"

@implementation CSColorPickerViewController {
    NSLayoutConstraint *_topConstraint;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    [self performSelector:@selector(loadColorPickerView) withObject:nil afterDelay:0];
    UIBarButtonItem *setHexButton = [[UIBarButtonItem alloc] initWithTitle:@"#" style:UIBarButtonItemStylePlain target:self action:@selector(presentHexColorAlert)];
    self.navigationItem.rightBarButtonItem = setHexButton;
    self.colorPickerContainerView.alpha = 0;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    // animate in
    [UIView animateWithDuration:0.3 animations:^{
        self.colorPickerContainerView.alpha = 1;
        self.colorPickerPreviewView.backgroundColor = [self startColor];
    }];
    [self setLayoutConstraints];
    [self setColorInformationTextWithInformationFromColor:[self colorForHSBSliders]];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self saveColor];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {

    [UIView animateWithDuration:duration animations:^{
        CGRect bounds = [self calculatedBounds];
        [self.colorPickerContainerView setFrame:bounds];
        [self.colorPickerPreviewView setFrame:bounds];
        [self.colorPickerBackgroundView setFrame:bounds];
        [self setColorInformationTextWithInformationFromColor:[self colorForHSBSliders]];
        _topConstraint.constant = [self navigationHeight];
    }];
}

- (void)loadColorPickerView {

    // create views
    self.alphaEnabled = ([self.specifier propertyForKey:@"alpha"] && ![[self.specifier propertyForKey:@"alpha"] boolValue]) ? NO : YES;
    self.isGradient = ([self.specifier propertyForKey:@"gradient"] && [[self.specifier propertyForKey:@"gradient"] boolValue]);

    CGRect bounds = [self calculatedBounds];
    self.colorPickerContainerView = [[UIView alloc] initWithFrame:bounds];
    self.colorPickerContainerView.tag = 199;
    self.colorPickerBackgroundView = [[CSColorPickerBackgroundView alloc] initWithFrame:bounds];
    self.colorPickerPreviewView = [[UIView alloc] initWithFrame:bounds];
    self.colorPickerPreviewView.tag = 199;

    self.colors = [self.specifier propertyForKey:@"colors"];
    self.selectedIndex = self.colors.count - 1;
    self.gradientSelection = [[CSGradientSelection alloc] initWithSize:CGSizeZero target:self addAction:@selector(addAction:) removeAction:@selector(removeAction:) selectAction:@selector(selectAction:)];
    [self.gradientSelection setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.colorPickerContainerView addSubview:self.gradientSelection];

    [self.gradientSelection addColors:self.colors];

    self.colorInformationLable = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.colorInformationLable setNumberOfLines:self.alphaEnabled ? 11 : 9];
    [self.colorInformationLable setFont:[UIFont boldSystemFontOfSize:[self isLandscape] ? 16 : 20]];
    [self.colorInformationLable setBackgroundColor:[UIColor clearColor]];
    [self.colorInformationLable setTextAlignment:NSTextAlignmentCenter];
    [self.colorPickerContainerView addSubview:self.colorInformationLable];
    [self.colorInformationLable setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.colorInformationLable.layer setShadowOffset:CGSizeZero];
    [self.colorInformationLable.layer setShadowRadius:2];
    [self.colorInformationLable.layer setShadowOpacity:1];
    self.colorInformationLable.tag = 199;

    //Alpha slider
    self.colorPickerAlphaSlider = [[CSColorSlider alloc] initWithFrame:CGRectZero sliderType:CSColorSliderTypeAlpha label:@"A" startColor:[self startColor]];
    [self.colorPickerAlphaSlider addTarget:self action:@selector(sliderDidChange:) forControlEvents:UIControlEventValueChanged];
    [self.colorPickerContainerView addSubview:self.colorPickerAlphaSlider];
    [self.colorPickerAlphaSlider setTranslatesAutoresizingMaskIntoConstraints:NO];

    //hue slider
    self.colorPickerHueSlider = [[CSColorSlider alloc] initWithFrame:CGRectZero sliderType:CSColorSliderTypeHue label:@"H" startColor:[self startColor]];
    [self.colorPickerHueSlider addTarget:self action:@selector(sliderDidChange:) forControlEvents:UIControlEventValueChanged];
    [self.colorPickerContainerView addSubview:self.colorPickerHueSlider];
    [self.colorPickerHueSlider setTranslatesAutoresizingMaskIntoConstraints:NO];

    // saturation slider
    self.colorPickerSaturationSlider = [[CSColorSlider alloc] initWithFrame:CGRectZero sliderType:CSColorSliderTypeSaturation label:@"S" startColor:[self startColor]];
    [self.colorPickerSaturationSlider addTarget:self action:@selector(sliderDidChange:) forControlEvents:UIControlEventValueChanged];
    [self.colorPickerContainerView addSubview:self.colorPickerSaturationSlider];
    [self.colorPickerSaturationSlider setTranslatesAutoresizingMaskIntoConstraints:NO];

    // brightness slider
    self.colorPickerBrightnessSlider = [[CSColorSlider alloc] initWithFrame:CGRectZero sliderType:CSColorSliderTypeBrightness label:@"B" startColor:[self startColor]];
    [self.colorPickerBrightnessSlider addTarget:self action:@selector(sliderDidChange:) forControlEvents:UIControlEventValueChanged];
    [self.colorPickerContainerView addSubview:self.colorPickerBrightnessSlider];
    [self.colorPickerBrightnessSlider setTranslatesAutoresizingMaskIntoConstraints:NO];

    // red slider
    self.colorPickerRedSlider = [[CSColorSlider alloc] initWithFrame:CGRectZero sliderType:CSColorSliderTypeRed label:@"R" startColor:[self startColor]];
    [self.colorPickerRedSlider addTarget:self action:@selector(sliderDidChange:) forControlEvents:UIControlEventValueChanged];
    [self.colorPickerContainerView addSubview:self.colorPickerRedSlider];
    [self.colorPickerRedSlider setTranslatesAutoresizingMaskIntoConstraints:NO];

    // green slider
    self.colorPickerGreenSlider = [[CSColorSlider alloc] initWithFrame:CGRectZero sliderType:CSColorSliderTypeGreen label:@"G" startColor:[self startColor]];
    [self.colorPickerGreenSlider addTarget:self action:@selector(sliderDidChange:) forControlEvents:UIControlEventValueChanged];
    [self.colorPickerContainerView addSubview:self.colorPickerGreenSlider];
    [self.colorPickerGreenSlider setTranslatesAutoresizingMaskIntoConstraints:NO];

    // blue slider
    self.colorPickerBlueSlider = [[CSColorSlider alloc] initWithFrame:CGRectZero sliderType:CSColorSliderTypeBlue label:@"B" startColor:[self startColor]];
    [self.colorPickerBlueSlider addTarget:self action:@selector(sliderDidChange:) forControlEvents:UIControlEventValueChanged];
    [self.colorPickerContainerView addSubview:self.colorPickerBlueSlider];
    [self.colorPickerBlueSlider setTranslatesAutoresizingMaskIntoConstraints:NO];

    [self.view insertSubview:self.colorPickerBackgroundView atIndex:0];
    [self.view insertSubview:self.colorPickerPreviewView atIndex:2];
    [self.view insertSubview:self.colorPickerContainerView atIndex:2];

    // alpha enabled
    self.colorPickerAlphaSlider.hidden = !self.alphaEnabled;
    self.colorPickerAlphaSlider.userInteractionEnabled = self.alphaEnabled;
    self.gradientSelection.hidden = !self.isGradient;
    self.gradientSelection.userInteractionEnabled = self.isGradient;
}

- (CGRect)calculatedBounds {
    UIEdgeInsets insets = UIEdgeInsetsZero;
    if ([self.view respondsToSelector:@selector(safeAreaInsets)]) {
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Wunguarded-availability-new"
        insets = [self.view safeAreaInsets];
        #pragma clang diagnostic pop
        insets.top = 0;
    }

    return UIEdgeInsetsInsetRect(self.view.bounds, insets);
}

- (void)sliderDidChange:(CSColorSlider *)sender {
    UIColor *color = (sender.sliderType > 2) ? [self colorForRGBSliders] : [self colorForHSBSliders];
    [self updateColor:color animated:NO];
}

- (UIColor *)colorForHSBSliders {
    return [UIColor colorWithHue:self.colorPickerHueSlider.value
                      saturation:self.colorPickerSaturationSlider.value
                      brightness:self.colorPickerBrightnessSlider.value
                           alpha:self.colorPickerAlphaSlider.value];
}

- (UIColor *)colorForRGBSliders {
    return [UIColor colorWithRed:self.colorPickerRedSlider.value
                           green:self.colorPickerGreenSlider.value
                            blue:self.colorPickerBlueSlider.value
                           alpha:self.colorPickerAlphaSlider.value];
}

- (void)updateColor:(UIColor *)color animated:(BOOL)animated{
    [self setColor:color animated:animated];
    if (self.isGradient) {
        self.colors[self.selectedIndex] = color;
        [self.gradientSelection setColor:color atIndex:self.selectedIndex];
    }
}

- (void)setColor:(UIColor *)color animated:(BOOL)animated{
    void (^update)(void) = ^void(void) {
        [self.colorPickerAlphaSlider setColor:color];
        [self.colorPickerHueSlider setColor:color];
        [self.colorPickerSaturationSlider setColor:color];
        [self.colorPickerBrightnessSlider setColor:color];
        [self.colorPickerRedSlider setColor:color];
        [self.colorPickerGreenSlider setColor:color];
        [self.colorPickerBlueSlider setColor:color];
        self.colorPickerPreviewView.backgroundColor = color;

        [self setColorInformationTextWithInformationFromColor:color];
    };

    if (animated) 
        [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{ update(); } completion:nil];
    else 
        update();
}

- (void)setColorInformationTextWithInformationFromColor:(UIColor *)color {
    [self.colorInformationLable setText:[self informationStringForColor:color]];
    UIColor *legibilityTint = (!color.cscp_light && color.cscp_alpha > 0.5) ? UIColor.whiteColor : UIColor.blackColor;
    UIColor *shadowColor = legibilityTint == UIColor.blackColor ? UIColor.whiteColor : UIColor.blackColor;
    
    [self.colorInformationLable setTextColor:legibilityTint];
    [self.colorInformationLable.layer setShadowColor:[shadowColor CGColor]];
    [self.colorInformationLable setFont:[UIFont boldSystemFontOfSize:[self isLandscape] ? 16 : 20]];
}

- (UIColor *)startColor {
    return self.isGradient ? self.colors.lastObject : [self.specifier propertyForKey:@"color"];
}

- (void)saveColor {
    NSString *saveValue = nil;
    if (self.isGradient) {
        for (UIColor *color in self.colors) {
            saveValue = saveValue ? [saveValue stringByAppendingFormat:@",%@", color.cscp_hexStringWithAlpha] : [NSString stringWithFormat:@"%@", color.cscp_hexStringWithAlpha];
        }
    } else {
        saveValue = [self colorForRGBSliders].cscp_hexStringWithAlpha;
    }

	NSString *key = [self.specifier propertyForKey:@"key"];
	NSString *defaults = [self.specifier propertyForKey:@"defaults"];

    NSString *plistPath = [NSString stringWithFormat:@"/User/Library/Preferences/%@.plist", defaults];
    NSMutableDictionary *prefsDict = [NSMutableDictionary dictionaryWithContentsOfFile:plistPath] ? : [NSMutableDictionary new];
	UITableViewCell *cell = [self.specifier propertyForKey:@"cellObject"];
	
    // save via plist
    [prefsDict setObject:saveValue forKey:key];
    [prefsDict writeToFile:plistPath atomically:NO];

    // save in CFPreferences
    CFPreferencesSetValue((__bridge CFStringRef)key, (__bridge CFPropertyListRef)saveValue, (__bridge CFStringRef)defaults, kCFPreferencesCurrentUser, kCFPreferencesAnyHost);
    CFPreferencesSynchronize((__bridge CFStringRef)defaults, kCFPreferencesCurrentUser, kCFPreferencesAnyHost);

    // save in domain for NSUserDefaults
	[[NSUserDefaults standardUserDefaults] setObject:saveValue forKey:key inDomain:defaults];
	
	if (cell && [cell isKindOfClass:[CSColorDisplayCell class]])
		[(CSColorDisplayCell *)cell refreshCellWithColor:[self colorForRGBSliders]];
    else if (cell && [cell isKindOfClass:[CSGradientDisplayCell class]])
        [(CSGradientDisplayCell *)cell refreshCellWithColors:self.colors];
		
    if ([self.specifier propertyForKey:@"PostNotification"])
        CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(),
                                             (CFStringRef)[self.specifier propertyForKey:@"PostNotification"],
                                             (CFStringRef)[self.specifier propertyForKey:@"PostNotification"],
                                             NULL,
                                             YES);
	
    if ([self.specifier propertyForKey:@"callbackAction"]) {
        SEL callback = NSSelectorFromString([self.specifier propertyForKey:@"callbackAction"]);
        if ([self.specifier.target respondsToSelector:callback]) {
            ((void (*)(id, SEL))[self.specifier.target methodForSelector:callback])(self.specifier.target, callback);
        }
    }
}

- (void)addAction:(UIButton *)sender {
    [self.colors addObject:UIColor.redColor];
    [self.gradientSelection addColor:UIColor.redColor];
    [self setColor:self.colors.lastObject animated:YES];
    self.selectedIndex = self.colors.count - 1;
}

- (void)removeAction:(UIButton *)sender {
    [self.colors removeObjectAtIndex:self.selectedIndex];
    [self.gradientSelection removeColorAtIndex:self.selectedIndex];
    [self setColor:self.colors.lastObject animated:YES];
    self.selectedIndex = self.colors.count - 1;
}

- (void)selectAction:(UIButton *)sender {
    [self setColor:self.colors[sender.titleLabel.tag] animated:YES];
    self.selectedIndex = sender.titleLabel.tag;
}


// well this is ugly
- (NSString *)informationStringForColor:(UIColor *)color {
    CGFloat h, s, b, a, r, g, bb, aa;
    [color getHue:&h saturation:&s brightness:&b alpha:&a];
    [color getRed:&r green:&g blue:&bb alpha:&aa];
    if (self.view.bounds.size.width > self.view.bounds.size.height) {
        if (self.alphaEnabled) {
            return [NSString stringWithFormat:@"#%@\n\nR: %.f       H: %.f\nG: %.f       S: %.f\nB: %.f       B: %.f\nA: %.f       A: %.f", [color cscp_hexString], r * 255, h * 360, g * 255, s * 100, bb * 255, b * 100, aa * 100, a * 100];
        }
        return [NSString stringWithFormat:@"#%@\n\nR: %.f       H: %.f\nG: %.f       S: %.f\nB: %.f       B: %.f", [color cscp_hexString], r * 255, h * 360, g * 255, s * 100, bb * 255, b * 100];
    } else {
        if (self.alphaEnabled) {
            return [NSString stringWithFormat:@"#%@\n\nR: %.f\nG: %.f\nB: %.f\nA: %.f\n\nH: %.f\nS: %.f\nB: %.f\nA: %.f", [color cscp_hexString], r * 255, g * 255, bb * 255, aa * 100, h * 360, s * 100, b * 100, a * 100];
        }
        return [NSString stringWithFormat:@"#%@\n\nR: %.f\nG: %.f\nB: %.f\n\nH: %.f\nS: %.f\nB: %.f", [color cscp_hexString], r * 255, g * 255, bb * 255, h * 360, s * 100, b * 100];
    }
}

- (void)presentHexColorAlert {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:ALERT_TITLE message:ALERT_MESSAGE preferredStyle:UIAlertControllerStyleAlert];

    [alertController addTextFieldWithConfigurationHandler:^(UITextField *hexField) {
        hexField.text = [NSString stringWithFormat:@"#%@", [[self colorForHSBSliders] cscp_hexString]];
        hexField.textColor = [UIColor blackColor];
        hexField.clearButtonMode = UITextFieldViewModeAlways;
        hexField.borderStyle = UITextBorderStyleRoundedRect;
    }];

    [alertController addAction:[UIAlertAction actionWithTitle:ALERT_COPY style:UIAlertActionStyleDefault handler:^(UIAlertAction *copy) {
        [[UIPasteboard generalPasteboard] setString:[self colorForHSBSliders].cscp_hexStringWithAlpha];
    }]];

    [alertController addAction:[UIAlertAction actionWithTitle:ALERT_SET style:UIAlertActionStyleDefault handler:^(UIAlertAction *set) {
        [self updateColor:[UIColor cscp_colorFromHexString:alertController.textFields[0].text] animated:YES];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:ALERT_PASTEBOARD style:UIAlertActionStyleDefault handler:^(UIAlertAction *set) {
        [self updateColor:[UIColor cscp_colorFromHexString:[UIPasteboard generalPasteboard].string] animated:YES];
    }]];

    [alertController addAction:[UIAlertAction actionWithTitle:ALERT_CANCEL style:UIAlertActionStyleCancel handler:nil]];


    [self presentViewController:alertController animated:YES completion:nil];
}

- (CGFloat)navigationHeight {
    return [self isLandscape] ? self.navigationController.navigationBar.frame.size.height :
        self.navigationController.navigationBar.frame.size.height + UIApplication.sharedApplication.statusBarFrame.size.height;
}

- (BOOL)isLandscape {
    return UIInterfaceOrientationIsLandscape(UIApplication.sharedApplication.statusBarOrientation);
}

- (void)setLayoutConstraints {
    for (id constraint in self.colorPickerContainerView.constraints) {
        [self.colorPickerContainerView removeConstraint:constraint];
    }

    NSArray *constraints = @[
        // red constraints
        [NSLayoutConstraint constraintWithItem:self.colorPickerRedSlider attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.colorPickerContainerView attribute:NSLayoutAttributeTop multiplier:1 constant:[self navigationHeight]],
        [NSLayoutConstraint constraintWithItem:self.colorPickerRedSlider attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.colorPickerContainerView attribute:NSLayoutAttributeWidth multiplier:1 constant:0],
        [NSLayoutConstraint constraintWithItem:self.colorPickerRedSlider attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:SLIDER_HEIGHT],
        // green constraints
        [NSLayoutConstraint constraintWithItem:self.colorPickerGreenSlider attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.colorPickerRedSlider attribute:NSLayoutAttributeBottom multiplier:1 constant:0],
        [NSLayoutConstraint constraintWithItem:self.colorPickerGreenSlider attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.colorPickerContainerView attribute:NSLayoutAttributeWidth multiplier:1 constant:0],
        [NSLayoutConstraint constraintWithItem:self.colorPickerGreenSlider attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:SLIDER_HEIGHT],
        // blue constraints
        [NSLayoutConstraint constraintWithItem:self.colorPickerBlueSlider attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.colorPickerGreenSlider attribute:NSLayoutAttributeBottom multiplier:1 constant:0],
        [NSLayoutConstraint constraintWithItem:self.colorPickerBlueSlider attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.colorPickerContainerView attribute:NSLayoutAttributeWidth multiplier:1 constant:0],
        [NSLayoutConstraint constraintWithItem:self.colorPickerBlueSlider attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:SLIDER_HEIGHT],
        // gradient constraints
        [NSLayoutConstraint constraintWithItem:self.gradientSelection attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.colorPickerBlueSlider attribute:NSLayoutAttributeBottom multiplier:1 constant:0],
        [NSLayoutConstraint constraintWithItem:self.gradientSelection attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.colorPickerContainerView attribute:NSLayoutAttributeWidth multiplier:1 constant:0],
        [NSLayoutConstraint constraintWithItem:self.gradientSelection attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.isGradient ? 50.0 : 0],
        // alpha constraints
        [NSLayoutConstraint constraintWithItem:self.colorPickerAlphaSlider attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.colorPickerHueSlider attribute:NSLayoutAttributeTop multiplier:1 constant:0],
        [NSLayoutConstraint constraintWithItem:self.colorPickerAlphaSlider attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.colorPickerContainerView attribute:NSLayoutAttributeWidth multiplier:1 constant:0],
        [NSLayoutConstraint constraintWithItem:self.colorPickerAlphaSlider attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.alphaEnabled ? SLIDER_HEIGHT : 0],
        // hue constraints
        [NSLayoutConstraint constraintWithItem:self.colorPickerHueSlider attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.colorPickerSaturationSlider attribute:NSLayoutAttributeTop multiplier:1 constant:0],
        [NSLayoutConstraint constraintWithItem:self.colorPickerHueSlider attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.colorPickerContainerView attribute:NSLayoutAttributeWidth multiplier:1 constant:0],
        [NSLayoutConstraint constraintWithItem:self.colorPickerHueSlider attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:SLIDER_HEIGHT],
        // saturation constraints
        [NSLayoutConstraint constraintWithItem:self.colorPickerSaturationSlider attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.colorPickerBrightnessSlider attribute:NSLayoutAttributeTop multiplier:1 constant:0],
        [NSLayoutConstraint constraintWithItem:self.colorPickerSaturationSlider attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.colorPickerContainerView attribute:NSLayoutAttributeWidth multiplier:1 constant:0],
        [NSLayoutConstraint constraintWithItem:self.colorPickerSaturationSlider attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:SLIDER_HEIGHT],
        // brightness constraints
        [NSLayoutConstraint constraintWithItem:self.colorPickerBrightnessSlider attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.colorPickerContainerView attribute:NSLayoutAttributeBottom multiplier:1 constant:0],
        [NSLayoutConstraint constraintWithItem:self.colorPickerBrightnessSlider attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.colorPickerContainerView attribute:NSLayoutAttributeWidth multiplier:1 constant:0],
        [NSLayoutConstraint constraintWithItem:self.colorPickerBrightnessSlider attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:SLIDER_HEIGHT],
        // label constraints
        [NSLayoutConstraint constraintWithItem:self.colorInformationLable attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.gradientSelection attribute:NSLayoutAttributeBottom multiplier:1 constant:0],
        [NSLayoutConstraint constraintWithItem:self.colorInformationLable attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.colorPickerContainerView attribute:NSLayoutAttributeWidth multiplier:1 constant:0],
        [NSLayoutConstraint constraintWithItem:self.colorInformationLable attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.colorPickerAlphaSlider attribute:NSLayoutAttributeTop multiplier:1 constant:0]
    ];

    _topConstraint = constraints.firstObject;
    [self.colorPickerContainerView addConstraints:constraints];
}

@end
