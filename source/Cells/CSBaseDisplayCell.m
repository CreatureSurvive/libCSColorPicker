//
// Created by CreatureSurvive on 3/17/17.
// Copyright (c) 2016 - 2019 CreatureCoding. All rights reserved.
//

#import <Cells/CSBaseDisplayCell.h>
#import <Prefix.h>

@implementation CSBaseDisplayCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)identifier specifier:(PSSpecifier *)specifier {

    if ((self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier specifier:specifier])) {
        [specifier setTarget:self];
        [specifier setButtonAction:@selector(openColorPickerView)];
        self.detailTextLabel.textColor = secondaryLabelColor();

        self.cellColorDisplay = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 58, 29)];
        self.cellColorDisplay.tag = 199;
        self.cellColorDisplay.layer.cornerRadius = CGRectGetHeight(self.cellColorDisplay.frame) / 4;
        self.cellColorDisplay.layer.borderWidth = 2;
        self.cellColorDisplay.layer.borderColor = UIColor.lightGrayColor.CGColor;
        [self setAccessoryView:self.cellColorDisplay];
    }

    return self;
}

- (void)refreshCellContentsWithSpecifier:(PSSpecifier *)specifier {
    [super refreshCellContentsWithSpecifier:specifier];

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

    if (firmwareGreaterThanEqual(@"13.0")) { 
        NSLog(@"%@", viewController.debugDescription);
        [viewController presentViewController:NAVIGATION_WRAPPER_WITH_CONTROLLER(colorViewController) animated:YES completion:nil];
    } else {
        [viewController.navigationController pushViewController:colorViewController animated:YES];
    }
}

- (PSSpecifier *)specifier {

    return [super specifier];
}

@end
