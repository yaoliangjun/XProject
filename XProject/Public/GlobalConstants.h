//
//  GlobalConstants.h
//  全局公用常量类
//
//  Created by Jerry.Yao
//  Copyright (c) 2015年 Jerry.Yao All rights reserved.
//

#ifndef _____GlobalConstants_h
#define _____GlobalConstants_h

#define CORYRIGHT   @"Copyright (c) 2015 Missionsky. All rights reserved."

//获得iOS版本
#define kIOSVersions [[[UIDevice currentDevice] systemVersion] floatValue]
//设置x方向屏幕居中
#define kViewInCenter(view) view.center = CGPointMake(kScreenWidth / 2.0, view.center.y)
//默认图片占位
#define kDefaultPlaceholderImage      @"DefaultPlaceholderImage"

// custom constants
#define kScreenWidth  [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenBounds ([[UIScreen mainScreen] bounds])
#define kUIWindow     [[[UIApplication sharedApplication] delegate] window] //获得window
#define kDelegate (AppDelegate *)[UIApplication sharedApplication].delegate

// color
#pragma mark ---------------- 颜色 start ------------------------------------------------------------

//导航栏背景颜色值
#define kNavigationBarColor kHexRGB(0x22aee6)
//自定义导航条颜色
#define kCustomNavBarColor kHexRGB(0x178bb8)
//导航栏字体颜色值：#FFFFFF;
#define kNavigationBarTitleColor kHexRGB(0xFFFFFF)

#define kRGB(r, g, b) [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.0]

#define kRGBAlpha(r, g, b, a) [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:(a)]

#define kHexRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define kHexRGBAlpha(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(a)]

#define MAIN_BK_COLOR   [UIColor colorWithRed:0.937255 \
green:0.937255 \
blue:0.956863 \
alpha:1.0]

//公共顔色值
#define kWhiteColor kHexRGB(0xFFFFFF)
#define kGreenColor kHexRGB(0xA7C718)
#define kGrayColor [UIColor grayColor]
#define kLightGrayColor [UIColor lightGrayColor]
#define kLightColor kRGB(229, 229, 229)
#define kBlackColor [UIColor blackColor]
#define kRedColor [UIColor redColor]
#define kClearColor [UIColor clearColor]
#define kOrangeColor [UIColor orangeColor]
#define kGapColor kHexRGB(0xF2F8FA) // 灰色空隙的颜色

// app相关颜色值
#define kOrangeWithCXColor kHexRGB(0xff7b32)  // 橙色
#define kOrangeWithCXPressColor kHexRGB(0xff9b00)  // 按下的橙色
#define kBlackDuckColor kHexRGB(0x34495e)
#define kLineColor kHexRGB(0xdbdbdb)
#define kLoginBgColor kHexRGB(0xfafafa)


//holdPlacer字体颜色
#define kHoldPlacerColor kRGB(166.0, 166.0, 166.0)

#define kBlueColor     [UIColor colorWithRed:19.0/255 green:127.0/255 blue:222.0/255 alpha:1.0f]
#define kDarkBlueColor [UIColor colorWithRed:13.0/255 green:76.0/255 blue:130.0/255 alpha:1.0f]
#define kMenuBgColor   [UIColor colorWithRed:23.0/255 green:40.0/255 blue:44.0/255 alpha:1.0f]

#pragma mark ---------------- 颜色 end ---------------------------------------------------------

// 定义字体方式
#define kFont(kSize)     [UIFont systemFontOfSize:kSize]
#define kBoldFont(kSize) [UIFont boldSystemFontOfSize:kSize]
#define kHelveticaRegularFont(kSize) [UIFont fontWithName:@"Helvetica" size:kSize]          // 正常笔画
#define kHelveticaBoldFont(kSize)    [UIFont fontWithName:@"Helvetica Bold" size:kSize]     // 加粗
#define kHelveticaLightFont(kSize)   [UIFont fontWithName:@"Helvetica Light" size:kSize]    // 特细笔画

#define kUserDefaults [NSUserDefaults standardUserDefaults]
#define kNotificationCenter [NSNotificationCenter defaultCenter]

#pragma mark ---------------- AppConstants ----------------------------------------------------

// App相关常量
#import "AppConstants.h"
#import "XmppManager.h"

// App代理
#import "AppDelegate.h"

#endif
