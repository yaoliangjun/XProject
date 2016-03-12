//
//  RouteViewController.m
//  XProject
//
//  Created by Jerry.Yao on 16/3/10.
//  Copyright © 2016年 Jerry.Yao. All rights reserved.
//

#import "RouteViewController.h"

#define MYBUNDLE_NAME @ "mapapi.bundle"
#define MYBUNDLE_PATH [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: MYBUNDLE_NAME]
#define MYBUNDLE [NSBundle bundleWithPath: MYBUNDLE_PATH]

typedef NS_ENUM(NSInteger,SearchBy) {
    SearchByBus = 0,
    SearchByDriving,
    SearchByRiving,
    SearchByWalking
};

@interface RouteAnnotation : BMKPointAnnotation
{
    int _type; ///<0:起点 1：终点 2：公交 3：地铁 4:驾乘 5:途经点
    int _degree;
}

@property (nonatomic) int type;
@property (nonatomic) int degree;
@end

@implementation RouteAnnotation

@synthesize type = _type;
@synthesize degree = _degree;
@end

@interface RouteViewController () <BMKRouteSearchDelegate, BMKMapViewDelegate, BMKGeoCodeSearchDelegate>
@property (nonatomic, strong) BMKRouteSearch *routeSearch;

@property (nonatomic, strong) UITextField *startCityField;
@property (nonatomic, strong) UITextField *startAddrField;
@property (nonatomic, strong) UITextField *endCityField;
@property (nonatomic, strong) UITextField *endAddrField;

@property (nonatomic, strong) UIButton *btnBus;
@property (nonatomic, strong) UIButton *btnDriving;
@property (nonatomic, strong) UIButton *btnRiding;
@property (nonatomic, strong) UIButton *btnWalking;

@property (nonatomic, assign) CLLocationCoordinate2D startLocation;
@property (nonatomic, assign) CLLocationCoordinate2D endLocation;
@property (nonatomic, strong) BMKGeoCodeSearch *geoCodeSearch;

@property (nonatomic, assign) NSInteger searchStatus;
@end

@implementation RouteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    [self setupMapView];
}

- (void)setupView
{
    _startCityField = [self generalTextFieldWithFrame:CGRectMake(10, 10, 100, 44) andPlaceHolder:@"起点城市"];
    _startAddrField = [self generalTextFieldWithFrame:CGRectMake(CGRectGetMaxX(_startCityField.frame) + 10, 10, 200, 44) andPlaceHolder:@"起点地址"];
    _endCityField = [self generalTextFieldWithFrame:CGRectMake(10, CGRectGetMaxY(_startAddrField.frame) + 20, 100, 44) andPlaceHolder:@"终点城市"];
    _endAddrField = [self generalTextFieldWithFrame:CGRectMake(CGRectGetMaxX(_endCityField.frame) + 10, _endCityField.y, 200, 44) andPlaceHolder:@"终点地址"];
    
    [self.view addSubview:_startCityField];
    [self.view addSubview:_startAddrField];
    [self.view addSubview:_endCityField];
    [self.view addSubview:_endAddrField];
    
    _btnBus     = [self generalBtnWithFrame:CGRectMake(10, _endCityField.bottom + 10, 50, 35) andTitle:@"公交" andTag:0];
    _btnDriving = [self generalBtnWithFrame:CGRectMake(CGRectGetMaxX(_btnBus.frame) + 5, _btnBus.y, 50, 35) andTitle:@"自驾" andTag:1];
    _btnRiding  = [self generalBtnWithFrame:CGRectMake(CGRectGetMaxX(_btnDriving.frame) + 5, _btnBus.y, 50, 35) andTitle:@"骑行" andTag:2];
    _btnWalking = [self generalBtnWithFrame:CGRectMake(CGRectGetMaxX(_btnRiding.frame) + 5, _btnBus.y, 50, 35) andTitle:@"步行" andTag:3];
    
    [self.view addSubview:_btnBus];
    [self.view addSubview:_btnDriving];
    [self.view addSubview:_btnRiding];
    [self.view addSubview:_btnWalking];
}

