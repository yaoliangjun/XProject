//
//  AppDelegate.m
//  XProject
//
//  Created by Jerry.Yao on 16/2/13.
//  Copyright © 2016年 Jerry.Yao. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "BaseNavigationController.h"
#import "TabBarController.h"

#import "DDLog.h"
#import "DDTTYLogger.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [NSThread sleepForTimeInterval:1];
    
    // 日志
    //[DDLog addLogger:[DDTTYLogger sharedInstance]];
    
    // 沙盒路径
    //NSString *sandBoxPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    //LJLog(@"sandBoxPath = %@", sandBoxPath);
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self setupRootViewController];
    [self.window makeKeyAndVisible];

    [self setupBaiduMap];
    [self setupKeyboardManager];
    
    // 通知设置
    UIUserNotificationType types = UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
    [application registerUserNotificationSettings:settings];
    
    
    return YES;
}

- (void)setupBaiduMap
{
    BMKMapManager *mapManager = [[BMKMapManager alloc] init];
    [mapManager start:@"884v7BBC6tGg97BeihGDSfZN" generalDelegate:nil];
}

- (void)setupKeyboardManager
{
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enableAutoToolbar = YES;
    manager.shouldResignOnTouchOutside = YES;
}

- (void)setupRootViewController
{
    self.window.rootViewController = [[BaseNavigationController alloc] initWithRootViewController:[[MainViewController alloc] init]];
}

// 进入主页
- (void)enterMainPage
{
    self.window.rootViewController = nil;
    self.window.rootViewController = [[TabBarController alloc] init];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
