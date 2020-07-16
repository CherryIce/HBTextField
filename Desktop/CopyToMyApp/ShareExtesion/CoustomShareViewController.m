//
//  CoustomShareViewController.m
//  ShareExtesion
//
//  Created by Mr.Zhu on 07/07/2020.
//  Copyright © 2020 Mr.hu. All rights reserved.
//

#import "CoustomShareViewController.h"
#import "ShareTipsView.h"
#import "ShareDisplayView.h"

#define SHAREUSERDEFAULTSKEY @"ShareUserDefaultsKey"
#define UserInfoKey @"UserInfoKey"

@interface CoustomShareViewController ()<ShareDisplayViewDelegate>

//只允许分享同类型，目前可分享图片、视频、链接、文件
@property (nonatomic, copy) NSString *currentType;
@property (strong,nonatomic) NSMutableArray *shareArray;
@property (nonatomic, copy) NSString * typeStr;

@end

static NSString *kQueueOperationsChanged = @"kQueueOperationsChanged";

@implementation CoustomShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //获取用户信息
    NSUserDefaults *shareDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.share.entitlements"];
    NSDictionary * userDict = [shareDefaults objectForKey:UserInfoKey];
    
    // app名称
    NSDictionary * infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString * app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    if (!userDict) {
        //自定义视图
        ShareTipsView * tipsView = [ShareTipsView shareInstance];
        tipsView.tilteStr = app_Name;
        tipsView.contentStr = [NSString stringWithFormat:@"抱歉，请登录%@之后才能继续使用%@此功能。",app_Name,app_Name];
        [tipsView showInView:self.view];
        
        __weak typeof(self) weakSelf = self;
        tipsView.cancelButtonClickCall = ^{
            [weakSelf cancelBtnClickHandler:nil];
        };
        return;
    }
    
    NSLog(@"%@",self.extensionContext.inputItems);
    
    NSString *errorMessage = nil;
    _typeStr = nil;//图片 视频 网址 文件
    for (NSExtensionItem * obj in self.extensionContext.inputItems) {
        for (NSItemProvider * itemProvider in obj.attachments) {
            errorMessage = [self getErrorMessageWithType:itemProvider.registeredTypeIdentifiers.lastObject];
            _typeStr = [self getTypeNameWithType:itemProvider.registeredTypeIdentifiers.lastObject];
            if (errorMessage) {
                break;
            }
        }
    }
    
    if (errorMessage) {
        //自定义视图
        ShareTipsView * tipsView = [ShareTipsView shareInstance];
        tipsView.tilteStr = app_Name;
        tipsView.contentStr = errorMessage;
        [tipsView showInView:self.view];
        
        __weak typeof(self) weakSelf = self;
        tipsView.cancelButtonClickCall = ^{
            [weakSelf cancelBtnClickHandler:nil];
        };
        return;
    }
    
    self.shareArray = [NSMutableArray array];
    
   //获取分享链接
    __weak typeof(self) weakself= self;
    [self.extensionContext.inputItems enumerateObjectsUsingBlock:^(NSExtensionItem *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj.attachments enumerateObjectsUsingBlock:^(NSItemProvider *  _Nonnull itemProvider, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([itemProvider hasItemConformingToTypeIdentifier:@"public.url"]) {//分享网址
                [itemProvider loadItemForTypeIdentifier:@"public.url"
                                                options:nil
                                      completionHandler:^(id<NSSecureCoding>  _Nullable item, NSError * _Null_unspecified error) {
                    [weakself.shareArray addObject:[(NSURL *)item absoluteString]];
                    [weakself showDisplay];
                }];
            }
            else if ([itemProvider hasItemConformingToTypeIdentifier:@"public.jpeg"]
                                     || [itemProvider hasItemConformingToTypeIdentifier:@"public.png"]
                                     || [itemProvider hasItemConformingToTypeIdentifier:@"com.compuserve.gif"]){//分享图片
                [itemProvider loadItemForTypeIdentifier:itemProvider.registeredTypeIdentifiers.lastObject
                                                                              options:nil
                                                                    completionHandler:^(id<NSSecureCoding>  _Nullable item, NSError * _Null_unspecified error) {
                  /*
                  NSData *data = [NSData dataWithContentsOfURL:(NSURL *)item];
                  UIImage *image = [UIImage imageWithData:data];
                   */
                  /**根据实际情况来*/
                  if ([(NSURL *)item respondsToSelector:@selector(absoluteString)]) {
                      [weakself.shareArray addObject:[(NSURL *)item absoluteString]];
                      [weakself showDisplay];
                  }
                }];
            }
            else if ([itemProvider hasItemConformingToTypeIdentifier:@"com.apple.quicktime-movie"]
                                      || [itemProvider hasItemConformingToTypeIdentifier:@"public.mpeg-4"]) {//分享视频
                 [itemProvider loadItemForTypeIdentifier:itemProvider.registeredTypeIdentifiers.lastObject
                                                                                 options:nil
                                                                       completionHandler:^(id<NSSecureCoding>  _Nullable item, NSError * _Null_unspecified error) {
                      /*
                       NSData *data = [NSData dataWithContentsOfURL:(NSURL *)item];
                       */
                      /**根据实际情况来*/
                      if ([(NSURL *)item respondsToSelector:@selector(absoluteString)]) {
                          [weakself.shareArray addObject:[(NSURL *)item absoluteString]];
                          [weakself showDisplay];
                      }
                 }];
            }
            else if ([itemProvider hasItemConformingToTypeIdentifier:@"public.file-url"]) {//分享文件
                 [itemProvider loadItemForTypeIdentifier:itemProvider.registeredTypeIdentifiers.lastObject
                                                                                 options:nil
                                                                       completionHandler:^(id<NSSecureCoding>  _Nullable item, NSError * _Null_unspecified error) {
                      /*
                       NSData *data = [NSData dataWithContentsOfURL:(NSURL *)item];
                       */
                      /**根据实际情况来*/
                      if ([(NSURL *)item respondsToSelector:@selector(absoluteString)]) {
                          [weakself.shareArray addObject:[(NSURL *)item absoluteString]];
                          [weakself showDisplay];
                      }
                 }];
            }
            else {
                NSLog(@"目前只支持分享图片、视频、链接、文件");
                *stop = YES;
            }
                                
         }];
        *stop = YES;
    }];
}

