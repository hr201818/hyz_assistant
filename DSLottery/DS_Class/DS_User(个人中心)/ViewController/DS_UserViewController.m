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

/** viewController */
#import "DS_WebViewController.h"
#import "DS_AboutViewController.h"
#import "DS_LoginViewController.h"
#import "DS_RegisterViewController.h"
#import "DS_VersionViewController.h"

/** viewModel */
#import "DS_UserViewModel.h"

@interface DS_UserViewController ()

/** 头部按钮视图 */
@property (strong, nonatomic) DS_UserHeaderView * headerView;

/** 广告视图 */
@property (strong, nonatomic) DS_AdvertView     * advertView;

@property (strong, nonatomic) DS_UserViewModel  * viewModel;

@end

@implementation DS_UserViewController


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init {
    if ([super init]) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _viewModel = [[DS_UserViewModel alloc] init];
    
    [self registerNotification];
    [self layoutView];
    [self requestAdvert];
}

#pragma mark - 界面
- (void)layoutView {
    self.title = DS_STRINGS(@"kPersonalTitle");
    
    self.view.backgroundColor = COLOR_BACK;
    
    [self navLeftItem:[DS_FunctionTool leftNavBackTarget:self Item:@selector(leftButtonAction:)]];
    [self.view addSubview:self.headerView];
    
    [self.view addSubview:self.advertView];
    [_advertView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(156);
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
    DS_AdvertModel * model = [[DS_AdvertShare share] advertModelWithAdvertID:@"19"];
    if (model) {
        _advertView.model = model;
        _advertView.hidden = NO;
    } else {
        _advertView.hidden = YES;
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
/**
 头视图的按钮事件
 @param type 按钮类型
 */
- (void)headerViewButtonAction:(DS_UserHeaderViewButtonType)type {
    switch (type) {
        case DS_UserHeaderViewButtonType_Customer:
            [self openCustomerService]; break;
        case DS_UserHeaderViewButtonType_Acount:
            [self openAbountWe]; break;
        case DS_UserHeaderViewButtonType_Version:
            [self openVersion]; break;
        case DS_UserHeaderViewButtonType_Cache:
            [self openCache]; break;
        case DS_UserHeaderViewButtonType_Login:
            [self openLogin]; break;
        case DS_UserHeaderViewButtonType_Logout:
            [self askLogout]; break;
        case DS_UserHeaderViewButtonType_Register:
            [self openRegister]; break;
        default: break;
    }
}

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
    DS_LoginViewController * loginVC = [[DS_LoginViewController alloc]init];
    [self.navigationController pushViewController:loginVC animated:YES];
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
- (DS_UserHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[DS_UserHeaderView alloc] init];
        _headerView.frame = CGRectMake(0, NAVIGATIONBAR_HEIGHT, self.view.width, 160);
        weakifySelf
        _headerView.headerButtonBlock = ^(DS_UserHeaderViewButtonType type) {
            [weakSelf headerViewButtonAction:type];
        };
    }
    return _headerView;
}

- (DS_AdvertView *)advertView {
    if (!_advertView) {
        _advertView = [[DS_AdvertView alloc] init];
        _advertView.hidden = YES;
    }
    return _advertView;
}

@end
