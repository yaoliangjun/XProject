//
//  UIButton+Yao.h
//  2.练习
//
//  Created by Jerry.Yao on 15-10-17.
//  Copyright (c) 2015年 com.ylj.dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Yao)
/**
 *  生成一个普通的btn
 *
 *  @param frame                      <#frame description#>
 *  @param title                      <#title description#>
 *  @param titleColor                 <#titleColor description#>
 *  @param titleHighlightedColor      <#titleHighlightedColor description#>
 *  @param font                       <#font description#>
 *  @param image                      <#image description#>
 *  @param selectedImage              <#selectedImage description#>
 *  @param backgroundColor            <#backgroundColor description#>
 *  @param backgroundImage            <#backgroundImage description#>
 *  @param backgroundHighlightedImage <#backgroundHighlightedImage description#>
 *  @param borderWidth                <#borderWidth description#>
 *  @param borderColor                <#borderColor description#>
 *  @param cornerRadius               <#cornerRadius description#>
 *  @param target                     <#target description#>
 *  @param selector                   <#selector description#>
 *
 *  @return <#return value description#>
 */
+ (UIButton *)buttonWithFrame:(CGRect)frame andTitle:(NSString *)title andTitleColor:(UIColor *)titleColor andTitleHighlightedColor:(UIColor *)titleHighlightedColor andFont:(UIFont *)font andImage:(UIImage *)image andSelectedImage:(UIImage *)selectedImage andBackgroundColor:(UIColor *)backgroundColor andBackgroundImage:(UIImage *)backgroundImage andBackgroundHighlightedImage:(UIImage *)backgroundHighlightedImage andBorderWidth:(int)borderWidth andBorderColor:(UIColor *)borderColor andCornerRadius:(float)cornerRadius andTarget:(id)target andSelector:(SEL)selector;

/**
 *  生成一个带下划线的btn
 *
 *  @param frame                 <#frame description#>
 *  @param title                 <#title description#>
 *  @param titleColor            <#titleColor description#>
 *  @param titleHighlightedColor <#titleHighlightedColor description#>
 *  @param font                  <#font description#>
 *  @param target                <#target description#>
 *  @param selector              <#selector description#>
 *
 *  @return <#return value description#>
 */
+ (UIButton *)buttonWithFrame:(CGRect)frame andTitle:(NSString *)title andTitleColor:(UIColor *)titleColor andTitleHighlightedColor:(UIColor *)titleHighlightedColor andFont:(UIFont *)font andTarget:(id)target andSelector:(SEL)selector;
@end
