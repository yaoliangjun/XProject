//
//  IMMessagesViewController.h
//  XProject
//
//  Created by Jerry.Yao on 16/2/26.
//  Copyright © 2016年 Jerry.Yao. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JSQMessages.h"
#import "DemoModelData.h"
#import "NSUserDefaults+DemoSettings.h"
#import "XMPPJID.h"

@class DemoMessagesViewController;

@protocol JSQDemoViewControllerDelegate <NSObject>

- (void)didDismissJSQDemoViewController:(DemoMessagesViewController *)vc;

@end

@interface IMMessagesViewController : JSQMessagesViewController <UIActionSheetDelegate, JSQMessagesComposerTextViewPasteDelegate>

@property (weak, nonatomic) id<JSQDemoViewControllerDelegate> delegateModal;
@property (strong, nonatomic) DemoModelData *demoData;

// 当前聊天好友的jid
@property (strong, nonatomic) XMPPJID *friendJid;



- (void)receiveMessagePressed:(UIBarButtonItem *)sender;

- (void)closePressed:(UIBarButtonItem *)sender;
@end
