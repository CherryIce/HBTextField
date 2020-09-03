//
//  TFCell.m
//  TT
//
//  Created by Mr.Zhu on 01/09/2020.
//  Copyright © 2020 Mr.hu. All rights reserved.
//

#import "TFCell.h"

@interface TFCell()

@property (nonatomic , strong) UIImageView * icon;

@end

@implementation TFCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.icon];
    }
    return self;
}

- (void)setData:(id)data atItem:(NSInteger)item {
    NSLog(@"setData:%@",data);
}

- (UIImageView *)icon {
    if (!_icon) {
        _icon = [[UIImageView alloc] initWithFrame:self.bounds];
        _icon.backgroundColor = [UIColor blueColor];
    }
    return _icon;
}

@end
