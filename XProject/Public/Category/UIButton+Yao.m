//
//  UIButton+Yao.m
//  2.练习
//
//  Created by Jerry.Yao on 15-10-17.
//  Copyright (c) 2015年 com.ylj.dev. All rights reserved.
//

#import "UIButton+Yao.h"

@implementation UIButton (Yao)

+ (UIButton *)buttonWithFrame:(CGRect)frame andTitle:(NSString *)title andTitleColor:(UIColor *)titleColor andTitleHighlightedColor:(UIColor *)titleHighlightedColor andFont:(UIFont *)font andImage:(UIImage *)image andSelectedImage:(UIImage *)selectedImage andBackgroundColor:(UIColor *)backgroundColor andBackgroundImage:(UIImage *)backgroundImage andBackgroundHighlightedImage:(UIImage *)backgroundHighlightedImage andBorderWidth:(int)borderWidth andBorderColor:(UIColor *)borderColor andCornerRadius:(float)cornerRadius andTarget:(id)target andSelector:(SEL)selector
{
    UIButton *btn = [[self alloc] initWithFrame:frame];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.font = font;
    
    if (titleColor != nil) {
        [btn setTitleColor:titleColor forState:UIControlStateNormal];
    }
    if (titleHighlightedColor != nil) {
        [btn setTitleColor:titleHighlightedColor forState:UIControlStateHighlighted];
    }
    
    if (image != nil) {
        [btn setImage:image forState:UIControlStateNormal];
    }
    
    if (selectedImage != nil) {
        [btn setImage:selectedImage forState:UIControlStateHighlighted];
    }
    
    if (backgroundColor != nil) {
        [btn setBackgroundColor:backgroundColor];
    }
    
    if (backgroundImage != nil) {
        [btn setBackgroundImage:backgroundImage forState:UIControlStateNormal];
    }
    
    if (backgroundHighlightedImage != nil) {
        [btn setBackgroundImage:backgroundHighlightedImage forState:UIControlStateHighlighted];
    }
    if (borderColor != nil) {
        btn.layer.borderColor = borderColor.CGColor;
    }
    
    btn.layer.borderWidth = borderWidth;
    btn.layer.cornerRadius = cornerRadius;
    [btn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    btn.clipsToBounds = YES;
    return btn;
}

+ (UIButton *)buttonWithFrame:(CGRect)frame andTitle:(NSString *)title andTitleColor:(UIColor *)titleColor andTitleHighlightedColor:(UIColor *)titleHighlightedColor andFont:(UIFont *)font andTarget:(id)target andSelector:(SEL)selector
{
    UIButton *btn = [[self alloc] initWithFrame:frame];
    btn.titleLabel.font = font;

    [btn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    // 内容横向对齐
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    // 正常状态
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:title];
    NSRange strRange = NSMakeRange(0, [attrStr length]);
    [attrStr setAttributes:@{NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle], NSForegroundColorAttributeName: titleColor} range:strRange];
    [btn setAttributedTitle:attrStr forState:UIControlStateNormal];
    // 高亮状态
    NSMutableAttributedString *attrStrPress = [[NSMutableAttributedString alloc] initWithString:title];
    NSRange strRangePress = NSMakeRange(0, [attrStrPress length]);
    [attrStrPress setAttributes:@{NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle], NSForegroundColorAttributeName: titleHighlightedColor} range:strRangePress];
    [btn setAttributedTitle:attrStrPress forState:UIControlStateHighlighted];
    
    return btn;
}

@end
