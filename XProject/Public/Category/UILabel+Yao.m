//
//  UILabel+Yao.m
//  2.练习
//
//  Created by Jerry.Yao on 15-10-17.
//  Copyright (c) 2015年 com.ylj.dev. All rights reserved.
//

#import "UILabel+Yao.h"

@implementation UILabel (Yao)
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
+ (UILabel *)labelWithFrame:(CGRect)frame andText:(NSString *)text andTextColor:(UIColor *) textColor andFont:(UIFont *)font
{
    UILabel *label = [[self alloc] init];
    label.frame = frame;
    label.text = text;
    label.textColor = textColor;
    label.font = font;
    
    return label;
}

@end
