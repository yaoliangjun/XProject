//
//  AddContactViewController.m
//  XProject
//
//  Created by Jerry.Yao on 16/2/26.
//  Copyright © 2016年 Jerry.Yao. All rights reserved.
//

#import "AddContactViewController.h"

@interface AddContactViewController ()
{
    UITextField *_accountField;
    UITextField *_pwdField;
}


@end

@implementation AddContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
}

- (void)setupView {
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"添加好友";
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(backItemClick)];
    self.navigationItem.leftBarButtonItem = backItem;
    
    //
    UITextField *accountField = [[UITextField alloc] initWithFrame:CGRectMake(30, 30, kScreenWidth - 30 * 2, 44)];
    [accountField setPlaceholder:@"请输入好友账号"];
    // 关闭首字母大写功能
    accountField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    // 自动联想功能关闭
    accountField.autocorrectionType = UITextAutocorrectionTypeNo;
    accountField.layer.cornerRadius = 5;
    accountField.layer.borderWidth = 0.5;
    accountField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    accountField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    accountField.leftViewMode = UITextFieldViewModeAlways;
    _accountField = accountField;
    [self.view addSubview:accountField];
    
    //
    UIButton *loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(accountField.frame) + 20, kScreenWidth - 30 * 2, 50)];
    [loginBtn setTitle:@"添  加" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginBtn.layer.cornerRadius = 5;
    [loginBtn addTarget:self action:@selector(addContactClick) forControlEvents:UIControlEventTouchUpInside];
    
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

- (void)addContactClick
{
    if (!_accountField.text.length) {
        LJLog(@"请输入好友账号");
        return;
    }
    
    XMPPJID *friendJid = [XMPPJID jidWithString:[NSString stringWithFormat:@"%@@%@", _accountField.text, kXmppDomain]];
    
    // 判断好友是否已经存在
    BOOL isFriendExist = [[XmppManager sharedManager].rosterStorage userExistsWithJID:friendJid xmppStream:[XmppManager sharedManager].xmppStream];
    if (isFriendExist) {
        LJLog(@"该好友已经存在啦");
        return;
    }
    
    //双向添加和删除设置
    [XmppManager sharedManager].roster.autoAcceptKnownPresenceSubscriptionRequests = YES;
    
    // 发送好友请求
    
    [[XmppManager sharedManager].roster subscribePresenceToUser:friendJid];
}

- (void)backItemClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
