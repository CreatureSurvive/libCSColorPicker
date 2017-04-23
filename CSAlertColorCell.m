#import "CSAlertColorCell.h"

@implementation CSAlertColorCell
@synthesize cellColorDisplay, options;

- (id)initWithStyle:(long long)style reuseIdentifier:(id)identifier specifier:(PSSpecifier *)specifier {

    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier specifier:specifier];

    [self setOptions];

    return self;
}

- (void)setOptions {
    if (!self.specifier) {
        return;
    }
    self.options = [NSMutableDictionary new];
    [self.options setObject:[[self.specifier properties] objectForKey:@"fallback"] forKey:@"fallback"];
    [self.options setObject:[[self.specifier properties] objectForKey:@"defaults"] forKey:@"defaults"];
    [self.options setObject:[[self.specifier properties] objectForKey:@"key"] forKey:@"key"];

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
    PSViewController *viewController = (PSViewController *)[[[[self nextResponder] nextResponder] nextResponder] nextResponder];

    CSColorPickerViewController *colorViewController = [[CSColorPickerViewController alloc] initForContentSize:viewController.view.frame.size];

    if (self.specifier && [[self.specifier properties] objectForKey:@"fallback"] && [[self.specifier properties] objectForKey:@"defaults"] &&
        [[self.specifier properties] objectForKey:@"key"]) {

        // PSSpecifier *specifier = self.specifier;
        colorViewController.options = self.options;
    }

    colorViewController.view.frame = viewController.view.frame;
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

    NSMutableDictionary *prefsDict = [NSMutableDictionary dictionaryWithContentsOfFile:plistPath] ?
                                     [NSMutableDictionary dictionaryWithContentsOfFile:plistPath] :
                                     [NSMutableDictionary dictionary];

    if (!prefsDict) {
        prefsDict = [NSMutableDictionary dictionary];
    }

    NSString *hex = [prefsDict objectForKey:[[self.specifier properties] objectForKey:@"key"]] ?          //if default color
                    [prefsDict objectForKey:[[self.specifier properties] objectForKey:@"key"]] :          //then default color
                    [prefsDict objectForKey:[[self.specifier properties] objectForKey:@"fallback"]] ?     //else if fallback
                    [prefsDict objectForKey:[[self.specifier properties] objectForKey:@"fallback"]] :     //then fallback
                    @"FF0000)";                                                                           //else red

    UIColor *color = [UIColor colorFromHexString:hex];

    [self.options setObject:hex forKey:@"hexValue"];
    [self.options setObject:color forKey:@"color"];

    return color;
}

- (PSSpecifier *)specifier {

    return [super specifier];
}

@end
