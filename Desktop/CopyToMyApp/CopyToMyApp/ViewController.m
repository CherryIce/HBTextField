//
//  ViewController.m
//  CopyToMyApp
//
//  Created by Mr.Zhu on 03/07/2020.
//  Copyright © 2020 Mr.hu. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fileNotification:) name:@"FileNotification" object:nil];
}

- (void)fileNotification:(NSNotification *)notifcation {
    NSDictionary *info = notifcation.userInfo;
    // fileName是文件名称、filePath是文件存储在本地的路径
    // jfkdfj123a.pdf
    NSString *fileName = [info objectForKey:@"fileName"];
    // /private/var/mobile/Containers/Data/Application/83643509-E90E-40A6-92EA-47A44B40CBBF/Documents/Inbox/jfkdfj123a.pdf
    NSString *filePath = [info objectForKey:@"filePath"];

    NSLog(@"fileName=%@---filePath=%@", fileName, filePath);
    
    
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:fileName message:filePath preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:action]; 
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
