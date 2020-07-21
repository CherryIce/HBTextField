//
//  AViewController.m
//  pop_completion
//
//  Created by Mr.Zhu on 20/07/2020.
//  Copyright © 2020 Mr.hu. All rights reserved.
//

#import "AViewController.h"

#import "UIViewController+PopCompletion.h"
#import "UINavigationController+PopCompletion.h"

@interface AViewController ()

@end

@implementation AViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"1111111");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blueColor];
    
    NSString * handleStr = @"pop";
    if (self.navigationController.viewControllers.count == 1) {
        handleStr = @"add";
    }
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:handleStr style:UIBarButtonItemStyleDone target:self action:@selector(popView)];
}

- (void) popView {
    if (self.navigationController.viewControllers.count == 1) {
        AViewController * ctl = [AViewController new];
        [self.navigationController pushViewController:ctl animated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:NO compeletion:^{
            NSLog(@"pop回调");
        }];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
