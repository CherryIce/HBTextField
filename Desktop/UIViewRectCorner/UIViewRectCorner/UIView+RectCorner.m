//
//  UIView+RectCorner.m
//  UIViewRectCorner
//
//  Created by Mr.Zhu on 29/07/2020.
//  Copyright © 2020 Mr.hu. All rights reserved.
//

#import "UIView+RectCorner.h"

@implementation UIView (RectCorner)

- (void) setSMCornerRadius:(CGFloat) cornerRadius SMRectCorner:(SMRectCorner)rectCorner {
    UIRectCorner rectcors = (UIRectCorner)rectCorner;
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:rectcors cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
    //创建 layer
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    //赋值
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

@end
