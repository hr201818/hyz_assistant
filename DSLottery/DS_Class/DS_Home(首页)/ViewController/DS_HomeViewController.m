//
//  DS_HomeViewController.m
//  DSLottery
//
//  Created by 黄玉洲 on 2018/5/9.
//  Copyright © 2018年 海南达生实业有限公司. All rights reserved.
//

#import "DS_HomeViewController.h"
#import "UIButton+GraphicLayout.h"

/** viewController */
#import "DS_UserViewController.h"

/** model */
#import "DS_HomeViewModel.h"
#import "DS_NewsListModel.h"

/** share */
#import "DS_AdvertShare.h"
#import "DS_CategoryShare.h"

/** view */
#import "DS_HomeHeaderView.h"
#import "DS_NewsCategoryView.h"

@interface DS_HomeViewController ()

/** 资讯种类ID */
@property (copy, nonatomic)   NSString          * categoryID;

/** 视图模型 */
@property (strong, nonatomic) DS_HomeViewModel  * viewModel;

/** 列表头视图 */
@property (strong, nonatomic) DS_HomeHeaderView * headerView;

/* 首页列表 */
@property (strong, nonatomic) UITableView       * tableView;

@end

@implementation DS_HomeViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self registerNotice];
    [self initData];
    [self layoutView];
}

#pragma mark - 初始化
- (void)initData {
    _viewModel = [[DS_HomeViewModel alloc] init];
    
    [self requestAdvert];
    
    [self requestNotice];
    
    [self requestCategoryOpenMore:NO];
    
    [self requestNewsWithIsRefresh:YES];
}

