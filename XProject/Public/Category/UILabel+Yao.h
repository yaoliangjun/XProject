//
//  UILabel+Yao.h
//  2.练习
//
//  Created by Jerry.Yao on 15-10-17.
//  Copyright (c) 2015年 com.ylj.dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Yao)
/**
 *  @author Jerry.Yao, 15-10-17
 *
 *  创建一个通用的UILabel
 *
 *  @param frame     frame
 *  @param text      文本
 *  @param textColor 文本颜色
 *  @param font      字体
 *
 *  @return UILabel
 */
+ (UILabel *)labelWithFrame:(CGRect)frame andText:(NSString *)text andTextColor:(UIColor *) textColor andFont:(UIFont *)font;

@end
