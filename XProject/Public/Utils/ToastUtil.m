//
//  ToastUtil.m
//  2.练习
//
//  Created by Jerry.Yao on 15-10-24.
//  Copyright (c) 2015年 com.ylj.dev. All rights reserved.
//

#import "MBProgressHUD.h"
#import "GlobalConstants.h"

@implementation ToastUtil : NSObject 

+ (void) showMessage:(NSString *)message
{
    dispatch_async(dispatch_get_main_queue() , ^{
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:kUIWindow animated:YES];
        hud.detailsLabelText = message;
        hud.detailsLabelFont = kFont(16);
        hud.mode = MBProgressHUDModeText;
        [hud hide:YES afterDelay:1.5];
        hud.removeFromSuperViewOnHide = YES;
        [hud setUserInteractionEnabled:YES];
    });
}

// 加载
+ (void)showLoading;
{
    [MBProgressHUD showHUDAddedTo:kUIWindow animated:YES];
}

//隐藏
+ (void)dismissLoading
{
    [MBProgressHUD hideHUDForView:kUIWindow animated:YES];
}
@end
