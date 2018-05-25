//
//  DS_NewsListViewController.m
//  DSLottery
//
//  Created by 黄玉洲 on 2018/5/25.
//  Copyright © 2018年 海南达生实业有限公司. All rights reserved.
//

#import "DS_NewsListViewController.h"
#import "DS_NewsListViewModel.h"

/** share */
#import "DS_CategoryShare.h"

/** view */
#import "DS_NewsCategoryView.h"

@interface DS_NewsListViewController ()

/** 资讯种类ID */
@property (copy, nonatomic)   NSString             * categoryID;

/** 资讯列表模型 */
@property (strong, nonatomic) DS_NewsListViewModel * viewModel;

/** 列表 */
@property (strong, nonatomic) UITableView * tableView;

@end

@implementation DS_NewsListViewController

- (instancetype)init {
    if ([super init]) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self layoutView];
}

#pragma mark - 数据
- (void)initData {
    _categoryID = @"";
    _viewModel = [[DS_NewsListViewModel alloc] init];
    [self requestNewsWithIsRefresh:YES];
//    [self requestCategoryOpenMore:NO];
}

#pragma mark - 数据请求
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

/**
 请求分类
 @param isOpen 是否打开更多分类
 */
- (void)requestCategoryOpenMore:(BOOL)isOpen {
    [self showhud];
    weakifySelf
    [[DS_CategoryShare share] requestCategoryListComplete:^(id object) {
        strongifySelf
        if (Request_Success(object)) {
            if (isOpen) {
                [self openMoreNewsCategory];
            }
            [self hidehud];
        } else {
            [self showMessagetext:Request_Description(object)];
        }
    } fail:^(NSError *failure) {
        Request_Error_tip;
    }];
}

#pragma mark - 界面
/** 布局 */
- (void)layoutView {
    self.title = DS_STRINGS(@"kLotteryNews");
    
    UIButton * leftButton = [DS_FunctionTool leftNavBackTarget:self Item:@selector(leftButtonAction:)];
    [self navLeftItem:leftButton];
    
    UIButton * rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setImage:DS_UIImageName(@"category_icon") forState:UIControlStateNormal];
    rightButton.frame = CGRectMake(0, 0, 48, 48);
    [rightButton addTarget:self action:@selector(rightButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self navRightItem:rightButton];
    rightButton.left = self.view.width - rightButton.width;
    
    [self.view addSubview:self.tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(NAVIGATIONBAR_HEIGHT);
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
            // 请求新的资讯内容
            [self requestNewsWithIsRefresh:YES];
        }
    };
}

#pragma mark - 按钮事件
/** 左侧按钮 */
- (void)leftButtonAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

/** 右侧按钮 */
- (void)rightButtonAction:(UIButton *)sender {
    if ([[DS_CategoryShare share] haveNetworkData]) {
        [self openMoreNewsCategory];
    } else {
        [self requestCategoryOpenMore:YES];
    }
}

#pragma mark - property
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.tableFooterView = [UIView new];
        _tableView.delegate = _viewModel;
        _tableView.dataSource = _viewModel;
        
        //刷新
        weakifySelf
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            strongifySelf
            [_tableView.mj_footer resetNoMoreData];
            [self requestNewsWithIsRefresh:YES];
        }];
        
        // 加载
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            strongifySelf
            [self requestNewsWithIsRefresh:NO];
        }];
    }
    return _tableView;
}

@end
