//
//  DViewController.m
//  XProject
//
//  Created by Jerry.Yao on 16/2/14.
//  Copyright © 2016年 Jerry.Yao. All rights reserved.
//

#import "DViewController.h"

@interface DViewController ()

@end

@implementation DViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
}

- (void)setupView {
    self.view.backgroundColor = kWhiteColor;
    self.title = @"D";
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"demo_avatar_cook"]];
    imageView.frame = CGRectMake(10, 64, 100, 100);
    [self.view addSubview:imageView];
}

@end
