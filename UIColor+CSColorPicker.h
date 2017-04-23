
@interface UIColor (CSColorPicker)

+ (NSString *)hexStringFromColor:(UIColor *)color;
+ (NSString *)hexStringFromColorWithAlpha:(UIColor *)color;
+ (NSString *)informationStringForColor:(UIColor *)color wide:(BOOL)wide;
+ (CGFloat)brightnessOfColor:(UIColor *)color;
+ (UIColor *)colorFromHexString:(NSString *)hexString;
+ (UIColor *)colorFromHexString:(NSString *)hexString fallbackString:(NSString *)fallback;
+ (UIColor *)colorFromHexString:(NSString *)hexString alpha:(CGFloat)alpha;
+ (BOOL)isValidHexString:(NSString *)hexStr;
- (UIColor *)adjustBrightnessByAmount:(CGFloat)amount;
- (CGFloat)alpha;
- (CGFloat)red;
- (CGFloat)green;
- (CGFloat)blue;
- (CGFloat)hue;
- (CGFloat)saturation;
- (CGFloat)brightness;
@end