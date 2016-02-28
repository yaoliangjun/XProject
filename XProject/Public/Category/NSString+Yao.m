//
//  NSString+Yao.m
//  2.练习
//
//  Created by Jerry.Yao on 15-11-9.
//  Copyright (c) 2015年 com.ylj.dev. All rights reserved.
//

#import "NSString+Yao.h"

@implementation NSString (Yao)

/**
 *  判断字符串是否为Nil或者空
 *
 *  @param str 需要校验的字符串
 *
 *  @return  YES:为nil或者空，NO:有内容
 */
+ (BOOL )isNilOrEmpty: (NSString *) str
{
    if (str && ![str isEqualToString:@""])
    {
        return NO;
    }
    
    return YES;
}

+ (NSString *)htmlStrDecode: (NSString *) str
{
    NSString *string = [str stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    string = [string stringByReplacingOccurrencesOfString:@"&apos;" withString:@"'"];
    string = [string stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    string = [string stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    string = [string stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    return string;
}

@end
