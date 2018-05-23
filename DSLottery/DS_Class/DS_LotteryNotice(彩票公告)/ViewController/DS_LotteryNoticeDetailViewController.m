//
//  DS_LotteryNoticeDetailViewController.m
//  DSLottery
//
//  Created by 黄玉洲 on 2018/5/14.
//  Copyright © 2018年 海南达生实业有限公司. All rights reserved.
//

#import "DS_LotteryNoticeDetailViewController.h"

/** viewModel */
#import "DS_LotteryNoticeDetailViewModel.h"

/** share */
#import "DS_AdvertShare.h"

@interface DS_LotteryNoticeDetailViewController () <UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView * tableView;

@property (strong, nonatomic) DS_LotteryNoticeDetailViewModel * viewModel;

@end

@implementation DS_LotteryNoticeDetailViewController


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    
    // 布局视图
    [self layoutView];
    
    // 请求开奖信息
    [self requestLotteryNoticeDetail];
    
}

#pragma mark - 数据
/** 数据初始化 */
- (void)initData {
    _viewModel = [[DS_LotteryNoticeDetailViewModel alloc] init];
}

#pragma mark - 界面
/** 布局 */
- (void)layoutView {
    
    self.title = DS_STRINGS(@"kLotteryDetail");
    
    [self navLeftItem:[DS_FunctionTool leftNavBackTarget:self Item:@selector(leftButtonAction:)]];
    
    [self.view addSubview:self.tableView];
}

#pragma mark - 网络请求
/** 获得开奖详情列表 */
- (void)requestLotteryNoticeDetail {
    [self showhud];
    weakifySelf
    [_viewModel requestLotteryNoticeDetailWithLotteryID:_playGroupId complete:^(id object) {
        strongifySelf
        [self.tableView.mj_header endRefreshing];
        BOOL isPop = NO;
        if (Request_Success(object)) {
            if ([_viewModel lotteryCount] > 0) {
                // 获取广告
                [self hidehud];
                [self.tableView reloadData];
                [self requestAdvert];
            } else {
                [self showMessagetext:@"暂无相关数据"];
                isPop = YES;
            }
        } else {
            [self showMessagetext:@"请求失败"];
            isPop = YES;
        }
        if (isPop) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
    } fail:^(NSError *failure) {
        Request_Error_tip
    }];
}

/** 请求广告 */
- (void)requestAdvert {
    if ([[DS_AdvertShare share] advertCount] == 0) {
        weakifySelf
        [[DS_AdvertShare share] requestAdvertListComplete:^(id object) {
            strongifySelf
            [self.viewModel loadAdvertData];
            [self.tableView reloadData];
        } fail:^(NSError *failure) {
            
        }];
    } else {
        [self.viewModel loadAdvertData];
        [self.tableView reloadData];
    }
}

#pragma mark - 按钮事件
- (void)leftButtonAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 懒加载
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NAVIGATIONBAR_HEIGHT, Screen_WIDTH, Screen_HEIGHT - NAVIGATIONBAR_HEIGHT) style:UITableViewStylePlain];
        _tableView.delegate = _viewModel;
        _tableView.dataSource = _viewModel;
        _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        
        // 刷新
        weakifySelf
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            strongifySelf
            [self requestLotteryNoticeDetail];
        }];
    }
    return _tableView;
}


@end
