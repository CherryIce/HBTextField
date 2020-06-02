//
//  Singleton.h
//  iOSMap
//
//  Created by Mr.Zhu on 02/06/2020.
//  Copyright © 2020 Mr.hu. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SingletonDelegate <NSObject>
@optional

- (void)userAuthWillLogout;

- (void)userAuthDidLogin;

- (void)updateUserInfo;

@end

@protocol AppNetWorkDelegate <NSObject>
@optional

- (void) noNetwork;

@end

@interface Singleton : NSObject

+(instancetype)shareInstance;

@property (nonatomic , strong) NSHashTable * delegates;

- (void) addDelegate:(__weak id)delegate;

- (void)onWillLogout;

- (void)onDidLogin;

- (void)removeDelegate:(__weak id)delegate;

- (void) noNetworkToDoSomething;

@end

