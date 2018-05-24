//
//  DS_MapViewController.m
//  DSLottery
//
//  Created by 黄玉洲 on 2018/5/15.
//  Copyright © 2018年 海南达生实业有限公司. All rights reserved.
//

#import "DS_MapViewController.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
@interface DS_MapViewController () <BMKMapViewDelegate, BMKLocationServiceDelegate>
{
    // 定位
    BMKLocationService * _locationManager;
}
/** 地图视图 */
@property (strong, nonatomic) BMKMapView * mapView;



@end

@implementation DS_MapViewController


- (void)dealloc {
    
}

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    DS_BaseNavigationController * navigation = (DS_BaseNavigationController *)self.navigationController;
    navigation.backhandlepan = NO;
    
    [_locationManager startUserLocationService];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    DS_BaseNavigationController * navigation = (DS_BaseNavigationController *)self.navigationController;
    navigation.backhandlepan = YES;
    
    [_locationManager stopUserLocationService];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 数据初始化
    [self initData];
    
    //视图布局
    [self layoutView];
    
    //提示
    if(![DS_FunctionTool isBlankString:self.hudText]){
        [self showMessagetext:self.hudText];
    }
}

#pragma mark - 数据
- (void)initData {
    //初始化实例
    _locationManager = [[BMKLocationService alloc] init];
    //设置delegate
    _locationManager.delegate = self;
    //设置距离过滤参数
    _locationManager.distanceFilter = kCLDistanceFilterNone;
    //设置预期精度参数
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    //设置是否自动停止位置更新
    _locationManager.pausesLocationUpdatesAutomatically = YES;
    //设置是否允许后台定位
    _locationManager.allowsBackgroundLocationUpdates = NO;
    [_locationManager startUserLocationService];
}

#pragma mark - 布局
/* 布局 */
-(void)layoutView {
    
    self.title = self.typeName;
    
    [self navLeftItem:[DS_FunctionTool leftNavBackTarget:self Item:@selector(leftButtonAction:)]];
    
    [self.view addSubview:self.mapView];
    
    
    // 没有坐标就加载，自动获取周边的数据添加
    if(self.longitude != 0){
        
        BMKPointAnnotation * annotation = [[BMKPointAnnotation alloc]init];
        annotation.coordinate = CLLocationCoordinate2DMake(self.latitude, self.longitude);
        annotation.title = self.typeName;
        [_mapView addAnnotation:annotation];
    }
}

#pragma mark - 按钮事件
- (void)leftButtonAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - <BMKMapViewDelegate>
/**
 *地图初始化完毕时会调用此接口
 *@param mapView 地图View
 */
- (void)mapViewDidFinishLoading:(BMKMapView *)mapView {
    
}

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
        BMKPinAnnotationView*annotationView = (BMKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        if (annotationView == nil) {
            annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
        }
        annotationView.pinColor = BMKPinAnnotationColorPurple;
        annotationView.canShowCallout= YES;      //设置气泡可以弹出，默认为NO
        annotationView.animatesDrop=YES;         //设置标注动画显示，默认为NO
        annotationView.draggable = YES;          //设置标注可以拖动，默认为NO
        [annotationView setSelected:YES animated:YES];
        return annotationView;
    }
    return nil;
}

#pragma mark - <BMKLocationServiceDelegate>
/**
 *在将要启动定位时，会调用此函数
 */
- (void)willStartLocatingUser {
    
}

/**
 *在停止定位后，会调用此函数
 */
- (void)didStopLocatingUser {
    
}

/**
 *用户方向更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation {
    
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation {
    [_mapView updateLocationData:userLocation];
}

/**
 *定位失败后，会调用此函数
 *@param error 错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error {
    
}

#pragma mark - 懒加载
- (BMKMapView *)mapView {
    if (!_mapView) {
        _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, NAVIGATIONBAR_HEIGHT, self.view.width, Screen_HEIGHT - NAVIGATIONBAR_HEIGHT)];
        _mapView.delegate = self;
        _mapView.showsUserLocation = YES;
        [_mapView setCenterCoordinate:CLLocationCoordinate2DMake(self.latitude, self.longitude)];
        _mapView.zoomLevel = 18;
        _mapView.mapType = BMKMapTypeStandard;
        _mapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态为普通定位模式
    }
    return _mapView;
}


@end
