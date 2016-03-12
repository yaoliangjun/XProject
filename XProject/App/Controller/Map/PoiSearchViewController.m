//
//  PoiSearchViewController.m
//  XProject
//
//  Created by Jerry.Yao on 16/3/12.
//  Copyright © 2016年 Jerry.Yao. All rights reserved.
//

#import "PoiSearchViewController.h"

@interface PoiSearchViewController () <BMKPoiSearchDelegate, BMKMapViewDelegate, BMKLocationServiceDelegate>

@property (nonatomic, strong) UITextField *searchCity;
@property (nonatomic, strong) UITextField *keyword;
@property (nonatomic, strong) UITextField *distanceLabel;
@property (nonatomic, strong) UITextField *distance;

@property (nonatomic, strong) UIButton *btnBus;
@property (nonatomic, strong) UIButton *btnDriving;
@property (nonatomic, strong) UIButton *btnRiding;
@property (nonatomic, strong) UIButton *btnWalking;

@property (nonatomic, strong) BMKPoiSearch *poiSearch;
@property (nonatomic, strong) BMKLocationService *locationService;
@end

@implementation PoiSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
}


- (void)setupView
{
    self.title = @"POI检索";
    _poiSearch = [[BMKPoiSearch alloc] init];
    _poiSearch.delegate = self;
    
    _locationService = [[BMKLocationService alloc] init];
    _locationService.delegate = self;
    
    _searchCity = [self generalTextFieldWithFrame:CGRectMake(10, 10, 100, 44) andPlaceHolder:@"搜索城市"];
    _searchCity.text = @"深圳";
    _keyword = [self generalTextFieldWithFrame:CGRectMake(CGRectGetMaxX(_searchCity.frame) + 10, 10, 180, 44) andPlaceHolder:@"关键词"];
    _keyword.text = @"银行";
    _distanceLabel = [self generalTextFieldWithFrame:CGRectMake(10, CGRectGetMaxY(_keyword.frame) + 10, 100, 44) andPlaceHolder:@"距离范围"];
    _distanceLabel.enabled = NO;
    _distance = [self generalTextFieldWithFrame:CGRectMake(CGRectGetMaxX(_distanceLabel.frame) + 10, _distanceLabel.y, 180, 44) andPlaceHolder:@"距离"];
    _distance.keyboardType = UIKeyboardTypeNumberPad;
    _distance.text = @"1000";
    [self.view addSubview:_searchCity];
    [self.view addSubview:_keyword];
    [self.view addSubview:_distanceLabel];
    [self.view addSubview:_distance];
    
    _btnBus     = [self generalBtnWithFrame:CGRectMake(CGRectGetMaxX(_keyword.frame) + 5, _keyword.y, 60, 35) andTitle:@"搜索" andTag:0];
    [self.view addSubview:_btnBus];
    
    self.mapView.delegate = self;
    self.mapView.frame = CGRectMake(0, _distanceLabel.bottom, kScreenWidth, kScreenHeight);
}


#pragma mark - 搜索
- (void)btnSearchClick:(UIButton *)btn
{
    
    if (!_searchCity.text.length || !_keyword.text.length) {
        [ToastUtil showMessage: @"请输入要搜索的城市和关键字"];
        return;
    }
    // 有输入距离就按照距离检索
    if (_distance.text.length) {
        LJLog(@"distance search");
        [self nearBySearch];
    } else {
        LJLog(@"city search");
        [self citySearch];
    }
}

#pragma mark - 按附近距离搜索 -- 定位
- (void)nearBySearch
{
    [_locationService startUserLocationService];
    
    self.mapView.showsUserLocation = NO;//先关闭显示的定位图层
    self.mapView.userTrackingMode = BMKUserTrackingModeFollow;//设置定位的状态 好像必须要设置
    self.mapView.showsUserLocation = YES;//显示定位图层
    
}

#pragma mark - 按城市搜索
- (void)citySearch
{
    BMKCitySearchOption *cityOption = [[BMKCitySearchOption alloc] init];
    cityOption.city = _searchCity.text;
    cityOption.keyword = _keyword.text;
    BOOL flag = [_poiSearch poiSearchInCity:cityOption];
    if(flag)
    {
        NSLog(@"城市内检索发送成功");
    }
    else
    {
        NSLog(@"城市内检索发送失败");
    }
}

/**
 *返回POI搜索结果
 *@param searcher 搜索对象
 *@param poiResult 搜索结果列表
 *@param errorCode 错误号，@see BMKSearchErrorCode
 */
- (void)onGetPoiResult:(BMKPoiSearch*)searcher result:(BMKPoiResult*)poiResult errorCode:(BMKSearchErrorCode)errorCode
{
    LJLog(@"errorCode = %ld", (NSInteger)errorCode);
    // 清楚屏幕中所有的annotation
    NSArray* array = [NSArray arrayWithArray:self.mapView.annotations];
    [self.mapView removeAnnotations:array];
    
    if (errorCode == BMK_SEARCH_NO_ERROR) {
        
        ///本次POI搜索的总结果数
//        @property (nonatomic) int totalPoiNum;
//        ///当前页的POI结果数
//        @property (nonatomic) int currPoiNum;
//        ///本次POI搜索的总页数
//        @property (nonatomic) int pageNum;
//        ///当前页的索引
//        @property (nonatomic) int pageIndex;
//        ///POI列表，成员是BMKPoiInfo
//        @property (nonatomic, strong) NSArray* poiInfoList;
//        ///城市列表，成员是BMKCityListInfo
//        @property (nonatomic, strong) NSArray* cityList;
        
        NSArray* poiInfoList = poiResult.poiInfoList;
        NSMutableArray *annotations = [NSMutableArray array];
        for (NSInteger index = 0; index < poiInfoList.count; index ++) {
            BMKPoiInfo *poiInfo = poiInfoList[index];
            BMKPointAnnotation *point = [[BMKPointAnnotation alloc] init];
            point.coordinate = poiInfo.pt;
            point.title = poiInfo.name;
            [annotations addObject:point];
        }
        
        [self.mapView addAnnotations:annotations];
        [self.mapView showAnnotations:annotations animated:YES];
    }
}

