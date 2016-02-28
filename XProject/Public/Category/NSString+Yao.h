//
//  NSString+Yao.h
//  2.练习
//
//  Created by Jerry.Yao on 15-11-9.
//  Copyright (c) 2015年 com.ylj.dev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Yao)
+ (BOOL)isNilOrEmpty: (NSString *) str;

+ (NSString *)htmlStrDecode: (NSString *) str;
@end
