//
//  DateUtils.h
//  Guru
//
//  Created by Jerry.Yao on 15-12-6.
//  Copyright (c) 2015年 com.ylj.dev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateUtils : NSObject

+ (NSString *)convertMillisecondToTime:(long)second;

+ (NSString *)convertMillisecondToDate:(long)second andFormatter:(NSString *)formatter;

@end
