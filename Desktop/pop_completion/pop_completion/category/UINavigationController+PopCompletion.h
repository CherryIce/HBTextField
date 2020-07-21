//
//  UINavigationController+PopCompletion.h
//  pop_completion
//
//  Created by Mr.Zhu on 20/07/2020.
//  Copyright © 2020 Mr.hu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UINavigationController (PopCompletion)

- (void)popViewControllerAnimated:(BOOL)animated compeletion:(void(^)(void))compeletion;

@end

NS_ASSUME_NONNULL_END
