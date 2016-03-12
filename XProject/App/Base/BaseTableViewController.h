//
//  BaseTableViewController.h
//  XProject
//
//  Created by Jerry.Yao on 16/3/4.
//  Copyright © 2016年 Jerry.Yao. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseTableViewController : BaseViewController

@property (nonatomic, strong) UITableView *tableView;

- (void)loadNewData;
- (void)loadMoreData;

- (void)endRefreshingHeader;
- (void)endRefreshingFooter;

@end
