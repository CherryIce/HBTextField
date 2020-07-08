//
//  AppDelegate+CopyFile.h
//  CopyToMyApp
//
//  Created by Mr.Zhu on 07/07/2020.
//  Copyright © 2020 Mr.hu. All rights reserved.
//

#import "AppDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface AppDelegate (CopyFile)

- (void) copy_file_application:(UIApplication *)app openURL:(NSURL *)url options:options;

@end

NS_ASSUME_NONNULL_END
