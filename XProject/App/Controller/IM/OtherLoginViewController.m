//
//  OtherLoginViewController.m
//  XmppDemo
//
//  Created by Jerry.Yao on 16/2/25.
//  Copyright © 2016年 Jerry.Yao. All rights reserved.
//

#import "OtherLoginViewController.h"
#import "AppDelegate.h"

#define kScreenWidth  [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height


@interface OtherLoginViewController ()
{
    UITextField *_accountField;
    UITextField *_pwdField;
}
@end

@implementation OtherLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
}

- (void)setupView {
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"其他登录方式";
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(backItemClick)];
    self.navigationItem.leftBarButtonItem = backItem;
    
    //
    UITextField *accountField = [[UITextField alloc] initWithFrame:CGRectMake(30, 64, kScreenWidth - 30 * 2, 44)];
    [accountField setPlaceholder:@"请输入账号"];
    // 关闭首字母大写功能
    accountField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    // 自动联想功能关闭
    accountField.autocorrectionType = UITextAutocorrectionTypeNo;
    accountField.text = @"zhangsan";
    accountField.layer.cornerRadius = 5;
    accountField.layer.borderWidth = 0.5;
    accountField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    accountField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    accountField.leftViewMode = UITextFieldViewModeAlways;
    _accountField = accountField;
    [self.view addSubview:accountField];
    
    //
    UITextField *pwdField = [[UITextField alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(accountField.frame) + 15, kScreenWidth - 30 * 2, 44)];
    [pwdField setPlaceholder:@"请输入密码"];
    pwdField.text = @"123456";
    pwdField.layer.cornerRadius = 5;
    pwdField.layer.borderWidth = 0.5;
    pwdField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    pwdField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    pwdField.leftViewMode = UITextFieldViewModeAlways;
    _pwdField = pwdField;
    [self.view addSubview:pwdField];
    
    //
    UIButton *loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(pwdField.frame) + 10, kScreenWidth - 30 * 2, 50)];
    [loginBtn setTitle:@"登  录" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginBtn.layer.cornerRadius = 5;
    [loginBtn addTarget:self action:@selector(loginBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    CGFloat top = 10; // 顶端盖高度
    CGFloat bottom = 10 ; // 底端盖高度
    CGFloat left = 10; // 左端盖宽度
    CGFloat right = 10; // 右端盖宽度
    UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
    UIImage *image = [UIImage imageNamed:@"green_btn"];
    // 指定为拉伸模式，伸缩后重新赋值
    image = [image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    [loginBtn setBackgroundImage:image forState:UIControlStateNormal];
    [self.view addSubview:loginBtn];
}

- (void)backItemClick
{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)handleLoginResult:(XmppResultType)resultType
{
    dispatch_async(dispatch_get_main_queue(), ^{
        switch (resultType) {
            case XmppResultTypeSuccess:
                // 登录成功
                [self enterMainPage];
                [XmppManager sharedManager].myJid = [NSString stringWithFormat:@"%@@%@", _accountField.text, kXmppDomain];
                [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
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

- (void)loginBtnClick
{
    NSString *account = _accountField.text;
    NSString *password = _pwdField.text;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:account forKey:@"account"];
    [userDefaults setObject:password forKey:@"password"];
    [userDefaults synchronize];
    
    [[XmppManager sharedManager] xmppUserLogin:^(XmppResultType resultType) {
        [self handleLoginResult:resultType];
    }];
    
    
}

@end
