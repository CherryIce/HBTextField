//
//  ShareTipsView.h
//  ShareExtesion
//
//  Created by Mr.Zhu on 14/07/2020.
//  Copyright © 2020 Mr.hu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ShareTipsView : UIView

@property (nonatomic , copy) NSString * tilteStr;

@property (nonatomic , copy) NSString * contentStr;

@property (nonatomic , copy) void(^cancelButtonClickCall)(void);

+ (instancetype) shareInstance;

- (void)showInView:(UIView *) baseView;

- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
