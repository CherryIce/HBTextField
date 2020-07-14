//
//  ShareDisplayView.m
//  ShareExtesion
//
//  Created by Mr.Zhu on 14/07/2020.
//  Copyright © 2020 Mr.hu. All rights reserved.
//

#import "ShareDisplayView.h"

#import "CycleScrollView.h"

#import <AVFoundation/AVAsset.h>
#import <AVFoundation/AVAssetImageGenerator.h>
#import <AVFoundation/AVTime.h>

#import <WebKit/WebKit.h>

@interface ShareDisplayView()<UITableViewDelegate,UITableViewDataSource,WKNavigationDelegate>

@property (nonatomic , strong) UITableView * tableView;

@property (nonatomic , weak) UIView *  headerView;

@property (weak,nonatomic) CycleScrollView *cycleScrollView;

@property (nonatomic , weak) WKWebView * webView;

@property (nonatomic, strong) UIActivityIndicatorView * loading;

@end

static NSString * cellId = @"Cell";

@implementation ShareDisplayView

+ (instancetype) shareInstance{
    return [[self alloc] initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.25];
        [self addSubview:self.tableView];
    }
    return self;
}

//显示
- (void)showInView:(UIView *) baseView {
//    if ([baseView.subviews containsObject:self]) {
//        [self removeFromSuperview];
//    }
    CGRect frame = self.tableView.frame;
    CGRect frame2 = frame;
    frame2.origin.y += frame2.size.height;
    self.tableView.frame = frame2;
    
    [self initUI];
    [baseView addSubview:self];
    self.alpha = 0;
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.alpha = 1;
        self.tableView.frame = frame;
    } completion:nil];
}

//消失
- (void)dismiss {
    CGRect frame = self.tableView.frame;
    frame.origin.y += frame.size.height;
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 0;
        self.tableView.frame = frame;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

//禁止上滑
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    NSLog(@"<><><><>%@",scrollView);
    CGFloat off_y = scrollView.contentOffset.y;
    if (off_y > 0) {
        scrollView.contentOffset = CGPointZero;
    }
}

#pragma mark -- setter
- (void)setCurrentTypeStr:(NSString *)currentTypeStr {
    _currentTypeStr = currentTypeStr;
}

- (void)setShareArray:(NSArray *)shareArray {
    _shareArray = shareArray;
}

#pragma mark -- UI
- (void) initUI {
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellId];
    [self.tableView reloadData];
    
    [self setHeaderView];
}

- (void) setHeaderView {
    if (self.headerView) {
        [self.headerView removeFromSuperview];
    }
    
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0,0, CGRectGetWidth(self.frame), CGRectGetWidth(self.frame)/2 + 20 + 45)];
    headerView.backgroundColor = [UIColor whiteColor];
    self.headerView = headerView;
    
    UIView * topV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.headerView.frame), 45)];
    [self.headerView addSubview:topV];
    
    UIButton * cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setFrame:CGRectMake(16, 5, 45, 35)];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelBtnClickHandler:) forControlEvents:UIControlEventTouchUpInside];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [topV addSubview:cancelButton];
    
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(cancelButton.frame) + 10, CGRectGetMinY(cancelButton.frame), CGRectGetWidth(topV.frame) - 2 * (CGRectGetMaxX(cancelButton.frame) + 10), CGRectGetHeight(cancelButton.frame))];
    titleLabel.text = [NSString stringWithFormat:@"共%zd项",self.shareArray.count];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [topV addSubview:titleLabel];
    
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(topV.frame)+5, CGRectGetWidth(topV.frame), 1)];
    lineView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.headerView addSubview:lineView];
    
    if ([self.currentTypeStr isEqualToString:@"图片"]) {
        CycleScrollView *scrollView = [[CycleScrollView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(lineView.frame) + 10, CGRectGetWidth(self.headerView.frame), CGRectGetHeight(self.headerView.frame) - 10 - CGRectGetMaxY(lineView.frame)) cycleDirection:CycleDirectionLandscape pictures:self.shareArray delegate:nil];
        [self.headerView addSubview:self.cycleScrollView = scrollView];
    }
    if ([self.currentTypeStr isEqualToString:@"视频"]) {
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(lineView.frame) + 10, CGRectGetWidth(self.headerView.frame), CGRectGetHeight(self.headerView.frame) - 10 - CGRectGetMaxY(lineView.frame))];
        [self.headerView addSubview:imageView];
        
        NSURL * url = [NSURL URLWithString:self.shareArray.firstObject];
        imageView.image = [self getVideoPreViewImage:url];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    
    if ([self.currentTypeStr isEqualToString:@"网址"]) {
        WKWebViewConfiguration *webConfiguration = [WKWebViewConfiguration new];
        WKWebView * webView = [[WKWebView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(lineView.frame) + 10, CGRectGetWidth(self.headerView.frame), CGRectGetHeight(self.headerView.frame) - 10 - CGRectGetMaxY(lineView.frame)) configuration:webConfiguration];
        webView.navigationDelegate = self;
        NSString *urlStr = self.shareArray.lastObject;
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlStr]];
        [webView loadRequest:request];
        [self.headerView addSubview:self.webView = webView];
    }
    
    self.tableView.tableHeaderView = self.headerView;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self dismiss];
    if (self.delegate && [self.delegate respondsToSelector:@selector(shareToApp)]) {
        [self.delegate shareToApp];
    }
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

- (void)cancelBtnClickHandler:(id)sender {
    [self dismiss];
    if (self.delegate && [self.delegate respondsToSelector:@selector(cancel)]) {
        [self.delegate cancel];
    }
}

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    [self addActive];
    decisionHandler(WKNavigationActionPolicyAllow);
}

// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    //[self.loading stopAnimating];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [self.loading stopAnimating];
}

//失败
- (void)webView:(WKWebView *)webView didFailNavigation: (null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    [self.loading stopAnimating];
    NSLog(@"webview didFailNavigation %@",error);
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    [self.loading stopAnimating];
    NSLog(@"%s", __FUNCTION__);
    NSLog(@"%@",error);
}

//添加菊花
- (void) addActive {
    if (_loading == nil) {
        //创建
        self.loading = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        //控件中心坐标
        _loading.center = self.headerView.center;
        //开启动画
        [_loading startAnimating];
        //添加
        [self.headerView addSubview:_loading];
//        //使导航栏也显示此控件
//        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    }else{
        [_loading startAnimating];
    }
}

#pragma mark -- lazy load
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 100, self.bounds.size.width, self.bounds.size.height - 100) style:UITableViewStylePlain];
        //CGFloat contentInsetTop = 100.f;
        //_tableView.contentInset = UIEdgeInsetsMake(contentInsetTop, 0, 0, 0);
        //_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor  = [UIColor whiteColor];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _tableView.dataSource = self;
        _tableView.delegate   = self;
        _tableView.rowHeight = 50.f;
        _tableView.tableFooterView = [UIView new];
        
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(16,16)];
        //创建 layer
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = self.bounds;
        //赋值
        maskLayer.path = maskPath.CGPath;
        _tableView.layer.mask = maskLayer;
    }
    return _tableView;;
}

@end
