//
//  ShareDisplayViewController.h
//  ShareExtesion
//
//  Created by Mr.Zhu on 14/07/2020.
//  Copyright © 2020 Mr.hu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ShareDisplayViewController : UIViewController

//只允许分享同类型，目前可分享图片、视频、链接
@property (nonatomic, copy) NSString *currentTypeStr;

@property (strong,nonatomic) NSMutableArray *shareArray;

@end

NS_ASSUME_NONNULL_END
