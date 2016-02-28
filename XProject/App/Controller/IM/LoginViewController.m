//
//  LoginViewController.m
//  XmppDemo
//
//  Created by Jerry.Yao on 16/2/21.
//  Copyright © 2016年 Jerry.Yao. All rights reserved.
//

#import "LoginViewController.h"
#import "OtherLoginViewController.h"
#import "BaseNavigationController.h"
#import "RegisterViewController.h"
#import "AppDelegate.h"

@interface LoginViewController ()

@end

@implementation LoginViewController
{
    UILabel *_accountLabel;
    UITextField *_pwdField;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupView];
    [self addKeyboardListener];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([XmppManager sharedManager].isLoginOperation) {
        _accountLabel.text = [userDefaults objectForKey:@"account"];
    } else {
        _accountLabel.text = [userDefaults objectForKey:@"regAccount"];
    }
}

- (void)addKeyboardListener
{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureEvent)];
    [self.view addGestureRecognizer:tapGesture];
}

- (void)tapGestureEvent
{
    [self.view endEditing:YES];
}

- (void)setupView {
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"登录";
    
    //
    UIImageView *avatarImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"default_avatar"]];
    avatarImage.frame = CGRectMake((kScreenWidth - 80 ) / 2, 64, 80, 80);
    [self.view addSubview:avatarImage];
    
    //
    UILabel *accountLabel = [[UILabel alloc] init];
    _accountLabel = accountLabel;
    accountLabel.text = @"zhangsan";
    accountLabel.textColor = [UIColor blackColor];
    accountLabel.frame = CGRectMake(0, CGRectGetMaxY(avatarImage.frame) + 5, kScreenWidth, 20);
    accountLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:accountLabel];
    
    //
    UITextField *pwdField = [[UITextField alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(accountLabel.frame) + 15, kScreenWidth - 30 * 2, 44)];
    [pwdField setPlaceholder:@"请输入密码"];
    pwdField.text = @"123456";
    _pwdField = pwdField;
    pwdField.layer.cornerRadius = 5;
    pwdField.layer.borderWidth = 0.5;
    pwdField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    pwdField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    pwdField.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:pwdField];
    
    //
    UIButton *loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(pwdField.frame) + 10, kScreenWidth - 30 * 2, 50)];
    [loginBtn setTitle:@"登  录" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginBtn.layer.cornerRadius = 5;
    CGFloat top = 10; // 顶端盖高度
    CGFloat bottom = 10 ; // 底端盖高度
    CGFloat left = 10; // 左端盖宽度
    CGFloat right = 10; // 右端盖宽度
    UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
    UIImage *image = [UIImage imageNamed:@"green_btn"];
    // 指定为拉伸模式，伸缩后重新赋值
    image = [image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    [loginBtn setBackgroundImage:image forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(loginBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    
    //
    UIButton *registerBtn = [[UIButton alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(loginBtn.frame) + 10, kScreenWidth - 30 * 2, 50)];
    [registerBtn setTitle:@"注  册" forState:UIControlStateNormal];
    [registerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    registerBtn.layer.cornerRadius = 5;
    [registerBtn setBackgroundImage:image forState:UIControlStateNormal];
    [registerBtn addTarget:self action:@selector(registerBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerBtn];
    
    //
    UIButton *otherLoinModel = [[UIButton alloc] init];
    [otherLoinModel setTitle:@"其他方式登录" forState:UIControlStateNormal];
    [otherLoinModel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    otherLoinModel.frame = CGRectMake(0, kScreenHeight - 105, kScreenWidth, 20);
    [otherLoinModel addTarget:self action:@selector(otherLoginModelClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:otherLoinModel];
}

#pragma mark - 登录
- (void)loginBtnClick
{
    // TODO
    [XmppManager sharedManager].isLoginOperation = YES;
    
    NSString *account = _accountLabel.text;
    NSString *password = _pwdField.text;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:account forKey:@"account"];
    [userDefaults setObject:password forKey:@"password"];
    [userDefaults synchronize];
    
    [self.view endEditing:YES];
    
    [[XmppManager sharedManager] xmppUserLogin:^(XmppResultType resultType) {
        [self handleLoginResult:resultType];
    }];
    
}

- (void)handleLoginResult:(XmppResultType)resultType
{
    dispatch_async(dispatch_get_main_queue(), ^{
        switch (resultType) {
            case XmppResultTypeSuccess:
                // 登录成功 进入主页
                [self enterMainPage];
                [XmppManager sharedManager].myJid = [NSString stringWithFormat:@"%@@%@", _accountLabel.text, kXmppDomain];
                
                break;
            case XmppResultTypeFailure:
                // 登录失败
                NSLog(@"login failure in %s", __FUNCTION__);
                break;
            case XmppResultTypeNetworkError:
                // 网络出错
                NSLog(@"network error in %s", __FUNCTION__);
                break;
            default:
                break;
        }
    });
}

- (void)enterMainPage
{
    AppDelegate *appDelegate = kDelegate;
    [appDelegate enterMainPage];
}

#pragma mark - 注册
- (void)registerBtnClick
{
    
    RegisterViewController *registerVC = [[RegisterViewController alloc] init];
    BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:registerVC];
    [self.navigationController presentViewController:nav animated:YES completion:^{
        
    }];
}

#pragma mark - 其他方式登录
- (void)otherLoginModelClick
{
    
    OtherLoginViewController *otherLogin = [[OtherLoginViewController alloc] init];
    BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:otherLogin];
    [self.navigationController presentViewController:nav animated:YES completion:^{
        
    }];
}
@end
