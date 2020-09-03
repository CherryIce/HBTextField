//
//  ViewController.m
//  ATB
//
//  Created by Mr.Zhu on 02/09/2020.
//  Copyright © 2020 Mr.hu. All rights reserved.
//

#import "ViewController.h"
#import "RAViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIView *v1;
@property (weak, nonatomic) IBOutlet UIView *v1s;
@property (weak, nonatomic) IBOutlet UIView *v2;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    _v1s.frame = CGRectMake(0, 0, 100, 100);
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
    [_v1s addGestureRecognizer:tap];
}

- (IBAction)click:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        [_v2 addSubview:_v1s];
    }else{
        [_v1 addSubview:_v1s];
    }
}

- (void) tapClick {
    RAViewController * ra = [[RAViewController alloc] init];
    ra.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:ra animated:YES completion:nil];
}

@end
