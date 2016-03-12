//
//  BaseTableViewController.m
//  XProject
//
//  Created by Jerry.Yao on 16/3/4.
//  Copyright © 2016年 Jerry.Yao. All rights reserved.
//

#import "BaseTableViewController.h"
#import "MJRefresh.h"

@interface BaseTableViewController ()

@end

@implementation BaseTableViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.view.backgroundColor = kWhiteColor;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64) style:UITableViewStylePlain];
        _tableView.rowHeight = 50;
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
        _tableView.mj_header  = header;
        
        // 隐藏时间
        header.lastUpdatedTimeLabel.hidden = YES;
        // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    }
    return _tableView;
}

- (void)loadNewData
{
    LJLog(@"子类需要重写方法");
}

- (void)loadMoreData
{
    LJLog(@"子类需要重写方法");
}

- (void)endRefreshingHeader
{
    [NSThread sleepForTimeInterval:1];
    [self.tableView.mj_header endRefreshing];
}

- (void)endRefreshingFooter
{
    [NSThread sleepForTimeInterval:1];
    [self.tableView.mj_footer endRefreshing];
}
@end
