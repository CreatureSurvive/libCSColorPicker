//
// Created by CreatureSurvive on 3/17/17.
// Copyright (c) 2016 - 2019 CreatureCoding. All rights reserved.
//

#import <Cells/CSGradientDisplayCell.h>
#import <Prefix.h>

@implementation CSGradientDisplayCell
@synthesize cellColorDisplay, gradient;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)identifier specifier:(PSSpecifier *)specifier {

    if ((self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier specifier:specifier])) {
        [specifier setTarget:self];
        [specifier setButtonAction:@selector(openColorPickerView)];
        [specifier setProperty:@(YES) forKey:@"gradient"];
        self.detailTextLabel.textColor = UIColor.lightGrayColor;
    }

    return self;
}

- (void)refreshCellContentsWithSpecifier:(PSSpecifier *)specifier {
    [super refreshCellContentsWithSpecifier:specifier];

    [self refreshCellWithColors:nil];
}

- (void)refreshCellWithColors:(NSArray<UIColor *> *)newColors {
	
	if (!newColors) {
		newColors = [self previewColors];
	} else {
        [self.specifier setProperty:newColors.lastObject.cscp_hexString forKey:@"hexValue"];
        [self.specifier setProperty:newColors.lastObject forKey:@"color"];
        [self.specifier setProperty:newColors forKey:@"colors"];
    }
	
    self.detailTextLabel.text = nil;
	NSMutableArray<id> *colors = [NSMutableArray new];
    for (UIColor *color in newColors) {
        if (self.detailTextLabel.text)
            self.detailTextLabel.text = [self.detailTextLabel.text stringByAppendingFormat:@", #%@", color.cscp_hexString];
        else self.detailTextLabel.text = [NSString stringWithFormat:@"#%@", color.cscp_hexString];
        [colors addObject:(id)color.CGColor];
    }

    if (colors.count == 1) {
        [colors addObject:colors.firstObject];
    }

    self.gradient.colors = colors;
}

- (void)didMoveToSuperview {
    if (!self.specifier) {
        return;
    }

    [super didMoveToSuperview];

    [self configureColorDisplay];
    [self refreshCellWithColors:nil];
}

- (void)configureColorDisplay {
    self.cellColorDisplay = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 58, 29)];
    self.cellColorDisplay.tag = 199;
    self.cellColorDisplay.layer.cornerRadius = CGRectGetHeight(self.cellColorDisplay.frame) / 4;
    self.cellColorDisplay.layer.borderWidth = 2;
    self.cellColorDisplay.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    self.gradient = [CAGradientLayer layer];
    self.gradient.frame = self.cellColorDisplay.bounds;
    self.gradient.cornerRadius = self.cellColorDisplay.layer.cornerRadius;
    self.gradient.startPoint = CGPointMake(0, 0.5);
    self.gradient.endPoint = CGPointMake(1, 0.5);
    
    [self.cellColorDisplay.layer addSublayer:self.gradient];
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

- (NSArray<UIColor *> *)previewColors {
    NSString *userPrefsPath, *defaultsPlistPath, *hexs;
    NSDictionary *prefsDict, *defaultsDict;
    NSMutableArray<UIColor *> *colors = [NSMutableArray new];

    userPrefsPath = [NSString stringWithFormat:@"/var/mobile/Library/Preferences/%@.plist", [self.specifier propertyForKey:@"defaults"]];
    defaultsPlistPath = [[NSBundle bundleWithPath:[self.specifier propertyForKey:@"defaultsPath"]] pathForResource:@"defaults" ofType:@"plist"];

    if ((prefsDict = [NSDictionary dictionaryWithContentsOfFile:userPrefsPath])) {
        hexs = prefsDict[[self.specifier propertyForKey:@"key"]];
    }

    if (!hexs && (defaultsDict = [NSDictionary dictionaryWithContentsOfFile:defaultsPlistPath])) {
        hexs = defaultsDict[[self.specifier propertyForKey:@"key"]];
    }

    if (!hexs) {
        hexs = [self.specifier propertyForKey:@"fallback"] ? : @"FF0000,FFFFFF";
    }

    for (NSString *hex in [hexs componentsSeparatedByString:@","]) {
        [colors addObject:[hex cscp_hexColor]];
    }

    if (colors.count < 2) [colors addObject:UIColor.redColor];
    [self.specifier setProperty:colors.lastObject.cscp_hexStringWithAlpha forKey:@"hexValue"];
    [self.specifier setProperty:colors.lastObject forKey:@"color"];
    [self.specifier setProperty:colors forKey:@"colors"];

    return colors;
}

- (PSSpecifier *)specifier {

    return [super specifier];
}

@end
