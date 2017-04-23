@interface PSSpecifier : NSObject {

    id target;
    SEL getter;
    SEL setter;
    SEL action;
    SEL cancel;
    Class detailControllerClass;
    long long cellType;
    Class editPaneClass;
    long long keyboardType;
    long long autoCapsType;
    long long autoCorrectionType;
    unsigned long long textFieldType;
    NSString *_name;
    NSArray *_values;
    NSDictionary *_titleDict;
    NSDictionary *_shortTitleDict;
    id _userInfo;
    NSMutableDictionary *_properties;
    SEL _confirmationAction;
    SEL _confirmationCancelAction;
    SEL _buttonAction;
    SEL _controllerLoadAction;
    BOOL _showContentString;

}

@property (nonatomic, retain) NSArray *values;                                 //@synthesize values=_values - In the implementation block
@property (nonatomic, retain) NSString *name;                                  //@synthesize name=_name - In the implementation block
@property (nonatomic, retain) id userInfo;                                      //@synthesize userInfo=_userInfo - In the implementation block
@property (nonatomic, retain) NSDictionary *titleDictionary;                   //@synthesize titleDict=_titleDict - In the implementation block
@property (nonatomic, retain) NSDictionary *shortTitleDictionary;              //@synthesize shortTitleDict=_shortTitleDict - In the implementation block
@property (nonatomic, retain) NSString *identifier;
@property (assign, nonatomic) id target;
@property (assign, nonatomic) Class detailControllerClass;
@property (assign, nonatomic) long long cellType;
@property (assign, nonatomic) Class editPaneClass;
@property (assign, nonatomic) SEL confirmationAction;                           //@synthesize confirmationAction=_confirmationAction - In the implementation block
@property (assign, nonatomic) SEL confirmationCancelAction;                     //@synthesize confirmationCancelAction=_confirmationCancelAction - In the implementation block
@property (assign, nonatomic) SEL buttonAction;                                 //@synthesize buttonAction=_buttonAction - In the implementation block
@property (assign, nonatomic) SEL controllerLoadAction;                         //@synthesize controllerLoadAction=_controllerLoadAction - In the implementation block
@property (assign, nonatomic) BOOL showContentString;                           //@synthesize showContentString=_showContentString - In the implementation block
+ (id)emptyGroupSpecifier;
+ (id)groupSpecifierWithID:(id)arg1 name:(id)arg2;
+ (id)specifierWithSpecifier:(id)arg1;
+ (long long)autoCorrectionTypeForNumber:(id)arg1;
+ (long long)autoCapsTypeForString:(id)arg1;
+ (long long)keyboardTypeForString:(id)arg1;
+ (id)deleteButtonSpecifierWithName:(id)arg1 target:(id)arg2 action:(SEL)arg3;
+ (id)preferenceSpecifierNamed:(id)arg1 target:(id)arg2 set:(SEL)arg3 get:(SEL)arg4 detail:(Class)arg5 cell:(long long)arg6 edit:(Class)arg7;
+ (id)groupSpecifierWithName:(id)arg1;
+ (id)groupSpecifierWithID:(id)arg1;
- (id)init;
- (id)description;
- (id)objectForKeyedSubscript:(id)arg1;
- (void)setObject:(id)arg1 forKeyedSubscript:(id)arg2;
- (void)setName:(NSString *)arg1;
- (NSString *)name;
- (NSString *)identifier;
- (id)userInfo;
- (void)setTarget:(id)arg1;
- (id)target;
- (NSArray *)values;
- (void)setValues:(NSArray *)arg1;
- (void)setIdentifier:(NSString *)arg1;
- (void)setUserInfo:(id)arg1;
- (void)setProperties:(id)arg1;
- (id)propertyForKey:(id)arg1;
- (void)removePropertyForKey:(id)arg1;
- (void)setProperty:(id)arg1 forKey:(id)arg2;
- (id)properties;
- (void)setButtonAction:(SEL)arg1;
- (SEL)buttonAction;
- (void)setValues:(id)arg1 titles:(id)arg2;
- (void)setKeyboardType:(long long)arg1 autoCaps:(long long)arg2 autoCorrection:(long long)arg3;
- (BOOL)showContentString;
- (void)performLegacyAction;
- (void)performControllerLoadAction;
- (void)performButtonAction;
- (SEL)confirmationAction;
- (void)performConfirmationAction;
- (SEL)confirmationCancelAction;
- (void)performConfirmationCancelAction;
- (SEL)legacyCancel;
- (void)setLegacyAction:(SEL)arg1;
- (SEL)legacyAction;
- (void)setupIconImageWithPath:(id)arg1;
- (Class)detailControllerClass;
- (void)setDetailControllerClass:(Class)arg1;
- (Class)editPaneClass;
- (void)setEditPaneClass:(Class)arg1;
- (void)setLegacyCancel:(SEL)arg1;
- (void)setConfirmationAction:(SEL)arg1;
- (void)setConfirmationCancelAction:(SEL)arg1;
- (void)setShowContentString:(BOOL)arg1;
- (NSDictionary *)titleDictionary;
- (void)setTitleDictionary:(NSDictionary *)arg1;
- (NSDictionary *)shortTitleDictionary;
- (void)setShortTitleDictionary:(NSDictionary *)arg1;
- (BOOL)hasValidSetter;
- (BOOL)hasValidGetter;
- (void)setValues:(id)arg1 titles:(id)arg2 shortTitles:(id)arg3;
- (void)performSetterWithValue:(id)arg1;
- (id)performGetter;
- (void)loadValuesAndTitlesFromDataSource;
- (void)setValues:(id)arg1 titles:(id)arg2 shortTitles:(id)arg3 usingLocalizedTitleSorting:(BOOL)arg4;
- (void)setupIconImageWithBundle:(id)arg1;
- (long long)titleCompare:(id)arg1;
- (BOOL)isEqualToSpecifier:(id)arg1;
- (void)setCellType:(long long)arg1;
- (long long)cellType;
- (void)setControllerLoadAction:(SEL)arg1;
- (SEL)controllerLoadAction;
@end
