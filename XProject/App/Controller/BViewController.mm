//
//  BViewController.m
//  XProject
//
//  Created by Jerry.Yao on 16/2/14.
//  Copyright © 2016年 Jerry.Yao. All rights reserved.
//

#import "BViewController.h"
#import "MJRefresh.h"
#import "BaseMapViewController.h"
#import "LocationViewController.h"
#import "RouteViewController.h"
#import "PoiSearchViewController.h"

@interface BViewController () <UITableViewDataSource, UITableViewDelegate>

//@property (nonatomic, strong) UITableView *tableView;

@end

@implementation BViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
//    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
//    self.tableView.mj_header  = header;
//    // 隐藏时间
//    header.lastUpdatedTimeLabel.hidden = YES;
//    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
//    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}

- (void)loadNewData
{
    LJLog(@"子类已经重写了父类方法");
    [self endRefreshingHeader];
}

- (void)loadMoreData
{
    LJLog(@"子类已经重写了父类方法");
    [self endRefreshingFooter];
}

- (void)setupView {
    
    self.title = @"B";
    
    [self addTableView];
}

#pragma mark - UITableViewDelegate method
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 15;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    switch (indexPath.row) {
        case 0:
        {
            cell.textLabel.text = @"基础地图";
        }
            break;
        case 1:
        {
            cell.textLabel.text = @"定位";
        }
            break;
        case 2:
        {
            cell.textLabel.text = @"路线规划";
        }
            break;
        case 3:
        {
            cell.textLabel.text = @"POI检索 - 自定义popView";
        }
            break;
        case 4:
        {
            cell.textLabel.text = @"离线地图";
        }
            break;
            
        case 5:
        {
            cell.textLabel.text = @"导航";
        }
            break;
        case 6:
        {
            cell.textLabel.text = @"地理编码";
        }
            break;
        default:
            cell.textLabel.text = @"";
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        {
            BaseMapViewController *baseMapView = [[BaseMapViewController alloc] init];
            [self.navigationController pushViewController:baseMapView animated:YES];
        }
            break;
        case 1:
        {
            LocationViewController *location = [[LocationViewController alloc] init];
            [self.navigationController pushViewController:location animated:YES];
        }
            break;
        case 2:
        {
            RouteViewController *route = [[RouteViewController alloc] init];
            [self.navigationController pushViewController:route animated:YES];
        }
            break;
            
        case 3:
        {
            PoiSearchViewController *poiSearch = [[PoiSearchViewController alloc] init];
            [self.navigationController pushViewController:poiSearch animated:YES];
        }
            break;
            
        case 4:
        {

        }
            break;
            
        case 5:
        {
            
        }
            break;
        case 6:
        {
            
        }
            break;
        default:
            break;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)addTableView
{
//    self.tableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight / 2);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

- (void)dealloc
{
    self.tableView.delegate = nil;
    self.tableView.dataSource = nil;
}

@end
