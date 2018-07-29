//
// Created by CreatureSurvive on 3/17/17.
// Copyright (c) 2018 CreatureCoding. All rights reserved.
//

#import <UIKit/UIKit.h>

enum {
    CSColorSliderTypeHue = 0,
    CSColorSliderTypeSaturation = 1,
    CSColorSliderTypeBrightness = 2,
    CSColorSliderTypeRed = 3,
    CSColorSliderTypeGreen = 4,
    CSColorSliderTypeBlue = 5,
    CSColorSliderTypeAlpha = 6
};
typedef NSUInteger CSColorSliderType;

@interface CSColorSlider : UISlider

@property (nonatomic, strong) UIColor *color;
@property (nonatomic, assign) UIColor *selectedColor;

@property (nonatomic, strong) UILabel *sliderLabel;
@property (nonatomic, assign) CSColorSliderType sliderType;//0=H 1=S 2=B 3=R 4=G 5=B 6=A

@property (nonatomic) int colorTrackHeight;

- (instancetype)initWithFrame:(CGRect)frame sliderType:(CSColorSliderType)sliderType label:(NSString *)label startColor:(UIColor *)startColor;
- (void)updateTrackImage;
@end
