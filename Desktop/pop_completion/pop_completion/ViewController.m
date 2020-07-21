//
//  ViewController.m
//  pop_completion
//
//  Created by Mr.Zhu on 20/07/2020.
//  Copyright © 2020 Mr.hu. All rights reserved.
//

#import "ViewController.h"

#import "AViewController.h"
#import "BViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)pushClick:(UIButton *)sender {
    AViewController * ctl = [AViewController new];
    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:ctl];
    [self presentViewController:nav animated:YES completion:^{
        
    }];
}

- (IBAction)presentClick:(UIButton *)sender {
    BViewController * ctl = [BViewController new];
    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:ctl];
    [self presentViewController:nav animated:YES completion:^{
        
    }];
}


@end
