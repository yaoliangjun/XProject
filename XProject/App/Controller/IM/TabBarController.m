//
//  MainViewController.m
//  XmppDemo
//
//  Created by Jerry.Yao on 16/2/25.
//  Copyright © 2016年 Jerry.Yao. All rights reserved.
//

#import "TabBarController.h"
#import "HomeViewController.h"
#import "ContactViewController.h"
#import "DiscoverViewController.h"
#import "MeViewController.h"
#import "BaseNavigationController.h"

@interface TabBarController ()

@end

@implementation TabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViewControllers];
}

- (void)setupViewControllers {
    HomeViewController *home = [[HomeViewController alloc] init];
    [self addChildViewController:home andTitle:@"微信" andImage:@"tabbar_mainframe" andSelectedImage:@"tabbar_mainframeHL"];
    
    ContactViewController *contact = [[ContactViewController alloc] init];
    [self addChildViewController:contact andTitle:@"联系人" andImage:@"tabbar_contacts" andSelectedImage:@"tabbar_contactsHL"];
    
    DiscoverViewController *discover = [[DiscoverViewController alloc] init];
    [self addChildViewController:discover andTitle:@"发现" andImage:@"tabbar_discover" andSelectedImage:@"tabbar_discoverHL"];
    
    MeViewController *me = [[MeViewController alloc] init];
    [self addChildViewController:me andTitle:@"我" andImage:@"tabbar_me" andSelectedImage:@"tabbar_meHL"];
    
}

- (void)addChildViewController:(UIViewController *)vc andTitle:(NSString *)title andImage:(NSString *)image andSelectedImage:(NSString *)selectedImage
{
    BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:vc];
    vc.tabBarItem.image = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    vc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    vc.title = title;
    [self.tabBar setTintColor:[UIColor greenColor]];
    [self addChildViewController:nav];
}

@end
