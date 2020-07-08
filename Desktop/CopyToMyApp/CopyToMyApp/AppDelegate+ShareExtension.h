//
//  AppDelegate+ShareExtension.h
//  CopyToMyApp
//
//  Created by Mr.Zhu on 07/07/2020.
//  Copyright © 2020 Mr.hu. All rights reserved.
//

#import "AppDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface AppDelegate (ShareExtension)

- (void) share_extension_application:(UIApplication *)app openURL:(nonnull NSURL *)url options:(nonnull NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options;

@end

NS_ASSUME_NONNULL_END
