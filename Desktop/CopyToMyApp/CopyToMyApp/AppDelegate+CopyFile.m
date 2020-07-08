//
//  AppDelegate+CopyFile.m
//  CopyToMyApp
//
//  Created by Mr.Zhu on 07/07/2020.
//  Copyright © 2020 Mr.hu. All rights reserved.
//

#import "AppDelegate+CopyFile.h"

@implementation AppDelegate (CopyFile)

- (void) copy_file_application:(UIApplication *)app openURL:(NSURL *)url options:options{
    NSLog(@"copyfile_url:%@",url);
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

        }
    }
}

// 当文件名为中文时，解决url编码问题
- (NSString *)URLDecodedString:(NSString *)str {
    NSString *decodedString = [str stringByRemovingPercentEncoding];
    return decodedString;
}

@end
