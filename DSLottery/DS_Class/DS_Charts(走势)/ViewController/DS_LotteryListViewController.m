//
//  DS_LotteryListViewController.m
//  DSLottery
//
//  Created by 黄玉洲 on 2018/5/28.
//  Copyright © 2018年 海南达生实业有限公司. All rights reserved.
//

#import "DS_LotteryListViewController.h"

/** viewModel */
#import "DS_LotteryListViewModel.h"
@interface DS_LotteryListViewController ()

@property (strong, nonatomic) UITableView * tableView;

@property (strong, nonatomic) DS_LotteryListViewModel * viewModel;

@end

@implementation DS_LotteryListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self layoutView];
}

#pragma mark - 数据
/** 数据初始化 */
- (void)initData {
    _viewModel = [DS_LotteryListViewModel  new];
}

#pragma mark - 界面
/** 布局 */
- (void)layoutView {
    self.title = DS_STRINGS(@"kLotteryList");
    
    [self navLeftItem:[DS_FunctionTool leftNavBackTarget:self Item:@selector(leftButtonAction:)]];
    
    [self.view addSubview:self.tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(NAVIGATIONBAR_HEIGHT);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
}

#pragma mark - 按钮事件
- (void)leftButtonAction:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 懒加载
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.dataSource = _viewModel;
        _tableView.delegate = _viewModel;
        _tableView.tableFooterView = [UIView new];
        
        weakifySelf
        _viewModel.selectLotteryBlock = ^(NSString *lotterID) {
            strongifySelf
            if (self.selectLotteryBlock) {
                [self dismissViewControllerAnimated:YES completion:nil];
                self.selectLotteryBlock(lotterID);
            }
        };
    }
    return _tableView;
}
@end
