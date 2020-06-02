//
//  AppDelegate.m
//  QiNotification
//
//  Created by wangdacheng on 2018/8/29.
//  Copyright © 2018年 dac. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
#import <UserNotifications/UserNotifications.h>
#endif

@interface AppDelegate () <UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
   
    ViewController *controller = [[ViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
    _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [_window setRootViewController:nav];
    [_window makeKeyAndVisible];
    
    ////注册本地推送通知（具体操作在ViewController中）
    //[self registerLocalNotification];
    // 注册远程推送通知
    [self registerRemoteNotifications];
    
    return YES;
}

- (void)registerLocalNotification {

    if (@available(iOS 10.0, *)) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (!error) {
                NSLog(@"request authorization succeeded!");
            }
        }];
    } else {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
}


- (void)registerRemoteNotifications
{
    if (@available(iOS 10.0, *)) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionCarPlay) completionHandler:^(BOOL granted, NSError *_Nullable error) {
            if (!error) {
                NSLog(@"request authorization succeeded!");
                dispatch_async(dispatch_get_main_queue(), ^{
                   [[UIApplication sharedApplication] registerForRemoteNotifications];
                });
            } else {
                NSLog(@"request authorization failed!");
            }
        }];
    } else {
        UIUserNotificationType types = (UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
}


- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    
    NSLog(@"didRegisterUserNotificationSettings");
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    
    NSLog(@"app收到本地推送(didReceiveLocalNotification:):%@", notification.userInfo);
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    // 获取并处理deviceToken
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"DeviceToken:%@\n", token);
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    
    NSLog(@"didFailToRegisterForRemoteNotificationsWithError: %@", error.description);
}

// 注：iOS10以上如果不使用UNUserNotificationCenter时，也将走此回调方法
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // iOS6及以下系统
    if (userInfo) {
        if (application.applicationState == UIApplicationStateActive) {
            NSLog(@"app位于前台通知(didReceiveRemoteNotification:):%@", userInfo);
            UIViewController *ctl = [[UIViewController alloc] init];
            ctl.view.backgroundColor = [UIColor redColor];
            [[self currentViewController] presentViewController:ctl animated:NO completion:nil];
        } else {
            NSLog(@"app位于后台通知(didReceiveRemoteNotification:):%@", userInfo);
            UIViewController *ctl = [[UIViewController alloc] init];
            ctl.view.backgroundColor = [UIColor greenColor];
            [[self currentViewController] presentViewController:ctl animated:NO completion:nil];
        }
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler NS_AVAILABLE_IOS(7_0) {
    // iOS7及以上系统
    if (userInfo) {
        if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
            NSLog(@"app位于前台通知(didReceiveRemoteNotification:fetchCompletionHandler:):%@", userInfo);
            UIViewController *ctl = [[UIViewController alloc] init];
            ctl.view.backgroundColor = [UIColor brownColor];
            [[self currentViewController] presentViewController:ctl animated:NO completion:nil];
        } else {
            UIViewController *ctl = [[UIViewController alloc] init];
            ctl.view.backgroundColor = [UIColor blueColor];
            [[self currentViewController] presentViewController:ctl animated:NO completion:nil];
            NSLog(@"app位于后台通知(didReceiveRemoteNotification:fetchCompletionHandler:):%@", userInfo);
        }
    }
    completionHandler(UIBackgroundFetchResultNewData);
}


#pragma mark - iOS>=10 中收到推送消息

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler
API_AVAILABLE(ios(10.0)){
    NSDictionary * userInfo = notification.request.content.userInfo;
    if (userInfo) {
        NSLog(@"app位于前台通知(willPresentNotification:):%@", userInfo);
    }
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert);
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler
API_AVAILABLE(ios(10.0)){
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if (userInfo) {
        NSLog(@"点击通知进入App时触发(didReceiveNotificationResponse:):%@", userInfo);
        if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
            UIViewController *ctl = [[UIViewController alloc] init];
            ctl.view.backgroundColor = [UIColor brownColor];
            [[self currentViewController] presentViewController:ctl animated:NO completion:nil];
        } else {
            UIViewController *ctl = [[UIViewController alloc] init];
            ctl.view.backgroundColor = [UIColor blueColor];
            [[self currentViewController] presentViewController:ctl animated:NO completion:nil];
        }
    }
    completionHandler();
}

- (UIViewController*)currentViewController {
    UIWindow * keyWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
    UIViewController* vc = keyWindow.rootViewController;
    while (1) {
        if ([vc isKindOfClass:[UITabBarController class]]) {
            vc = ((UITabBarController*)vc).selectedViewController;
        }
        if ([vc isKindOfClass:[UINavigationController class]]) {
            vc = ((UINavigationController*)vc).visibleViewController;
        }
        if (vc.presentedViewController) {
            vc = vc.presentedViewController;
        }else{
            break;
        }
    }
    return vc;
}

#endif


@end




//// apsModel示例
/*
 特殊说明：
 1. APNS去掉alert、badge、sound字段实现静默推送，增加增加字段"content-available":1，也可以在后台做一些事情。
 2. mutable-content这个键值为1，说明此条推送可以被 Service Extension 进行更改。
 */

/**
 {"aps":{"alert":{"title":"通知的title","subtitle":"通知的subtitle","body":"通知的body","title-loc-key":"TITLE_LOC_KEY","title-loc-args":["t_01","t_02"],"loc-key":"LOC_KEY","loc-args":["l_01","l_02"]},"sound":"sound01.wav","badge":1,"mutable-content":1,"category": "QiShareCategoryIdentifier"},"msgid":"123"}
 */

/**
{"aps":{"alert":{"title":"Title...","subtitle":"Subtitle...","body":"Body..."},"sound":"default","badge": 1,"mutable-content": 1,"category": "QiShareCategoryIdentifier",},"msgid":"123","media":{"type":"image","url":"https://www.fotor.com/images2/features/photo_effects/e_bw.jpg"}}
*/
