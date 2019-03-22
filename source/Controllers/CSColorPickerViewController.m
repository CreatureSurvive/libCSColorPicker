//
// Created by CreatureSurvive on 3/17/17.
// Copyright (c) 2018 CreatureCoding. All rights reserved.
//

#import <Controllers/CSColorPickerViewController.h>

@implementation CSColorPickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    [self performSelector:@selector(loadColorPickerView) withObject:nil afterDelay:0];
    UIBarButtonItem *setHexButton = [[UIBarButtonItem alloc] initWithTitle:@"#" style:UIBarButtonItemStylePlain target:self action:@selector(presentHexColorAlert)];
    self.navigationItem.rightBarButtonItem = setHexButton;
    self.colorPickerContainerView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0, 0);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    // animate in
    [UIView animateWithDuration:0.5 animations:^{
        self.colorPickerContainerView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
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

    [self.colorPickerContainerView setFrame:self.view.frame];
    [self.colorPickerPreviewView setFrame:self.view.frame];
    [self.colorPickerBackgroundView setFrame:self.view.frame];
    [self setLayoutConstraints];
    [self setColorInformationTextWithInformationFromColor:[self colorForHSBSliders]];
}

- (void)loadColorPickerView {

    // create views
    CGRect bounds = self.view.bounds;
    UIEdgeInsets insets = UIEdgeInsetsZero;
	if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 11.0) {
        if ([self.view respondsToSelector:@selector(safeAreaInsets)]) {
			#pragma clang diagnostic push
			#pragma clang diagnostic ignored "-Wunguarded-availability-new"
            insets = [self.view safeAreaInsets];
			#pragma clang diagnostic pop
            insets.top = 0;
            bounds = UIEdgeInsetsInsetRect(self.view.bounds, insets);
        }
    }

    self.alphaEnabled = ([self.specifier propertyForKey:@"alpha"] && ![[self.specifier propertyForKey:@"alpha"] boolValue]) ? NO : YES;

    self.colorPickerContainerView = [[UIView alloc] initWithFrame:bounds];
    self.colorPickerBackgroundView = [[CSColorPickerBackgroundView alloc] initWithFrame:bounds];
    self.colorPickerPreviewView = [[UIView alloc] initWithFrame:bounds];
    self.colorPickerPreviewView.tag = 199;

    self.colorInformationLable = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.colorInformationLable setNumberOfLines:self.alphaEnabled ? 11 : 9];
    [self.colorInformationLable setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:20]];
    [self.colorInformationLable setBackgroundColor:[UIColor clearColor]];
    [self.colorInformationLable setTextAlignment:NSTextAlignmentCenter];
    [self.colorPickerContainerView addSubview:self.colorInformationLable];
    [self.colorInformationLable setTranslatesAutoresizingMaskIntoConstraints:NO];
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
}

