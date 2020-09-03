//
//  TTModel.h
//  TT
//
//  Created by Mr.Zhu on 01/09/2020.
//  Copyright © 2020 Mr.hu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TTModel : NSObject

@property (nonatomic , copy) NSString * titleStr;

@property (nonatomic , strong) Class cellClass;

@end

NS_ASSUME_NONNULL_END
