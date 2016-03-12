//
//  XmppManager.m
//  XmppDemo
//
//  Created by Jerry.Yao on 16/2/25.
//  Copyright © 2016年 Jerry.Yao. All rights reserved.
//

#import "XmppManager.h"

static XmppManager *_xmppManager = nil;

@interface XmppManager () <XMPPStreamDelegate>
{
//    XMPPStream *_xmppStream;
    XmppResultBlock _resultBlock;
    
    // 电子名片模块
    XMPPvCardTempModule *_vCard;
    // 电子名片的数据存储
    XMPPvCardCoreDataStorage *_vCardStorage;
    // 头像模块
    XMPPvCardAvatarModule *_vCardAvatar;
    // 自动连接模块
    XMPPReconnect *_reConnect;
    // 花名册和存储
//    XMPPRoster *_roster;
//    XMPPRosterCoreDataStorage *_rosterStorage;
    
    // 消息和存储
    XMPPMessageArchiving *_msgArchivng;
//    XMPPMessageArchivingCoreDataStorage *_msgStorage;
}

// 1. 初始化xmppStream
- (void)setupXmppStream;

// 2. 连接到服务器，传一个jid
- (void)connectToHost;

// 3. 连接成功再发送密码授权
- (void)sendPwdToHost;

// 4. 授权成功后, 再发送 "在线" 消息
- (void)sendOnlineToHost;
@end

@implementation XmppManager

+ (XmppManager *)sharedManager;
{
    if (!_xmppManager) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _xmppManager = [[XmppManager alloc] init];
        });
    }
    return _xmppManager;
}


#pragma mark - 私有方法
// 1. 初始化xmppStream
- (void)setupXmppStream
{
    _xmppStream = [[XMPPStream alloc] init];
    // 设置代理
    [_xmppStream addDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    
    // 自动重连
    _reConnect = [[XMPPReconnect alloc] init];
    [_reConnect activate:_xmppStream];
    
    _vCardStorage = [XMPPvCardCoreDataStorage sharedInstance];
    _vCard = [[XMPPvCardTempModule alloc] initWithvCardStorage:_vCardStorage];
    // 激活
    [_vCard activate:_xmppStream];
    
    // 获取个人信息
//   XMPPvCardTemp *myInfo =  _vCard.myvCardTemp;
    
    _vCardAvatar = [[XMPPvCardAvatarModule alloc] initWithvCardTempModule:_vCard];
    [_vCardAvatar activate:_xmppStream];
    
    // 花名册(好友列表)和存储
    _rosterStorage = [[XMPPRosterCoreDataStorage alloc] init];
    _roster = [[XMPPRoster alloc] initWithRosterStorage:_rosterStorage];
    [_roster activate:_xmppStream];
    
    // 聊天消息
    _msgStorage = [[XMPPMessageArchivingCoreDataStorage alloc] init];
    _msgArchivng = [[XMPPMessageArchiving alloc] initWithMessageArchivingStorage:_msgStorage];
    [_msgArchivng activate:_xmppStream];
}

// 2. 连接到服务器，传一个jid
- (void)connectToHost
{
    if (!_xmppStream) {
        [self setupXmppStream];
    }
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *account = nil;
    if (self.isLoginOperation) {
        // 登录
        account = [userDefaults objectForKey:@"account"];
    } else {
        // 注册
        account = [userDefaults objectForKey:@"regAccount"];
    }
    
    // 设置当前登录的jid
    _xmppStream.myJID = [XMPPJID jidWithUser:account domain:kXmppDomain resource:@"iphone"];
    
    // 设置域名和端口
    _xmppStream.hostName = kXmppHostName;
    // 默认为5222
    _xmppStream.hostPort = kXmppHostPort;
    
    NSError *error = nil;
    BOOL isConnected = [_xmppStream connectWithTimeout:15 error:&error];
    if (!isConnected) {
        NSLog(@"error = %@", error);
    }
}

// 3. 连接成功再发送密码授权
- (void)sendPwdToHost
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *password = nil;
    NSError *error = nil;
    
    if (self.isLoginOperation) {
        // 登录
        password = [userDefaults objectForKey:@"password"];
        BOOL isAuthSuccess = [_xmppStream authenticateWithPassword:password error:&error];
        if (!isAuthSuccess) {
            NSLog(@"%@", error);
        }
    } else {
        // 注册
        password = [userDefaults objectForKey:@"regPassword"];
        BOOL isRegisterSuccess = [_xmppStream registerWithPassword:password error:&error];
        if (!isRegisterSuccess) {
            NSLog(@"%@", error);
        }
    }
}

