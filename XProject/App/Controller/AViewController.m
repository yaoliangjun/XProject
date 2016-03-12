//
//  AViewController.m
//  XProject
//
//  Created by Jerry.Yao on 16/2/14.
//  Copyright © 2016年 Jerry.Yao. All rights reserved.
//

#import "AViewController.h"
#import "SKDropDown.h"
#import "MainViewModel.h"

@interface AViewController () <SKDropDownDelegate, UIGestureRecognizerDelegate>
{
    UIView *_btn;
    UIButton *_btnMenu;
}

@property (nonatomic, strong) NSArray *tipArray;
@property (nonatomic, strong) SKDropDown *drapDownMenu;
@end

@implementation AViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = @"A";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //[self setupView];
    [self setupDrawDownMenu];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;

}

/**
 *  重写touchesEnded方法
 */
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if ([touches anyObject].view != _btnMenu) {
        // 判断点击的区域如果不是菜单按钮_btnMenu, 则关闭菜单
        [self closeDropDownMenu];
    }
}

#pragma mark - 下拉菜单
- (void)setupDrawDownMenu
{
    UIButton *btnMenu = [UIButton buttonWithFrame:CGRectMake(10, 20, kScreenWidth - 20, 44) andTitle:@"打开菜单" andTitleColor:kWhiteColor andTitleHighlightedColor:kGrayColor andFont:kFont(16) andImage:nil andSelectedImage:nil andBackgroundColor:kOrangeColor andBackgroundImage:[UIImage imageWithColor:kOrangeColor] andBackgroundHighlightedImage:[UIImage imageWithColor:kOrangeWithCXPressColor] andBorderWidth:0 andBorderColor:nil andCornerRadius:5 andTarget:self andSelector:@selector(btnMenuClick)];
    _btnMenu = btnMenu;
    [self.view addSubview:btnMenu];
}

- (void)btnMenuClick
{
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:3];
    notification.alertTitle = @"Jerry";
    notification.alertBody  = @"你吃饭了吗？";
    
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    
    
    // TODO
//    CGFloat kItemHeight = 44;
//    
//    if (!_drapDownMenu) {
////        _drapDownMenu = [[SKDropDown alloc] showDropDown:_btnMenu inView:self.view withItemHeight:kItemHeight withData:self.tipArray animationDirection:DropDownAnimationDirectionDown];
//        
//        _drapDownMenu = [[SKDropDown alloc] showDropDown:_btnMenu withItemHeight:kItemHeight withData:self.tipArray animationDirection:DropDownAnimationDirectionDown];
//        _drapDownMenu.delegate = self;
//        
//    } else {
//        [_drapDownMenu setDropDownItems:_tipArray];
//        [_drapDownMenu.tableView reloadData];
//    }

}

- (void)closeDropDownMenu
{
    if (_drapDownMenu) {
        [_drapDownMenu hideDropDown:_btnMenu];
        _drapDownMenu = nil;
    }
}


#pragma mark - 下拉菜单代理方法
- (void)skDropDownDelegateMethod:(SKDropDown *)sender withSelectedIndexPath:(NSIndexPath *)index
{
    NSString *title = _tipArray[index.row];
    NSLog(@"title = %@", title);
    [_btnMenu setTitle:title forState:UIControlStateNormal];
    
    [self closeDropDownMenu];
}

- (NSArray *)tipArray
{
    if (!_tipArray) {
        _tipArray = @[@"第一个菜单项", @"第二个菜单项", @"第三个菜单项", @"第四个菜单项"];
    }
    return _tipArray;
}

//- (void)setupView {
//    self.view.backgroundColor = kWhiteColor;
//    self.title = @"A";
//    
//    UIButton *btnAdd = [UIButton buttonWithType:UIButtonTypeContactAdd];
//    [btnAdd addTarget:self action:@selector(btnPress) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:btnAdd];
//    
//    UIView *btn = [[UIView alloc] initWithFrame:CGRectMake(10, 30, 50, 50)];
//    btn.backgroundColor = kBlackColor;
//    btn.alpha = 1.0;
//    _btn = btn;
//    [self.view addSubview:btn];
//}

//- (void)btnPress
//{
//    [self a];
//}
//
//- (void)a
//{
//    
//    [UIView animateWithDuration:1.5 delay:1.5 options:UIViewAnimationOptionCurveLinear animations:^{
//        _btn.alpha = 0.3;
//    } completion:^(BOOL finished) {
//        [self b];
//    }];
//}
//
//- (void)b
//{
//    
//    [UIView animateWithDuration:1.5 delay:1.5 options:UIViewAnimationOptionCurveLinear animations:^{
//        _btn.alpha = 1.0;
//    } completion:^(BOOL finished) {
//        [self a];
//    }];
//}
@end
