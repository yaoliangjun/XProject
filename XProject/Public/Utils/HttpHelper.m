//
//  HttpHelper.m
//  2.练习
//
//  Created by Jerry.Yao on 15-10-24.
//  Copyright (c) 2015年 com.ylj.dev. All rights reserved.
//

#import "HttpHelper.h"
#import "AFNetworking.h"
#import "ToastUtil.h"
#import "GlobalConstants.h"

typedef NS_ENUM(NSInteger, RequestMethod) {
    RequestMethodGet,
    RequestMethodPost,
    RequestMethodPut
};

static HttpHelper *_instance = nil;

@implementation HttpHelper

/**
 *  @author Jerry.Yao, 15-10-24
 *
 *  获取网络请求单例
 *
 */
+ (HttpHelper *)shared
{
    if (!_instance) {
        _instance = [[HttpHelper alloc] init];
    }
    
    return _instance;
}

//- (NSString *)token
//{
//    if (!_token) {
//        UserInfoModel *userInfo = [[UserInfoModel getUsingLKDBHelper] searchSingle:[UserInfoModel class] where:nil orderBy:nil];
//        if (!userInfo) return @"";
//        _token = userInfo.token;
//    }
//    return _token;
//}
//
//- (NSString *)uid
//{
//    if (!_uid) {
//        UserInfoModel *userInfo = [[UserInfoModel getUsingLKDBHelper] searchSingle:[UserInfoModel class] where:nil orderBy:nil];
//        if (!userInfo) return @"";
//        _uid = userInfo.uid;
//    }
//    return _uid;
//}

// 如果之前登录过，则再次登录
- (void)reLoginWithApi:(NSString *)api andMethod:(NSInteger)method andParams:(NSDictionary *)params success:(void(^)(NSDictionary *response))success failure:(void(^)(NSError *error))failure
{
//    NSString *userName = [kUserDefaults objectForKey:kUserName];
//    NSString *password = [kUserDefaults objectForKey:kPassword];
//    
//    if (![NSString isNilOrEmpty:userName] && ![NSString isNilOrEmpty:password]) {
//        
//        [[HttpHelper shared] postWithApi:kApiLogin andParams:@{@"userName": userName,@"password":password} showLoading:NO success:^(NSDictionary *response) {
//            if ([[response objectForKey:kStatusCode] isEqualToNumber:kSuccessCode]) {
//                UserInfoModel *userInfo = [UserInfoModel objectWithKeyValues:[response objectForKey:kResult]];
//                AppDelegate *appDelegate = kDelegate;
//                appDelegate.isLogin = YES;
//                // 更新数据库用户信息
//                [[UserInfoModel getUsingLKDBHelper] updateToDB:userInfo where:nil];
//                if (method == RequestMethodGet)
//                {
//                    [self getWithApi:api andParams:params showLoading:NO success:^(NSDictionary *response) {
//                        success(response);
//                    } failure:^(NSError *error) {
//                        failure(error);
//                    }];
//                }
//                else if (method == RequestMethodPost)
//                {
//                    [self postWithApi:api andParams:params showLoading:NO success:^(NSDictionary *response) {
//                        success(response);
//                    } failure:^(NSError *error) {
//                        failure(error);
//                    }];
//                }
//                else if (method == RequestMethodPut)
//                {
//                    [self putWithApi:api andParams:params showLoading:NO success:^(NSDictionary *response) {
//                        success(response);
//                    } failure:^(NSError *error) {
//                        failure(error);
//                    }];
//                }
//            } else {
//                NSLog(@"relogin failed = %@",[response objectForKey:kMessage]);
//            }
//        } failure:^(NSError *error) {
//            NSLog(@"relogin error = %@",error);
//        }];
//    }
}

/**
 *  @author Jerry.Yao, 15-10-24
 *
 *  GET请求
 *
 *  @param api     api url
 *  @param params  body params
 *  @param success success block
 *  @param failure failure block
 */
