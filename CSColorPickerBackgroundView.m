#import "CSColorPickerBackgroundView.h"

@implementation CSColorPickerBackgroundView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    return self;
}

- (void)drawRect:(CGRect)rect {
    int scale = 10;
    NSArray *colors = [NSArray arrayWithObjects:
                       [UIColor whiteColor],
                       [UIColor grayColor],
                       nil];
    for (int row = 0; row < rect.size.height; row += scale) {
        int index = row % (scale * 2) == 0 ? 0 : 1;
        for (int col = 0; col < rect.size.width; col += scale) {
            [[colors objectAtIndex:index++ % 2] setFill];
            UIRectFill(CGRectMake(col, row, scale, scale));
        }
    }
}

@end