- (void)sliderDidChange:(CSColorSlider *)sender {
    UIColor *color = (sender.sliderType > 2) ? [self colorForRGBSliders] : [self colorForHSBSliders];
    [self setColor:color];
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

- (void)setColor:(UIColor *)color {
    @try {

        [self.colorPickerAlphaSlider setColor:color];
        [self.colorPickerHueSlider setColor:color];
        [self.colorPickerSaturationSlider setColor:color];
        [self.colorPickerBrightnessSlider setColor:color];
        [self.colorPickerRedSlider setColor:color];
        [self.colorPickerGreenSlider setColor:color];
        [self.colorPickerBlueSlider setColor:color];

        [self.colorPickerSaturationSlider setSelectedColor:[UIColor colorWithHue:self.colorPickerHueSlider.value
                                                                      saturation:1
                                                                      brightness:1
                                                                           alpha:1]];
        [self.colorPickerBrightnessSlider setSelectedColor:[UIColor colorWithHue:self.colorPickerHueSlider.value
                                                                      saturation:1
                                                                      brightness:1
                                                                           alpha:1]];
        self.colorPickerPreviewView.backgroundColor = color;

        [self setColorInformationTextWithInformationFromColor:color];
        [self.specifier setValue:[NSString stringWithFormat:@"%@:%f", [color hexString], color.alpha] forKey:@"hexValue"];
    } @catch (NSException *e) {
        CSError(@"%@", e.description);
    }
}

- (void)setColorInformationTextWithInformationFromColor:(UIColor *)color {
    [self.colorInformationLable setText:[self informationStringForColor:color wide:[self isLandscape]]];
    UIColor *legibilityTint = (![UIColor isColorLight:self.colorForHSBSliders] && self.colorForHSBSliders.alpha > 0.5) ? [UIColor whiteColor] : [UIColor blackColor];
    UIColor *shadowColor = [[UIColor whiteColor] colorWithAlphaComponent:1 - self.colorForHSBSliders.alpha];
    [self.colorInformationLable setTextColor:legibilityTint];

    [self.colorInformationLable.layer setShadowColor:[shadowColor CGColor]];
    [self.colorInformationLable.layer setShadowOffset:CGSizeMake(0, 0)];
    [self.colorInformationLable.layer setShadowRadius:10];
    [self.colorInformationLable.layer setShadowOpacity:1];

    [self.colorInformationLable setFont:[UIFont boldSystemFontOfSize:[self isLandscape] ? 16 : 20]];
}

- (BOOL)isLandscape {

    return (self.view.bounds.size.width > self.view.bounds.size.height);
}

- (void)presentHexColorAlert {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Set Hex Color"
                                                                             message:@"supported formats: 'RGB' 'ARGB' 'RRGGBB' 'AARRGGBB' 'RGB:0.25' 'RRGGBB:0.25'"
                                                                      preferredStyle:UIAlertControllerStyleAlert];

    [alertController addTextFieldWithConfigurationHandler:^(UITextField *hexField) {
        hexField.text = [NSString stringWithFormat:@"#%@", [[self colorForHSBSliders] hexString]];
        hexField.textColor = [UIColor blackColor];
        hexField.clearButtonMode = UITextFieldViewModeAlways;
        hexField.borderStyle = UITextBorderStyleRoundedRect;
    }];

    [alertController addAction:[UIAlertAction actionWithTitle:@"Copy Color" style:UIAlertActionStyleDefault handler:^(UIAlertAction *copy) {
        [[UIPasteboard generalPasteboard] setString:alertController.textFields[0].text];
    }]];

    [alertController addAction:[UIAlertAction actionWithTitle:@"Set Color" style:UIAlertActionStyleDefault handler:^(UIAlertAction *set) {
        [self setColor:[UIColor colorFromHexString:alertController.textFields[0].text]];

    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Set From PasteBoard" style:UIAlertActionStyleDefault handler:^(UIAlertAction *set) {
        [self setColor:[UIColor colorFromHexString:[UIPasteboard generalPasteboard].string]];

    }]];

    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];


    [self presentViewController:alertController animated:YES completion:nil];
}

- (UIColor *)startColor {
    return [UIColor colorFromHexString:[self.specifier propertyForKey:@"hexValue"]];
}

