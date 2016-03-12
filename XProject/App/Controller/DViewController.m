//
//  DViewController.m
//  XProject
//
//  Created by Jerry.Yao on 16/2/14.
//  Copyright © 2016年 Jerry.Yao. All rights reserved.
//

#import "DViewController.h"
#import "ChatViewController.h"
#import "MJRefresh.h"
#import "NewsCell.h"


@interface DViewController () <UITableViewDataSource, UITableViewDelegate>
@end

@implementation DViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)loadNewData
{
    [self endRefreshingHeader];
}

- (void)loadMoreData
{
    [self endRefreshingFooter];;
}

- (void)setupView {
    self.title = @"D";
    [self addTableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"NewsCell";
    
    NewsCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    cell.title = @"哥哥";
    cell.content = @"天下第一哦";
    cell.avatarName = @"icon60";
    return cell;
}

- (void)addTableView
{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 80;
    [self.tableView registerNib:[UINib nibWithNibName:@"NewsCell" bundle:nil] forCellReuseIdentifier:@"NewsCell"];
    [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    [self.view addSubview:self.tableView];
}

// 去掉分割线左边的margin
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setLayoutMargins:UIEdgeInsetsZero];
    [cell setSeparatorInset:UIEdgeInsetsZero];
}

- (void)dealloc
{
    self.tableView.delegate = nil;
    self.tableView.dataSource = nil;
}

@end