/**
 *根据anntation生成对应的View
 *@param mapView 地图View
 *@param annotation 指定的标注
 *@return 生成的标注View
 */
- (BMKAnnotationView *)mapView:(BMKMapView *)view viewForAnnotation:(id <BMKAnnotation>)annotation
{
    // 生成重用标示identifier
    NSString *AnnotationViewID = @"xidanMark";
    
    // 检查是否有重用的缓存
    BMKAnnotationView* annotationView = [view dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    
    // 缓存没有命中，自己构造一个，一般首次添加annotation代码会运行到此处
    if (annotationView == nil) {
        annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
        ((BMKPinAnnotationView*)annotationView).pinColor = BMKPinAnnotationColorRed;
        // 设置重天上掉下的效果(annotation)
        ((BMKPinAnnotationView*)annotationView).animatesDrop = YES;
        
        UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 210, 100)];
        customView.backgroundColor = kWhiteColor;
        customView.layer.cornerRadius = 5;
        customView.layer.borderWidth = 0.5;
        customView.layer.borderColor = kLightGrayColor.CGColor;
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 100, 20)];
        titleLabel.text = @"Name : Jerry";
        [customView addSubview:titleLabel];
        UILabel *phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(titleLabel.frame) + 5, 200, 20)];
        phoneLabel.text = @"Phone : 15626551075";
        [customView addSubview:phoneLabel];
        UIButton *btnContact = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        btnContact.frame = CGRectMake((210 - 80 ) /2, CGRectGetMaxY(phoneLabel.frame) + 5, 80, 35);
        [btnContact setTitle:@"联系我" forState:UIControlStateNormal];
        [btnContact setBackgroundImage:[UIImage imageWithColor:kOrangeColor] forState:UIControlStateNormal];
        [btnContact addTarget:self action:@selector(btnContactClick) forControlEvents:UIControlEventTouchUpInside];
        [customView addSubview:btnContact];
        
        BMKActionPaopaoView *popView = [[BMKActionPaopaoView alloc] initWithCustomView:customView];;
        annotationView.paopaoView = popView;
        
        annotationView.enabled3D = YES;
//        更换大头针图片
//        annotationView.image = [UIImage imageNamed:@"map"];
    }
    
    // 设置位置
    annotationView.centerOffset = CGPointMake(0, -(annotationView.frame.size.height * 0.5));
    annotationView.annotation = annotation;
    // 单击弹出泡泡，弹出泡泡前提annotation必须实现title属性
    annotationView.canShowCallout = YES;
    
    // 设置是否可以拖拽
    annotationView.draggable = NO;
    
    return annotationView;
}

- (void)btnContactClick
{
    LJLog(@"contact click");
}

#pragma mark - POI检索结果代理方法
/**
 *返回POI详情搜索结果
 *@param searcher 搜索对象
 *@param poiDetailResult 详情搜索结果
 *@param errorCode 错误号，@see BMKSearchErrorCode
 */
- (void)onGetPoiDetailResult:(BMKPoiSearch*)searcher result:(BMKPoiDetailResult*)poiDetailResult errorCode:(BMKSearchErrorCode)errorCode
{
    if (errorCode == BMK_SEARCH_NO_ERROR) {
        
    }
}

#pragma mark - 定位
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
    [_locationService stopUserLocationService];
    
    // 检索
    BMKNearbySearchOption *nearByOption = [[BMKNearbySearchOption alloc] init];
    nearByOption.radius = [_distance.text intValue];
    // 通过定位后得到的附近经纬度
//    nearByOption.location = location.coordinate;
    
    // 白石洲经纬度
    CLLocationCoordinate2D loc = {0};
    loc.latitude = 22.546650;
    loc.longitude = 113.975717;
    nearByOption.location = loc;
    
    nearByOption.keyword = _keyword.text;
//    nearByOption.pageIndex = 0;
//    nearByOption.pageCapacity = 10;
    BOOL flag = [_poiSearch poiSearchNearBy:nearByOption];
    if(flag)
    {
        NSLog(@"附近检索发送成功");
    }
    else
    {
        NSLog(@"附近检索发送失败");
    }
    
}

- (UIButton *)generalBtnWithFrame:(CGRect)frame andTitle:(NSString *)title andTag:(NSInteger)tag
{
    UIButton *btn = [[UIButton alloc] initWithFrame:frame];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageWithColor:kOrangeColor] forState:UIControlStateNormal];
    [btn setTitleColor:kWhiteColor forState:UIControlStateNormal];
    btn.tag = tag;
    [btn addTarget:self action:@selector(btnSearchClick:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
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


@end
