//
//  UIImage+LuBan.m
//  UIViewRectCorner
//
//  Created by Mr.Zhu on 01/09/2020.
//  Copyright © 2020 Mr.hu. All rights reserved.
//

#import "UIImage+LuBan.h"

#import <objc/runtime.h>
#import <MobileCoreServices/MobileCoreServices.h>

@implementation UIImage (LuBan)

static char isCustomImage;
static char customImageName;

+ (NSData *)lubanCompressImage:(UIImage *)image {
    return [self lubanCompressImage:image withMask:@""];
}

+ (NSData *)lubanCompressImage:( UIImage *)image imageType:( CFStringRef)imageType {
    return [self lubanCompressImage:image withMask:@"" imageType:imageType];
}


+ (NSData *)lubanCompressImage:(UIImage *)image withMask:(NSString *)maskName {
    return [self lubanCompressImage:image withMask:maskName imageType:kUTTypeJPEG];
}

+ (NSData *)lubanCompressImage:(UIImage *)image withMask:(NSString *)maskName imageType:(nonnull CFStringRef)imageType {
    
    double size;
    //测试图大小是44M
//    //UIImageJPEGRepresentation方法的峰值大概是30M-100+M 消耗时间都差不多
//    NSData *imageData = UIImageJPEGRepresentation(image, 0.7);
//    NSLog(@">>>>>> %f Kb",imageData1.length/1024.0);
    //ImageIO方法的峰值大概是17M-80+M
    NSData *imageData = [self rawData2:image imageType:imageType];
    NSLog(@"image data size before compressed == %f Kb",imageData.length/1024.0);
    
    int fixelW = (int)image.size.width;
    int fixelH = (int)image.size.height;
    int thumbW = fixelW % 2  == 1 ? fixelW + 1 : fixelW;
    int thumbH = fixelH % 2  == 1 ? fixelH + 1 : fixelH;
    
    
    int longSide = MAX(fixelW, fixelH);
    int shortSide = MIN(fixelW, fixelH);
    double scale = (double) shortSide/longSide;
    
    if (scale <= 1 && scale > 0.5625) {
        
        if (longSide < 1664) {
            if (imageData.length/1024.0 < 150) {
                return imageData;
            }
            size = (fixelW * fixelH) / pow(1664, 2) * 150;
            size = size < 60 ? 60 : size;
        }
        else if (longSide >= 1664 && longSide < 4990) {
            thumbW = fixelW / 2;
            thumbH = fixelH / 2;
            size   = (thumbH * thumbW) / pow(2495, 2) * 300;
            size = size < 60 ? 60 : size;
        }
        else if (longSide >= 4990 && longSide < 10240) {
            thumbW = fixelW / 4;
            thumbH = fixelH / 4;
            size = (thumbW * thumbH) / pow(2560, 2) * 300;
            size = size < 100 ? 100 : size;
        }
        else {
            int multiple = fixelH / 1280 == 0 ? 1 : fixelH / 1280;
//            multiple = multiple % 2 == 0 ? multiple : (multiple - 1);//兼容安卓bitmap只取偶的情况 ios实际场景未知
            thumbW = fixelW / multiple;
            thumbH = fixelH / multiple;
            size = (thumbW * thumbH) / pow(2560, 2) * 300;
            size = size < 100 ? 100 : size;
        }
    }
    else if (scale <= 0.5625 && scale > 0.5) {
        
        if (longSide < 1280 && imageData.length/1024 < 200) {
            
            return imageData;
        }
        int multiple = longSide / 1280 == 0 ? 1 : longSide / 1280;
//        multiple = multiple % 2 == 0 ? multiple : (multiple - 1);//兼容安卓bitmap只取偶的情况 ios实际场景未知
        thumbW = fixelW / multiple;
        thumbH = fixelH / multiple;
        size = (thumbW * thumbH) / (1440.0 * 2560.0) * 400;
        size = size < 100 ? 100 : size;
    }
    else {
        int multiple = (int)ceil(longSide / (1280.0 / scale));
//        multiple = multiple % 2 == 0 ? multiple : (multiple - 1);//兼容安卓bitmap只取偶的情况 ios实际场景未知
        thumbW = fixelW / multiple;
        thumbH = fixelH / multiple;
        size = ((thumbW * thumbH) / (1280.0 * (1280 / scale))) * 500;
        size = size < 100 ? 100 : size;
    }
    return [self compressWithImage:image thumbW:thumbW thumbH:thumbH size:size withMask:maskName];
}