#pragma mark - 界面
/** 布局 */
- (void)layoutView {
    self.title = DS_STRINGS(@"kHomeTitle");
    
    // 购彩中心
    UIButton * leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, 80, 30);
    [leftButton setImage:[UIImage imageNamed:@"left_icon"] forState:UIControlStateNormal];
    [leftButton setTitle:DS_STRINGS(@"kLotteryHall") forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(leftButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    leftButton.titleLabel.font = FONT(15.0f);
    [leftButton setImagePosition:DS_ImagePositionLeft spacing:5];
    [self navLeftItem:leftButton];
    
    // 个人中心
    UIButton * rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 80, 30);
    [rightBtn setTitle:@"个人中心" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [rightBtn addTarget:self action:@selector(rightButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self navRightItem:rightBtn];
    
    [self.view addSubview:self.tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(NAVIGATIONBAR_HEIGHT);
        make.bottom.mas_equalTo(-TABBAR_HEIGHT);
        make.left.right.mas_equalTo(0);
    }];
}

/** 打开更多资讯分类 */
- (void)openMoreNewsCategory {
    DS_NewsCategoryView * newCategoryView = [[DS_NewsCategoryView alloc] initWithFrame:CGRectMake(0, 0, Screen_WIDTH, Screen_HEIGHT)];
    newCategoryView.newsCategorys = [[DS_CategoryShare share] newsCategorys];
    [KeyWindows addSubview:newCategoryView];
    
    // 更多分类中，点击了分类后的操作
    weakifySelf
    newCategoryView.newsCategoryBlock = ^(NSString *newsCategoryID) {
        strongifySelf
        // 当点击的分类与当前不同时才执行
        if (![self.categoryID isEqual:newsCategoryID]) {
            self.categoryID = newsCategoryID;
            // 改变资讯分类滚动条的选中状态
            NSInteger index = [[DS_CategoryShare share] newsCategoryIndexWithID:newsCategoryID];
            [_headerView setIndex:index];
            // 请求新的资讯内容
            [self requestNewsWithIsRefresh:YES];
        }
    };
}

#pragma mark - 数据请求
/** 请求广告数据 */
- (void)requestAdvert {
    if ([[DS_AdvertShare share] advertCount] > 0) {
        return;
    }
    // 请求广告
    [[DS_AdvertShare share] requestAdvertListComplete:^(id object) {;
        if (Request_Success(object)) {
            [self.headerView refreshBanner];
        }
    } fail:^(NSError *failure) {
        
    }];
}

/** 请求公告数据 */
- (void)requestNotice {
    weakifySelf
    [_viewModel requestNoticeComplete:^(id object) {
        strongifySelf
        if (Request_Success(object)) {
            [self.headerView setNoticeCycleArray:[_viewModel noticeList]];
        }
    } fail:^(NSError *failure) {
        
    }];
}

/**
 请求分类
 @param isOpen 是否打开更多分类
 */
- (void)requestCategoryOpenMore:(BOOL)isOpen {
    weakifySelf
    [[DS_CategoryShare share] requestCategoryListComplete:^(id object) {
        strongifySelf
        if (Request_Success(object)) {
            [self.headerView refreshCategory];
        }
    } fail:^(NSError *failure) {
        
    }];
}

/**
 请求首页资讯
 @param isRefresh 是否刷新
 */
- (void)requestNewsWithIsRefresh:(BOOL)isRefresh {
    [self showhud];
    weakifySelf
    [_viewModel requestNewsWithIsRefresh:isRefresh categoryID:_categoryID complete:^(id object, BOOL more) {
        strongifySelf
        [self.tableView reloadData];
        if (isRefresh) {
            [self.tableView.mj_header endRefreshing];
        } else {
            // 有更多数据
            if (more) {
                [self.tableView.mj_footer endRefreshing];
            } else {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        }
        [self hidehud];
    } fail:^(NSError *failure) {
        Request_Error_tip
        [self.tableView.mj_footer endRefreshing];
    }];
}

#pragma mark - 通知
/** 注册通知 */
- (void)registerNotice {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(praiseAndReadChange:) name:@"praise_read_number" object:nil];
}

/** 通知事件 */
- (void)praiseAndReadChange:(NSNotification *)notifi {
    DS_NewsModel * newsModel = (DS_NewsModel *)notifi.object;
    [_viewModel processNewNews:newsModel];
    [_tableView reloadData];
}

#pragma mark - public
/** 搜索指定彩种的资讯 */
- (void)searchNewsWithLotteryID:(NSString *)lotteryID {
    _categoryID = [[DS_CategoryShare share] categoryIDWithLotteryID:lotteryID];
    [self requestNewsWithIsRefresh:YES];
    NSInteger index = [[DS_CategoryShare share] newsCategoryIndexWithID:_categoryID];
    [_headerView setIndex:index];
}

#pragma mark - 按钮事件
- (void)leftButtonAction:(UIButton *)sender {
    [[DS_AdvertShare share] openFirstAdvert];
}

- (void)rightButtonAction:(UIButton *)sender {
    DS_UserViewController * vc = [[DS_UserViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 懒加载
- (DS_HomeHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[DS_HomeHeaderView alloc] initWithFrame:CGRectMake(0, 0, Screen_WIDTH, 205)];
        
        weakifySelf
        _headerView.categoryIDBlock = ^(NSString * categoryID) {
            strongifySelf
            if (![self.categoryID isEqual:categoryID]) {
                self.categoryID = categoryID;
                [self requestNewsWithIsRefresh:YES];
                [self requestAdvert];
                [self requestNotice];
            }
        };
        
        /** 扩展按钮点击 */
        _headerView.extensionBlock = ^{
            strongifySelf
            if ([[[DS_CategoryShare share] newsCategoryIDs] count] > 0) {
                [self openMoreNewsCategory];
            } else {
                [self requestCategoryOpenMore:YES];
            }
        };
    }
    return _headerView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NAVIGATIONBAR_HEIGHT, Screen_WIDTH, Screen_HEIGHT - NAVIGATIONBAR_HEIGHT - TABBAR_HEIGHT) style:UITableViewStylePlain];
        _tableView.delegate = _viewModel;
        _tableView.dataSource = _viewModel;
        _tableView.backgroundColor =[UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        _tableView.tableHeaderView = self.headerView;
        
        //刷新
        weakifySelf
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            strongifySelf
            [self requestAdvert];
            [self requestNotice];
            [self requestNewsWithIsRefresh:YES];
        }];
        
        // 加载
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [self requestNewsWithIsRefresh:NO];
        }];
    }
    return _tableView;
}

@end
