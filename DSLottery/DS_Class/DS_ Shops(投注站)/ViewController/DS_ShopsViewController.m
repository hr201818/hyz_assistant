//
//  DS_ShopsViewController.m
//  DSLottery
//
//  Created by 黄玉洲 on 2018/5/9.
//  Copyright © 2018年 海南达生实业有限公司. All rights reserved.
//

#import "DS_ShopsViewController.h"
#import "DS_MapViewController.h"

/** share */
#import "DS_AdvertShare.h"

/** model */
#import "DS_AdvertListModel.h"

/** view */
#import "DS_AdvertTableViewCell.h"
#import "DS_ShopTableViewCell.h"

/** frame */
#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件
#import <BaiduMapAPI_Location/BMKLocationComponent.h>

@interface DS_ShopsViewController () <BMKPoiSearchDelegate,UITableViewDelegate,UITableViewDataSource,BMKLocationServiceDelegate>
{
    /** 记录当前的城市名称 */
    NSString * _city;
    /** 搜索关键字 */
    NSString * _keyword;
    /** 分页 */
    NSInteger  _page;
    /** 当前坐标 */
    CLLocationCoordinate2D _currentLocaltion;
    // 定位
    BMKLocationService * _locationManager;
}

@property (nonatomic, strong) UITableView       * tableView;

/** 存放地图点模型数组 */
@property (nonatomic, strong) NSMutableArray    * response;

#pragma mark - 百度地图相关
/** 搜索 */
@property (strong, nonatomic) BMKPoiSearch      * searcher;

@end

@implementation DS_ShopsViewController


- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = DS_STRINGS(@"kShops");
    
    [self initData];
    [self layoutView];
}

// 不使用时将delegate设置为 nil
- (void)viewWillDisappear:(BOOL)animated {
    _searcher.delegate = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    _searcher.delegate = self;
}

#pragma mark - 数据
- (void)initData {
    _response = [[NSMutableArray alloc]init];
    
    _page = 0;
    _keyword = @"投注站";
    
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
    
    //初始化搜索对象 ，并设置代理
    _searcher =[[BMKPoiSearch alloc] init];
    _searcher.delegate = self;
}

/** 加载广告 */
- (void)loadData {
    NSArray <DS_AdvertModel *> * shopsAdverts = [[DS_AdvertShare share] shopsAdverts];
    if ([shopsAdverts count] > 0) {
        // 判断第1位是否为广告，如果不是则插入
        if (![[self.response firstObject] isKindOfClass:[DS_AdvertModel class]]) {
            [self.response insertObject:[shopsAdverts firstObject] atIndex:0];
        }
    }

    if ([shopsAdverts count] > 1) {
        if (self.response.count > 5) {
            // 如果数组大于6位，则判断第6位是否为广告，如果不是则插入
            if (![[self.response objectAtIndex:6] isKindOfClass:[DS_AdvertModel class]]) {
                [self.response insertObject:[shopsAdverts lastObject] atIndex:6];
            }
        } else {
            // 如果数组小于6位，则判断最后一位是否为广告，如果不是则插入
            if (![[self.response lastObject] isKindOfClass:[DS_AdvertModel class]]) {
                [self.response addObject:[shopsAdverts lastObject]];
            }
        }
    }
}

#pragma mark - 界面
/** 视图布局 */
- (void)layoutView {
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NAVIGATIONBAR_HEIGHT, self.view.width, Screen_HEIGHT - NAVIGATIONBAR_HEIGHT - TABBAR_HEIGHT) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
    // 刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [_locationManager startUserLocationService];
        _page = 0;
    }];
    
    // 加载
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        _page++;
        [_locationManager startUserLocationService];
    }];
}