- (UIButton *)generalBtnWithFrame:(CGRect)frame andTitle:(NSString *)title andTag:(NSInteger)tag
{
    UIButton *btn = [[UIButton alloc] initWithFrame:frame];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageWithColor:kOrangeColor] forState:UIControlStateNormal];
    [btn setTitleColor:kWhiteColor forState:UIControlStateNormal];
    btn.tag = tag;
    [btn addTarget:self action:@selector(btnClickHandle:) forControlEvents:UIControlEventTouchUpInside];
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

#pragma mark - 路线按钮点击事件
- (void)btnClickHandle:(UIButton *)btn
{
    if (!_startCityField.text.length || !_startAddrField.text.length || !_endCityField.text.length || !_endAddrField.text.length) {
        [ToastUtil showMessage:@"请输入起始点和地址再搜索"];
        return;
    }
    
    switch (btn.tag) {
        case 0:
        {
            LJLog(@"公交");
            _searchStatus = SearchByBus;
            [self onBusBtnClickEvent];
        }
            break;
        case 1:
        {
            LJLog(@"自驾");
            _searchStatus = SearchByDriving;
            [self geoCode];
        }
            break;
        case 2:
        {
            LJLog(@"骑行");
            _searchStatus = SearchByRiving;
            [self geoCode];
        }
            break;
        case 3:
        {
            LJLog(@"步行");
            _searchStatus = SearchByWalking;
            [self geoCode];
        }
            break;
            
        default:
            break;
    }
}
- (void)geoCode
{
    // 地理编码
    BMKGeoCodeSearchOption *startGeoCodeOption = [[BMKGeoCodeSearchOption alloc] init];
    startGeoCodeOption.city = _startCityField.text;
    startGeoCodeOption.address = _startAddrField.text;
    BOOL flag = [_geoCodeSearch geoCode:startGeoCodeOption];
    if(flag)
    {
        NSLog(@"start geo检索发送成功");
    }
    else
    {
        NSLog(@"start geo检索发送失败");
    }
}

- (void)onDrivingClickEvent
{
    BMKPlanNode *startNode = [[BMKPlanNode alloc] init];
    // 需要设置城市字段
//    startNode.cityName = @"深圳";
//    startNode.name     =  @"白石洲";//startAddr;
//    startNode.pt = {22.547041432502301, 113.97546723851463};
    startNode.pt = _startLocation;
//    白石洲下白石二坊location = (latitude = 22.546650, longitude = 113.975717)

    
    BMKPlanNode *endNode = [[BMKPlanNode alloc] init];
//    endNode.cityName = @"深圳";
//    endNode.name     = @"软件大厦";//endAddr;
//    endNode.pt = {22.555006830134214, 113.94778712472588};
    endNode.pt = _endLocation;
    // 软件大厦location = (latitude = 22.555006830134214, longitude = 113.94778712472588)
    
    BMKDrivingRoutePlanOption *drivingOption = [[BMKDrivingRoutePlanOption alloc] init];
    drivingOption.from = startNode;
    drivingOption.to   = endNode;
    [_routeSearch drivingSearch:drivingOption];
}

- (void)onRivingClickEvent
{
    BMKPlanNode *startNode = [[BMKPlanNode alloc] init];
    startNode.pt = _startLocation;
    
    BMKPlanNode *endNode = [[BMKPlanNode alloc] init];
    endNode.pt = _endLocation;
    
    BMKRidingRoutePlanOption *ridingOption = [[BMKRidingRoutePlanOption alloc] init];
    ridingOption.from = startNode;
    ridingOption.to   = endNode;
    [_routeSearch ridingSearch:ridingOption];
}

- (void)onWalkingClickEvent
{
    BMKPlanNode *startNode = [[BMKPlanNode alloc] init];
    startNode.pt = _startLocation;
    
    BMKPlanNode *endNode = [[BMKPlanNode alloc] init];
    endNode.pt = _endLocation;
    
    BMKWalkingRoutePlanOption *walkingOption = [[BMKWalkingRoutePlanOption alloc] init];
    walkingOption.from = startNode;
    walkingOption.to   = endNode;
    [_routeSearch walkingSearch:walkingOption];
}

