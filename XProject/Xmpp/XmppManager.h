//
//  XmppManager.h
//  XmppDemo
//
//  Created by Jerry.Yao on 16/2/25.
//  Copyright © 2016年 Jerry.Yao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPPFramework.h"

typedef NS_ENUM(NSInteger, XmppResultType) {
    XmppResultTypeSuccess,
    XmppResultTypeFailure,
    XmppResultTypeRegisterSuccess,
    XmppResultTypeRegisterFailure,
    XmppResultTypeNetworkError
};

// 登录结果回调block
typedef void(^XmppResultBlock)(XmppResultType resultType);

@interface XmppManager : NSObject

+ (XmppManager *)sharedManager;


@property (strong, nonatomic, readonly) XMPPStream *xmppStream;
// 花名册存储
@property (strong, nonatomic, readonly) XMPPRoster *roster;
@property (strong, nonatomic, readonly) XMPPRosterCoreDataStorage *rosterStorage;
// 聊天数据存储
@property (strong, nonatomic, readonly) XMPPMessageArchivingCoreDataStorage *msgStorage;


// 当前登录人的jid
@property (copy, nonatomic) NSString *myJid;
// 是登录操作还是注册操作
@property (assign, nonatomic) BOOL isLoginOperation;

- (void)xmppUserLogin:(XmppResultBlock)resultBlock;
- (void)xmppUserRegister:(XmppResultBlock)resultBlock;
- (void)xmppUserLogout;

@end
