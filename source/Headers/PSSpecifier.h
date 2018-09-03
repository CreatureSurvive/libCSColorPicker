//
// Created by CreatureSurvive on 3/17/17.
// Copyright (c) 2018 CreatureCoding. All rights reserved.
//

@interface PSSpecifier : NSObject

@property (nonatomic, assign) id target;
@property (nonatomic, assign) SEL buttonAction;

- (id)propertyForKey:(NSString *)key;
- (void)setProperty:(id)value forKey:(NSString *)key;

@end