#pragma mark - 代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.response.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_response[indexPath.row] isKindOfClass:[DS_AdvertModel class]]) {
        DS_AdvertTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DS_AdvertTableViewCellID];
        if (cell == nil) {
            cell = [[DS_AdvertTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:DS_AdvertTableViewCellID];
        }
        cell.model = self.response[indexPath.row];
        return cell;
    } else {
        DS_ShopTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DS_ShopTableViewCellID];
        if (!cell) {
            cell = [[DS_ShopTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:DS_ShopTableViewCellID];
        }
        cell.model = self.response[indexPath.row];
        return cell;
    }
    //广告位
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_response[indexPath.row] isKindOfClass:[DS_AdvertModel class]]) {
        return IOS_SiZESCALE(DS_AdvertTableViewCellHeight);
    }else{
        return DS_ShopTableViewCellHeight;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self.response[indexPath.row] isKindOfClass:[BMKPoiInfo class]]) {
        BMKPoiInfo * poiInfo = (BMKPoiInfo *)self.response[indexPath.row];
        DS_MapViewController * mapVC = [[DS_MapViewController alloc]init];
        mapVC.hidesBottomBarWhenPushed = YES;
        mapVC.imageUrl = [NSString stringWithFormat:@"http://api.map.baidu.com/panorama/v2?ak=TS9nyRMSTDTX3RRMgWGsL0WivcEcUvLM&location=%lf,%lf&poiid=%@",poiInfo.pt.longitude,poiInfo.pt.latitude,poiInfo.uid];
        mapVC.longitude = poiInfo.pt.longitude;
        mapVC.latitude = poiInfo.pt.latitude;
        mapVC.typeName = poiInfo.name;
        mapVC.currentCordinate = _currentLocaltion;
        [self.navigationController pushViewController:mapVC animated:YES];
    }
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
    if (userLocation.location != nil) {
        [_locationManager stopUserLocationService];
        _currentLocaltion = userLocation.location.coordinate;
        [self searchInfoWithCoordinate:_currentLocaltion keyword:_keyword];
    }
}

/**
 *定位失败后，会调用此函数
 *@param error 错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error {
    
}

#pragma mark - 百度地图相关操作
/**
 周边搜索
 @param coordinate 中心经纬度
 @param keyword 关键字
 */
- (void)searchInfoWithCoordinate:(CLLocationCoordinate2D)coordinate keyword:(NSString *)keyword {
    [self showhud];
    
    BMKNearbySearchOption * nearbySearchOption = [[BMKNearbySearchOption alloc] init];
    nearbySearchOption.pageIndex = (int)_page;
    nearbySearchOption.pageCapacity = 10;
    nearbySearchOption.keyword = keyword;
    nearbySearchOption.radius = 5000;
    nearbySearchOption.sortType = BMK_POI_SORT_BY_DISTANCE;
    nearbySearchOption.location = coordinate;
    
    BOOL flag = [_searcher poiSearchNearBy:nearbySearchOption];
    if(flag) {
        NSLog(@"周边搜索发送成功");
    } else {
        if (_page > 0) {
            _page--;
        }
        NSLog(@"周边搜索发送失败");
    }
}

/**
 按城市搜索指定地点
 @param city    城市
 @param keyword 关键字
 */
- (void)searchInfoWithCity:(NSString *)city keyword:(NSString *)keyword {
    
    [self showhud];
    
    //请求参数类BMKCitySearchOption
    BMKCitySearchOption *citySearchOption = [[BMKCitySearchOption alloc]init];
    citySearchOption.pageIndex = (int)_page;
    citySearchOption.pageCapacity = 10;
    citySearchOption.city = city;
    citySearchOption.keyword = keyword;
    //发起城市内POI检索
    BOOL flag = [_searcher poiSearchInCity:citySearchOption];
    if(flag) {
        NSLog(@"城市内检索发送成功");
    } else {
        if (_page > 0) {
            _page--;
        }
        NSLog(@"城市内检索发送失败");
    }
}

/**
 处理搜索数据
 @param poiResultList poiResultList数组
 */
- (void)dealPoiData:(BMKPoiResult *)poiResultList {
    if (_page <= 0) {
        [self.response removeAllObjects];
    }
    
    for (BMKPoiInfo * poiInfo in poiResultList.poiInfoList) {
        [self.response addObject:poiInfo];
    }
    
    [self loadData];
    
    [self.tableView reloadData];
}

#pragma mark - <PoiSearchDeleage>
// 实现PoiSearchDeleage处理回调结果
- (void)onGetPoiResult:(BMKPoiSearch*)searcher result:(BMKPoiResult*)poiResultList errorCode:(BMKSearchErrorCode)error
{
    [self hidehud];
    //在此处理正常结果
    if (error == BMK_SEARCH_NO_ERROR) {
        [self dealPoiData:poiResultList];
    }
    //当在设置城市未找到结果，但在其他城市找到结果时，回调建议检索城市列表
    else if (error == BMK_SEARCH_AMBIGUOUS_KEYWORD){
        // result.cityList;
        NSLog(@"起始点有歧义");
        if (_page > 0) {
            _page--;
        }
    }
    else {
        NSLog(@"抱歉，未找到结果");
        if (_page > 0) {
            _page--;
        }
    }
    
    [_tableView.mj_header endRefreshing];
    [_tableView.mj_footer endRefreshing];
}

#pragma mark - 点击事件
-(void)btnAction{
    
}

@end
