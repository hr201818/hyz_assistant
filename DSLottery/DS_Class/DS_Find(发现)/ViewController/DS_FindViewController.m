//
//  DS_FindViewController.m
//  DSLottery
//
//  Created by 黄玉洲 on 2018/5/9.
//  Copyright © 2018年 海南达生实业有限公司. All rights reserved.
//

#import "DS_FindViewController.h"

/** share */
#import "DS_AdvertShare.h"

/** viewModel */
#import "DS_FindViewModel.h"

@interface DS_FindViewController ()

@property (strong, nonatomic) DS_FindViewModel * viewModel;

@property (strong, nonatomic) UITableView * tableView;

@end

@implementation DS_FindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _viewModel = [[DS_FindViewModel alloc] init];
    [self layoutView];
    [self requestLotteryNotice];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //    [_viewModel resetData];
    //    [_tableView reloadData];
}

#pragma mark - 初始化
- (void)layoutView {
    self.title = @"发现";
    
    [self.view addSubview:self.tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(NAVIGATIONBAR_HEIGHT);
        make.bottom.mas_equalTo(-TABBAR_HEIGHT);
    }];
}

#pragma mark - 数据请求
/**
 请求开奖公告
 */
- (void)requestLotteryNotice {
    [self showhud];
    weakifySelf
    [_viewModel requestLotteryNoticeComplete:^(id object) {
        strongifySelf
        [self.tableView reloadData];
        [self hidehud];
        [self requestAdvert];
        [self.tableView.mj_header endRefreshing];
    } fail:^(NSError *failure) {
        strongifySelf
        [self hidehud];
        [self.tableView.mj_header endRefreshing];
    }];
}

/** 请求广告 */
- (void)requestAdvert {
    /* 没有广告的情况的再去请求 */
    if ([[DS_AdvertShare share] advertCount] == 0) {
        weakifySelf
        [[DS_AdvertShare share] requestAdvertListComplete:^(id object) {
            strongifySelf
            if (Request_Success(object)) {
                [_viewModel resetData];
                [self.tableView reloadData];
            }
        } fail:^(NSError *failure) {
            
        }];
    }else{
        [_viewModel resetData];
        [self.tableView reloadData];
    }
}

#pragma mark - 懒加载
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.tableFooterView = [UIView new];
        _tableView.delegate = _viewModel;
        _tableView.dataSource = _viewModel;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        weakifySelf
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            strongifySelf
            [self requestLotteryNotice];
        }];
    }
    return _tableView;
}

@end
