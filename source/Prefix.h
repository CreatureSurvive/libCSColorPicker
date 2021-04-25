
// get the associated view controller from a UIView
// credits https://stackoverflow.com/questions/1372977/given-a-view-how-do-i-get-its-viewcontroller/24590678
#define UIViewParentController(__view) ({ UIResponder *__responder = __view; while ([__responder isKindOfClass:[UIView class]]) __responder = [__responder nextResponder]; (UIViewController *)__responder; })

#ifdef DEBUG
	#define CSLog(format, ...)		NSLog((@"(*** libCSColorPicker ***)%s [LOG Line %d] " format), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
	#define CSInfo(format, ...)		NSLog((@"(*** libCSColorPicker ***)%s [INFO Line %d] " format), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
	#define CSError(format, ...)	NSLog((@"(*** libCSColorPicker ***)%s [ERROR Line %d] " format), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
	#define CSWarn(format, ...)		NSLog((@"(*** libCSColorPicker ***)%s [WARN Line %d] " format), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
	#define CSLog(format, ...)
	#define CSInfo(format, ...)
	#define CSError(format, ...)
	#define CSWarn(format, ...)
#endif

NS_INLINE BOOL firmwareGreaterThanEqual(NSString *version) {
    return [[[UIDevice currentDevice] systemVersion] floatValue] >= [version floatValue];
}

NS_INLINE BOOL firmwareGreaterThan(NSString *version) {
    return [[[UIDevice currentDevice] systemVersion] floatValue] > [version floatValue];
}

NS_INLINE BOOL firmwareLessThanEqual(NSString *version) {
    return [[[UIDevice currentDevice] systemVersion] floatValue] <= [version floatValue];
}

NS_INLINE BOOL firmwareLessThan(NSString *version) {
    return [[[UIDevice currentDevice] systemVersion] floatValue] < [version floatValue];
}

NS_INLINE BOOL firmwareEqual(NSString *version) {
    return [[[UIDevice currentDevice] systemVersion] floatValue] == [version floatValue];
}

NS_INLINE __unused UINavigationController *NAVIGATION_WRAPPER_WITH_CONTROLLER(UIViewController *controller) {
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
    return navigationController;
}