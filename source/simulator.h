#ifdef SIMULATOR

@interface UIView ()
@property(nonatomic, readonly) UIEdgeInsets safeAreaInsets; //9.2 sdk needed for simulator and this property was added in 11
@end

extern NSString* simulatorPath(NSString* path);
#define rPath(args ...) ({ simulatorPath(args); })

#else

#define rPath(args ...) ({ args; })

#endif
