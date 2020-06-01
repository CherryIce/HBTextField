//
//  ViewController.m
//  HBTextFiled
//
//  Created by Mr.Zhu on 30/05/2020.
//  Copyright © 2020 Mr.hu. All rights reserved.
//

#import "ViewController.h"

#import "HBTextField.h"

@interface ViewController ()<HBTextFieldDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    HBTextField * tf = [[HBTextField alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    tf.backgroundColor = [UIColor systemGray6Color];
    tf.center = self.view.center;
    tf.maxLength  = 12;
    tf.type = HBInputTextURLType;
    [self.view addSubview:tf];
    
    //代理要使用hbDelegate 不能使用delegate 不然会有冲突
    tf.hbDelegate = self;
}


@end
