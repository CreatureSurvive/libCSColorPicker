//
// Created by CreatureSurvive on 3/17/17.
// Copyright (c) 2018 CreatureCoding. All rights reserved.
//

#import <Cells/CSColorDisplayCell.h>

// get the associated view controller from a UIView
// credits https://stackoverflow.com/questions/1372977/given-a-view-how-do-i-get-its-viewcontroller/24590678
#define UIViewParentController(__view) ({ UIResponder *__responder = __view; while ([__responder isKindOfClass:[UIView class]]) __responder = [__responder nextResponder]; (UIViewController *)__responder; })

@implementation CSColorDisplayCell
@synthesize cellColorDisplay;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)identifier specifier:(PSSpecifier *)specifier {

    if ((self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier specifier:specifier])) {
        [specifier setTarget:self];
        [specifier setButtonAction:@selector(openColorPickerView)];
    }

    return self;
}

- (void)refreshCellContentsWithSpecifier:(PSSpecifier *)specifier {
    [super refreshCellContentsWithSpecifier:specifier];

    [self refreshCellWithColor:nil];
}

- (void)refreshCellWithColor:(UIColor *)color {
	
	if (!color) {
		color = [self previewColor];
	}
	
	self.cellColorDisplay.backgroundColor = color;
	self.detailTextLabel.text = [NSString stringWithFormat:@"#%@", [color hexString]];
}

- (void)didMoveToSuperview {
    if (!self.specifier) {
        return;
    }

    [super didMoveToSuperview];

    [self configureColorDisplay];
    [self updateCellLabels];
    [self updateCellDisplayColor];
}

- (void)configureColorDisplay {
    self.cellColorDisplay = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 58, 29)];
    self.cellColorDisplay.tag = 199;
    self.cellColorDisplay.layer.cornerRadius = CGRectGetHeight(self.cellColorDisplay.frame) / 4;
    self.cellColorDisplay.layer.borderWidth = 2;
    self.cellColorDisplay.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [self setAccessoryView:self.cellColorDisplay];
}

- (void)openColorPickerView {
    PSViewController *viewController;
    UIViewController *vc;

    if ([self respondsToSelector:@selector(_viewControllerForAncestor)]) {
        vc = [self performSelector:@selector(_viewControllerForAncestor)];
    }

    if (!vc) {
        if ([self.specifier propertyForKey:@"parent"]) {
            vc = [self.specifier propertyForKey:@"parent"];
        } else {
            vc = UIViewParentController(self);
        }
    }

    if (vc && [vc isKindOfClass:[PSViewController class]]) {
        viewController = (PSViewController *)vc;
    } else {
        return;
    }


    CSColorPickerViewController *colorViewController = [[CSColorPickerViewController alloc] init];

    if (self.specifier && [self.specifier propertyForKey:@"defaults"] && [self.specifier propertyForKey:@"key"]) {

        colorViewController.specifier = self.specifier;
    }

    colorViewController.view.frame = viewController.view.frame;
    colorViewController.parentController = viewController;
    colorViewController.specifier = self.specifier;
    [viewController.navigationController pushViewController:colorViewController animated:YES];
}

- (void)updateCellLabels {
    self.detailTextLabel.text = [NSString stringWithFormat:@"#%@", [[self previewColor] hexString]];
    self.detailTextLabel.alpha = 0.65;
}

- (void)updateCellDisplayColor {
    self.cellColorDisplay.backgroundColor = [self previewColor];
}

- (UIColor *)previewColor {
    NSString *userPrefsPath, *defaultsPlistPath, *motuumLSDefaultsPath, *hex;
    NSDictionary *prefsDict, *defaultsDict;
    UIColor *color;

    userPrefsPath = [NSString stringWithFormat:@"/User/Library/Preferences/%@.plist", [self.specifier propertyForKey:@"defaults"]];
    defaultsPlistPath = [[NSBundle bundleWithPath:[self.specifier propertyForKey:@"defaultsPath"]] pathForResource:@"defaults" ofType:@"plist"];
    motuumLSDefaultsPath = [[NSBundle bundleWithPath:@"/Library/PreferenceBundles/motuumLS.bundle"] pathForResource:@"com.creaturesurvive.motuumls_defaults" ofType:@"plist"];

    if ((prefsDict = [NSDictionary dictionaryWithContentsOfFile:userPrefsPath])) {
        hex = prefsDict[[self.specifier propertyForKey:@"key"]];
    }

    if (!hex && (defaultsDict = [NSDictionary dictionaryWithContentsOfFile:defaultsPlistPath])) {
        hex = defaultsDict[[self.specifier propertyForKey:@"key"]];
    }

    if (!hex && (defaultsDict = [NSDictionary dictionaryWithContentsOfFile:motuumLSDefaultsPath])) {
        hex = defaultsDict[[self.specifier propertyForKey:@"key"]];
    }

    if (!hex) {
        hex = [self.specifier propertyForKey:@"fallback"] ? : @"FF0000)";
    }

    color = [UIColor colorFromHexString:hex];    
    [self.specifier setProperty:hex forKey:@"hexValue"];
    [self.specifier setProperty:color forKey:@"color"];

    return color;
}

- (PSSpecifier *)specifier {

    return [super specifier];
}

// TODO implement this
// - (void)setValue:(id)value {
//     [super setValue:value];
//     [self refreshCellDisplay];
// }

@end