- (void)onBusBtnClickEvent
{
    NSString *startCity = _startCityField.text;
    NSString *startAddr = _startAddrField.text;
//    NSString *endCity   = _endCityField.text;
    NSString *endAddr   = _endAddrField.text;
    
//    if (!startCity.length || !startAddr.length || !endCity.length || !endAddr.length) {
//        [ToastUtil showMessage:@"请输入完整地址再搜索"];
//        return;
//    }
    
    BMKPlanNode *startNode = [[BMKPlanNode alloc] init];
    // 不需要在这里设置城市字段
//    startNode.cityName = startCity;
    startNode.name     =  startAddr;
    
    BMKPlanNode *endNode = [[BMKPlanNode alloc] init];
//    endNode.cityName = endCity;
    endNode.name     = endAddr;
    
    BMKTransitRoutePlanOption *transitOption = [[BMKTransitRoutePlanOption alloc] init];
    // 公交搜索只能在同一个城市
    transitOption.city = startCity;
    transitOption.from = startNode;
    transitOption.to   = endNode;
    [_routeSearch transitSearch:transitOption];
}


- (void)setupMapView {
    self.view.backgroundColor = kWhiteColor;
    self.title = @"路线规划";
    
    [self.view addSubview:self.mapView];
    
    _routeSearch = [[BMKRouteSearch alloc] init];
    _routeSearch.delegate = self;
    
    _geoCodeSearch = [[BMKGeoCodeSearch alloc] init];
    _geoCodeSearch.delegate = self;
    
}

#pragma mark - BMKMapViewDelegate

- (BMKAnnotationView *)mapView:(BMKMapView *)view viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[RouteAnnotation class]]) {
        return [self getRouteAnnotationView:view viewForAnnotation:(RouteAnnotation*)annotation];
    }
    return nil;
}

- (BMKOverlayView*)mapView:(BMKMapView *)map viewForOverlay:(id<BMKOverlay>)overlay
{
    if ([overlay isKindOfClass:[BMKPolyline class]]) {
        BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        polylineView.fillColor = [[UIColor alloc] initWithRed:0 green:1 blue:1 alpha:1];
        polylineView.strokeColor = [[UIColor alloc] initWithRed:0 green:0 blue:1 alpha:0.7];
        polylineView.lineWidth = 3.0;
        return polylineView;
    }
    return nil;
}

- (void)removeAnnotationsAndOverlays
{
    [_mapView removeAnnotations:_mapView.annotations];
    [_mapView removeOverlays:_mapView.overlays];
}

/**
 *返回公交搜索结果
 *@param searcher 搜索对象
 *@param result 搜索结果，类型为BMKTransitRouteResult
 *@param error 错误号，@see BMKSearchErrorCode
 */
- (void)onGetTransitRouteResult:(BMKRouteSearch*)searcher result:(BMKTransitRouteResult*)result errorCode:(BMKSearchErrorCode)error
{
    LJLog(@"error = %ld", (NSInteger)error);
    [self removeAnnotationsAndOverlays];
    
    if (error == BMK_SEARCH_NO_ERROR) {
        BMKTransitRouteLine *plan = [result.routes firstObject];

        // 计算路线方案中的路段数目
        NSInteger size = [plan.steps count];
        int planPointCounts = 0;
        for (int i = 0; i < size; i++) {
            BMKTransitStep* transitStep = [plan.steps objectAtIndex:i];
            if(i==0){
                RouteAnnotation *item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.starting.location;
                item.title = @"起点";
                item.type = 0;
                [_mapView addAnnotation:item]; // 添加起点标注
                
            }else if(i==size-1){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.terminal.location;
                item.title = @"终点";
                item.type = 1;
                [_mapView addAnnotation:item]; // 添加起点标注
            }
            RouteAnnotation* item = [[RouteAnnotation alloc]init];
            item.coordinate = transitStep.entrace.location;
            item.title = transitStep.instruction;
            item.type = 3;
            [_mapView addAnnotation:item];
            
            //轨迹点总数累计
            planPointCounts += transitStep.pointsCount;
        }
        
        //轨迹点
        BMKMapPoint * temppoints = new BMKMapPoint[planPointCounts];
        int i = 0;
        for (int j = 0; j < size; j++) {
            BMKTransitStep* transitStep = [plan.steps objectAtIndex:j];
            int k=0;
            for(k=0;k<transitStep.pointsCount;k++) {
                temppoints[i].x = transitStep.points[k].x;
                temppoints[i].y = transitStep.points[k].y;
                i++;
            }
            
        }
        // 通过points构建BMKPolyline
        BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:temppoints count:planPointCounts];
        [_mapView addOverlay:polyLine]; // 添加路线overlay
        delete []temppoints;
        [self mapViewFitPolyLine:polyLine];
    }
}
/**
 *返回驾乘搜索结果
 *@param searcher 搜索对象
 *@param result 搜索结果，类型为BMKDrivingRouteResult
 *@param error 错误号，@see BMKSearchErrorCode
 */
