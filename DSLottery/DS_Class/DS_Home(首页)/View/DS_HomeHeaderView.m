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
#import "SGPagingView.h"

@interface DS_HomeHeaderView () <SDCycleScrollViewDelegate,SGPageTitleViewDelegate, SGPageContentViewDelegate>
{
    NSArray * _categoryNames;
    NSArray * _categoryIDs;
    
    NSMutableArray * _bannerURLs;
    NSMutableArray * _bannerImageURLs;
}

/** 选项条 */
@property (nonatomic, strong) SGPageTitleView   * pageTitleView;

/** 扩展按钮 */
@property (nonatomic, strong) UIButton          * extensionButton;

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
    _categoryNames = [[DS_CategoryShare share] newsCategoryNames];
    _categoryIDs = [[DS_CategoryShare share] newsCategoryIDs];
}

#pragma mark - 界面
/** 布局 */
- (void)layoutView {
    [self addSubview:self.pageTitleView];
    
    [self addSubview:self.extensionButton];
    
    UIView * line = [[UIView alloc] init];
    line.backgroundColor = COLOR_Line;
    line.frame = CGRectMake(_pageTitleView.right + 10, 5, 1, 30);
    [self addSubview:line];
    
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

/** 设置下标 */
- (void)setIndex:(NSInteger)index {
    _pageTitleView.selectedIndex = index;
    _pageTitleView.resetSelectedIndex = index;
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

/** 刷新分类 */
- (void)refreshCategory {
    // 标题
    _categoryNames = [[DS_CategoryShare share] newsCategoryNames];
    
    // ID
    _categoryIDs = [[DS_CategoryShare share] newsCategoryIDs];
    
    // 重新布局
    [_pageTitleView removeFromSuperview];
    _pageTitleView = nil;
    [self addSubview:self.pageTitleView];
}

#pragma mark - 按钮事件
/** 扩展按钮 */
- (void)extensionButtonAction:(UIButton *)sender {
    if (self.extensionBlock) {
        self.extensionBlock();
    }
}

#pragma mark - <SGPageTitleViewDelegate>
- (void)pageTitleView:(SGPageTitleView *)pageTitleView selectedIndex:(NSInteger)selectedIndex {
    if (self.categoryIDBlock) {
        self.categoryIDBlock(_categoryIDs[selectedIndex]);
    }
}

#pragma mark - <SDCycleScrollViewDelegate>
/** 轮播点击事件 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    NSArray * bannerModels = [[DS_AdvertShare share] bannerAdverts];
    DS_AdvertModel * advertModel = bannerModels[index];
    [DS_FunctionTool openAdvert:advertModel];
}

#pragma mark - 懒加载
- (SGPageTitleView *)pageTitleView {
    if (!_pageTitleView) {
        SGPageTitleViewConfigure *configure = [SGPageTitleViewConfigure pageTitleViewConfigure];
        configure.bottomSeparatorColor = [UIColor clearColor];
        configure.titleFont = [UIFont systemFontOfSize:16];
        configure.titleColor = COLOR_Font121;
        configure.titleSelectedColor = COLOR_HOME;
        configure.indicatorColor = COLOR_HOME;
        configure.indicatorAnimationTime = 0.1;
        configure.titleSelectedFont = [UIFont systemFontOfSize:17];
        
        _pageTitleView = [SGPageTitleView pageTitleViewWithFrame:CGRectMake(0, 0, self.width - 70, 40) delegate:self titleNames:_categoryNames configure:configure];
        _pageTitleView.backgroundColor = [UIColor whiteColor];
    }
    return _pageTitleView;
}

- (UIButton *)extensionButton {
    if (!_extensionButton) {
        _extensionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _extensionButton.frame = CGRectMake(self.width - 25 - 15, (_pageTitleView.height - 23) / 2, 25, 23);
        [_extensionButton setImage:[UIImage imageNamed:@"category_more"] forState:UIControlStateNormal];
        [_extensionButton addTarget:self action:@selector(extensionButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _extensionButton;
}

- (SDCycleScrollView *)advertScrollView {
    if (!_advertScrollView) {
        _advertScrollView = [[SDCycleScrollView alloc] initWithFrame:CGRectMake(0, _pageTitleView.bottom, self.width, 130)];
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
        [labaImage setImage:[UIImage imageNamed:@"gift"]];
        [_noticeScrollView addSubview:labaImage];
        [labaImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.centerY.mas_equalTo(_noticeScrollView);
            make.width.height.mas_equalTo(16);
        }];
    }
    return _noticeScrollView;
}

@end
