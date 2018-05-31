//
//  DS_ChartsViewController.m
//  DSLottery
//
//  Created by 黄玉洲 on 2018/5/9.
//  Copyright © 2018年 海南达生实业有限公司. All rights reserved.
//

#import "DS_ChartsViewController.h"

/** viewController */
#import "DSLotteryChartsDrawViewController.h"
#import "DS_LotteryListViewController.h"

/** share */
#import "DS_AdvertShare.h"

/** view */
#import "DS_AdvertView.h"

@interface DS_ChartsViewController ()
{
    // 彩种ID
    NSString * _playGroupId;
}
@property (strong, nonatomic) UIImageView   * lotteryImageView;

@property (strong, nonatomic) DS_AdvertView * advertView;

@end

@implementation DS_ChartsViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self requestAdvert];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initData];
    [self layoutView];
}

#pragma mark - 数据
- (void)initData {
    _playGroupId = @"1";
}

#pragma mark - 界面
- (void)layoutView {
    self.navigationBarImage = DS_UIImageName(@"chats_icon");
    UIButton * rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, 80, 30);
    [rightButton setTitle:DS_STRINGS(@"kBuyLottery") forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rightButton.titleLabel.font = FONT(16.0f);
    rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    rightButton.hidden = YES;
    [rightButton addTarget:self action:@selector(rightButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self navRightItem:rightButton];
    
    UIScrollView * scrollView = [[UIScrollView alloc] init];
    [self.view addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(Screen_HEIGHT - NAVIGATIONBAR_HEIGHT - TABBAR_HEIGHT);
        make.top.mas_equalTo(NAVIGATIONBAR_HEIGHT);
    }];
    
    UIView * containView = [[UIView alloc] init];
    [scrollView addSubview:containView];
    [containView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(scrollView);
        make.width.mas_equalTo(scrollView);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    // 顶部背景容器
    UIImageView * topBackView = [[UIImageView alloc] init];
    topBackView.userInteractionEnabled = YES;
    topBackView.image = DS_UIImageName(@"charts_back");
    [containView addSubview:topBackView];
    [topBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(containView);
        make.width.mas_equalTo(IOS_SiZESCALE(315));
        make.top.mas_equalTo(scrollView).offset(20);
        make.height.mas_equalTo(IOS_SiZESCALE(450));
    }];
    
    // 彩种图标
    [topBackView addSubview:self.lotteryImageView];
    [_lotteryImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(topBackView);
        make.top.mas_equalTo(IOS_SiZESCALE(20));
        make.width.mas_equalTo(IOS_SiZESCALE(83));
        make.height.mas_equalTo(IOS_SiZESCALE(75));
    }];
    
    // 广告
    [containView addSubview:self.advertView];
    [_advertView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(containView);
        make.top.mas_equalTo(topBackView.mas_bottom).offset(20);
        make.height.mas_equalTo(DS_AdvertViewHeight);
        make.bottom.mas_equalTo(containView.mas_bottom);
    }];
    
    [self addChartsButtonInSuperView:topBackView];
}

/** 添加走势类型按钮 */
- (void)addChartsButtonInSuperView:(UIView *)superView {
    NSArray * icons = @[@"hmzs", @"dwzs", @"kdzs", @"cszs", @"hzzs", @"jozs", @"dxzs", @"hwzs"];
    NSArray * titles = @[@"号码走势", @"定位走势", @"跨度走势", @"除三余走势", @"和值走势", @"奇偶走势", @"大小走势", @"和尾走势"];
    
    CGFloat x, y = 0;
    CGFloat width = IOS_SiZESCALE(315) / 3.0;
    CGFloat height = IOS_SiZESCALE(70);
    for (NSInteger i = 0; i < [icons count]; i++) {
        NSInteger row = i / 3;
        x =  (i % 3) * width;
        y =  IOS_SiZESCALE(120) + row * height + row * IOS_SiZESCALE(30);
        
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:@selector(operationButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 1000 + i;
        [superView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(x);
            make.top.mas_equalTo(y);
            make.width.mas_equalTo(width);
            make.height.mas_equalTo(height);
        }];
        
        UIImage * image = DS_UIImageName(icons[i]);
        UIImageView * imageView = [[UIImageView alloc] init];
        imageView.image = DS_UIImageName(icons[i]);
        [button addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(image.size.height);
            make.width.mas_equalTo(image.size.width);
            make.top.mas_equalTo(0);
            make.centerX.mas_equalTo(button);
        }];
        
        UILabel * label = [[UILabel alloc] init];
        label.font = FONT(13.0f);
        label.text = titles[i];
        label.textAlignment = NSTextAlignmentCenter;
        [button addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(20);
            make.bottom.mas_equalTo(0);
            make.left.right.mas_equalTo(0);
        }];
    }
}

