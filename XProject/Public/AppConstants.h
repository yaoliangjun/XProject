//
//  AppConstants.h
//  App公用常量类
//
//  Created by Jerry.Yao
//  Copyright (c) 2015年 Jerry.Yao All rights reserved.
//

#ifndef _____AppConstants_h
#define _____AppConstants_h

// API Url
#import "ApiUrl.h"

// Http 请求工具
#import "HttpHelper.h"

// Utils
#import "UIUtils.h"
#import "ToastUtil.h"
#import "DateUtils.h"


// import category
#import "UITextField+Yao.h"
#import "UILabel+Yao.h"
#import "UIButton+Yao.h"
#import "UIToolbar+Yao.h"
#import "UIImage+Yao.h"
#import "NSString+Yao.h"
#import "UIView+Yao.h"


// import pods
#import "SDImageCache.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "MJExtension.h"
#import "MBProgressHUD.h"
#import "SVProgressHUD.h"
#import "IQKeyboardManager.h"
#import "LKDBHelper.h"
#import "Masonry.h"


// 不可复制的TextField
#import "NoPasteTextField.h"
#import "PlaceHolderTextView.h"

#define kStatusCode @"code"
#define kSuccessCode @200

#define kToken   @"token"
#define kUserId  @"userId"
#define kUid  @"uid"
#define kResult  @"result"
#define kData    @"data"
#define kMessage @"message"

#define kUserName @"userName"
#define kPassword @"password"

#define kPlaceHolderImage @"user-nologin"

// app相关字符串
#define kCommuneId @"communeId"
#define kPage @"page"
#define kStatus @"status"
#define kModile @"mobile"
#define kVerifyCode @"verifyCode"

// Xmpp IP和端口
#define kXmppHostName @"192.168.1.104"
#define kXmppDomain   @"demo.xmpp"
#define kXmppHostPort 5222

// BaiduMap
#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件

#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件

#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件

#import <BaiduMapAPI_Cloud/BMKCloudSearchComponent.h>//引入云检索功能所有的头文件

#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件

#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>//引入计算工具所有的头文件

#import <BaiduMapAPI_Radar/BMKRadarComponent.h>//引入周边雷达功能所有的头文件

#import <BaiduMapAPI_Map/BMKMapView.h>//只引入所需的单个头文件

#endif
