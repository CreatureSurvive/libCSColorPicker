#import <Preferences/PSViewController.h>
#import <Preferences/PSTableCell.h>
#import "CSColorPickerViewController.h"
#import "PSSpecifier.h"


@interface CSColorDisplayCell : PSTableCell

@property (nonatomic, retain) UIView *cellColorDisplay;
@property (nonatomic, retain) NSMutableDictionary *options;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)identifier specifier:(PSSpecifier *)specifier;
- (void)refreshCellDisplay;
- (void)updateCellLabels;
- (void)updateCellDisplayColor;

- (void)openColorPickerView;

@end
