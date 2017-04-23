#import <Preferences/PSViewController.h>
#import <Preferences/PSTableCell.h>
#import "CSColorPickerViewController.h"
#import "PSSpecifier.h"


@interface CSAlertColorCell : PSTableCell

@property (nonatomic, retain) UIView *cellColorDisplay;
@property (nonatomic, retain) NSMutableDictionary *options;

- (id)initWithStyle:(long long)style reuseIdentifier:(id)identifier specifier:(PSSpecifier *)specifier;
- (void)updateCellLabels;
- (void)updateCellDisplayColor;

- (void)openColorPickerView;

@end
