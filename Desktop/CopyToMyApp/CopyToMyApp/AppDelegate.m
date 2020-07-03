//
//  AppDelegate.m
//  CopyToMyApp
//
//  Created by Mr.Zhu on 03/07/2020.
//  Copyright © 2020 Mr.hu. All rights reserved.
//

#import "AppDelegate.h"

#import "ViewController.h"

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
    if (url) {
        NSString *fileName = url.lastPathComponent; // 从路径中获得完整的文件名（带后缀）
        // path 类似这种格式：file:///private/var/mobile/Containers/Data/Application/83643509-E90E-40A6-92EA-47A44B40CBBF/Documents/Inbox/jfkdfj123a.pdf
        NSString *path = url.absoluteString; // 完整的url字符串
        path = [self URLDecodedString:path]; // 解决url编码问题

        NSMutableString *string = [[NSMutableString alloc] initWithString:path];

        if ([path hasPrefix:@"file://"]) { // 通过前缀来判断是文件
            // 去除前缀：/private/var/mobile/Containers/Data/Application/83643509-E90E-40A6-92EA-47A44B40CBBF/Documents/Inbox/jfkdfj123a.pdf
            [string replaceOccurrencesOfString:@"file://" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, path.length)];

            // 此时获取到文件存储在本地的路径，就可以在自己需要使用的页面使用了
            NSDictionary *dict = @{@"fileName":fileName,
                                   @"filePath":string};
            [[NSNotificationCenter defaultCenter] postNotificationName:@"FileNotification" object:nil userInfo:dict];

            return YES;
        }
    }
    return YES;
}

// 当文件名为中文时，解决url编码问题
- (NSString *)URLDecodedString:(NSString *)str {
    NSString *decodedString = [str stringByRemovingPercentEncoding];
    return decodedString;
}

//- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
//{
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths lastObject];
//    if (url != nil) {
//        NSString *path = [url absoluteString];
//        path = [path stringByRemovingPercentEncoding];
//        NSMutableString *string = [[NSMutableString alloc] initWithString:path];
//        if ([path hasPrefix:@"file:///private"]) {
//            [string replaceOccurrencesOfString:@"file:///private" withString:@"" options:NSCaseInsensitiveSearch  range:NSMakeRange(0, path.length)];
//        }
//        NSArray *tempArray = [string componentsSeparatedByString:@"/"];
//        NSString *fileName = tempArray.lastObject;
//        NSString *sourceName = options[@"UIApplicationOpenURLOptionsSourceApplicationKey"];
//
//        NSFileManager *fileManager = [NSFileManager defaultManager];
//        NSString *filePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@",sourceName,fileName]];
//        if ([fileManager fileExistsAtPath:filePath]) {
//            NSLog(@"文件已存在");
//            return YES;
//        }
//        BOOL isSuccess = [fileManager copyItemAtPath:string toPath:filePath error:nil];
//        if (isSuccess == YES) {
//            NSLog(@"拷贝成功");
//        } else {
//            NSLog(@"拷贝失败");
//        }
//    }
//    NSLog(@"application:openURL:options:");
//    return  YES;
//}

@end
