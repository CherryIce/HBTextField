//
//  ShareDisplayView.h
//  ShareExtesion
//
//  Created by Mr.Zhu on 14/07/2020.
//  Copyright © 2020 Mr.hu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ShareDisplayViewDelegate <NSObject>

@optional
- (void) cancel;

- (void) shareToApp;

@end

NS_ASSUME_NONNULL_BEGIN

@interface ShareDisplayView : UIView

@property (nonatomic, weak) id<ShareDisplayViewDelegate> delegate;

//只允许分享同类型，目前可分享图片、视频、链接
@property (nonatomic, copy) NSString *currentTypeStr;

@property (copy,nonatomic) NSArray *shareArray;

+ (instancetype) shareInstance;

- (void)showInView:(UIView *) baseView;

- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
