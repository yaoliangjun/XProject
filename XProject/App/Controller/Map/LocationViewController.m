//
//  LocationViewController.m
//  XProject
//
//  Created by Jerry.Yao on 16/3/10.
//  Copyright © 2016年 Jerry.Yao. All rights reserved.
//

#import "LocationViewController.h"

@interface LocationViewController () <BMKLocationServiceDelegate, BMKMapViewDelegate>
@property (nonatomic, strong) BMKLocationService *locationService;
@end

@implementation LocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupMapView];
}

- (BMKMapView *)mapView
{
    if (!_mapView) {
        _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    }
    return _mapView;
}

- (void)setupMapView {
    self.view.backgroundColor = kWhiteColor;
    self.title = @"定位";
    [self.view addSubview:self.mapView];
    
    _locationService = [[BMKLocationService alloc] init];
    _locationService.delegate = self;
//    设定定位的最小更新距离
    _locationService.distanceFilter = 5;
    _locationService.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    [_locationService startUserLocationService];
    
    _mapView.showsUserLocation = NO;//先关闭显示的定位图层
    //设置定位的状态 好像必须要设置！
    _mapView.userTrackingMode = BMKUserTrackingModeFollow;
    _mapView.showsUserLocation = YES;//显示定位图层
    _mapView.zoomLevel = 15;
    _mapView.delegate = self;
    
}


/**
 *用户方向更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    CLLocation *location = userLocation.location;
    double latitude  =  location.coordinate.latitude;
    double longitude =  location.coordinate.longitude;
    NSLog(@"latitude = %f, longitude = %f", latitude, longitude);
    [_mapView updateLocationData:userLocation];
    [_locationService stopUserLocationService];
}


- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
{
    NSLog(@"点击了标注点");
}

- (void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view
{
    NSLog(@"点击了泡泡");
}

@end
