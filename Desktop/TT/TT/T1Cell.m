//
//  T1Cell.m
//  TT
//
//  Created by Mr.Zhu on 01/09/2020.
//  Copyright © 2020 Mr.hu. All rights reserved.
//

#import "T1Cell.h"

@implementation T1Cell

- (void)setData:(id)data atItem:(NSInteger)item {
    NSLog(@"T1Cell");
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addGesture];
    }
    return self;
}

- (void) addGesture {
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tttest)];
    [self addGestureRecognizer:tap];
}

- (void) tttest {
    if (self.delegate && [self.delegate respondsToSelector:@selector(doTT)]) {
        [self.delegate doTT];
    }
}


@end
