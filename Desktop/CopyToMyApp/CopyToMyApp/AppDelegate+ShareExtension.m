//
//  AppDelegate+ShareExtension.m
//  CopyToMyApp
//
//  Created by Mr.Zhu on 07/07/2020.
//  Copyright © 2020 Mr.hu. All rights reserved.
//

#import "AppDelegate+ShareExtension.h"
#define SHAREUSERDEFAULTSKEY @"ShareUserDefaultsKey"

@implementation AppDelegate (ShareExtension)

- (void) share_extension_application:(UIApplication *)app openURL:(nonnull NSURL *)url options:(nonnull NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    NSLog(@"share_extension_url:%@",url);
    if ([[url scheme] isKindOfClass:[NSString class]] && [[url scheme] isEqualToString:@"MyShare"]) {//打开当前App
        if ([[options objectForKey:UIApplicationOpenURLOptionsSourceApplicationKey] isEqualToString:@"com.freedom.CopyToMyApp.ShareExtesion"]) {//分享扩展发送过来的
            //获取分享类型
            //NSString * shareTypessssss = [[url.absoluteString componentsSeparatedByString:@"-"] lastObject];
            
            //获取分享数据NSDictionary *shareDic = @{@"shareType" : self.currentType,@"shareData" : self.shareArray,@"detail":@""};
            NSUserDefaults *shareDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.share.entitlements"];
            NSData *data = [shareDefaults objectForKey:SHAREUSERDEFAULTSKEY];
            if (data) {
                NSDictionary *shareDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                NSString *shareType = [shareDic objectForKey:@"shareType"];
                NSArray *shareData = [shareDic objectForKey:@"shareData"];
                NSString *detail = [shareDic objectForKey:@"detail"];
                
                NSLog(@">>>>>shareType:%@ \n shareData:%@ \n detail:%@",shareType,shareData,detail);
                UIAlertController * alert = [UIAlertController alertControllerWithTitle:shareType message:shareData.lastObject preferredStyle:UIAlertControllerStyleActionSheet];
                UIAlertAction * action = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                [alert addAction:action];
                [app.keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
            }
        }
    }
}

@end