- (void)onGetDrivingRouteResult:(BMKRouteSearch*)searcher result:(BMKDrivingRouteResult*)result errorCode:(BMKSearchErrorCode)error
{
    LJLog(@"onGetDrivingRouteResult error = %ld", (NSInteger)error);
    [_mapView removeAnnotations:_mapView.annotations];
    [_mapView removeOverlays:_mapView.overlays];
    
    if (error == BMK_SEARCH_NO_ERROR) {
        BMKDrivingRouteLine *plan = (BMKDrivingRouteLine*)[result.routes objectAtIndex:0];
        // 计算路线方案中的路段数目
        NSInteger size = [plan.steps count];
        int planPointCounts = 0;
        for (int i = 0; i < size; i++) {
            BMKDrivingStep* transitStep = [plan.steps objectAtIndex:i];
            if(i==0){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.starting.location;
                item.title = @"起点";
                item.type = 0;
                [_mapView addAnnotation:item]; // 添加起点标注
                
            }else if(i==size-1){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.terminal.location;
                item.title = @"终点";
                item.type = 1;
                [_mapView addAnnotation:item]; // 添加起点标注
            }
            //添加annotation节点
            RouteAnnotation* item = [[RouteAnnotation alloc]init];
            item.coordinate = transitStep.entrace.location;
            item.title = transitStep.entraceInstruction;
            item.degree = transitStep.direction * 30;
            item.type = 4;
            [_mapView addAnnotation:item];
            
            //轨迹点总数累计
            planPointCounts += transitStep.pointsCount;
        }
        // 添加途经点
        if (plan.wayPoints) {
            for (BMKPlanNode* tempNode in plan.wayPoints) {
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item = [[RouteAnnotation alloc]init];
                item.coordinate = tempNode.pt;
                item.type = 5;
                item.title = tempNode.name;
                [_mapView addAnnotation:item];
            }
        }
        //轨迹点
        BMKMapPoint * temppoints = new BMKMapPoint[planPointCounts];
        int i = 0;
        for (int j = 0; j < size; j++) {
            BMKDrivingStep* transitStep = [plan.steps objectAtIndex:j];
            int k=0;
            for(k=0;k<transitStep.pointsCount;k++) {
                temppoints[i].x = transitStep.points[k].x;
                temppoints[i].y = transitStep.points[k].y;
                i++;
            }
            
        }
        // 通过points构建BMKPolyline
        BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:temppoints count:planPointCounts];
        [_mapView addOverlay:polyLine]; // 添加路线overlay
        delete []temppoints;
        [self mapViewFitPolyLine:polyLine];
    } else if (error == BMK_SEARCH_AMBIGUOUS_ROURE_ADDR){
        LJLog(@"检索地址有岐义");

    }

}


/**
 *返回骑行搜索结果
 *@param searcher 搜索对象
 *@param result 搜索结果，类型为BMKRidingRouteResult
 *@param error 错误号，@see BMKSearchErrorCode
 */
