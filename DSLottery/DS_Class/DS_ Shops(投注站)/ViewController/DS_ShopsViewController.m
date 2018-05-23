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
#import "SGPagingView.h"
#import "DS_AdvertTableViewCell.h"
#import "DS_ShopTableViewCell.h"

/** frame */
#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件

@interface DS_ShopsViewController () <SGPageTitleViewDelegate, SGPageContentViewDelegate, BMKPoiSearchDelegate,UITableViewDelegate,UITableViewDataSource>
{
    /** 记录当前的城市名称 */
    NSString * _city;
    /** 搜索关键字 */
    NSString * _keyword;
    /** 分页 */
    NSInteger  _page;
}

@property (nonatomic, strong) UITableView       * tableView;

/** 选项条 */
@property (nonatomic, strong) SGPageTitleView   * pageTitleView;

/** 选项条标题数组 */
@property (nonatomic, strong) NSArray           * titleArr;

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
    
    self.title = @"投注站";
    
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
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"DS_CityList" ofType:@"plist"];
    _titleArr = [[NSMutableArray alloc] initWithContentsOfFile:plistPath];
    
    _page = 0;
    _city = [_titleArr firstObject];
    _keyword = @"投注站";
    
    //初始化搜索对象 ，并设置代理
    _searcher =[[BMKPoiSearch alloc] init];
    _searcher.delegate = self;
    
    [self searchInfoWithCity:_city keyword:_keyword];
}

/** 加载广告 */
-(void)loadData {
    DS_AdvertModel * advert1 = [[DS_AdvertShare share] advertModelWithAdvertID:@"17"];
    if (advert1 != nil) {
        // 判断第1位是否为广告，如果不是则插入
        if (![[self.response firstObject] isKindOfClass:[DS_AdvertModel class]]) {
            [self.response insertObject:advert1 atIndex:0];
        }
    }
    
    DS_AdvertModel * advert2 = [[DS_AdvertShare share] advertModelWithAdvertID:@"18"];
    if (advert2 != nil) {
        if (self.response.count > 5) {
            // 如果数组大于6位，则判断第6位是否为广告，如果不是则插入
            if (![[self.response objectAtIndex:6] isKindOfClass:[DS_AdvertModel class]]) {
                [self.response insertObject:advert2 atIndex:6];
            }
        } else {
            // 如果数组小于6位，则判断最后一位是否为广告，如果不是则插入
            if (![[self.response lastObject] isKindOfClass:[DS_AdvertModel class]]) {
                [self.response addObject:advert2];
            }
            
        }
    }
}

#pragma mark - 界面
/** 视图布局 */
- (void)layoutView {
    //选项条
    SGPageTitleViewConfigure * configure = [SGPageTitleViewConfigure pageTitleViewConfigure];
    configure.bottomSeparatorColor = [UIColor clearColor];
    configure.titleFont = [UIFont systemFontOfSize:16];
    configure.titleColor = COLOR_Font121;
    configure.titleSelectedColor = COLOR_HOME;
    configure.indicatorColor = COLOR_HOME;
    configure.indicatorAnimationTime = 0.1;
    configure.titleSelectedFont = [UIFont systemFontOfSize:17];
    self.pageTitleView = [SGPageTitleView pageTitleViewWithFrame:CGRectMake(0, NAVIGATIONBAR_HEIGHT, self.view.width, 44) delegate:self titleNames:self.titleArr configure:configure];
    [self.view addSubview:self.pageTitleView];
    
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NAVIGATIONBAR_HEIGHT + 44, self.view.width, Screen_HEIGHT - NAVIGATIONBAR_HEIGHT - TABBAR_HEIGHT - 44) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
    // 刷新
    weakifySelf
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        strongifySelf
        _page = 0;
        [self searchInfoWithCity:_city keyword:_keyword];
    }];
    
    // 加载
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        strongifySelf
        _page++;
        [self searchInfoWithCity:_city keyword:_keyword];

    }];
}

#pragma mark - 代理
- (void)pageTitleView:(SGPageTitleView *)pageTitleView selectedIndex:(NSInteger)selectedIndex {
    _city = self.titleArr[selectedIndex];
    _page = 0;
    [self searchInfoWithCity:_city keyword:_keyword];
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
        DS_MapViewController * mapView = [[DS_MapViewController alloc]init];
        mapView.hidesBottomBarWhenPushed = YES;
        mapView.imageUrl = [NSString stringWithFormat:@"http://api.map.baidu.com/panorama/v2?ak=TS9nyRMSTDTX3RRMgWGsL0WivcEcUvLM&location=%lf,%lf&poiid=%@",poiInfo.pt.longitude,poiInfo.pt.latitude,poiInfo.uid];
        mapView.longitude = poiInfo.pt.longitude;
        mapView.latitude = poiInfo.pt.latitude;
        mapView.typeName = poiInfo.name;
        [self.navigationController pushViewController:mapView animated:YES];
    }
}

#pragma mark - 百度地图相关操作
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
