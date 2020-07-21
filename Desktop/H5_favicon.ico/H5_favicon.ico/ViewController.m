//
//  ViewController.m
//  H5_favicon.ico
//
//  Created by Mr.Zhu on 17/07/2020.
//  Copyright © 2020 Mr.hu. All rights reserved.
//

#import "ViewController.h"

#import <WebKit/WebKit.h>

@interface ViewController ()<WKNavigationDelegate,WKUIDelegate>

@property (weak, nonatomic) IBOutlet UILabel *showLabel;
@property (weak, nonatomic) IBOutlet UIImageView *showIcon;
@property (weak, nonatomic) IBOutlet UITextField *inputLinkTf;

@property (nonatomic , copy) NSString * lastUrlString;

@property (weak, nonatomic) IBOutlet WKWebView *webView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate = self;
}

- (IBAction)buttonClick:(UIButton *)sender {
    NSString * currentStr = _inputLinkTf.text;;
    if (![_lastUrlString isEqualToString:currentStr]) {
        _lastUrlString = _inputLinkTf.text;
        _showLabel.text = _lastUrlString;
        NSURL * url = [NSURL URLWithString:_lastUrlString];
        UIImage * urlIcon = [self getFavivon_icoFromUrlString:url];
        if (urlIcon) {
            [_showIcon setImage:urlIcon];
        }else{
            _showLabel.text = [NSString stringWithFormat:@"未能获取%@的ico",_lastUrlString];
        }
        
        [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    }
}

- (UIImage *) getFavivon_icoFromUrlString:(NSURL *) url {
    NSString *tmpString = url.absoluteString;
    UIImage * logo = nil;
    /** http https */
    bool isHttp = [tmpString hasPrefix:@"http://"];
    bool isHttps = [tmpString hasPrefix:@"https://"];
    if (isHttp || isHttps) {
        tmpString = url.host;
        NSString *URLString = nil;
        if (isHttp) URLString = [NSString stringWithFormat:@"http://%@/favicon.ico",tmpString];
        else URLString = [NSString stringWithFormat:@"https://%@/favicon.ico",tmpString];
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:URLString]];
        if (data) {
            logo = [UIImage imageWithData:data];
        }
    }
    return logo;
}

//获取h5的描述标签当做消息的副标题
- (void) getWebViewDescription {
    __weak typeof(self) weakSelf = self;
    [self.webView evaluateJavaScript:@"document.getElementsByName(\"description\")[0].content" completionHandler:^(id result, NSError * _Nullable error) {
        if ([result isKindOfClass:[NSString class]]) {
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"description" message:result preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * action = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alert addAction:action];
            [weakSelf presentViewController:alert animated:YES completion:^{
                NSLog(@"description %@",result);
            }];
        }
    }];
}

#pragma mark -- WKNavigationDelegate
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation  {
    [self getWebViewDescription];
}

/**
 Collect~获取网站 favicon.ico 的三种方法
 方法一：
 直接在网址后面加favicon.ico
 例如谷歌的：https://www.google.com/favicon.ico

 方法二：
 F12或者右键查看网页源代码，然后再网页头部找到 ,链接指向即为favicon.ico的地址
 例如虫部落的：
 <link rel="shortcut icon" href="http://chong.qiniudn.com/wp-content/uploads/2015/03/favicon.ico" />

 方法三：
 可以使用google的服务来获取，获取方式如下：
 http://www.google.com/s2/favicons?domain=网站地址
 例如获取百度的：http://www.google.com/s2/favicons?domain=www.baidu.com
 */

@end
