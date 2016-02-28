//
//  MainViewFrame.h
//  XProject
//
//  Created by Jerry.Yao on 16/2/14.
//  Copyright © 2016年 Jerry.Yao. All rights reserved.
//
@class MainViewModel;
#import <Foundation/Foundation.h>

@interface MainViewFrame : NSObject

@property (nonatomic, strong) MainViewModel *mainViewModel;

@property (nonatomic, assign) CGRect imageFrame;
@property (nonatomic, assign) CGRect titleFrame;

@property (nonatomic, assign) CGFloat rowHeight;

@end
