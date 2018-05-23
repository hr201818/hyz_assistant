//
//  DS_NewsDetailViewController.m
//  DSLottery
//
//  Created by 黄玉洲 on 2018/5/12.
//  Copyright © 2018年 海南达生实业有限公司. All rights reserved.
//

#import "DS_NewsDetailViewController.h"

/** share */
#import "DS_AdvertShare.h"

/** viewModel */
#import "DS_NewsDetailViewModel.h"

/** view */
#import "DS_NewsHeaderView.h"

@interface DS_NewsDetailViewController ()

@property (strong, nonatomic) UITableView * tableView;



/** 头视图 */
@property (strong, nonatomic) DS_NewsHeaderView * headerView;

@property (strong, nonatomic) DS_NewsDetailViewModel * viewModel;

@end

@implementation DS_NewsDetailViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (_tableView) {
        [_tableView reloadData];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self registerNotice];

    /** 初始化数据 */
    [self initData];

    /* 视图布局 */
    [self layoutView];
}

#pragma mark - 数据
- (void)initData {
    _viewModel = [[DS_NewsDetailViewModel alloc] initWithModel:_model models:_models];
    
    // 请求增加文章阅读数
    [self requestReadNews];

    weakifySelf
    _viewModel.supportBlock = ^(DS_NewsModel *model) {
        strongifySelf
        [self requestSupportNews];
    };
    
    _viewModel.childVCBlock = ^(DS_NewsModel *model, NSMutableArray<DS_NewsModel *> *models) {
        strongifySelf
        DS_NewsDetailViewController * vc = [[DS_NewsDetailViewController alloc] init];
        vc.model = model;
        vc.models = models;
        [self.navigationController pushViewController:vc animated:YES];
    };
}

/** 请求阅读资讯 */
- (void)requestReadNews {
    [_viewModel requestReadNewsComplete:^(id object) {

    } fail:^(NSError *failure) {

    }];
}

/** 请求点赞资讯 */
- (void)requestSupportNews {
    [self showhud];
    [_viewModel requestSupportNewsComplete:^(id object) {
        if (Request_Success(object)) {
            [self hidehud];
        } else {
            [self showMessagetext:@"请重试"];
        }
    } fail:^(NSError *failure) {
        Request_Error_tip
    }];
}

#pragma mark - 界面
/** 布局 */
-(void)layoutView{

    self.title = DS_STRINGS(@"kNewsDetail");

    UIButton * leftButton = [DS_FunctionTool leftNavBackTarget:self Item:@selector(leftButtonAction:)];
    [self navLeftItem:leftButton];

    UIButton * rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setTitle:DS_STRINGS(@"kLotteryHall") forState:UIControlStateNormal];
    rightButton.frame = CGRectMake(0, 0, 70, 30);
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:15];
    rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [rightButton addTarget:self action:@selector(rightButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self navRightItem:rightButton];

    //首页列表
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NAVIGATIONBAR_HEIGHT, Screen_WIDTH, Screen_HEIGHT - NAVIGATIONBAR_HEIGHT) style:UITableViewStylePlain];
    self.tableView.delegate = _viewModel;
    self.tableView.dataSource = _viewModel;
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.view addSubview:self.tableView];

    self.tableView.tableHeaderView = self.headerView;
}

#pragma mark - 按钮事件
/** 左侧按钮事件 */
- (void)leftButtonAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

/** 右侧按钮事件 */
- (void)rightButtonAction:(UIButton *)sender {
    [[DS_AdvertShare share] openFirstAdvert];
}

#pragma mark - 通知
/** 注册通知 */
- (void)registerNotice {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(praiseAndReadChange:) name:@"praise_read_number" object:nil];
}

/** 通知事件 */
- (void)praiseAndReadChange:(NSNotification *)notifi {
    DS_NewsModel * model = (DS_NewsModel *)notifi.object;
    [_headerView setThumbNumber:model.thumbsUpNumb];
    [_headerView setReadNumber:model.readerNumb];
    [_viewModel processNews:model];
    [self.tableView reloadData];
}

#pragma mark - 懒加载
- (DS_NewsHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[DS_NewsHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 95) model:_model];
    }
    return _headerView;
}


@end
