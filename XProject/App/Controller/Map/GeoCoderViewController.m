//
//  GeoCoderViewController.m
//  XProject
//
//  Created by Jerry.Yao on 16/3/13.
//  Copyright © 2016年 Jerry.Yao. All rights reserved.
//

#import "GeoCoderViewController.h"

@interface GeoCoderViewController () <BMKGeoCodeSearchDelegate, BMKMapViewDelegate>

@property (nonatomic, strong) BMKGeoCodeSearch *geoCodeSearch;

@property (nonatomic, strong) UITextField *searchCity;
@property (nonatomic, strong) UITextField *searchAddress;
@property (nonatomic, strong) UITextField *latitude;
@property (nonatomic, strong) UITextField *longitude;

@property (nonatomic, strong) UIButton *btnGeoSearch;
@property (nonatomic, strong) UIButton *btnReverseGeoSearch;

@property (nonatomic, strong) BMKMapView *mapView;

@end

@implementation GeoCoderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
}

- (void)setupView
{
    self.title = @"地理编码";
    
    _geoCodeSearch = [[BMKGeoCodeSearch alloc] init];
    _geoCodeSearch.delegate = self;
    
    _searchCity = [self generalTextFieldWithFrame:CGRectMake(10, 10, 100, 44) andPlaceHolder:@"城市"];
    _searchCity.text = @"深圳";
    
    _searchAddress = [self generalTextFieldWithFrame:CGRectMake(CGRectGetMaxX(_searchCity.frame) + 10, 10, 160, 44) andPlaceHolder:@"地区"];
    _searchAddress.text = @"世界之窗";
    
    // 白石洲下白石二坊location = (latitude = 22.546650, longitude = 113.975717)
    _latitude = [self generalTextFieldWithFrame:CGRectMake(10, CGRectGetMaxY(_searchAddress.frame) + 10, 100, 44) andPlaceHolder:@"纬度"];
    _latitude.text = @"22.546650";
    _longitude = [self generalTextFieldWithFrame:CGRectMake(CGRectGetMaxX(_latitude.frame) + 10, _latitude.y, 160, 44) andPlaceHolder:@"经度"];
    _longitude.text = @"113.975717";
    
    _latitude.keyboardType = UIKeyboardTypeDecimalPad;
    _longitude.keyboardType = UIKeyboardTypeDecimalPad;
    
    [self.view addSubview:_searchCity];
    [self.view addSubview:_searchAddress];
    [self.view addSubview:_latitude];
    [self.view addSubview:_longitude];
    
    _btnGeoSearch            = [self generalBtnWithFrame:CGRectMake(CGRectGetMaxX(_searchAddress.frame) + 5, _searchAddress.y, 70, 35) andTitle:@"Geo" andTag:0];
    _btnReverseGeoSearch     = [self generalBtnWithFrame:CGRectMake(CGRectGetMaxX(_longitude.frame) + 5, _longitude.y, 70, 35) andTitle:@"Reverse" andTag:1];
    
    [self.view addSubview:_btnGeoSearch];
    [self.view addSubview:_btnReverseGeoSearch];
    
    [self.view addSubview:self.mapView];
    _mapView.delegate = self;
    _mapView.frame = CGRectMake(0, _latitude.bottom + 3, kScreenWidth, kScreenHeight);
    _mapView.zoomLevel = 15;
}