- (void)onGetRidingRouteResult:(BMKRouteSearch *)searcher result:(BMKRidingRouteResult *)result errorCode:(BMKSearchErrorCode)error {
    NSLog(@"onGetRidingRouteResult error:%d", (int)error);
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    array = [NSArray arrayWithArray:_mapView.overlays];
    [_mapView removeOverlays:array];
    if (error == BMK_SEARCH_NO_ERROR) {
        BMKRidingRouteLine* plan = (BMKRidingRouteLine*)[result.routes objectAtIndex:0];
        NSInteger size = [plan.steps count];
        int planPointCounts = 0;
        for (int i = 0; i < size; i++) {
            BMKRidingStep* transitStep = [plan.steps objectAtIndex:i];
            if (i == 0) {
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.starting.location;
                item.title = @"起点";
                item.type = 0;
                [_mapView addAnnotation:item]; // 添加起点标注
            } else if(i==size-1){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.terminal.location;
                item.title = @"终点";
                item.type = 1;
                [_mapView addAnnotation:item]; // 添加起点标注
            }
            //添加annotation节点
            RouteAnnotation* item = [[RouteAnnotation alloc]init];
            item.coordinate = transitStep.entrace.location;
            item.title = transitStep.instruction;
            item.degree = (int)transitStep.direction * 30;
            item.type = 4;
            [_mapView addAnnotation:item];
            
            //轨迹点总数累计
            planPointCounts += transitStep.pointsCount;
        }
        
        //轨迹点
        BMKMapPoint * temppoints = new BMKMapPoint[planPointCounts];
        int i = 0;
        for (int j = 0; j < size; j++) {
            BMKRidingStep* transitStep = [plan.steps objectAtIndex:j];
            int k=0;
            for(k=0;k<transitStep.pointsCount;k++) {
                temppoints[i].x = transitStep.points[k].x;
                temppoints[i].y = transitStep.points[k].y;
                i++;
            }
            
        }
        // 通过points构建BMKPolyline
        BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:temppoints count:planPointCounts];
        [_mapView addOverlay:polyLine]; // 添加路线overlay
        delete []temppoints;
        [self mapViewFitPolyLine:polyLine];
    }
}

- (void)onGetWalkingRouteResult:(BMKRouteSearch*)searcher result:(BMKWalkingRouteResult*)result errorCode:(BMKSearchErrorCode)error
{
    NSLog(@"onGetWalkingRouteResult error:%d", (int)error);
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    array = [NSArray arrayWithArray:_mapView.overlays];
    [_mapView removeOverlays:array];
    if (error == BMK_SEARCH_NO_ERROR) {
        BMKWalkingRouteLine* plan = (BMKWalkingRouteLine*)[result.routes objectAtIndex:0];
        NSInteger size = [plan.steps count];
        int planPointCounts = 0;
        for (int i = 0; i < size; i++) {
            BMKWalkingStep* transitStep = [plan.steps objectAtIndex:i];
            if(i==0){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.starting.location;
                item.title = @"起点";
                item.type = 0;
                [_mapView addAnnotation:item]; // 添加起点标注
                
            }else if(i==size-1){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.terminal.location;
                item.title = @"终点";
                item.type = 1;
                [_mapView addAnnotation:item]; // 添加起点标注
            }
            //添加annotation节点
            RouteAnnotation* item = [[RouteAnnotation alloc]init];
            item.coordinate = transitStep.entrace.location;
            item.title = transitStep.entraceInstruction;
            item.degree = transitStep.direction * 30;
            item.type = 4;
            [_mapView addAnnotation:item];
            
            //轨迹点总数累计
            planPointCounts += transitStep.pointsCount;
        }
        
        //轨迹点
        BMKMapPoint * temppoints = new BMKMapPoint[planPointCounts];
        int i = 0;
        for (int j = 0; j < size; j++) {
            BMKWalkingStep* transitStep = [plan.steps objectAtIndex:j];
            int k=0;
            for(k=0;k<transitStep.pointsCount;k++) {
                temppoints[i].x = transitStep.points[k].x;
                temppoints[i].y = transitStep.points[k].y;
                i++;
            }
            
        }
        // 通过points构建BMKPolyline
        BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:temppoints count:planPointCounts];
        [_mapView addOverlay:polyLine]; // 添加路线overlay
        delete []temppoints;
        [self mapViewFitPolyLine:polyLine];
    }
}

/**
 *返回地址信息搜索结果
 *@param searcher 搜索对象
 *@param result 搜索结BMKGeoCodeSearch果
 *@param error 错误号，@see BMKSearchErrorCode
 */
- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    if (error == BMK_SEARCH_NO_ERROR) {
        if ([result.address isEqualToString:_startAddrField.text]) {
            //  (latitude = 22.555006830134214, longitude = 113.94778712472588)
            _startLocation = result.location;
            
            BMKGeoCodeSearchOption *endGeoCodeOption = [[BMKGeoCodeSearchOption alloc] init];
            endGeoCodeOption.city = _endCityField.text;
            endGeoCodeOption.address = _endAddrField.text;
            BOOL flag2 = [_geoCodeSearch geoCode:endGeoCodeOption];
            if(flag2)
            {
                NSLog(@"end geo检索发送成功");
            }
            else
            {
                NSLog(@"end geo检索发送失败");
            }
            
        } else if ([result.address isEqualToString:_endAddrField.text]){
            _endLocation = result.location;
        }
        
        if (_startLocation.latitude != 0 && _startLocation.longitude != 0 && _endLocation.latitude != 0 && _endLocation.longitude != 0) {
            switch (_searchStatus) {
                case SearchByBus:

                    // 公交的直接搜索，逻辑不经过这里
                    break;
                case SearchByDriving:
                    [self onDrivingClickEvent];
                    
                    break;
                    
                case SearchByRiving:
                    [self onRivingClickEvent];
                    
                    break;
                    
                case SearchByWalking:
                    [self onWalkingClickEvent];
                    
                    break;
                default:
                    break;
            }
                    }
    }
}


//根据polyline设置地图范围
- (void)mapViewFitPolyLine:(BMKPolyline *) polyLine {
    CGFloat ltX, ltY, rbX, rbY;
    if (polyLine.pointCount < 1) {
        return;
    }
    BMKMapPoint pt = polyLine.points[0];
    ltX = pt.x, ltY = pt.y;
    rbX = pt.x, rbY = pt.y;
    for (int i = 1; i < polyLine.pointCount; i++) {
        BMKMapPoint pt = polyLine.points[i];
        if (pt.x < ltX) {
            ltX = pt.x;
        }
        if (pt.x > rbX) {
            rbX = pt.x;
        }
        if (pt.y > ltY) {
            ltY = pt.y;
        }
        if (pt.y < rbY) {
            rbY = pt.y;
        }
    }
    BMKMapRect rect;
    rect.origin = BMKMapPointMake(ltX , ltY);
    rect.size = BMKMapSizeMake(rbX - ltX, rbY - ltY);
    [_mapView setVisibleMapRect:rect];
    _mapView.zoomLevel = _mapView.zoomLevel - 0.3;
}

- (BMKAnnotationView*)getRouteAnnotationView:(BMKMapView *)mapview viewForAnnotation:(RouteAnnotation*)routeAnnotation
{
    BMKAnnotationView* view = nil;
    switch (routeAnnotation.type) {
        case 0:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"start_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"start_node"];
                view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_start.png"]];
                view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
                view.canShowCallout = TRUE;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case 1:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"end_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"end_node"];
                view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_end.png"]];
                view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
                view.canShowCallout = TRUE;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case 2:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"bus_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"bus_node"];
                view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_bus.png"]];
                view.canShowCallout = TRUE;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case 3:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"rail_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"rail_node"];
                view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_rail.png"]];
                view.canShowCallout = TRUE;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case 4:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"route_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"route_node"];
                view.canShowCallout = TRUE;
            } else {
                [view setNeedsDisplay];
            }
            
            UIImage* image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_direction.png"]];
            view.image = [image imageRotatedByDegrees:routeAnnotation.degree];
            view.annotation = routeAnnotation;
            
        }
            break;
        case 5:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"waypoint_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"waypoint_node"];
                view.canShowCallout = TRUE;
            } else {
                [view setNeedsDisplay];
            }
            
            UIImage* image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_waypoint.png"]];
            view.image = [image imageRotatedByDegrees:routeAnnotation.degree];
            view.annotation = routeAnnotation;
        }
            break;
        default:
            break;
    }
    
    return view;
}

#pragma mark - 私有

- (NSString*)getMyBundlePath1:(NSString *)filename
{
    
    NSBundle * libBundle = MYBUNDLE ;
    if ( libBundle && filename ){
        NSString * s=[[libBundle resourcePath ] stringByAppendingPathComponent : filename];
        return s;
    }
    return nil ;
}

- (BMKMapView *)mapView
{
    if (!_mapView) {
        _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, _btnBus.bottom + 10, kScreenWidth, kScreenHeight)];
        _mapView.delegate = self;
    }
    return _mapView;
}
@end
