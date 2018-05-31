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
#import "DS_LoginViewController.h"

/** model */
#import "DS_HomeViewModel.h"
#import "DS_NewsListModel.h"

/** share */
#import "DS_AdvertShare.h"
#import "DS_CategoryShare.h"

/** view */
#import "DS_HomeHeaderView.h"

@interface DS_HomeViewController ()

/** 资讯种类ID */
@property (copy, nonatomic)   NSString          * categoryID;

/** 视图模型 */
@property (strong, nonatomic) DS_HomeViewModel  * viewModel;

/** 列表头视图 */
@property (strong, nonatomic) DS_HomeHeaderView * headerView;

/* 首页列表 */
@property (strong, nonatomic) UITableView       * tableView;

/** 导航栏按钮 */
@property (strong, nonatomic) UIButton          * leftButton;
@property (strong, nonatomic) UIButton          * rightButton;

@end

@implementation DS_HomeViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.rightButton.hidden = ![[DS_AdvertShare share] haveAdvertData];
    [_headerView setAutoScroll:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_headerView setAutoScroll:NO];
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
    
    [self requestLotteryNotice];
    
    [self requestNewsWithIsRefresh:YES];
    
    [self requestAreaLimit];
    
    [self requestGengxin];
}

#pragma mark - 界面
/** 布局 */
- (void)layoutView {
    
    self.navigationBarImage = DS_UIImageName(@"home_icon");
    
    // 左侧按钮
    [self navLeftItem:self.leftButton];
    
    // 右侧按钮
    [self navRightItem:self.rightButton];
    
    [self.view addSubview:self.tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(NAVIGATIONBAR_HEIGHT);
        make.height.mas_equalTo(Screen_HEIGHT - NAVIGATIONBAR_HEIGHT - TABBAR_HEIGHT);
        make.left.right.mas_equalTo(0);
    }];
    [self.tableView reloadData];
}

#pragma mark - 数据请求
/** 请求广告数据 */
- (void)requestAdvert {
    // 请求广告
    [[DS_AdvertShare share] requestAdvertListComplete:^(id object) {;
        if (Request_Success(object)) {
            self.rightButton.hidden = ![[DS_AdvertShare share] haveAdvertData];
            [self.headerView refreshBanner];
        }
    } fail:^(NSError *failure) {
        
    }];
}

/** 请求开奖公告 */
- (void)requestLotteryNotice {
    weakifySelf
    [_viewModel requestLotteryNoticeComplete:^(id object) {
        strongifySelf
        [self.tableView reloadData];
    } fail:^(NSError *failure) {
        Request_Error_tip
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
        Request_Error_tip
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
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

/** 请求注销 */
- (void)requestLogout {
    [self showhud];
    [[DS_UserShare share] logoutComplete:^(id result) {
        if (Request_Success(result) != YES &&
            Request_Code(result) != Request_Code_Timeout) {
            [self showMessagetext:Request_Description(result)];
        }
    } fail:^(NSError *failure) {
        Request_Error_tip;
    }];
}

/** 请求区域限制 */
- (void)requestAreaLimit {
    weakifySelf
    [[DS_AreaLimitShare share] requestCheckIPComplete:^{
        strongifySelf
        [self.headerView refreshBanner];
        [self.headerView setNoticeCycleArray:[_viewModel noticeList]];
        [self.tableView reloadData];
    } fail:^(NSError *failure) {
        strongifySelf
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self requestAreaLimit];
        });
    }];
}

/** 请求版本 */
- (void)requestGengxin {
    weakifySelf
    [[DS_AreaLimitShare share] requestGengxinComplete:^{
        
    } fail:^(NSError *failure) {
        strongifySelf
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self requestGengxin];
        });
    }];
}

#pragma mark - 通知
/** 注册通知 */
- (void)registerNotice {
    // 登录成功
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess) name:Login_Notice object:nil];
    
    // 注销成功
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutSuccess) name:Logout_Notice object:nil];

}

/** 登录成功 */
- (void)loginSuccess {
    [_leftButton setTitle:DS_STRINGS(@"kLogout") forState:UIControlStateNormal];
    [self showMessagetext:DS_STRINGS(@"kLoginSuccess")];
}

/** 注销成功 */
- (void)logoutSuccess {
    [_leftButton setTitle:DS_STRINGS(@"kLogin") forState:UIControlStateNormal];
    [self showMessagetext:DS_STRINGS(@"kLogoutSuccess")];
}

#pragma mark - 按钮事件
- (void)leftButtonAction:(UIButton *)sender {
    if ([DS_UserShare share].userID) {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定要退出登录吗?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if([DS_UserShare share].token){
                [self requestLogout];
            } else{
                [[DS_UserShare share] logoutSucceed];
            }
        }];
        UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:defaultAction];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        DS_LoginViewController * loginVC = [[DS_LoginViewController alloc] init];
        loginVC.isPresent = YES;
        DS_BaseNavigationController * nav = [[DS_BaseNavigationController alloc] initWithRootViewController:loginVC];
        [self presentViewController:nav animated:YES completion:nil];
    }
}

- (void)rightButtonAction:(UIButton *)sender {
    [[DS_AdvertShare share] openFirstAdvert];
}

#pragma mark - 懒加载
- (UIButton *)leftButton {
    if (!_leftButton) {
        _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftButton.frame = CGRectMake(0, 0, 80, 30);
        if ([DS_UserShare share].userID) {
            [_leftButton setTitle:DS_STRINGS(@"kLogout") forState:UIControlStateNormal];
        } else {
            [_leftButton setTitle:DS_STRINGS(@"kLogin") forState:UIControlStateNormal];
        }
        
        [_leftButton addTarget:self action:@selector(leftButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        _leftButton.titleLabel.font = FONT(16.0f);
    }
    return _leftButton;
}

- (UIButton *)rightButton {
    if (!_rightButton) {
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightButton.frame = CGRectMake(0, 0, 80, 30);
        [_rightButton setTitle:DS_STRINGS(@"kBuyLottery") forState:UIControlStateNormal];
        [_rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _rightButton.titleLabel.font = FONT(16.0f);
        _rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        _rightButton.hidden = YES;
        [_rightButton addTarget:self action:@selector(rightButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightButton;
}

- (DS_HomeHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[DS_HomeHeaderView alloc] initWithFrame:CGRectMake(0, 0, Screen_WIDTH, 158)];
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
            [self requestLotteryNotice];
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