- (void) showDisplay {
    NSExtensionItem * items = self.extensionContext.inputItems.firstObject;
    NSLog(@"!!!!!!!!!!%zd ------ %zd",self.shareArray.count,items.attachments.count);
    if (self.shareArray.count == items.attachments.count) {
        dispatch_async(dispatch_get_main_queue(), ^{
            ShareDisplayView * dsp = [ShareDisplayView shareInstance];
            dsp.currentTypeStr = self.typeStr;
            dsp.shareArray = self.shareArray;
            dsp.delegate = self;
            [dsp showInView:self.view];
        });
    }
}

- (NSString *)getErrorMessageWithType:(NSString *)type {//判断当前类型是否可以进行分享
    NSString *typeN = [self getTypeNameWithType:type];
    if (typeN == nil) {
        return @"目前只支持分享图片、视频、链接、文件";
    }
    if (self.currentType != nil) {
        if (![type isEqualToString:self.currentType]) {
            NSString *typeName = [self getTypeNameWithType:self.currentType];
            if (![typeN isEqualToString:typeName]) {
               return [NSString stringWithFormat:@"%@和%@不能同时分享",typeName,typeN];
            }
        }
    }else {
        self.currentType = type;
    }
    return nil;
}

- (NSString *)getTypeNameWithType:(NSString *)type {
    if ([type isEqualToString:@"public.url"]) {//分享网址
        return @"网址";
    }else if ([type isEqualToString:@"public.jpeg"] || [type isEqualToString:@"public.png"] || [type isEqualToString:@"com.compuserve.gif"] || [type isEqualToString:@"public.heic"]) {//分享图片
        return @"图片";
    }else if ([type isEqualToString:@"com.apple.quicktime-movie"]||[type isEqualToString:@"public.mpeg-4"]) {//分享视频
        return @"视频";
    }else if ([type isEqualToString:@"public.file-url"]) {//分享文件
        return @"文件";
    }
    else {
        return nil;
    }
}

#pragma mark -- 取消
- (void)cancelBtnClickHandler:(id)sender {
    //取消分享
    [self.extensionContext cancelRequestWithError:[NSError errorWithDomain:@"CustomShareError" code:NSUserCancelledError userInfo:nil]];
}

#pragma mark -- 确定
- (void)openAppWithURL:(NSString*)urlString text:(NSString*)text {
    UIResponder* responder = self;
    while ((responder = [responder nextResponder]) != nil) {
        if ([responder respondsToSelector:@selector(openURL:)] == YES) {
            [responder performSelector:@selector(openURL:) withObject:[NSURL URLWithString:[NSString stringWithFormat:@"MyShare://%@", [self urlStringForShareExtension:urlString text:text]]]];
        }
    }
}
- (NSString*)urlStringForShareExtension:(NSString*)urlString text:(NSString*)text {
    NSString* finalUrl=[NSString stringWithFormat:@"%@-%@", urlString, text];
    NSCharacterSet * allowedCharacters = [[NSCharacterSet characterSetWithCharactersInString:finalUrl] invertedSet];
    finalUrl = [finalUrl stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacters];
    return finalUrl;
}

- (void)postBtnClickHandler:(id)sender {
    //执行分享内容处理
    NSUserDefaults *shareDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.share.entitlements"];
    NSDictionary *shareDic = @{@"shareType" : self.typeStr,@"shareData" : self.shareArray,@"detail":@""};
    NSData *data= [NSJSONSerialization dataWithJSONObject:shareDic options:NSJSONWritingPrettyPrinted error:nil];
    [shareDefaults setObject:data forKey:SHAREUSERDEFAULTSKEY];
    
    [self openAppWithURL:@"myshare" text:self.typeStr];
    
    [self.extensionContext completeRequestReturningItems:@[] completionHandler:nil];
}

#pragma mark -- ShareDisplayViewDelegate
- (void)cancel {
    [self cancelBtnClickHandler:nil];
}

- (void)shareToApp {
    [self postBtnClickHandler:nil];
}

@end
