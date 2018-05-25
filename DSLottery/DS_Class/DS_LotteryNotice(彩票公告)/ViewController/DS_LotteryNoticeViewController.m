//
//  DS_LotteryNoticeViewController.m
//  DSLottery
//
//  Created by 黄玉洲 on 2018/5/9.
//  Copyright © 2018年 海南达生实业有限公司. All rights reserved.
//

#import "DS_LotteryNoticeViewController.h"

/** share */
#import "DS_AdvertShare.h"

/** viewModel */
#import "DS_LotteryNoticeViewModel.h"

@interface DS_LotteryNoticeViewController ()

@property (strong, nonatomic) UITableView          * tableView;

@property (strong, nonatomic) DS_LotteryNoticeViewModel * viewModel;

@end

@implementation DS_LotteryNoticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self layoutView];
    [self requestLotteryNotice];
}

#pragma mark - 数据
- (void)initData {
    _viewModel = [[DS_LotteryNoticeViewModel alloc] init];
}

#pragma mark - 数据请求
/** 请求彩票公告 */
- (void)requestLotteryNotice {
    [self showhud];
    weakifySelf
    [_viewModel requestLotteryNoticeComplete:^(id object) {
       strongifySelf
        if (Request_Success(object)) {
            [self.tableView reloadData];
            [self requestAdvert];
            [self hidehud];
        } else {
            [self showMessagetext:@"请求失败"];
        }
        [self.tableView.mj_header endRefreshing];
    } fail:^(NSError *failure) {
        strongifySelf
        Request_Error_tip
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
                [_viewModel loadAdvertData];
                [self.tableView reloadData];
            }
        } fail:^(NSError *failure) {
            
        }];
    }else{
        [_viewModel loadAdvertData];
        [self.tableView reloadData];
    }
}

#pragma mark - 界面
/** 布局 */
- (void)layoutView {
    self.view.backgroundColor = COLOR_BACK;
    
    self.title = DS_STRINGS(@"kLotteryNotice");
    
    // 彩票公告列表
    [self.view addSubview:self.tableView];
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
}

#pragma mark - 按钮事件
- (void)rightButtonAction:(UIButton *)sender {
    [[DS_AdvertShare share] openFirstAdvert];
}

#pragma mark - 懒加载
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NAVIGATIONBAR_HEIGHT, Screen_WIDTH, Screen_HEIGHT - NAVIGATIONBAR_HEIGHT - TABBAR_HEIGHT) style:UITableViewStylePlain];
        _tableView.delegate = _viewModel;
        _tableView.dataSource = _viewModel;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        
        //刷新
        weakifySelf
        self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            strongifySelf
            [self requestLotteryNotice];
        }];
    }
    return _tableView;
}

@end
