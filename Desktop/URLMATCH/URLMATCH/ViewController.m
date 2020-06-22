//
//  ViewController.m
//  URLMATCH
//
//  Created by Mr.Zhu on 15/06/2020.
//  Copyright © 2020 Mr.hu. All rights reserved.
//

#import "ViewController.h"

#import "SMVerify.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *tf;

@property (weak, nonatomic) IBOutlet UILabel *finallLab;

@end



@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // add
}

//http: http:/ http:// https: https:/ https://
- (IBAction)senderClick:(UIButton *)sender {
    if (_tf.text.length > 0) {
        NSString * urlString = _tf.text;
        _finallLab.attributedText = [SMVerify verifyStringIsContainURLString:urlString andSetColor:[UIColor blueColor] font:[UIFont systemFontOfSize:16]];
    }else{
        _finallLab.text = @"你先输入一个想要判断url的字符串啊";
    }
}

/**
 //转码
 NSString *encodedString = (NSString *)
 CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                           
                                                           (CFStringRef)url,
                                                           
                                                           (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",
                                                           
                                                           NULL,
                                                           
                                                           kCFStringEncodingUTF8));
 */


@end
