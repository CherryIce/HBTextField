//
//  ShareDisplayViewController.m
//  ShareExtesion
//
//  Created by Mr.Zhu on 14/07/2020.
//  Copyright © 2020 Mr.hu. All rights reserved.
//

#import "ShareDisplayViewController.h"
#import "CycleScrollView.h"

#import <AVFoundation/AVAsset.h>
#import <AVFoundation/AVAssetImageGenerator.h>
#import <AVFoundation/AVTime.h>

#import <WebKit/WebKit.h>

#define SHAREUSERDEFAULTSKEY @"ShareUserDefaultsKey"

@interface ShareDisplayViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic , strong) UITableView * tableView;

@property (nonatomic , weak) UIView *  headerView;

@property (weak,nonatomic) CycleScrollView *cycleScrollView;

@property (nonatomic , weak) WKWebView * webView;

@end

static NSString * cellId = @"Cell";

@implementation ShareDisplayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNav];
    [self initUI];
}

- (void)setShareArray:(NSMutableArray *)shareArray {
    _shareArray = shareArray;
    self.navigationController.title = [NSString stringWithFormat:@"共%zd项",_shareArray.count];
}

- (void) setNav {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancelBtnClickHandler:)];
}

- (void) initUI {
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellId];
    [self.tableView reloadData];
    
    [self setHeaderView];
}

- (void) setHeaderView {
    if (self.headerView) {
        [self.headerView removeFromSuperview];
    }
    
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0,0, CGRectGetWidth(self.view.frame), CGRectGetWidth(self.view.frame)/2+20)];
    self.headerView = headerView;
    
    if ([self.currentTypeStr isEqualToString:@"图片"]) {
        CycleScrollView *scrollView = [[CycleScrollView alloc] initWithFrame:CGRectMake(0,10, CGRectGetWidth(self.headerView.frame), CGRectGetHeight(self.headerView.frame)/2 - 10) cycleDirection:CycleDirectionLandscape pictures:self.shareArray delegate:nil];
        [self.headerView addSubview:self.cycleScrollView = scrollView];
    }
    if ([self.currentTypeStr isEqualToString:@"视频"]) {
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,10, CGRectGetWidth(self.headerView.frame), CGRectGetHeight(self.headerView.frame)/2 - 10)];
        [self.headerView addSubview:imageView];
        
        NSURL * url = self.shareArray.firstObject;
        imageView.image = [self getVideoPreViewImage:url];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    
    if ([self.currentTypeStr isEqualToString:@"网址"]) {
        WKWebViewConfiguration *webConfiguration = [WKWebViewConfiguration new];
        WKWebView * webView = [[WKWebView alloc] initWithFrame:[UIScreen mainScreen].bounds configuration:webConfiguration];
        NSURL *urlStr = self.shareArray.lastObject;
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:urlStr];
        [webView loadRequest:request];
        [self.headerView addSubview:self.webView = webView];
    }
    
    self.tableView.tableHeaderView = self.headerView;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self postBtnClickHandler:nil];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.textLabel.text = @"发送给朋友";
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

#pragma mark -- 取消
- (void)cancelBtnClickHandler:(id)sender {
    /** 用代理先dimss再回调操作不知道如何**/
    UIViewController * ctl = self;
    //取消分享
    [ctl.extensionContext cancelRequestWithError:[NSError errorWithDomain:@"CustomShareError" code:NSUserCancelledError userInfo:nil]];
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
    NSDictionary *shareDic = @{@"shareType" : self.currentTypeStr,@"shareData" : self.shareArray,@"detail":@""};
    NSData *data= [NSJSONSerialization dataWithJSONObject:shareDic options:NSJSONWritingPrettyPrinted error:nil];
    [shareDefaults setObject:data forKey:SHAREUSERDEFAULTSKEY];
    
    [self openAppWithURL:@"myshare" text:self.currentTypeStr];
    /** 用代理先dimss再回调操作不知道如何**/
    [self.extensionContext completeRequestReturningItems:@[] completionHandler:nil];
}

#pragma mark // 获取视频第一帧
- (UIImage*) getVideoPreViewImage:(NSURL *)path
{
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:path options:nil];
    AVAssetImageGenerator *assetGen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    
    assetGen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [assetGen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *videoImage = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    return videoImage;
}

#pragma mark -- lazy load
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        CGFloat contentInsetTop = 10.f;
        _tableView.contentInset = UIEdgeInsetsMake(contentInsetTop, 0, 0, 0);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor  = [UIColor clearColor];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _tableView.dataSource = self;
        _tableView.delegate   = self;
        _tableView.rowHeight = 50.f;
        _tableView.tableFooterView = [UIView new];
        [self.view addSubview:_tableView];
    }
    return _tableView;;
}

@end
