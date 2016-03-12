///
//  FViewController.m
//  XProject
//
//  Created by Jerry.Yao on 16/2/14.
//  Copyright © 2016年 Jerry.Yao. All rights reserved.
//

#import "FViewController.h"
#import "ChatViewController.h"
#import "MJRefresh.h"
#import "ArticleCell.h"

@interface FViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation FViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.tableView.mj_header  = header;
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}

- (void)loadNewData
{
    [NSThread sleepForTimeInterval:1];
    [self.tableView.mj_header endRefreshing];
}

- (void)loadMoreData
{
    [NSThread sleepForTimeInterval:1];
    [self.tableView.mj_footer endRefreshing];
}

- (void)setupView {
    self.view.backgroundColor = kWhiteColor;
    self.title = @"F";
    [self.view addSubview:self.tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    ArticleCell *cell = [ArticleCell cellWithTableView:tableView];
    cell.title = @"哥哥我";
    cell.content = @"天下第一哦";
    cell.avatarName = @"icon60";
    return cell;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 80;
        [_tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    return _tableView;
}

// 去掉分割线左边的margin
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setLayoutMargins:UIEdgeInsetsZero];
    [cell setSeparatorInset:UIEdgeInsetsZero];
}

- (void)dealloc
{
    _tableView.delegate = nil;
    _tableView.dataSource = nil;
}

@end
