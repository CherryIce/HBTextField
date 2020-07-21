//
//  UINavigationController+PopCompletion.m
//  pop_completion
//
//  Created by Mr.Zhu on 20/07/2020.
//  Copyright © 2020 Mr.hu. All rights reserved.
//

#import "UINavigationController+PopCompletion.h"

#import <objc/runtime.h>

@implementation UINavigationController (PopCompletion)

- (void)popViewControllerAnimated:(BOOL)animated compeletion:(void(^)(void))compeletion {
   UIViewController *topVC = self.topViewController;

    __weak typeof(topVC) weakTopVC = topVC;
    void(^popCompeletion)(void) = ^{
        __strong typeof(weakTopVC) topVC = weakTopVC;
        BOOL directPop = [objc_getAssociatedObject(topVC, @"directPop") boolValue];
        if (!directPop) { // 预防compeletion被多次执行
            objc_setAssociatedObject(topVC, @"directPop", @(YES), OBJC_ASSOCIATION_ASSIGN);
            
            if (compeletion) {
                compeletion();
            }
        }
    };
    objc_setAssociatedObject(topVC, @"popCompeletion", popCompeletion, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    [self popViewControllerAnimated:animated];
}

@end
