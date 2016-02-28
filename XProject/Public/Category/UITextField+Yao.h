//
//  UITextField+Yao.h
//  2.练习
//
//  Created by Jerry.Yao on 15-10-17.
//  Copyright (c) 2015年 com.ylj.dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (Yao)
/**
 *  @author Jerry.Yao, 15-10-17
 *
 *  创建一个通用的TextField
 *
 *  @param frame        frame
 *  @param borderColor  边框颜色
 *  @param borderWidth  边框宽度
 *  @param cornerRadius 圆角
 *
 *  @return TextField
 */
+ (UITextField *)textFieldWithFrame:(CGRect)frame andBorderColor:(UIColor *)borderColor andBorderWidth:(int)borderWidth andCornerRadius:(float)cornerRadius andPlaceHolder:(NSString *)placeHolder andPlaceHolderColor:(UIColor *)placeHolderColor andLeftView:(UIView *)leftView andLeftViewMode:(UITextFieldViewMode )leftViewMode andClearBtnModel:(UITextFieldViewMode)clearBtnMode andFont:(UIFont *)font;

/**
 *  校验是否为手机号
 *
 *  @return <#return value description#>
 */
- (BOOL)isPhoneNumber;
@end
