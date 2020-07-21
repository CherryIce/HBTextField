//
//  UIViewController+PopCompletion.m
//  pop_completion
//
//  Created by Mr.Zhu on 20/07/2020.
//  Copyright © 2020 Mr.hu. All rights reserved.
//

#import "UIViewController+PopCompletion.h"

#import <objc/runtime.h>

@implementation UIViewController (PopCompletion)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method originalMethod = class_getInstanceMethod(self, @selector(viewDidDisappear:));
        Method swizzledMethod = class_getInstanceMethod(self, @selector(xks_viewDidDisappear:));
        method_exchangeImplementations(originalMethod, swizzledMethod);
    });
}

- (void)xks_viewDidDisappear:(BOOL)animated {
    //[super xks_viewDidDisappear:animated];
    void(^popCompeletion)(void) = objc_getAssociatedObject(self, @"popCompeletion");
    if (popCompeletion) {
        popCompeletion();
    }
}

@end
