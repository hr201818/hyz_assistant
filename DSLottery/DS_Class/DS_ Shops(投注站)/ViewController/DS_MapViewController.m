//
//  DS_MapViewController.m
//  DSLottery
//
//  Created by 黄玉洲 on 2018/5/15.
//  Copyright © 2018年 海南达生实业有限公司. All rights reserved.
//

#import "DS_MapViewController.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件
@interface DS_MapViewController () <BMKMapViewDelegate>

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
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    DS_BaseNavigationController * navigation = (DS_BaseNavigationController *)self.navigationController;
    navigation.backhandlepan = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.typeName;
    
    [self navLeftItem:[DS_FunctionTool leftNavBackTarget:self Item:@selector(leftButtonAction:)]];
    
    //视图布局
    [self layoutView];
    
    //提示
    if(![DS_FunctionTool isBlankString:self.hudText]){
        [self showMessagetext:self.hudText];
    }
}

#pragma mark - 布局
/* 布局 */
-(void)layoutView {
    //    self.userInfomation = nil;
    
    [self.view addSubview:self.mapView];
    
    
    // 没有坐标就加载，自动获取周边的数据添加
    if(self.longitude != 0){
        
        BMKPointAnnotation * annotation = [[BMKPointAnnotation alloc]init];
        annotation.coordinate = CLLocationCoordinate2DMake(self.latitude, self.longitude);
        annotation.title = self.typeName;
        [_mapView addAnnotation:annotation];
    }
    
    //个人位置蓝色图标设置
//    BMKLocationViewDisplayParam *displayParam = [[BMKLocationViewDisplayParam alloc]init];
//    displayParam.isRotateAngleValid = NO;
//    displayParam.isAccuracyCircleShow = NO;
//    displayParam.accuracyCircleFillColor = [UIColor redColor];
//    displayParam.locationViewOffsetX = self.longitude;//定位偏移量(经度)
//    displayParam.locationViewOffsetY = self.latitude;//定位偏移量（纬度）
//    [_mapView updateLocationViewWithParam:displayParam];
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

#pragma mark - 懒加载
- (BMKMapView *)mapView {
    if (!_mapView) {
        _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, NAVIGATIONBAR_HEIGHT, self.view.width, Screen_HEIGHT - NAVIGATIONBAR_HEIGHT)];
        _mapView.delegate = self;
        _mapView.showsUserLocation = YES;
        [_mapView setCenterCoordinate:CLLocationCoordinate2DMake(self.latitude, self.longitude)];
        _mapView.zoomLevel = 18;
        _mapView.userTrackingMode = BMKUserTrackingModeFollow;//设置定位的状态为普通定位模式
    }
    return _mapView;
}


@end
