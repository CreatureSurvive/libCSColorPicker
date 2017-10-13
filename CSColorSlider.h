#import <UIKit/UIKit.h>

@interface CSColorSlider : UISlider

@property (nonatomic, strong) UIColor *color;
@property (nonatomic, assign) UIColor *selectedColor;

@property (nonatomic, strong) UILabel *sliderLabel;
@property (nonatomic) int sliderType;//0=H 1=S 2=B 3=R 4=G 5=B 6=A

@property (nonatomic) int colorTrackHeight;

- (instancetype)initWithFrame:(CGRect)frame sliderType:(int)sliderType label:(NSString *)label startColor:(UIColor *)startColor;
- (void)updateTrackImage;
@end