- (void) getWithApi:(NSString *)api andParams:(NSDictionary *)params showLoading:(BOOL)show success:(void(^)(NSDictionary *response))success failure:(void(^)(NSError *error))failure
{
    if (show) {
        [ToastUtil showLoading];
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    // 设置头信息
    manager.requestSerializer = [self prepareJSONRequestSerializer];
    NSString *url = [NSString stringWithFormat:@"%@%@",kBaseUrl,api];
    
    LJLog(@"\n[** Get请求 **] API url: %@ \n请求参数: %@ ", url,params);
    
    [manager GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (show) {
            [ToastUtil dismissLoading];
        }
        success(responseObject);
        // token过期
//        if ([[responseObject objectForKey:kStatusCode] integerValue] == 403) {
//            // 清除用户id,用户角色和token
//            //[self clearLocalInfo];
//            [self reLoginWithApi:api andMethod:RequestMethodGet andParams:params success:^(NSDictionary *response) {
//                success(response);
//            } failure:^(NSError *error) {
//                failure(error);
//            }];
////            [kNotificationCenter postNotificationName:@"checkTokenExpired" object:nil];
//        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
        LJLog(@"http request error = %@",error);
        if (show) {
            [ToastUtil dismissLoading];
        }
//        // token过期
//        if ([error.localizedDescription isEqualToString:@"Request failed: unauthorized (401)"]) {
//            // 清除用户id,用户角色和token
//            [self clearLocalInfo];
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"tokenExpire" object:nil];
//        }
    }];
}

/**
 *  @author Jerry.Yao, 15-10-24
 *
 *  POST请求
 *
 *  @param api     <#api description#>
 *  @param params  <#params description#>
 *  @param success <#success description#>
 *  @param failure <#failure description#>
 */
- (void) postWithApi:(NSString *)api andParams:(NSDictionary *)params showLoading:(BOOL)show success:(void(^)(NSDictionary *response))success failure:(void(^)(NSError *error))failure
{
    if (show) {
         [ToastUtil showLoading];
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    // Fixed error: response Code=-1016 "Request failed: unacceptable content-type: text/html"
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    // 设置头信息
    manager.requestSerializer = [self prepareJSONRequestSerializer];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",kBaseUrl,api];
    
    LJLog(@"\n[** Post请求 **] API url: %@ \n请求参数: %@ ", url,params);
    
    [manager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (show) {
            [ToastUtil dismissLoading];
        }
        success([self resolveResponse:responseObject]);
        // token过期
//        if ([[responseObject objectForKey:kStatusCode] integerValue] == 403) {
//            // 清除用户id,用户角色和token
////            [self clearLocalInfo];
////            [kNotificationCenter postNotificationName:@"checkTokenExpired" object:nil];
//            [self reLoginWithApi:api andMethod:RequestMethodGet andParams:params success:^(NSDictionary *response) {
//                success(response);
//            } failure:^(NSError *error) {
//                failure(error);
//            }];
//        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
        NSLog(@"request error = %@",error);
        if (show) {
            [ToastUtil dismissLoading];
        }
//        // token过期
//        if ([error.localizedDescription isEqualToString:@"Request failed: unauthorized (401)"]) {
//            // 清除用户id,用户角色和token
//            [self clearLocalInfo];
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"tokenExpire" object:nil];
//        }
    }];
}

/**
 *  @author Jerry.Yao, 15-10-24
 *
 *  PUT请求
 *
 *  @param api     <#api description#>
 *  @param params  <#params description#>
 *  @param success <#success description#>
 *  @param failure <#failure description#>
 */
- (void) putWithApi:(NSString *)api andParams:(NSDictionary *)params showLoading:(BOOL)show success:(void(^)(NSDictionary *response))success failure:(void(^)(NSError *error))failure
{
    if (show) {
        [ToastUtil showLoading];
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    // 设置头信息
    manager.requestSerializer = [self prepareJSONRequestSerializer];
    NSString *url = [NSString stringWithFormat:@"%@%@",kBaseUrl,api];
    LJLog(@"\n[** Put请求 **] API url: %@ \n请求参数: %@ ", url,params);
    [manager PUT:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (show) {
            [ToastUtil dismissLoading];
        }
        success(responseObject);
        // token过期
//        if ([[responseObject objectForKey:kStatusCode] integerValue] == 403) {
//            // 清除用户id,用户角色和token
////            [self clearLocalInfo];
////            [kNotificationCenter postNotificationName:@"checkTokenExpired" object:nil];
//            [self reLoginWithApi:api andMethod:RequestMethodGet andParams:params success:^(NSDictionary *response) {
//                success(response);
//            } failure:^(NSError *error) {
//                failure(error);
//            }];
//        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
        if (show) {
            [ToastUtil dismissLoading];
        }
//        // token过期
//        if ([error.localizedDescription isEqualToString:@"Request failed: unauthorized (401)"]) {
//            // 清除用户id,用户角色和token
//            [self clearLocalInfo];
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"tokenExpire" object:nil];
//        }
    }];
}