- (void)saveColor {

    NSString *color = [UIColor hexStringFromColor:[self colorForRGBSliders] alpha:YES];
	NSString *key = [self.specifier propertyForKey:@"key"];
	NSString *defaults = [self.specifier propertyForKey:@"defaults"];

    NSString *plistPath = [NSString stringWithFormat:@"/User/Library/Preferences/%@.plist", defaults];
    NSMutableDictionary *prefsDict = [NSMutableDictionary dictionaryWithContentsOfFile:plistPath] ? : [NSMutableDictionary new];
	CSColorDisplayCell *cell = (CSColorDisplayCell *)[self.specifier propertyForKey:@"cellObject"];
	
    // save via plist
    [prefsDict setObject:color forKey:key];
    [prefsDict writeToFile:plistPath atomically:NO];

    // save in CFPreferences
    CFPreferencesSetValue((__bridge CFStringRef)key, (__bridge CFPropertyListRef)color, (__bridge CFStringRef)defaults, kCFPreferencesCurrentUser, kCFPreferencesAnyHost);
    CFPreferencesSynchronize((__bridge CFStringRef)defaults, kCFPreferencesCurrentUser, kCFPreferencesAnyHost);

    // save in domain for NSUserDefaults
	[[NSUserDefaults standardUserDefaults] setObject:color forKey:key inDomain:defaults];
	
	if (cell)
		[cell refreshCellWithColor:[self colorForRGBSliders]];
		
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

// well this is ugly
- (NSString *)informationStringForColor:(UIColor *)color wide:(BOOL)wide {
    CGFloat h, s, b, a, r, g, bb, aa;
    [color getHue:&h saturation:&s brightness:&b alpha:&a];
    [color getRed:&r green:&g blue:&bb alpha:&aa];
    if (wide) {
        if (self.alphaEnabled) {
            return [NSString stringWithFormat:@"#%@\n\nR: %.f       H: %.f\nG: %.f       S: %.f\nB: %.f       B: %.f\nA: %.f       A: %.f", [color hexString], r * 255, h * 360, g * 255, s * 100, bb * 255, b * 100, aa * 100, a * 100];
        }
        return [NSString stringWithFormat:@"#%@\n\nR: %.f       H: %.f\nG: %.f       S: %.f\nB: %.f       B: %.f", [color hexString], r * 255, h * 360, g * 255, s * 100, bb * 255, b * 100];
    } else {
        if (self.alphaEnabled) {
            return [NSString stringWithFormat:@"#%@\n\nR: %.f\nG: %.f\nB: %.f\nA: %.f\n\nH: %.f\nS: %.f\nB: %.f\nA: %.f", [color hexString], r * 255, g * 255, bb * 255, aa * 100, h * 360, s * 100, b * 100, a * 100];
        }
        return [NSString stringWithFormat:@"#%@\n\nR: %.f\nG: %.f\nB: %.f\n\nH: %.f\nS: %.f\nB: %.f", [color hexString], r * 255, g * 255, bb * 255, h * 360, s * 100, b * 100];
    }
}

- (void)setLayoutConstraints {
    NSMutableArray *constraints = [NSMutableArray new];
    CGFloat navHeight = self.navigationController.navigationBar.frame.size.height;
    CGFloat statusHeight = [UIApplication sharedApplication].statusBarFrame.size.height;

    for (id constraint in self.colorPickerContainerView.constraints) {
        [self.colorPickerContainerView removeConstraint:constraint];
    }

    if ([self isLandscape]) {
        // label constraints
        [constraints addObject:[NSLayoutConstraint constraintWithItem:self.colorInformationLable attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.colorPickerContainerView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
        [constraints addObject:[NSLayoutConstraint constraintWithItem:self.colorInformationLable attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.colorPickerContainerView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:(navHeight / 2) - 20]];
        // alpha constraints
        [constraints addObject:[NSLayoutConstraint constraintWithItem:self.colorPickerAlphaSlider attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:self.colorPickerContainerView.bounds.size.width]];
        [constraints addObject:[NSLayoutConstraint constraintWithItem:self.colorPickerAlphaSlider attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.colorPickerContainerView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
        [constraints addObject:[NSLayoutConstraint constraintWithItem:self.colorPickerAlphaSlider attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.colorPickerContainerView attribute:NSLayoutAttributeBottom multiplier:1 constant:-121]];
        [constraints addObject:[NSLayoutConstraint constraintWithItem:self.colorPickerAlphaSlider attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:40.0]];
        // hue constraints
        [constraints addObject:[NSLayoutConstraint constraintWithItem:self.colorPickerHueSlider attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:self.colorPickerContainerView.bounds.size.width]];
        [constraints addObject:[NSLayoutConstraint constraintWithItem:self.colorPickerHueSlider attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.colorPickerContainerView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
        [constraints addObject:[NSLayoutConstraint constraintWithItem:self.colorPickerHueSlider attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.colorPickerContainerView attribute:NSLayoutAttributeBottom multiplier:1 constant:-81]];
        [constraints addObject:[NSLayoutConstraint constraintWithItem:self.colorPickerHueSlider attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:40.0]];
        // saturation constraints
        [constraints addObject:[NSLayoutConstraint constraintWithItem:self.colorPickerSaturationSlider attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:self.colorPickerContainerView.bounds.size.width]];
        [constraints addObject:[NSLayoutConstraint constraintWithItem:self.colorPickerSaturationSlider attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.colorPickerContainerView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
        [constraints addObject:[NSLayoutConstraint constraintWithItem:self.colorPickerSaturationSlider attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.colorPickerContainerView attribute:NSLayoutAttributeBottom multiplier:1 constant:-41]];
        [constraints addObject:[NSLayoutConstraint constraintWithItem:self.colorPickerSaturationSlider attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:40.0]];
        // brightness constraints
        [constraints addObject:[NSLayoutConstraint constraintWithItem:self.colorPickerBrightnessSlider attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:self.colorPickerContainerView.bounds.size.width]];
        [constraints addObject:[NSLayoutConstraint constraintWithItem:self.colorPickerBrightnessSlider attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.colorPickerContainerView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
        [constraints addObject:[NSLayoutConstraint constraintWithItem:self.colorPickerBrightnessSlider attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.colorPickerContainerView attribute:NSLayoutAttributeBottom multiplier:1 constant:-1]];
        [constraints addObject:[NSLayoutConstraint constraintWithItem:self.colorPickerBrightnessSlider attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:40.0]];
        // red constraints
        [constraints addObject:[NSLayoutConstraint constraintWithItem:self.colorPickerRedSlider attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:self.colorPickerContainerView.bounds.size.width]];
        [constraints addObject:[NSLayoutConstraint constraintWithItem:self.colorPickerRedSlider attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.colorPickerContainerView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
        [constraints addObject:[NSLayoutConstraint constraintWithItem:self.colorPickerRedSlider attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.colorPickerContainerView attribute:NSLayoutAttributeTop multiplier:1 constant:0 + navHeight]];
        [constraints addObject:[NSLayoutConstraint constraintWithItem:self.colorPickerRedSlider attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:40.0]];
        // green constraints
        [constraints addObject:[NSLayoutConstraint constraintWithItem:self.colorPickerGreenSlider attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:self.colorPickerContainerView.bounds.size.width]];
        [constraints addObject:[NSLayoutConstraint constraintWithItem:self.colorPickerGreenSlider attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.colorPickerContainerView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
        [constraints addObject:[NSLayoutConstraint constraintWithItem:self.colorPickerGreenSlider attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.colorPickerContainerView attribute:NSLayoutAttributeTop multiplier:1 constant:40 + navHeight]];
        [constraints addObject:[NSLayoutConstraint constraintWithItem:self.colorPickerGreenSlider attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:40.0]];
        // blue constraints
        [constraints addObject:[NSLayoutConstraint constraintWithItem:self.colorPickerBlueSlider attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:self.colorPickerContainerView.bounds.size.width]];
        [constraints addObject:[NSLayoutConstraint constraintWithItem:self.colorPickerBlueSlider attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.colorPickerContainerView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
        [constraints addObject:[NSLayoutConstraint constraintWithItem:self.colorPickerBlueSlider attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.colorPickerContainerView attribute:NSLayoutAttributeTop multiplier:1 constant:80 + navHeight]];
        [constraints addObject:[NSLayoutConstraint constraintWithItem:self.colorPickerBlueSlider attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:40.0]];
    } else {
        // label constraints
        [constraints addObject:[NSLayoutConstraint constraintWithItem:self.colorInformationLable attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.colorPickerContainerView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
        [constraints addObject:[NSLayoutConstraint constraintWithItem:self.colorInformationLable attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.colorPickerContainerView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:(navHeight / 2)]];
        // alpha constraints
        [constraints addObject:[NSLayoutConstraint constraintWithItem:self.colorPickerAlphaSlider attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:self.colorPickerContainerView.bounds.size.width]];
        [constraints addObject:[NSLayoutConstraint constraintWithItem:self.colorPickerAlphaSlider attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.colorPickerContainerView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
        [constraints addObject:[NSLayoutConstraint constraintWithItem:self.colorPickerAlphaSlider attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.colorPickerContainerView attribute:NSLayoutAttributeBottom multiplier:1 constant:-121]];
        [constraints addObject:[NSLayoutConstraint constraintWithItem:self.colorPickerAlphaSlider attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:40.0]];
        // hue constraints
        [constraints addObject:[NSLayoutConstraint constraintWithItem:self.colorPickerHueSlider attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:self.colorPickerContainerView.bounds.size.width]];
        [constraints addObject:[NSLayoutConstraint constraintWithItem:self.colorPickerHueSlider attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.colorPickerContainerView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
        [constraints addObject:[NSLayoutConstraint constraintWithItem:self.colorPickerHueSlider attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.colorPickerContainerView attribute:NSLayoutAttributeBottom multiplier:1 constant:-81]];
        [constraints addObject:[NSLayoutConstraint constraintWithItem:self.colorPickerHueSlider attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:40.0]];
        // saturation constraints
        [constraints addObject:[NSLayoutConstraint constraintWithItem:self.colorPickerSaturationSlider attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:self.colorPickerContainerView.bounds.size.width]];
        [constraints addObject:[NSLayoutConstraint constraintWithItem:self.colorPickerSaturationSlider attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.colorPickerContainerView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
        [constraints addObject:[NSLayoutConstraint constraintWithItem:self.colorPickerSaturationSlider attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.colorPickerContainerView attribute:NSLayoutAttributeBottom multiplier:1 constant:-41]];
        [constraints addObject:[NSLayoutConstraint constraintWithItem:self.colorPickerSaturationSlider attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:40.0]];
        // brightness constraints
        [constraints addObject:[NSLayoutConstraint constraintWithItem:self.colorPickerBrightnessSlider attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:self.colorPickerContainerView.bounds.size.width]];
        [constraints addObject:[NSLayoutConstraint constraintWithItem:self.colorPickerBrightnessSlider attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.colorPickerContainerView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
        [constraints addObject:[NSLayoutConstraint constraintWithItem:self.colorPickerBrightnessSlider attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.colorPickerContainerView attribute:NSLayoutAttributeBottom multiplier:1 constant:-1]];
        [constraints addObject:[NSLayoutConstraint constraintWithItem:self.colorPickerBrightnessSlider attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:40.0]];
        // red constraints
        [constraints addObject:[NSLayoutConstraint constraintWithItem:self.colorPickerRedSlider attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:self.colorPickerContainerView.bounds.size.width]];
        [constraints addObject:[NSLayoutConstraint constraintWithItem:self.colorPickerRedSlider attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.colorPickerContainerView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
        [constraints addObject:[NSLayoutConstraint constraintWithItem:self.colorPickerRedSlider attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.colorPickerContainerView attribute:NSLayoutAttributeTop multiplier:1 constant:0 + navHeight + statusHeight]];
        [constraints addObject:[NSLayoutConstraint constraintWithItem:self.colorPickerRedSlider attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:40.0]];
        // green constraints
        [constraints addObject:[NSLayoutConstraint constraintWithItem:self.colorPickerGreenSlider attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:self.colorPickerContainerView.bounds.size.width]];
        [constraints addObject:[NSLayoutConstraint constraintWithItem:self.colorPickerGreenSlider attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.colorPickerContainerView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
        [constraints addObject:[NSLayoutConstraint constraintWithItem:self.colorPickerGreenSlider attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.colorPickerContainerView attribute:NSLayoutAttributeTop multiplier:1 constant:40 + navHeight + statusHeight]];
        [constraints addObject:[NSLayoutConstraint constraintWithItem:self.colorPickerGreenSlider attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:40.0]];
        // blue constraints
        [constraints addObject:[NSLayoutConstraint constraintWithItem:self.colorPickerBlueSlider attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:self.colorPickerContainerView.bounds.size.width]];
        [constraints addObject:[NSLayoutConstraint constraintWithItem:self.colorPickerBlueSlider attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.colorPickerContainerView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
        [constraints addObject:[NSLayoutConstraint constraintWithItem:self.colorPickerBlueSlider attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.colorPickerContainerView attribute:NSLayoutAttributeTop multiplier:1 constant:80 + navHeight + statusHeight]];
        [constraints addObject:[NSLayoutConstraint constraintWithItem:self.colorPickerBlueSlider attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:40.0]];

    }
    for (id constraint in constraints) {
        [self.colorPickerContainerView addConstraint:constraint];
    }
}

@end
