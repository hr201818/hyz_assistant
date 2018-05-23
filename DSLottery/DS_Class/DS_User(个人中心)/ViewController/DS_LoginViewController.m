//
//  DS_LoginViewController.m
//  DSLottery
//
//  Created by 黄玉洲 on 2018/5/10.
//  Copyright © 2018年 海南达生实业有限公司. All rights reserved.
//

#import "DS_LoginViewController.h"
#import "DS_RegisterViewController.h"

/** share */
#import "DS_AdvertShare.h"

/** view */
#import "DS_InputView.h"
#import "DS_AdvertView.h"

@interface DS_LoginViewController ()

/** 账号输入框 */
@property (strong, nonatomic) DS_InputView  * accountView;

/** 密码输入框 */
@property (strong, nonatomic) DS_InputView  * passwordView;

/** 广告 */
@property (strong, nonatomic) DS_AdvertView * advertView;

@end

@implementation DS_LoginViewController

- (instancetype)init {
    if ([super init]) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = DS_STRINGS(@"kLogin");
    
    [self navLeftItem:[DS_FunctionTool leftNavBackTarget:self Item:@selector(leftButtonAction:)]];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTouch)];
    [self.view addGestureRecognizer:tap];
    UIButton * rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [rightBtn setTitle:@"注册" forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rightBtn.frame = CGRectMake(0, 0, 60, 30);
    [self navRightItem:rightBtn];
    
    //视图布局
    [self layoutView];
    
    //广告数据请求
    [self requestAdvert];
    
    
}

- (void)layoutView {
    
    [self.view addSubview:self.accountView];
    [_accountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(NAVIGATIONBAR_HEIGHT + 40);
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(-30);
        make.height.mas_equalTo(40);
    }];
    
    [self.view addSubview:self.passwordView];
    [_passwordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_accountView.mas_bottom).offset(30);
        make.left.right.height.mas_equalTo(_accountView);
    }];
    
    //忘记密码按钮
    UIButton * forgetPassword = [UIButton buttonWithType:UIButtonTypeCustom];
    [forgetPassword setTitleColor:COLOR(250, 80, 50) forState:UIControlStateNormal];
    [forgetPassword setTitle:@"忘记密码？" forState:UIControlStateNormal];
    [forgetPassword addTarget:self action:@selector(forgetPasswordButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    forgetPassword.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:forgetPassword];
    [forgetPassword mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-30);
        make.width.mas_equalTo(100);
        make.top.mas_equalTo(_passwordView.mas_bottom).offset(15);
        make.height.mas_equalTo(40);
    }];
    
    /* 登录按钮 */
    UIButton * loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginBtn setBackgroundImage:[UIImage imageNamed:@"loginBtn"] forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(loginButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(IOS_SiZESCALE(45));
        make.centerX.mas_equalTo(self.view);
        make.width.mas_equalTo(IOS_SiZESCALE(320));
        make.top.mas_equalTo(_passwordView.mas_bottom).offset(70);
    }];
    
    [self.view addSubview:self.advertView];
    [_advertView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(loginBtn.mas_bottom).offset(30);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(156);
    }];
}

#pragma mark - 网络请求
/* 请求广告 */
-(void)requestAdvert {
    /* 没有广告的情况的再去请求 */
    if ([[DS_AdvertShare share] advertCount] == 0) {
        weakifySelf
        [[DS_AdvertShare share] requestAdvertListComplete:^(id object) {
            strongifySelf
            [self loadData];
        } fail:^(NSError *failure) {
            
        }];
    }else{
        [self loadData];
    }
}
/* 加载广告 */
-(void)loadData {
    //非空判断，不然数组会闪退
    DS_AdvertModel * model = [[DS_AdvertShare share] advertModelWithAdvertID:@"21"];
    if (model) {
        _advertView.model = model;
        _advertView.hidden = NO;
    } else {
        _advertView.hidden = YES;
    }
}

/** 请求登录 */
-(void)requestLoginInfo{
    /* 判断账号密码是否符合要求 */
    if(![DS_FunctionTool isValidateMobile:[_accountView getTextFieldContent]]){
        [self hudErrorText:@"手机格式不正确"];
        return;
    }
    if([DS_FunctionTool isBlankString:[_accountView getTextFieldContent]]){
        [self hudErrorText:@"账号不能为空"];
        return;
    }
    if ([_passwordView getTextFieldContent].length < 6) {
        [self hudErrorText:@"密码至少输入6位"];
        return;
    }
    if([DS_FunctionTool isBlankString:[_passwordView getTextFieldContent]]){
        [self hudErrorText:@"密码不能为空"];
        return;
    }
    
    [self showhud];
    weakifySelf
    [[DS_UserShare share] loginWithAccount:[_accountView getTextFieldContent]  password:[_passwordView getTextFieldContent] complete:^(id result) {
        if (Request_Success(result)) {
            [self leftButtonAction:nil];
        } else {
            [self hudErrorText:[result objectForKey:@"description"]];
        }
        [self hidehud];
    } fail:^(NSError *failure) {
        strongifySelf
        Request_Error_tip
    }];
}


#pragma mark - 点击事件
/* 返回 */
- (void)leftButtonAction:(UIButton *)sender {
    if (_isPresent) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

/* 注册 */
- (void)rightButtonAction:(UIButton *)sender {
    DS_RegisterViewController * registerVC = [[DS_RegisterViewController alloc]init];
    [self.navigationController pushViewController:registerVC animated:YES];
}

/* 登录 */
- (void)loginButtonAction:(UIButton *)sender {
    [self requestLoginInfo];
}

/* 忘记密码 */
- (void)forgetPasswordButtonAction:(UIButton *)sender {
    [self showMessagetext:@"请联系在线客服"];
}

/* 退出键盘 */
-(void)tapTouch{
    HidenKeybory;
}

/* 法律声明 */
-(void)lawBtnAction{
//    DSLawViewController * lawVC = [[DSLawViewController alloc]init];
//    lawVC.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:lawVC animated:YES];
}

#pragma mark - 懒加载
- (DS_InputView *)accountView {
    if (!_accountView) {
        _accountView = [[DS_InputView alloc] initWithType:DS_InputViewType_Account];
    }
    return _accountView;
}

- (DS_InputView *)passwordView {
    if (!_passwordView) {
        _passwordView = [[DS_InputView alloc] initWithType:DS_InputViewType_Password];
    }
    return _passwordView;
}

//- (DS_LoginAdvertView *)advertView {
//    if (!_advertView) {
//        _advertView = [[DS_LoginAdvertView alloc] init];
//    }
//    return _advertView;
//}


@end
