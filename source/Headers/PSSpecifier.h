//
// Created by CreatureSurvive on 3/17/17.
// Copyright (c) 2016 - 2019 CreatureCoding. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PSSpecifier : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) id target;
@property (nonatomic, assign) SEL buttonAction;

- (id)propertyForKey:(NSString *)key;
- (void)setProperty:(id)value forKey:(NSString *)key;

@end
