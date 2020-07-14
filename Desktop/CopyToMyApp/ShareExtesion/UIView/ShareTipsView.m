//
//  ShareTipsView.m
//  ShareExtesion
//
//  Created by Mr.Zhu on 14/07/2020.
//  Copyright © 2020 Mr.hu. All rights reserved.
//

#import "ShareTipsView.h"

@interface ShareTipsView()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation ShareTipsView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.frame = [[UIScreen mainScreen] bounds];
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.25];
}

+ (instancetype) shareInstance{
    return [[NSBundle mainBundle] loadNibNamed:@"ShareTipsView" owner:nil options:nil].firstObject;
}

- (void)setTilteStr:(NSString *)tilteStr {
    _tilteStr = tilteStr;
    _titleLabel.text = _tilteStr;
}

- (void)setContentStr:(NSString *)contentStr {
    _contentStr = contentStr;
    _contentLabel.text = _contentStr;
}

- (IBAction)buttonClick:(UIButton *)sender {
    if (_cancelButtonClickCall) {
        _cancelButtonClickCall();
    }
}

- (void)showInView:(UIView *) baseView {
    [baseView addSubview:self];
    self.alpha = 0;
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.alpha = 1;
    } completion:nil];
}

- (void)dismiss {
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
