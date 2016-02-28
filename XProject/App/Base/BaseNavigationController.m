//
//  BaseNavigationController.m
//  XProject
//
//  Created by Jerry.Yao on 16/2/13.
//  Copyright © 2016年 Jerry.Yao. All rights reserved.
//

#import "BaseNavigationController.h"

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationBarStyle];
}

- (void)setupNavigationBarStyle {
    UINavigationBar *navBar = [UINavigationBar appearance];
    // 设置导航栏背景颜色
    [navBar setBackgroundImage:[UIImage imageWithColor:kBlueColor] forBarMetrics:UIBarMetricsDefault];
    // 设置返回按钮文字颜色
    [navBar setTintColor:kWhiteColor];
    // 设置导航栏title字体大小和颜色
    [navBar setTitleTextAttributes:@{NSForegroundColorAttributeName : kWhiteColor, NSFontAttributeName : kFont(20)}];
    // 隐藏返回按钮的文字
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
}



@end
