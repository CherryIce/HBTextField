//
//UIImage+LuBan.h
//UIViewRectCorner
//
//Created by Mr.Zhu on 01/09/2020.
//Copyright © 2020 Mr.hu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (LuBan)

/**
算法步骤
注：下文所说“比例”统一表示：图片短边除以长边为该图片比例

第三挡压缩（参考最新版微信压缩效果）
判断图片比例值，是否处于以下区间内；
[1, 0.5625) 即图片处于 [1:1 ~ 9:16) 比例范围内
[0.5625, 0.5) 即图片处于 [9:16 ~ 1:2) 比例范围内
[0.5, 0) 即图片处于 [1:2 ~ 1:∞) 比例范围内
判断图片最长边是否过边界值；
[1, 0.5625) 边界值为：1664 * n（n=1）, 4990 * n（n=2）, 1280 * pow(2, n-1)（n≥3）
[0.5625, 0.5) 边界值为：1280 * pow(2, n-1)（n≥1）
[0.5, 0) 边界值为：1280 * pow(2, n-1)（n≥1）
计算压缩图片实际边长值，以第2步计算结果为准，超过某个边界值则：width / pow(2, n-1)，height/pow(2, n-1)
计算压缩图片的实际文件大小，以第2、3步结果为准，图片比例越大则文件越大。
size = (newW * newH) / (width * height) * m；
[1, 0.5625) 则 width & height 对应 1664，4990，1280 * n（n≥3），m 对应 150，300，300；
[0.5625, 0.5) 则 width = 1440，height = 2560, m = 200；
[0.5, 0) 则 width = 1280，height = 1280 / scale，m = 500；注：scale为比例值
判断第4步的size是否过小
[1, 0.5625) 则最小 size 对应 60，60，100
[0.5625, 0.5) 则最小 size 都为 100
[0.5, 0) 则最小 size 都为 100
将前面求到的值压缩图片 width, height, size 传入压缩流程，压缩图片直到满足以上数值
*/

//单纯的压缩图
+ (NSData *)lubanCompressImage:(UIImage *)image;
//指定压缩的类型
+ (NSData *)lubanCompressImage:(UIImage *)image imageType:(CFStringRef)imageType;
//压缩图+水印
+ (NSData *)lubanCompressImage:(UIImage *)image withMask:(NSString *)maskName;
//指定压缩的类型+水印
+ (NSData *)lubanCompressImage:(UIImage *)image withMask:(NSString *)maskName imageType:(CFStringRef)imageType;
//压缩图+水印图
+ (NSData *)lubanCompressImage:(UIImage *)image withCustomImage:(NSString *)imageName;
//指定压缩的类型+水印图
+ (NSData *)lubanCompressImage:(UIImage *)image withCustomImage:(NSString *)imageName imageType:(CFStringRef)imageType;

@end

NS_ASSUME_NONNULL_END
