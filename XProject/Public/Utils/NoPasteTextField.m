//
//  NoPasteTextField.m
//  Guru
//
//  Created by jerry.yao on 15/11/30.
//  Copyright (c) 2015年 com.ylj.dev. All rights reserved.
//

#import "NoPasteTextField.h"


@implementation NoPasteTextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    if (menuController) {
        [UIMenuController sharedMenuController].menuVisible = NO;
    }
    return NO;
}

@end