//
//  CollectionViewCell.m
//  ATB
//
//  Created by Mr.Zhu on 02/09/2020.
//  Copyright © 2020 Mr.hu. All rights reserved.
//

#import "CollectionViewCell.h"

@implementation CollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    NSLog(@"layoutSubviews");
}

@end
