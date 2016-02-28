//
//  UIToolbar+Yao.m
//  2.练习
//
//  Created by Jerry.Yao on 15-11-3.
//  Copyright (c) 2015年 com.ylj.dev. All rights reserved.
//

#import "UIToolbar+Yao.h"

@implementation UIToolbar (Yao)

+ (UIToolbar *)toolBarWithFrame:(CGRect)frame andTarget:(id)target andSelector:(SEL)selector
{
    // toolbar
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:frame];
    UIButton *done = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 44 - 15, 0, 44, 44)];
    [done setTitle:@"Done" forState:UIControlStateNormal];
    [done setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [done setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [done addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    [toolBar addSubview:done];

    return toolBar;
}
@end
