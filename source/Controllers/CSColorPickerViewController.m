//
// Created by CreatureSurvive on 3/17/17.
// Copyright (c) 2016 - 2019 CreatureCoding. All rights reserved.
//

#import <Controllers/CSColorPickerViewController.h>
#import <Cells/CSColorDisplayCell.h>
#import <Cells/CSGradientDisplayCell.h>
#import <Prefix.h>

#define SLIDER_HEIGHT 40.0
#define GRADIENT_HEIGHT 50.0
#define ALERT_TITLE @"Set Hex Color"
#define ALERT_MESSAGE @"supported formats: 'RGB' 'ARGB' 'RRGGBB' 'AARRGGBB' 'RGB:0.25' 'RRGGBB:0.25'"
#define ALERT_COPY @"Copy Color"
#define ALERT_SET @"Set Color"
#define ALERT_PASTEBOARD @"Set From PasteBoard"
#define ALERT_CANCEL @"Cancel"

@implementation CSColorPickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self loadColorPickerView];
    [self setColorInformationTextWithInformationFromColor:[self colorForHSBSliders]];
    self.colorPickerPreviewView.backgroundColor = [self startColor];

    if (firmwareGreaterThanEqual(@"13.0")) {
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Wunguarded-availability"
        self.navigationItem.title = self.specifier.name;
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismiss)];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"number.circle"] style:UIBarButtonItemStylePlain target:self action:@selector(presentHexColorAlert)];
        #pragma clang diagnostic pop
    } else {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"#" style:UIBarButtonItemStylePlain target:self action:@selector(presentHexColorAlert)];
    }
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
        [self setColorInformationTextWithInformationFromColor:[self colorForHSBSliders]];
    }];
}

