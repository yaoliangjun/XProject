//
//  UIView+Yao.h
//  2.练习
//
//  Created by Jerry.Yao on 15-11-20.
//  Copyright (c) 2015年 com.ylj.dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Yao)

@property (nonatomic, assign) CGFloat   x;
@property (nonatomic, assign) CGFloat   y;
@property (nonatomic, assign) CGFloat   width;
@property (nonatomic, assign) CGFloat   height;
@property (nonatomic, assign) CGPoint   origin;
@property (nonatomic, assign) CGSize    size;
@property (nonatomic, assign) CGFloat   bottom;
@property (nonatomic, assign) CGFloat   right;
@property (nonatomic, assign) CGFloat   centerX;
@property (nonatomic, assign) CGFloat   centerY;
@property (nonatomic, strong, readonly) UIView *lastSubviewOnX;
@property (nonatomic, strong, readonly) UIView *lastSubviewOnY;

/**
 * @brief 抖动
 */
- (void) shake;

/**
 * @brief 移除此view上的所有子视图
 */
- (void)removeAllSubviews;

@end
