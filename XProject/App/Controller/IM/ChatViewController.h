//
//  ChatViewController.h
//  XProject
//
//  Created by Jerry.Yao on 16/2/27.
//  Copyright © 2016年 Jerry.Yao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMPPJID.h"

@interface ChatViewController : UIViewController

// 当前聊天好友的jid
@property (strong, nonatomic) XMPPJID *friendJid;

@end
