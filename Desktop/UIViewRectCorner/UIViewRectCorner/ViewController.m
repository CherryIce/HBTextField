//
//  ViewController.m
//  UIViewRectCorner
//
//  Created by Mr.Zhu on 29/07/2020.
//  Copyright © 2020 Mr.hu. All rights reserved.
//

#import "ViewController.h"

#import "UIView+RectCorner.h"
#import "UIImage+LuBan.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIImageView * imgv = [[UIImageView alloc] init];
    [self.view addSubview:imgv];
    //获取图片路径
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *resourcePath = [bundle resourcePath];
    NSString *filePath = [resourcePath stringByAppendingPathComponent:@"IMG_0370.PNG"];
    //压缩过程
    NSData * imgData       = [UIImage lubanCompressImage:[UIImage imageWithContentsOfFile:filePath]];
    //重新赋值
    UIImage * img    = [UIImage imageWithData:imgData];
    //计算位置
    CGRect frame = imgv.frame;
    frame.size = CGSizeMake(200, img.size.height*200/img.size.width);
    imgv.frame = frame;
    imgv.center = self.view.center;
    [imgv setSMCornerRadius:10 SMRectCorner:SMRectCornerAllCorners];
    //设置显示
    imgv.image = img;
}


@end