#pragma mark- 网络请求
/* 请求广告 */
-(void)requestAdvert{
    /* 没有广告的情况的再去请求 */
    if ([[DS_AdvertShare share] advertCount] == 0) {
        weakifySelf
        [[DS_AdvertShare share] requestAdvertListComplete:^(id object) {
            strongifySelf
            if (Request_Success(object)) {
                [self loadData];
            }
        } fail:^(NSError *failure) {
            
        }];
    }else{
        [self loadData];
    }
}
/* 加载广告 */
- (void)loadData {
    // 获取广告
    NSArray <DS_AdvertModel *> * chartsAdverts = [[DS_AdvertShare share] chartsAdverts];
    
    if ([chartsAdverts count] > 0) {
        _advertView.model = [chartsAdverts firstObject];
        _advertView.hidden = NO;
    }
}

#pragma mark - 按钮
- (void)leftButtonAction:(UIButton *)sender {
    
}

- (void)rightButtonAction:(UIButton *)sender {
    
}

- (void)operationButtonAction:(UIButton *)sender {
    DSLotteryChartsDrawViewController * vc = [[DSLotteryChartsDrawViewController alloc] init];
    switch (sender.tag - 1000) {
        case 0: { // 号码走势
            vc.chartType = DSChartsBasicType;
            break;
        }
        case 1: { // 定位走势
            vc.chartType = DSChartsLocationType;
            break;
        }
        case 2: { // 跨度走势
            vc.chartType = DSChartsSpadType;
            break;
        }
        case 3: { // 除三余走势
            vc.chartType = DSChartsThreeType;
            break;
        }
        case 4: { // 和值走势
            vc.chartType = DSChartsHezhiType;
            break;
        }
        case 5: { // 奇偶走势
            vc.chartType = DSChartsJiouType;
            break;
        }
        case 6: { // 大小走势
            vc.chartType = DSChartsDaxiaoType;
            break;
        }
        case 7: { // 和尾走势
            vc.chartType = DSChartsHeweiType;
            break;
        }
        default:
            break;
    }
    vc.playGroupId = _playGroupId;
    vc.isMeCharts = (sender.tag - 1000) > 3 ? YES : NO;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 手势
- (void)titleTapAction:(UITapGestureRecognizer *)tapGesture {
    DS_LotteryListViewController * vc = [[DS_LotteryListViewController alloc] init];
    DS_BaseNavigationController * nav = [[DS_BaseNavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
    
    weakifySelf
    vc.selectLotteryBlock = ^(NSString *lotterID) {
        strongifySelf
        _playGroupId = lotterID;
        self.lotteryImageView.image = DS_UIImageName([DS_FunctionTool lotteryIconWithLotteryID:lotterID]);
    };
}

#pragma mark - 懒加载
- (UIImageView *)lotteryImageView {
    if (!_lotteryImageView) {
        _lotteryImageView = [[UIImageView alloc] init];
        _lotteryImageView.image = DS_UIImageName(@"chongqing");
    }
    return _lotteryImageView;
}

- (DS_AdvertView *)advertView {
    if (!_advertView) {
        _advertView = [[DS_AdvertView alloc] init];
        _advertView.hidden = YES;
    }
    return _advertView;
}

@end

