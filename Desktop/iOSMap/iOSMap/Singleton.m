//
//  Singleton.m
//  iOSMap
//
//  Created by Mr.Zhu on 02/06/2020.
//  Copyright © 2020 Mr.hu. All rights reserved.
//

#import "Singleton.h"

@interface Singleton()<NSCopying,NSMutableCopying>

@end

static Singleton *_mySingle = nil;

@implementation Singleton

+(instancetype)shareInstance{
    if (_mySingle == nil) {
        _mySingle = [[Singleton alloc] init];
    }
    return _mySingle;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _mySingle = [super allocWithZone:zone];
    });
    return _mySingle;
}

- (id)copyWithZone:(NSZone *)zone{
    return self;
}

- (id)mutableCopyWithZone:(NSZone *)zone{
    return self;
}



- (void) addDelegate:(__weak id)delegate {
    if(delegate &&self.delegates&& ![self.delegates containsObject:delegate]) {
        [self.delegates addObject:delegate];
    }
}

- (void)onWillLogout {
    [self.delegates.allObjects enumerateObjectsUsingBlock:^(id  <SingletonDelegate>delegate, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([delegate respondsToSelector:@selector(userAuthWillLogout)]) {
            [delegate userAuthWillLogout];
        }
    }];
}

- (void)onDidLogin {
    // TODO Something what you need
    [self.delegates.allObjects enumerateObjectsUsingBlock:^(id  <SingletonDelegate>delegate, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([delegate respondsToSelector:@selector(userAuthDidLogin)]) {
            [delegate userAuthDidLogin];
        }
    }];
}

- (void)noNetworkToDoSomething{
    [self.delegates.allObjects enumerateObjectsUsingBlock:^(id  <AppNetWorkDelegate>delegate, NSUInteger idx, BOOL * _Nonnull stop) {
           if ([delegate respondsToSelector:@selector(noNetwork)]) {
               [delegate noNetwork];
           }
    }];
}


- (NSHashTable *)delegates{
    if (!_delegates) {
        _delegates = [NSHashTable weakObjectsHashTable];
    }
    return _delegates;
}

- (void)removeDelegate:(__weak id)delegate{
    [self.delegates removeObject:delegate];
}

@end