- (void)loadColorPickerView {

    self.view.backgroundColor = [UIColor respondsToSelector:@selector(systemBackgroundColor)] ? [UIColor performSelector:@selector(systemBackgroundColor)] : [UIColor whiteColor];

    // create views
    self.alphaEnabled = ([self.specifier propertyForKey:@"alpha"] && ![[self.specifier propertyForKey:@"alpha"] boolValue]) ? NO : YES;
    self.isGradient = ([self.specifier propertyForKey:@"gradient"] && [[self.specifier propertyForKey:@"gradient"] boolValue]);

    CGRect bounds = [self calculatedBounds];
    self.colorPickerContainerView = [[UIView alloc] initWithFrame:bounds];
    self.colorPickerContainerView.tag = 199;
    [self.colorPickerContainerView setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.colorPickerBackgroundView = [[CSColorPickerBackgroundView alloc] initWithFrame:bounds];
    [self.colorPickerBackgroundView setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.colorPickerPreviewView = [[UIView alloc] initWithFrame:bounds];
    self.colorPickerPreviewView.tag = 199;
    [self.colorPickerPreviewView setTranslatesAutoresizingMaskIntoConstraints:NO];

    self.colors = [self.specifier propertyForKey:@"colors"];
    self.selectedIndex = self.colors.count - 1;
    self.gradientSelection = [[CSGradientSelection alloc] initWithSize:CGSizeZero target:self addAction:@selector(addAction:) removeAction:@selector(removeAction:) selectAction:@selector(selectAction:)];
    [self.gradientSelection setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.colorPickerContainerView addSubview:self.gradientSelection];

    UIBlurEffect *effect;
    if (firmwareGreaterThanEqual(@"13.0")) {
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Wunguarded-availability"
        effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleSystemChromeMaterial]; 
        #pragma clang diagnostic pop
    } else {
        effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    }
    self.topBackdrop = [[UIVisualEffectView alloc] initWithEffect:effect];
    self.bottomBackdrop = [[UIVisualEffectView alloc] initWithEffect:effect];
    [self.topBackdrop setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.bottomBackdrop setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.colorPickerContainerView insertSubview:self.topBackdrop atIndex:0];
    [self.colorPickerContainerView insertSubview:self.bottomBackdrop atIndex:1];

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
    [self.view insertSubview:self.colorPickerPreviewView atIndex:1];
    [self.view insertSubview:self.colorPickerContainerView atIndex:2];

    // alpha enabled
    self.colorPickerAlphaSlider.hidden = !self.alphaEnabled;
    self.colorPickerAlphaSlider.userInteractionEnabled = self.alphaEnabled;
    self.gradientSelection.hidden = !self.isGradient;
    self.gradientSelection.userInteractionEnabled = self.isGradient;

    [NSLayoutConstraint activateConstraints:@[
        // container view
        [self.colorPickerContainerView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.colorPickerContainerView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.colorPickerContainerView.topAnchor constraintEqualToAnchor:self.view.layoutMarginsGuide.topAnchor],
        [self.colorPickerContainerView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
        // color preview
        [self.colorPickerPreviewView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.colorPickerPreviewView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.colorPickerPreviewView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [self.colorPickerPreviewView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
        // checker view
        [self.colorPickerBackgroundView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.colorPickerBackgroundView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.colorPickerBackgroundView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [self.colorPickerBackgroundView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
        // red slider
        [self.colorPickerRedSlider.leadingAnchor constraintEqualToAnchor:self.colorPickerContainerView.leadingAnchor],
        [self.colorPickerRedSlider.trailingAnchor constraintEqualToAnchor:self.colorPickerContainerView.trailingAnchor],
        [self.colorPickerRedSlider.topAnchor constraintEqualToAnchor:self.view.layoutMarginsGuide.topAnchor],
        [self.colorPickerRedSlider.heightAnchor constraintEqualToConstant:SLIDER_HEIGHT],
        // green slider
        [self.colorPickerGreenSlider.leadingAnchor constraintEqualToAnchor:self.colorPickerContainerView.leadingAnchor],
        [self.colorPickerGreenSlider.trailingAnchor constraintEqualToAnchor:self.colorPickerContainerView.trailingAnchor],
        [self.colorPickerGreenSlider.topAnchor constraintEqualToAnchor:self.colorPickerRedSlider.bottomAnchor],
        [self.colorPickerGreenSlider.heightAnchor constraintEqualToConstant:SLIDER_HEIGHT],
        // blue slider
        [self.colorPickerBlueSlider.leadingAnchor constraintEqualToAnchor:self.colorPickerContainerView.leadingAnchor],
        [self.colorPickerBlueSlider.trailingAnchor constraintEqualToAnchor:self.colorPickerContainerView.trailingAnchor],
        [self.colorPickerBlueSlider.topAnchor constraintEqualToAnchor:self.colorPickerGreenSlider.bottomAnchor],
        [self.colorPickerBlueSlider.heightAnchor constraintEqualToConstant:SLIDER_HEIGHT],
        // alpha slider
        [self.colorPickerAlphaSlider.leadingAnchor constraintEqualToAnchor:self.colorPickerContainerView.leadingAnchor],
        [self.colorPickerAlphaSlider.trailingAnchor constraintEqualToAnchor:self.colorPickerContainerView.trailingAnchor],
        [self.colorPickerAlphaSlider.bottomAnchor constraintEqualToAnchor:self.colorPickerHueSlider.topAnchor],
        [self.colorPickerAlphaSlider.heightAnchor constraintEqualToConstant:self.alphaEnabled ? SLIDER_HEIGHT : 0],
        // hue slider
        [self.colorPickerHueSlider.leadingAnchor constraintEqualToAnchor:self.colorPickerContainerView.leadingAnchor],
        [self.colorPickerHueSlider.trailingAnchor constraintEqualToAnchor:self.colorPickerContainerView.trailingAnchor],
        [self.colorPickerHueSlider.bottomAnchor constraintEqualToAnchor:self.colorPickerSaturationSlider.topAnchor],
        [self.colorPickerHueSlider.heightAnchor constraintEqualToConstant:SLIDER_HEIGHT],
        // saturation slider
        [self.colorPickerSaturationSlider.leadingAnchor constraintEqualToAnchor:self.colorPickerContainerView.leadingAnchor],
        [self.colorPickerSaturationSlider.trailingAnchor constraintEqualToAnchor:self.colorPickerContainerView.trailingAnchor],
        [self.colorPickerSaturationSlider.bottomAnchor constraintEqualToAnchor:self.colorPickerBrightnessSlider.topAnchor],
        [self.colorPickerSaturationSlider.heightAnchor constraintEqualToConstant:SLIDER_HEIGHT],
        // brightness slider
        [self.colorPickerBrightnessSlider.leadingAnchor constraintEqualToAnchor:self.colorPickerContainerView.leadingAnchor],
        [self.colorPickerBrightnessSlider.trailingAnchor constraintEqualToAnchor:self.colorPickerContainerView.trailingAnchor],
        [self.colorPickerBrightnessSlider.bottomAnchor constraintEqualToAnchor:self.colorPickerContainerView.layoutMarginsGuide.bottomAnchor],
        [self.colorPickerBrightnessSlider.heightAnchor constraintEqualToConstant:SLIDER_HEIGHT],
        // gradient selection
        [self.gradientSelection.leadingAnchor constraintEqualToAnchor:self.colorPickerContainerView.leadingAnchor],
        [self.gradientSelection.trailingAnchor constraintEqualToAnchor:self.colorPickerContainerView.trailingAnchor],
        [self.gradientSelection.topAnchor constraintEqualToAnchor:self.colorPickerBlueSlider.bottomAnchor],
        [self.gradientSelection.heightAnchor constraintEqualToConstant:self.isGradient ? GRADIENT_HEIGHT : 0],
        // info label
        [self.colorInformationLable.leadingAnchor constraintEqualToAnchor:self.colorPickerContainerView.leadingAnchor],
        [self.colorInformationLable.trailingAnchor constraintEqualToAnchor:self.colorPickerContainerView.trailingAnchor],
        [self.colorInformationLable.topAnchor constraintEqualToAnchor:self.gradientSelection.bottomAnchor],
        [self.colorInformationLable.bottomAnchor constraintEqualToAnchor:self.colorPickerAlphaSlider.topAnchor],
        // top backdrop
        [self.topBackdrop.leadingAnchor constraintEqualToAnchor:self.colorPickerContainerView.leadingAnchor],
        [self.topBackdrop.trailingAnchor constraintEqualToAnchor:self.colorPickerContainerView.trailingAnchor],
        [self.topBackdrop.topAnchor constraintEqualToAnchor:self.colorPickerContainerView.topAnchor],
        [self.topBackdrop.bottomAnchor constraintEqualToAnchor:self.gradientSelection.bottomAnchor],
        // bottom backdrop
        [self.bottomBackdrop.leadingAnchor constraintEqualToAnchor:self.colorPickerContainerView.leadingAnchor],
        [self.bottomBackdrop.trailingAnchor constraintEqualToAnchor:self.colorPickerContainerView.trailingAnchor],
        [self.bottomBackdrop.topAnchor constraintEqualToAnchor:self.colorPickerAlphaSlider.topAnchor],
        [self.bottomBackdrop.bottomAnchor constraintEqualToAnchor:self.colorPickerContainerView.bottomAnchor],
    ]];
}

- (CGRect)calculatedBounds {
    UIEdgeInsets insets = UIEdgeInsetsZero;
    if ([self.view respondsToSelector:@selector(safeAreaInsets)]) {
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Wunguarded-availability-new"
        insets = [self.view safeAreaInsets];
        #pragma clang diagnostic pop
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
    UIColor *color = [self complementaryColorForColor:self.colors.lastObject];
    [self.colors addObject:color];
    [self.gradientSelection addColor:color];
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
        hexField.textColor = [UIColor respondsToSelector:@selector(labelColor)] ? [UIColor performSelector:@selector(labelColor)] : [UIColor blackColor];
        hexField.clearButtonMode = UITextFieldViewModeAlways;
        hexField.borderStyle = firmwareGreaterThanEqual(@"13.0") ? UITextBorderStyleNone : UITextBorderStyleRoundedRect;
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

- (UIColor *)complementaryColorForColor:(UIColor *)color {
    CGFloat h, s, b, a;
    if ([color getHue:&h saturation:&s brightness:&b alpha:&a]) {
        if (s < 0.25) {
            b = ((int)((b * 100) + 10) % 100) / 100.0f;
        }

        else {
            h = h - 0.1;
            if (h < 0) h = 1.0f - fabs(h);
        }

        return [UIColor colorWithHue:h saturation:s brightness:b alpha:a];
    }
    return nil;
}

- (void)dismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
