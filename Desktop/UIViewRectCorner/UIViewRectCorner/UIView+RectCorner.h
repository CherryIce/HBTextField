//
//  UIView+RectCorner.h
//  UIViewRectCorner
//
//  Created by Mr.Zhu on 29/07/2020.
//  Copyright © 2020 Mr.hu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSUInteger, SMRectCorner) {
    /**单个角度**/
    SMRectCornerTopLeft = UIRectCornerTopLeft,//上左
    SMRectCornerTopRight = UIRectCornerTopRight,//上右
    SMRectCornerBottomLeft = UIRectCornerBottomLeft,//下左
    SMRectCornerBottomRight = UIRectCornerBottomRight,//下右
    /**两个角度*/
    SMRectCornerLeft = SMRectCornerTopLeft | SMRectCornerBottomLeft,//左
    SMRectCornerTop = SMRectCornerTopLeft | SMRectCornerTopRight,//上
    SMRectCornerBottom = SMRectCornerBottomLeft | SMRectCornerBottomRight,//下
    SMRectCornerRight = SMRectCornerTopRight | SMRectCornerBottomRight,//右
    /**三个角度*/
    SMRectCornerNoneBottomRight = SMRectCornerTopLeft | SMRectCornerTopRight | SMRectCornerBottomLeft,//左2右上1
    SMRectCornerNoneTopLeft = SMRectCornerBottomRight | SMRectCornerTopRight | SMRectCornerBottomLeft,//左下1右2
    SMRectCornerNoneBottomLeft = SMRectCornerTopLeft | SMRectCornerTopRight | SMRectCornerBottomRight,//左上1右2
    SMRectCornerNoneTopRight = SMRectCornerTopLeft | SMRectCornerBottomRight | SMRectCornerBottomLeft,//左2右下1
    /**四个角度*/
    SMRectCornerAllCorners = UIRectCornerAllCorners,//全部
};

//UIRectCorner

NS_ASSUME_NONNULL_BEGIN

@interface UIView (RectCorner)

- (void) setSMCornerRadius:(CGFloat) cornerRadius SMRectCorner:(SMRectCorner)rectCorner;

@end

NS_ASSUME_NONNULL_END
