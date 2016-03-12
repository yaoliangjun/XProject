//
//  BaseMapViewController.m
//  XProject
//
//  Created by Jerry.Yao on 16/3/10.
//  Copyright © 2016年 Jerry.Yao. All rights reserved.
//

#import "BaseMapViewController.h"

@interface BaseMapViewController ()

@end

@implementation BaseMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupMapView];
}

- (void)setupMapView {
    self.view.backgroundColor = kWhiteColor;
    self.title = @"基础地图";
    [self.view addSubview:self.mapView];
}

- (BMKMapView *)mapView
{
    if (!_mapView) {
        _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    }
    return _mapView;
}

@end
