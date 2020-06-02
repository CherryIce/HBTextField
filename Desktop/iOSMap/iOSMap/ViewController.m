//
//  ViewController.m
//  iOSMap
//
//  Created by Mr.Zhu on 02/06/2020.
//  Copyright © 2020 Mr.hu. All rights reserved.
//

#import "ViewController.h"

#import "XXNSHashTable.h"
#import "Singleton.h"

@interface ViewController ()<SingletonDelegate,AppNetWorkDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    for (int i = 0; i < 5; i++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:CGRectMake(50, 50*(i+1), self.view.bounds.size.width - 2 * 50, 40)];
        button.tag = i;
        [button setTitle:[NSString stringWithFormat:@"%d",i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
        button.backgroundColor = [UIColor redColor];
        [self.view addSubview:button];
        
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [XXNSHashTable load];
    
    Singleton * test = [Singleton shareInstance];
    [test addDelegate:self];
    [test onWillLogout];
    [test onDidLogin];
    [test noNetworkToDoSomething];
}

- (void) buttonClick:(UIButton *) sender {
    NSDictionary * dict = @{@"0":@"do1:",
                            @"1":@"do2:",
                            @"2":@"do3:",
                            @"3":@"do4:",
                            @"4":@"do5:"
    };
    //key对应的判断条件，value对应执行方法的名字
    NSString *methodStr = dict[@(sender.tag).stringValue];

    SEL method = nil;
    if (methodStr == NULL) {
        method = NSSelectorFromString(@"methodHolderplace");
    } else {
        method = NSSelectorFromString(methodStr);
    }
    //拿到参数
    [self performSelector:method withObject:sender];
}

- (void)methodHolderplace {
    NSLog(@"启用缺省逻辑");
}

- (void)do1:(UIButton *)sender {
    NSLog(@"map条件判断%@", sender.currentTitle);
}

- (void)do2:(UIButton *)sender {
    NSLog(@"map条件判断%@", sender.currentTitle);
}

- (void)do3:(UIButton *)sender {
    NSLog(@"map条件判断%@", sender.currentTitle);
}

- (void)do4:(UIButton *)sender {
    NSLog(@"map条件判断%@", sender.currentTitle);
}

- (void)do5:(UIButton *)sender {
    NSLog(@"map条件判断%@", sender.currentTitle);
}

- (void)updateUserInfo {
   NSLog(@"updateUserInfo");
}

- (void)userAuthDidLogin {
   NSLog(@"userAuthDidLogin");
}

- (void)userAuthWillLogout {
    NSLog(@"userAuthWillLogout");
}

- (void)noNetwork {
    NSLog(@"noNetwork");
}

@end