// 4. 授权成功后, 再发送 "在线" 消息
- (void)sendOnlineToHost
{
    // 登录成功了
    XMPPPresence *presence = [XMPPPresence presence];
    [_xmppStream sendElement:presence];
    
    if (_resultBlock) {
        _resultBlock(XmppResultTypeSuccess);
    }
}

#pragma mark - XmppStream代理 连接成功
- (void)xmppStreamDidConnect:(XMPPStream *)sender
{
    NSLog(@"与主机连接成功");
    
    [self sendPwdToHost];
}

- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error
{
    if (error && _resultBlock) {
        _resultBlock(XmppResultTypeNetworkError);
    }
    
    NSLog(@"与主机断开连接 = %@", error);
}

#pragma mark - 授权成功
- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender
{
    NSLog(@"授权成功");
    [self sendOnlineToHost];
}

- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(DDXMLElement *)error
{
    NSLog(@"授权失败");
    
    if (_resultBlock) {
        _resultBlock(XmppResultTypeFailure);
    }
}

#pragma mark - 注册成功
- (void)xmppStreamDidRegister:(XMPPStream *)sender
{
    NSLog(@"注册成功");
    if (_resultBlock) {
        _resultBlock(XmppResultTypeRegisterSuccess);
    }
}

#pragma mark - 注册失败
-(void)xmppStream:(XMPPStream *)sender didNotRegister:(DDXMLElement *)error
{
    NSLog(@"注册失败");
    if (_resultBlock) {
        _resultBlock(XmppResultTypeRegisterFailure);
    }
}

#pragma mark - 注销登录
- (void)xmppUserLogout
{
    // 1. 发送 "离线" 消息
    XMPPPresence *offline = [XMPPPresence presenceWithType:@"unavailable"];
    [_xmppStream sendElement:offline];
    
    // 2. 与主机断开连接
    [_xmppStream disconnect];
}

#pragma mark - 登录
- (void)xmppUserLogin:(XmppResultBlock)resultBlock
{
    _resultBlock = resultBlock;
    
    // 如果之前有连接，则要断开
    if (_xmppStream && [_xmppStream isConnected]) {
        [_xmppStream disconnect];
    }
    
    [self connectToHost];
}

#pragma mark - 注册
- (void)xmppUserRegister:(XmppResultBlock)resultBlock
{
    _resultBlock = resultBlock;
    
    // 如果之前有连接，则要断开
    if (_xmppStream && [_xmppStream isConnected]) {
        [_xmppStream disconnect];
    }
    
    [self connectToHost];
}

- (void)dealloc
{
    [self teardownXmpp];
}

#pragma mark - 释放Xmpp相关的资源
- (void)teardownXmpp
{
    // 移除代理
    [_xmppStream removeDelegate:self];
    
    // 停止模块
    [_reConnect deactivate];
    [_vCard deactivate];
    [_vCardAvatar deactivate];
    [_roster deactivate];
    [_msgArchivng deactivate];
    
    // 断开连接
    [_xmppStream disconnect];
    
    // 清空资源
    _reConnect = nil;
    _vCard = nil;
    _vCardAvatar = nil;
    _vCardStorage = nil;
    _roster = nil;
    _rosterStorage = nil;
    _msgStorage = nil;
    _msgArchivng = nil;
    // 最后销毁
    _xmppStream = nil;
    
}
@end
