#import "CSColorDisplayCell.h"
#define UIViewParentController(__view) ({ \
        UIResponder *__responder = __view; \
        while ([__responder isKindOfClass:[UIView class]]) \
            __responder = [__responder nextResponder]; \
        (UIViewController *)__responder; \
    })

@implementation CSColorDisplayCell
@synthesize cellColorDisplay;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)identifier specifier:(PSSpecifier *)specifier {
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier specifier:specifier];

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

- (void)didMoveToSuperview {
    if (!self.specifier) {
        return;
    }

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


    CSColorPickerViewController *colorViewController = [[CSColorPickerViewController alloc] initForContentSize:viewController.view.frame.size];

    if (self.specifier && [self.specifier propertyForKey:@"defaults"] && [self.specifier propertyForKey:@"key"]) {

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

    NSString *plistPath = [NSString stringWithFormat:@"/var/mobile/Library/Preferences/%@.plist", [self.specifier propertyForKey:@"defaults"]];

    NSDictionary *prefsDict = [NSDictionary dictionaryWithContentsOfFile:plistPath] ? : [NSDictionary dictionary];

    NSDictionary *defaultsDict = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle bundleWithPath:[self.specifier propertyForKey:@"defaultsPath"]]
                                                                             pathForResource:@"defaults"
                                                                                      ofType:@"plist"]] ? :
                                 [NSDictionary dictionaryWithContentsOfFile:[[NSBundle bundleWithPath:@"/Library/PreferenceBundles/motuumLS.bundle"]
                                                                             pathForResource:@"com.creaturesurvive.motuumls_defaults"
                                                                                      ofType:@"plist"]] ? :
                                 [NSDictionary dictionary];


    NSString *hex = [prefsDict objectForKey:[self.specifier propertyForKey:@"key"]] ? :          //if default color          //then default color
                    [defaultsDict objectForKey:[self.specifier propertyForKey:@"key"]] ? :       //if defaults color         //then defaults color
                    [prefsDict objectForKey:[self.specifier propertyForKey:@"fallback"]] ? :     //else if fallback          //then fallback
                    @"FF0000)";                                                                             //else red

    UIColor *color = [UIColor colorFromHexString:hex];

    [self.specifier setProperty:hex forKey:@"hexValue"];
    [self.specifier setProperty:color forKey:@"color"];

    return color;
}

- (PSSpecifier *)specifier {

    return [super specifier];
}

@end
