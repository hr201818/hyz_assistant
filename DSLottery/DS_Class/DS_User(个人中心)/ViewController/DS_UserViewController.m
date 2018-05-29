//
//  DS_UserViewController.m
//  DSLottery
//
//  Created by 黄玉洲 on 2018/5/9.
//  Copyright © 2018年 海南达生实业有限公司. All rights reserved.
//

#import "DS_UserViewController.h"

/** share */
#import "DS_AdvertShare.h"

/** view */
#import "DS_UserHeaderView.h"
#import "DS_AdvertView.h"
#import "DS_UserOperationView.h"

/** viewController */
#import "DS_WebViewController.h"
#import "DS_AboutViewController.h"
#import "DS_LoginViewController.h"
#import "DS_RegisterViewController.h"
#import "DS_VersionViewController.h"

/** viewModel */
#import "DS_UserViewModel.h"

@interface DS_UserViewController ()

@property (strong, nonatomic) UIScrollView * scrollView;

/** 头部按钮视图 */
@property (strong, nonatomic) DS_UserHeaderView * headerView;

/** 操作视图 */
@property (strong, nonatomic) DS_UserOperationView * operationView;

/** 广告视图 */
@property (strong, nonatomic) DS_AdvertView     * advertView_1;
@property (strong, nonatomic) DS_AdvertView     * advertView_2;

@property (strong, nonatomic) DS_UserViewModel  * viewModel;

@end

@implementation DS_UserViewController


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init {
    if ([super init]) {
    
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self requestAdvert];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _viewModel = [[DS_UserViewModel alloc] init];
    
    [self registerNotification];
    [self layoutView];
}

#pragma mark - 界面
- (void)layoutView {
    self.navigationBar.hidden = YES;
    self.title = DS_STRINGS(@"kPersonalTitle");
    self.view.backgroundColor = COLOR_BACK;
    
    [self.view addSubview:self.scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(Screen_HEIGHT - TABBAR_HEIGHT);
    }];
    
    UIView * view = [[UIView alloc] init];
    [_scrollView addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(_scrollView);
        make.width.mas_equalTo(_scrollView);
        make.height.mas_greaterThanOrEqualTo(@0.f); // 此处保证容器View高度的动态变化 大于等于0.f的高度
    }];
    
    [view addSubview:self.headerView];
    [_headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(view);
        make.top.mas_equalTo(view);
        make.height.mas_equalTo(IOS_SiZESCALE(305 / 2.0));
    }];
    
    [view addSubview:self.operationView];
    [_operationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_headerView.mas_bottom);
        make.left.right.mas_equalTo(view);
        make.height.mas_equalTo(IOS_SiZESCALE(190));
    }];
    
    [view addSubview:self.advertView_1];
    [_advertView_1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(view);
        make.top.mas_equalTo(_operationView.mas_bottom);
        make.height.mas_equalTo(DS_AdvertViewHeight);
    }];
    
    [view addSubview:self.advertView_2];
    [_advertView_2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(view);
        make.top.mas_equalTo(_advertView_1.mas_bottom).offset(-10);
        make.height.mas_equalTo(_advertView_1);
        make.bottom.mas_equalTo(view).offset(-10);// 设置与容器View底部高度固定，contentLabel高度变化的时候，由于设置了容器View的高度动态变化，底部距离固定。 此时contentView的高度变化之后，ScrollView的contentSize就发生了变化，适配文字内容，滑动查看超出屏幕文字。
    }];
}

#pragma mark- 网络请求
/* 请求广告 */
-(void)requestAdvert{
    /* 没有广告的情况的再去请求 */
    if ([[DS_AdvertShare share] advertCount] == 0) {
        weakifySelf
        [[DS_AdvertShare share] requestAdvertListComplete:^(id object) {
            strongifySelf
            if (Request_Success(object)) {
                [self loadData];
            }
        } fail:^(NSError *failure) {
            
        }];
    }else{
        [self loadData];
    }
}
/* 加载广告 */
-(void)loadData{
    // 非空判断，不然数组会闪退
    DS_AdvertModel * model_1 = [[DS_AdvertShare share] advertModelWithAdvertID:@"19"];
    DS_AdvertModel * model_2 = [[DS_AdvertShare share] advertModelWithAdvertID:@"20"];
    // 判断第一个广告是否存在，如果不存在就用第二个广告来代替,而第二个广告则不展示。
    // 否则，按正常的两个广告都展示
    if (model_1) {
        _advertView_1.model = model_1;
        _advertView_1.hidden = NO;
        if (model_2) {
            _advertView_2.model = model_2;
            _advertView_2.hidden = NO;
        } else {
            _advertView_2.hidden = YES;
        }
    } else {
        if (model_2) {
            _advertView_1.model = model_2;
            _advertView_1.hidden = NO;
        } else {
            _advertView_1.hidden = YES;
        }
    }
}

