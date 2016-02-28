//
//  UIImage+Yao.h
//  2.练习
//
//  Created by Jerry.Yao on 15-11-11.
//  Copyright (c) 2015年 com.ylj.dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Yao)

+ (UIImage *)imageWithColor:(UIColor *)color;
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size andCornerRadius:(CGFloat)cornerRadius;

/**
 @brief 根据图片名对图片进行偏移
 @param name 图片名.如：back_button#0_18_0_1#.png，将按0,18,0,1四个方向对这张图片进行偏移
 @result UIImage 按指定偏移修改后的图片
 */
+ (UIImage *)imageScaleNamed:(NSString *)name;

/**
 @brief 等比率缩放
 @param scaleSize 缩放比例(float),0~1为缩小，1以上为放大
 @result UIImage 按指定比率缩放修改后的图片
 */
- (UIImage *)scaleImageToScale:(float)scaleSize;

/**
 @brief 自定图片长宽
 @param reSize 自定图片长宽的CGSize
 @result UIImage 按指定长宽修改后的图片
 */
- (UIImage *)reSizeImageToSize:(CGSize)reSize;

- (UIImage *)scaleImageWithWidth:(CGFloat)width;

@end