- (UIButton *)generalBtnWithFrame:(CGRect)frame andTitle:(NSString *)title andTag:(NSInteger)tag
{
    UIButton *btn = [[UIButton alloc] initWithFrame:frame];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageWithColor:kOrangeColor] forState:UIControlStateNormal];
    [btn setTitleColor:kWhiteColor forState:UIControlStateNormal];
    btn.tag = tag;
    [btn addTarget:self action:@selector(btnGeoSearchClick:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

#pragma mark - Geo/Reverse Geo搜索
- (void)btnGeoSearchClick:(UIButton *)btn
{
    switch (btn.tag) {
        case 0:
            LJLog(@"geo");
            [self geoCoder];
            break;
        case 1:
            LJLog(@"reverse geo");
            [self reverseGeoCoder];
            break;
            
        default:
            break;
    }

}

#pragma mark - 正向地理编码
- (void)geoCoder
{
    BMKGeoCodeSearchOption *geoCodeOption = [[BMKGeoCodeSearchOption alloc] init];
    geoCodeOption.city    = _searchCity.text;
    geoCodeOption.address = _searchAddress.text;
    BOOL flag = [_geoCodeSearch geoCode:geoCodeOption];
    if (flag) {
        LJLog(@"地理编码检索成功");
    } else {
        LJLog(@"地理编码检索失败");
    }
}

#pragma mark - 返向地理编码
- (void)reverseGeoCoder
{
    BMKReverseGeoCodeOption *reverseGeoCodeOption = [[BMKReverseGeoCodeOption alloc] init];
    NSString *latitude = _latitude.text;
    NSString *longitude = _longitude.text;
    CLLocationCoordinate2D coordinate = {0};
    coordinate.latitude = [latitude floatValue];
    coordinate.longitude = [longitude floatValue];
    reverseGeoCodeOption.reverseGeoPoint = coordinate;
    BOOL flag = [_geoCodeSearch reverseGeoCode:reverseGeoCodeOption];
    if (flag) {
        LJLog(@"反地理编码检索成功");
    } else {
        LJLog(@"反地理编码检索失败");
    }
}

#pragma mark - 正向地理编码结果
- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    LJLog(@"error = %ld", (long)error);
    [_mapView removeAnnotations:_mapView.annotations];
    [_mapView removeOverlays:_mapView.overlays];
    
    if (error == BMK_SEARCH_NO_ERROR) {
        CLLocationCoordinate2D coordinate = result.location;
        BMKPointAnnotation *annotation = [[BMKPointAnnotation alloc] init];
        annotation.coordinate = coordinate;
        annotation.title = result.address;
        [_mapView addAnnotation:annotation];
        _mapView.centerCoordinate = result.location;
    }
}

#pragma mark - 返向地理编码结果
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    [_mapView removeAnnotations:_mapView.annotations];
    [_mapView removeOverlays:_mapView.overlays];
    
    if (error == BMK_SEARCH_NO_ERROR) {
        CLLocationCoordinate2D coordinate = result.location;
        BMKPointAnnotation *annotation = [[BMKPointAnnotation alloc] init];
        annotation.coordinate = coordinate;
        annotation.title = result.address;
        [_mapView addAnnotation:annotation];
        _mapView.centerCoordinate = result.location;
    }
}

#pragma mark - 绘制大头针
- (BMKAnnotationView *)mapView:(BMKMapView *)view viewForAnnotation:(id <BMKAnnotation>)annotation
{
    NSString *AnnotationViewID = @"annotationViewID";
    //根据指定标识查找一个可被复用的标注View，一般在delegate中使用，用此函数来代替新申请一个View
    BMKAnnotationView *annotationView = [view dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    if (annotationView == nil) {
        annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
        ((BMKPinAnnotationView*)annotationView).pinColor = BMKPinAnnotationColorRed;
//        ((BMKPinAnnotationView*)annotationView).animatesDrop = YES;
    }
    
    annotationView.centerOffset = CGPointMake(0, -(annotationView.frame.size.height * 0.5));
    annotationView.annotation = annotation;
    annotationView.canShowCallout = YES;
    return annotationView;
}


- (UITextField *)generalTextFieldWithFrame:(CGRect)frame andPlaceHolder:(NSString *)placeHolder
{
    UITextField *textField = [[UITextField alloc] initWithFrame:frame];
    textField.layer.borderColor = kLightGrayColor.CGColor;
    textField.layer.borderWidth = 0.5;
    textField.layer.cornerRadius = 4;
    textField.placeholder = placeHolder;
    textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    textField.leftViewMode = UITextFieldViewModeAlways;
    
    return textField;
}

- (BMKMapView *)mapView
{
    if (!_mapView) {
        _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    }
    return _mapView;
}

@end
