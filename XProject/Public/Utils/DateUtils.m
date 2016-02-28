//
//  DateUtils.m
//  Guru
//
//  Created by Jerry.Yao on 15-12-6.
//  Copyright (c) 2015年 com.ylj.dev. All rights reserved.
//

#import "DateUtils.h"

@implementation DateUtils

/**
 * 由秒得到转换之后的时间（..分钟/..小时/..天）
 *
 * @param seconds
 * @return
 */
+ (NSString *)convertMillisecondToTime:(long)second
{
    NSTimeInterval timeInterval =[[NSDate date] timeIntervalSince1970];
    long time = timeInterval;      //NSTimeInterval返回的是double类型
    //NSLog(@"1970timeInterval == %ld",time);
    
    long createTime = time - second;
    if (createTime <= 0) {
        return @"刚刚";
    } else {
        long minutes = createTime / 60 + 1;
        if (minutes < 60) {
            return [NSString stringWithFormat:@"%ld分钟前",minutes];//minutes + "分钟前";
        } else {
            long hours = minutes / 60;
            if (hours < 24) {
                return [NSString stringWithFormat:@"%ld小时前",hours];//hours + "小时前";
            } else {
                long days = hours / 24;
                if (days < 30) {
                    return [NSString stringWithFormat:@"%ld天前",days];//days + "天前";
                } else {
                    long month = days / 30;
                    if (month < 12) {
                        return [NSString stringWithFormat:@"%ld月前",month];//month + "月前";
                    } else {
                        long year = month / 12;
                        return [NSString stringWithFormat:@"%ld年前",year];//year + "年前";
                    }
                }
            }
        }
    }
}
/**
 *  @author Jerry.Yao, 15-12-06
 *
 *  由秒得到转换之后的时间
 *
 *  @param second
 *  @param formatter 指定的时间格式:e.g. @"MM-dd HH:mm"
 *
 *  @return
 */
+ (NSString *)convertMillisecondToDate:(long)second andFormatter:(NSString *)formatter
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:second];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:formatter];
    NSString *dateString = [dateFormat stringFromDate:date];
    NSLog(@"convertMillisecondToDate == %@", dateString);
    return dateString;
}
@end
