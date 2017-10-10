/**
 * @Author: Dana Buehre <creaturesurvive>
 * @Date:   18-03-2017 12:13:14
 * @Email:  dbuehre@me.com
 * @Filename: CSColorDisplayCell.m
 * @Last modified by:   creaturesurvive
 * @Last modified time: 08-09-2017 2:30:46
 * @Copyright: Copyright © 2014-2017 CreatureSurvive
 */


#import "CSColorDisplayCell.h"

@implementation CSColorDisplayCell
@synthesize cellColorDisplay, options;

- (id)initWithStyle:(long long)style reuseIdentifier:(id)identifier specifier:(PSSpecifier *)specifier {

    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier specifier:specifier];

    [self setOptions];

    return self;
}

- (void)refreshCellContentsWithSpecifier:(PSSpecifier *)specifier {
    [super refreshCellContentsWithSpecifier:specifier];

    [self updateCellLabels];
    [self updateCellDisplayColor];
}

- (void)refreshCellDisplay {
    [self updateCellDisplayColor];
    [self updateCellLabels];
}

- (void)setOptions {
    if (!self.specifier) {
        return;
    }
    self.options = [NSMutableDictionary new];
    if ([[self.specifier properties] objectForKey:@"fallback"]) {
        [self.options setObject:[[self.specifier properties] objectForKey:@"fallback"] forKey:@"fallback"];
    }
    if ([[self.specifier properties] objectForKey:@"defaultsPath"]) {
        [self.options setObject:[[self.specifier properties] objectForKey:@"defaultsPath"] forKey:@"defaultsPath"];
    }
    [self.options setObject:[[self.specifier properties] objectForKey:@"defaults"] forKey:@"defaults"];
    [self.options setObject:[[self.specifier properties] objectForKey:@"key"] forKey:@"key"];
    [self.options setObject:self.specifier forKey:@"specifier"];

    if ([[self.specifier properties] objectForKey:@"PostNotification"]) {
        [self.options setObject:[[self.specifier properties] objectForKey:@"PostNotification"] forKey:@"PostNotification"];
    }
//   [(PSSpecifier *)self.specifier setProperty:[self.options objectForKey:@"PostNotification"] forKey:@"NotificationListener"];
}

- (void)didMoveToSuperview {
    if (!self.specifier) {
        return;
    }
    [self setOptions];

    [super didMoveToSuperview];

    self.cellColorDisplay = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 58, 29)];
    self.cellColorDisplay.tag = 199;     //disables coloring somehow
    self.cellColorDisplay.layer.cornerRadius = CGRectGetHeight(self.cellColorDisplay.frame) / 4;
    self.cellColorDisplay.layer.borderWidth = 2;
    self.cellColorDisplay.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [self setAccessoryView:self.cellColorDisplay];

    [self updateCellLabels];
    [self updateCellDisplayColor];

    [self.specifier setTarget:self];
    [self.specifier setButtonAction:@selector(openColorPickerView)];
}

- (void)openColorPickerView {
    PSViewController *viewController;

    if (self.specifier.properties[@"parent"]) {
        viewController = self.specifier.properties[@"parent"];
    } else {
        viewController = (PSViewController *)[[[[self nextResponder] nextResponder] nextResponder] nextResponder];
    }

    CSColorPickerViewController *colorViewController = [[CSColorPickerViewController alloc] initForContentSize:viewController.view.frame.size];

    if (self.specifier && [[self.specifier properties] objectForKey:@"defaults"] &&
        [[self.specifier properties] objectForKey:@"key"]) {

        // PSSpecifier *specifier = self.specifier;
        colorViewController.options = self.options;
        colorViewController.specifier = self.specifier;
    }

    colorViewController.view.frame = viewController.view.frame;
    colorViewController.parentController = viewController;
    colorViewController.specifier = self.specifier;
    [viewController.navigationController pushViewController:colorViewController animated:YES];
}

- (void)updateCellLabels {
    self.detailTextLabel.text = [NSString stringWithFormat:@"#%@", [UIColor hexStringFromColor:[self previewColor]]];
    self.detailTextLabel.alpha = 0.65;
}

- (void)updateCellDisplayColor {
    self.cellColorDisplay.backgroundColor = [self previewColor];
}

- (UIColor *)previewColor {

    NSString *plistPath = [NSString stringWithFormat:@"/var/mobile/Library/Preferences/%@.plist", [[self.specifier properties] objectForKey:@"defaults"]];

    NSDictionary *prefsDict = [NSDictionary dictionaryWithContentsOfFile:plistPath] ? : [NSDictionary dictionary];

    NSDictionary *defaultsDict = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle bundleWithPath:[[self.specifier properties] objectForKey:@"defaultsPath"]]
                                                                             pathForResource:@"defaults"
                                                                                      ofType:@"plist"]] ? :
                                 [NSDictionary dictionaryWithContentsOfFile:[[NSBundle bundleWithPath:@"/Library/PreferenceBundles/motuumLS.bundle"]
                                                                             pathForResource:@"com.creaturesurvive.motuumls_defaults"
                                                                                      ofType:@"plist"]] ? :
                                 [NSDictionary dictionary];


    NSString *hex = [prefsDict objectForKey:[[self.specifier properties] objectForKey:@"key"]] ? :          //if default color          //then default color
                    [defaultsDict objectForKey:[[self.specifier properties] objectForKey:@"key"]] ? :       //if defaults color         //then defaults color
                    [prefsDict objectForKey:[[self.specifier properties] objectForKey:@"fallback"]] ? :     //else if fallback          //then fallback
                    @"FF0000)";                                                                             //else red

    UIColor *color = [UIColor colorFromHexString:hex];

    [self.options setObject:hex forKey:@"hexValue"];
    [self.options setObject:color forKey:@"color"];

    return color;
}

- (PSSpecifier *)specifier {

    return [super specifier];
}

@end
