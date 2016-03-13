//
//  GViewController.m
//  XProject
//
//  Created by Jerry.Yao on 16/3/12.
//  Copyright © 2016年 Jerry.Yao. All rights reserved.
//

#import "GViewController.h"

@interface GViewController ()

@end

@implementation GViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
}

- (void)setupView {
    self.view.backgroundColor = kWhiteColor;
    self.title = @"环信";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

@end