+ (NSData *)lubanCompressImage:(UIImage *)image withCustomImage:(NSString *)imageName {
    if (imageName) {
        objc_setAssociatedObject(self, &isCustomImage, @(1), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        objc_setAssociatedObject(self, &customImageName, imageName, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return [self lubanCompressImage:image withMask:@""];
}

+ (NSData *)lubanCompressImage:(UIImage *)image withCustomImage:(NSString *)imageName imageType:(nonnull CFStringRef)imageType{
    if (imageName) {
        objc_setAssociatedObject(self, &isCustomImage, @(1), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        objc_setAssociatedObject(self, &customImageName, imageName, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return [self lubanCompressImage:image withMask:@"" imageType:imageType];
}

+ (NSData *)compressWithImage:(UIImage *)image thumbW:(int)width thumbH:(int)height size:(double)size withMask:(NSString *)maskName {
    
    UIImage *thumbImage = [image fixOrientation];
    thumbImage = [thumbImage resizeImage:image thumbWidth:width thumbHeight:height withMask:maskName];
    
    float qualityCompress = 0.0;
    NSData *imageData = UIImageJPEGRepresentation(thumbImage, qualityCompress);
    
    NSUInteger lenght = imageData.length;
    while (lenght / 1024 > size && qualityCompress <= (1-0.06)) {
        
        qualityCompress     += 0.06 ;
        int intCommpress   = (int)(qualityCompress*100);
        qualityCompress    = intCommpress/100.0;
        imageData    = UIImageJPEGRepresentation(thumbImage, qualityCompress);
        lenght       = imageData.length;
        thumbImage   = [UIImage imageWithData:imageData];
    }
    NSLog(@"image data size after compressed == %f kb",imageData.length/1024.0);
    return imageData;
}

// specify the size
- (UIImage *)resizeImage:(UIImage *)image thumbWidth:(int)width thumbHeight:(int)height withMask:(NSString *)maskName {
    
    int outW = (int)image.size.width;
    int outH = (int)image.size.height;
    
    int inSampleSize = 1;
    
    if (outW > width || outH > height) {
        int halfW = outW / 2;
        int halfH = outH / 2;
        
        while ((halfH / inSampleSize) > height && (halfW / inSampleSize) > width) {
            inSampleSize *= 2;
        }
    }
    
    // keep one decimal
    int outWith  = (int)((outW / (float) width)*10);
    int outHeiht = (int)((outH / (float) height)*10);
    float heightRatio = outHeiht/10.0;
    float widthRatio  = outWith/10.0;
    
    if (heightRatio > 1 || widthRatio > 1) {
        
        inSampleSize = heightRatio > widthRatio ? heightRatio : widthRatio;
    }
    CGSize thumbSize = CGSizeMake((NSUInteger)((CGFloat)(outW/inSampleSize)), (NSUInteger)((CGFloat)(outH/inSampleSize)));
    
    UIGraphicsBeginImageContext(thumbSize);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [image drawInRect:CGRectMake(0, 0, thumbSize.width, thumbSize.height)];
    if (maskName) {
        
        CGContextTranslateCTM (context, thumbSize.width / 2, thumbSize.height / 2);
        CGContextScaleCTM (context, 1, -1);
        
        [self drawMaskWithString:maskName context:context radius:0 angle:0 colour:[UIColor colorWithRed:1.0  green:1.0 blue:1.0 alpha:0.5] font:[UIFont systemFontOfSize:38.0] slantAngle:(CGFloat)(M_PI/6) size:thumbSize];
    }
    else {
        NSNumber *iscustom = objc_getAssociatedObject(self, &isCustomImage);
        BOOL      isCustom = [iscustom boolValue];
        if (isCustom) {
            NSString *imageName = objc_getAssociatedObject(self, &customImageName);
            UIImage *imageMask = [UIImage imageNamed:imageName];
            if (imageMask) {
                [imageMask drawInRect:CGRectMake(0, 0, thumbSize.width, thumbSize.height)];
            }
        }
    }
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    objc_setAssociatedObject(self, &isCustomImage, @(NO), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    return resultImage;
}

- (UIImage *)fixOrientation {
    
    // No-op if the orientation is already correct
    if (self.imageOrientation == UIImageOrientationUp) return self;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (self.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, self.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    
    switch (self.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, self.size.width, self.size.height,
                                             CGImageGetBitsPerComponent(self.CGImage), 0,
                                             CGImageGetColorSpace(self.CGImage),
                                             CGImageGetBitmapInfo(self.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.height,self.size.width), self.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.width,self.size.height), self.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

- (void) drawMaskWithString:(NSString *)str context:(CGContextRef)context radius:(CGFloat)radius angle:(CGFloat)angle colour:(UIColor *)colour font:(UIFont *)font slantAngle:(CGFloat)slantAngle size:(CGSize)size{
    // *******************************************************
    // This draws the String str centred at the position
    // specified by the polar coordinates (r, theta)
    // i.e. the x= r * cos(theta) y= r * sin(theta)
    // and rotated by the angle slantAngle
    // *******************************************************
    
    // Set the text attributes
    NSDictionary *attributes = @{NSForegroundColorAttributeName:colour,
                                            NSFontAttributeName:font};
    // Save the context
    CGContextSaveGState(context);
    // Undo the inversion of the Y-axis (or the text goes backwards!)
    CGContextScaleCTM(context, 1, -1);
    // Move the origin to the centre of the text (negating the y-axis manually)
    CGContextTranslateCTM(context, radius * cos(angle), -(radius * sin(angle)));
    // Rotate the coordinate system
    CGContextRotateCTM(context, -slantAngle);
    // Calculate the width of the text
    CGSize offset = [str sizeWithAttributes:attributes];
    // Move the origin by half the size of the text
    CGContextTranslateCTM (context, -offset.width / 2, -offset.height / 2); // Move the origin to the centre of the text (negating the y-axis manually)
    // Draw the text
    
    NSInteger width  = ceil(cos(slantAngle)*offset.width);
    NSInteger height = ceil(sin(slantAngle)*offset.width);
    
    NSInteger row    = size.height/(height+100.0);
    NSInteger coloum = size.width/(width+100.0)>6?:6;
    CGFloat xPoint   = 0;
    CGFloat yPoint   = 0;
    for (NSInteger index = 0; index < row*coloum; index++) {
        
        xPoint = (index%coloum) *(width+100.0)-[UIScreen mainScreen].bounds.size.width;
        yPoint = (index/coloum) *(height+100.0);
        [str drawAtPoint:CGPointMake(xPoint, yPoint) withAttributes:attributes];
        xPoint += -[UIScreen mainScreen].bounds.size.width;
        yPoint += -[UIScreen mainScreen].bounds.size.height;
        [str drawAtPoint:CGPointMake(xPoint, yPoint) withAttributes:attributes];
    }
    
    // Restore the context
    CGContextRestoreGState(context);
}

/**
 使用imageIO中的api生成data
 */
+ (NSData *)rawData2:(UIImage *)image imageType:(CFStringRef)imageType{
    if (!imageType) {
        imageType = kUTTypeJPEG;
    }
    NSDictionary *options = @{(__bridge NSString *)kCGImageSourceShouldCache : @NO,//不需要解码仅需要创建 CGImageSource
                              (__bridge NSString *)kCGImageSourceShouldCacheImmediately : @NO
                              };
    NSMutableData *data = [NSMutableData data];
    CGImageDestinationRef destRef = CGImageDestinationCreateWithData((__bridge CFMutableDataRef)data, imageType, 0.7/*1*/, (__bridge CFDictionaryRef)options);
    CGImageDestinationAddImage(destRef, image.CGImage, (__bridge CFDictionaryRef)options);
    CGImageDestinationFinalize(destRef);
    CFRelease(destRef);
    return data;
}


@end