/** 请求注销 */
- (void)requestLogout {
    [self showhud];
    [[DS_UserShare share] logoutComplete:^(id result) {
        [self hidehud];
    } fail:^(NSError *failure) {
        [self hidehud];
    }];
}

#pragma mark - 通知
/** 注册通知 */
- (void)registerNotification {
    //接收登录注销通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notificationAction:) name:Login_Notice object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notificationAction:) name:Logout_Notice object:nil];
}

/** 通知事件 */
- (void)notificationAction:(NSNotification *)sender {
    [_headerView refreshView];
}

#pragma mark - 按钮事件
- (void)leftButtonAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - private
/** 客服 */
- (void)openCustomerService {
    [self showhud];
    [_viewModel requestCustomerServiceComplete:^(id object) {
        if (Request_Success(object)) {
            if (object[@"kefuUrl"]) {
                DS_WebViewController * vc = [[DS_WebViewController alloc] init];
                DS_BaseNavigationController * nav = [[DS_BaseNavigationController alloc] initWithRootViewController:vc];
                vc.webURLStr = object[@"kefuUrl"];
                [self presentViewController:nav animated:YES completion:nil];
            }
            [self hidehud];
        } else {
            [self showMessagetext:@"未获取客服地址"];
        }
    } fail:^(NSError *failure) {
        Request_Error_tip
    }];
}

/** 关于我们 */
- (void)openAbountWe {
    DS_AboutViewController * AboutVC = [[DS_AboutViewController alloc]init];
    [self.navigationController pushViewController:AboutVC animated:YES];
}

/** 版本记录 */
- (void)openVersion {
    DS_VersionViewController * versionVC = [[DS_VersionViewController alloc]init];
    [self.navigationController pushViewController:versionVC animated:YES];
}

/** 清理缓存 */
- (void)openCache {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"当前有%.2fM缓存,确定要清除吗？",[DS_FunctionTool getCacheSize]] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [DS_FunctionTool clearCache];
        [self hudSuccessText:@"清理成功"];
    }];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:defaultAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

/** 登录 */
- (void)openLogin {
    DS_LoginViewController * loginVC = [[DS_LoginViewController alloc] init];
    loginVC.isPresent = YES;
    DS_BaseNavigationController * nav = [[DS_BaseNavigationController alloc] initWithRootViewController:loginVC];
    [self presentViewController:nav animated:YES completion:nil];
}

/** 注册 */
- (void)openRegister {
    DS_RegisterViewController * registerVC = [[DS_RegisterViewController alloc]init];
    [self.navigationController pushViewController:registerVC animated:YES];
}

/** 询问注销 */
-(void)askLogout {
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
}

#pragma mark - 懒加载
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        NSString *version = [UIDevice currentDevice].systemVersion;
        if (version.doubleValue >= 11.0) {
            // 针对 11.0 以上的iOS系统进行处理
            _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _scrollView;
}

- (DS_UserHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[DS_UserHeaderView alloc] init];

        weakifySelf
        _headerView.loginOrLogoutBlock = ^{
            strongifySelf
            if ([DS_UserShare share].userID) {
                [self askLogout];
            } else {
                [self openLogin];
            }
        };
    }
    return _headerView;
}

- (DS_UserOperationView *)operationView {
    if (!_operationView) {
        _operationView = [[DS_UserOperationView alloc] init];
        
        weakifySelf
        _operationView.operationBlock = ^(DS_OperationType type) {
            strongifySelf
            switch (type) {
                case DS_OperationType_CustomerService:
                    [self openCustomerService];
                    break;
                case DS_OperationType_AboutWe:
                    [self openAbountWe];
                    break;
                case DS_OperationType_Version:
                    [self openVersion];
                    break;
                case DS_OperationType_Cache:
                    [self openCache];
                    break;
                default:
                    break;
            }
        };
    }
    return _operationView;
}

- (DS_AdvertView *)advertView_1 {
    if (!_advertView_1) {
        _advertView_1 = [[DS_AdvertView alloc] init];
        _advertView_1.hidden = YES;
    }
    return _advertView_1;
}

- (DS_AdvertView *)advertView_2 {
    if (!_advertView_2) {
        _advertView_2 = [[DS_AdvertView alloc] init];
        _advertView_2.hidden = YES;
    }
    return _advertView_2;
}

@end
