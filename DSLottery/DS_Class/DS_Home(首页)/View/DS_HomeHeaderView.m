//
//  DS_HomeHeaderView.m
//  ALLTIMELOTTERY
//
//  Created by 黄玉洲 on 2018/5/4.
//  Copyright © 2018年 科技有限公司. All rights reserved.
//

#import "DS_HomeHeaderView.h"

/** share */
#import "DS_AdvertShare.h"
#import "DS_CategoryShare.h"

/** view */
#import "SDCycleScrollView.h"

@interface DS_HomeHeaderView () <SDCycleScrollViewDelegate>
{
    NSMutableArray * _bannerURLs;
    NSMutableArray * _bannerImageURLs;
}

/** 广告轮播图 */
@property (strong, nonatomic) SDCycleScrollView * advertScrollView;

/** 公告轮播 */
@property (strong, nonatomic) SDCycleScrollView * noticeScrollView;

@end

@implementation DS_HomeHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        [self initData];
        [self layoutView];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

#pragma mark - 数据
/** 初始化数据 */
- (void)initData {
    
}

#pragma mark - 界面
/** 布局 */
- (void)layoutView {
    
    [self addSubview:self.advertScrollView];
    
    [self addSubview:self.noticeScrollView];
    
    UIView * bottomLine = [[UIView alloc] init];
    bottomLine.backgroundColor = COLOR_BACK;
    [self addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(_noticeScrollView.mas_bottom);
    }];
}

#pragma mark - 数据设置
/** 设置公告轮播 */
- (void)setNoticeCycleArray:(NSArray *)notices {
    if (notices.count > 0) {
        _noticeScrollView.titlesGroup = notices;
    }
}

#pragma mark - 界面
/** 刷新轮播图 */
- (void)refreshBanner {
    // 轮播点击后的跳转链接数组
    if (!_bannerURLs) {
        _bannerURLs = [NSMutableArray array];
    }
    if ([_bannerURLs count] > 0) {
        [_bannerURLs removeAllObjects];
    }
    
    // 轮播图的链接数组
    if (!_bannerImageURLs) {
        _bannerImageURLs = [NSMutableArray array];
    }
    if ([_bannerImageURLs count] > 0) {
        [_bannerImageURLs removeAllObjects];
    }
    
    // 进行轮播界面的数据更新和界面刷新
    NSArray <DS_AdvertModel *> * advertModels = [[DS_AdvertShare share] bannerAdverts];
    for (DS_AdvertModel * model in advertModels) {
        [_bannerURLs addObject:model.advertisUrl];
        [_bannerImageURLs addObject:model.imageURL];
    }
    _advertScrollView.imageURLStringsGroup = _bannerImageURLs;
}

/**
 设置自动轮播
 @param autoScroll 是否自动轮播
 */
- (void)setAutoScroll:(BOOL)autoScroll {
    _advertScrollView.autoScroll = autoScroll;
    _noticeScrollView.autoScroll = autoScroll;
}

#pragma mark - <SDCycleScrollViewDelegate>
/** 轮播点击事件 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    NSArray * bannerModels = [[DS_AdvertShare share] bannerAdverts];
    DS_AdvertModel * advertModel = bannerModels[index];
    [DS_FunctionTool openAdvert:advertModel];
}

#pragma mark - 懒加载
- (SDCycleScrollView *)advertScrollView {
    if (!_advertScrollView) {
        _advertScrollView = [[SDCycleScrollView alloc] initWithFrame:CGRectMake(0, 0, self.width, 130)];
        _advertScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
        _advertScrollView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _advertScrollView.delegate = self;
        _advertScrollView.backgroundColor = [UIColor whiteColor];
    }
    return _advertScrollView;
}

- (SDCycleScrollView *)noticeScrollView {
    if (!_noticeScrollView) {
        _noticeScrollView = [[SDCycleScrollView alloc] initWithFrame:CGRectMake(0, _advertScrollView.bottom, self.width, 30)];
        
        _noticeScrollView.scrollDirection = UICollectionViewScrollDirectionVertical;
        _noticeScrollView.onlyDisplayText = YES;
        [_noticeScrollView disableScrollGesture];
        _noticeScrollView.userInteractionEnabled = NO;
        _noticeScrollView.titleLabelTextFont = [UIFont systemFontOfSize:15];
        _noticeScrollView.titleLabelBackgroundColor = [UIColor whiteColor];
        _noticeScrollView.titleLabelTextColor = COLOR_Font83;
        _noticeScrollView.backgroundColor = [UIColor whiteColor];
        
        UIImageView * labaImage = [[UIImageView alloc] init];
        [labaImage setImage:[UIImage imageNamed:@"notice_icon"]];
        [_noticeScrollView addSubview:labaImage];
        [labaImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.centerY.mas_equalTo(_noticeScrollView);
            make.width.height.mas_equalTo(20);
        }];
    }
    return _noticeScrollView;
}

@end
