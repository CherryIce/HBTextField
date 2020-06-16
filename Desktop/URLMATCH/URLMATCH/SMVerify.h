//
//  SMVerify.h
//  URLMATCH
//
//  Created by Mr.Zhu on 15/06/2020.
//  Copyright © 2020 Mr.hu. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

@interface SMVerify : NSObject

+ (NSMutableAttributedString *) verifyStringIsContainURLString:(NSString *)urlString andSetColor:(UIColor *)color font:(UIFont *)font;

@end