//进一步解析并打印得到的Response
- (NSDictionary *) resolveResponse: (NSDictionary *) getResponseObject
{
    NSDictionary *getDic = nil;
    if (!getResponseObject)
    {
        NSLog(@"----返回nil");
        return getDic;
    }
    NSData *data = (NSData *)getResponseObject;
    //打出得到字符串信息--------------------------
    NSString *getString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    
    if (getString == nil)
    {
        NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        getString = [[NSString alloc]initWithData:data encoding:enc];
    }
    
    NSLog(@"\nAPI返回的字典:\n%@", getString);
    
    //确定json为字典使用
    getDic = (NSDictionary *) [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error: nil];
    if (getDic)
    {
       // NSLog(@"请求成功, 得到的字典为: %@", getDic);
    }
    else
    {
        NSLog(@"----返回非字典, getsuccess");
    }
    //影藏加载圈
//    [[ObjectCTools shared] dissmissLoading];
    
    
    //超时处理//不同应用处理方式不一;-----------------------------------------
    if ([[getDic objectForKey:@"status"] isEqualToString:@"-1"] || [[getDic objectForKey:@"message"] isEqualToString:@"Invalid Error!"] || [[getDic objectForKey:@"message"] isEqualToString:@"Invalid Error!#1"])
    {
        //需先登录,同时返回时还需要在此页
//        [MainPageViewController shareMainPageVC]._needBackToThisMainPage = NO;
//        [[ObjectCTools shared].getAppDelegate signOut];
        [kNotificationCenter postNotificationName:@"tokenExpired" object:nil];
        // TODO 清除个人信息
    }
    
    return (getDic);  //将得到的字典返回
    
}

// 清除用户id,用户角色和token
- (void)clearLocalInfo
{
    // 删除用户名和密码
//    [kUserDefaults removeObjectForKey:kUserName];
//    [kUserDefaults removeObjectForKey:kPassword];
    
    // 删除保存的用户信息
//    UserInfoModel *userInfo = [[UserInfoModel getUsingLKDBHelper] searchSingle:[UserInfoModel class] where:nil orderBy:nil];
//    if (userInfo) {
//        BOOL isDeleteSuccess = [userInfo deleteToDB];
//        NSLog(@"是否删除数据库用户信息 = %@",isDeleteSuccess ? @"Yes":@"No");
//    }
}

#pragma mark ---------------- 请求头构造 -----------------
-(AFHTTPRequestSerializer *) prepareJSONRequestSerializer{
    
    //因为是 "application/x-www-form-urlencoded" 方式，所以不能用json方式初始化 !!!切记，json方式时才能用AFJSONRequestSerializer
    //AFJSONRequestSerializer *requestSerializer = [[AFJSONRequestSerializer alloc] init];
    AFHTTPRequestSerializer *requestSerializer = [[AFHTTPRequestSerializer alloc] init];
    requestSerializer.timeoutInterval = 30;
    
//    AFJSONResponseSerializer *responseSerializer = [[AFJSONResponseSerializer alloc] init];
//    responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
//    [responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    
//    [responseSerializer setValue:@"text/html" forKey:@"Content-Type"];
// #warning 不同应用需要针对性修改key
    
    //    [requestSerializer setValue:@"rfs.hns-china.com" forHTTPHeaderField:@"Host"];
    
    //    //如果没有token，先取本地token进行配置---

    //配置后再进行head设置
//    [requestSerializer setValue:[kUserDefaults objectForKey:kToken] forHTTPHeaderField:@"token"];
//    [requestSerializer setValue:[kUserDefaults objectForKey:kUserId]  forHTTPHeaderField:@"id"];
    //        [requestSerializer setValue:@"property" forHTTPHeaderField:@"appType"];
    
#warning 不同应用需要针对性修改key end
    
    //"application/x-www-form-urlencoded" 使用AFHTTPRequestSerializer 默认亦可
    [requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"enctype"];
    
//    NSArray *languages = [NSLocale preferredLanguages];
//    NSString *currentLanguage = [languages objectAtIndex:0];
//    //NSLog ( @"%@" , currentLanguage);
//    if([currentLanguage isEqualToString:@"zh-Hant-HK"])
//    {
//        NSLog(@"current Language:zh-Hant-HK");
//        [requestSerializer setValue:@"zh-hk" forHTTPHeaderField:@"lang"];
//    }else
//    {
//        [requestSerializer setValue:@"en-us" forHTTPHeaderField:@"lang"];
//    }
    
    
    //NSLog(@"请求头为：\n%@", requestSerializer.HTTPRequestHeaders);
    return requestSerializer;
}

@end
