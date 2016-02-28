//
//  UIImage+Yao.m
//  2.练习
//
//  Created by Jerry.Yao on 15-11-11.
//  Copyright (c) 2015年 com.ylj.dev. All rights reserved.
//

#import "UIImage+Yao.h"

@implementation UIImage (Yao)

+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContextWithOptions(rect.size, false, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size andCornerRadius:(CGFloat)cornerRadius {
    
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (cornerRadius > 0) {
        UIBezierPath* roundedRectanglePath = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius: cornerRadius];
        [color setFill];
        [roundedRectanglePath fill];
    } else {
        CGContextSetFillColorWithColor(context, [color CGColor]);
        CGContextFillRect(context, rect);
        
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

/**
 @brief 根据图片名对图片进行偏移
 @param name 图片名.如：back_button#0_18_0_1#.png，将按0,18,0,1四个方向对这张图片进行偏移
 @result UIImage 按指定偏移修改后的图片
 */
+ (UIImage *)imageScaleNamed:(NSString *)name
{
    UIImage *img = [UIImage imageNamed:name];
    NSArray *arr1 = [name componentsSeparatedByString:@"#"];
    if (arr1 && [arr1 count]== 3) {
        NSString *tmpStr = [arr1 objectAtIndex:1];
        NSArray *arr2 = [tmpStr componentsSeparatedByString:@"_"];
        if ([arr2 count]== 4) {
            {
                UIEdgeInsets edgeInsets = UIEdgeInsetsMake([[arr2 objectAtIndex:0] doubleValue], [[arr2 objectAtIndex:1] doubleValue], [[arr2 objectAtIndex:2] doubleValue], [[arr2 objectAtIndex:3] doubleValue]);
                img = [img resizableImageWithCapInsets:edgeInsets];
            }
        }
    }
    return img;
}

/**
 @brief 等比率缩放
 @param scaleSize 缩放比例(float),0~1为缩小，1以上为放大
 @result UIImage 按指定比率缩放修改后的图片
 */
- (UIImage *)scaleImageToScale:(float)scaleSize
{
    CGRect rect = CGRectZero;
    rect.size = CGSizeMake(self.size.width * scaleSize, self.size.height * scaleSize);
    rect = CGRectIntegral(rect);
    UIGraphicsBeginImageContext(rect.size);
    [self drawInRect:rect];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

/**
 @brief 自定图片长宽
 @param reSize 自定图片长宽的CGSize
 @result UIImage 按指定长宽修改后的图片
 */
- (UIImage *)reSizeImageToSize:(CGSize)reSize
{
    UIGraphicsBeginImageContext(CGSizeMake(reSize.width, reSize.height));
    [self drawInRect:CGRectMake(0, 0, reSize.width, reSize.height)];
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return reSizeImage;
}

- (UIImage *)scaleImageWithWidth:(CGFloat)width{
    if (self.size.width <width || width <= 0) {
        return self;
    }
    CGFloat scale = self.size.width/width;
    CGFloat height = self.size.height/scale;
    
    CGRect rect = CGRectMake(0, 0, width, height);
    
    // 开始上下文 目标大小是 这么大
    UIGraphicsBeginImageContext(rect.size);
    
    // 在指定区域内绘制图像
    [self drawInRect:rect];
    
    // 从上下文中获得绘制结果
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 关闭上下文返回结果
    UIGraphicsEndImageContext();
    return resultImage;
}

@end
