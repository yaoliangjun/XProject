//
//  EViewController.m
//  XProject
//
//  Created by Jerry.Yao on 16/2/14.
//  Copyright © 2016年 Jerry.Yao. All rights reserved.
//

#import "EViewController.h"
BOOL isShow;
@interface EViewController ()
{
    UIButton *_btnMenu;
}
@end

@implementation EViewController

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
    self.title = @"E";
    [self setupBtn];
}


- (void)setupBtn
{
    UIButton *btnMenu = [UIButton buttonWithFrame:CGRectMake(10, 20, kScreenWidth - 20, 44) andTitle:@"显示菊花" andTitleColor:kWhiteColor andTitleHighlightedColor:kGrayColor andFont:kFont(16) andImage:nil andSelectedImage:nil andBackgroundColor:kOrangeColor andBackgroundImage:[UIImage imageWithColor:kOrangeColor] andBackgroundHighlightedImage:[UIImage imageWithColor:kOrangeWithCXPressColor] andBorderWidth:0 andBorderColor:nil andCornerRadius:5 andTarget:self andSelector:@selector(btnPressHandle)];
    _btnMenu = btnMenu;
    [self.view addSubview:btnMenu];
    
}

- (void)btnPressHandle
{
    isShow = !isShow;
    if (isShow) {
        [_btnMenu setTitle:@"隐藏菊花" forState:UIControlStateNormal];
    } else {
        [_btnMenu setTitle:@"显示菊花" forState:UIControlStateNormal];
    }
    [[UIUtils shared] showActivityIndicatorLoading:isShow inView:self.view];
}
@end
