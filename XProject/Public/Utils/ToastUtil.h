//
//  ToastUtil.h
//  2.练习
//
//  Created by Jerry.Yao on 15-10-24.
//  Copyright (c) 2015年 com.ylj.dev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ToastUtil : NSObject

+ (void) showMessage:(NSString *)message;

+ (void)showLoading;

+ (void)dismissLoading;

@end
