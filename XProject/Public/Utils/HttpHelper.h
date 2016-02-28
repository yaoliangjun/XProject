//
//  HttpHelper.h
//  2.练习
//
//  Created by Jerry.Yao on 15-10-24.
//  Copyright (c) 2015年 com.ylj.dev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpHelper : NSObject
+ (HttpHelper *)shared;
- (void) getWithApi:(NSString *)api andParams:(NSDictionary *)params showLoading:(BOOL)show success:(void(^)(NSDictionary *response))success failure:(void(^)(NSError *error))failure;

- (void) postWithApi:(NSString *)api andParams:(NSDictionary *)params showLoading:(BOOL)show success:(void(^)(NSDictionary *response))success failure:(void(^)(NSError *error))failure;

- (void) putWithApi:(NSString *)api andParams:(NSDictionary *)params showLoading:(BOOL)show success:(void(^)(NSDictionary *response))success failure:(void(^)(NSError *error))failure;

@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *uid;

@end
