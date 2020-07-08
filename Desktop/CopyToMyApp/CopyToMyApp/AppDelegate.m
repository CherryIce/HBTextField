//
//  AppDelegate.m
//  CopyToMyApp
//
//  Created by Mr.Zhu on 03/07/2020.
//  Copyright © 2020 Mr.hu. All rights reserved.
//

#import "AppDelegate.h"

#import "ViewController.h"
#import "AppDelegate+ShareExtension.h"
#import "AppDelegate+CopyFile.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
     
    ViewController * ctl = [ViewController new];
    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:ctl];
     
    self.window.rootViewController = nav;
    [self.window makeKeyWindow];
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options{
    
    //拷贝文件
    [self copy_file_application:app openURL:url options:options];
    //APP share extension分享
    [self share_extension_application:app openURL:url options:options];
    
    return YES;
}

@end
