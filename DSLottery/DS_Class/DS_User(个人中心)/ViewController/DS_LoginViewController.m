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
@property (strong, nonatomic) DS_AdvertView * advertView_1;
@property (strong, nonatomic) DS_AdvertView * advertView_2;

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
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    
    //广告数据请求
    [self requestAdvert];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self transparentNavigationBar];
    
    //视图布局
    [self layoutView];
}

#pragma mark - 界面
/** 布局 */
- (void)layoutView {
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    [self navLeftItem:[DS_FunctionTool leftNavBackTarget:self Item:@selector(leftButtonAction:)]];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTouch)];
    [self.view addGestureRecognizer:tap];
    
    // 忘记密码按钮
    UIButton * rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.titleLabel.font = FONT_BOLD(15.0f);
    [rightBtn setTitle:DS_STRINGS(@"kForgotPassword") forState:UIControlStateNormal];
    [rightBtn setTitleColor:COLOR_HexRGB(@"95BCD0") forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.frame = CGRectMake(0, 0, 80, 30);
    [self navRightItem:rightBtn];
    
    // 顶部的背景图
    UIImageView * topBackView = [UIImageView new];
    topBackView.image = DS_UIImageName(@"login_back");
    [self.view addSubview:topBackView];
    [topBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(-STATUSBAR_HEIGHT);
        make.height.mas_equalTo(IOS_SiZESCALE(280));
    }];
    
    UIScrollView * scrollView = [UIScrollView new];
    [self.view addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    // 容器视图
    UIView * containView = [UIView new];
    containView.backgroundColor = [UIColor clearColor];
    [scrollView addSubview:containView];
    [containView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(scrollView);
        make.width.mas_equalTo(scrollView);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    // 北京赛车助手log
    UIImageView * logImageView = [UIImageView new];
    logImageView.image = DS_UIImageName(@"login_log");
    [containView addSubview:logImageView];
    [logImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(40);
        make.top.mas_equalTo(100);
        make.height.mas_equalTo(21);
        make.width.mas_equalTo(128);
    }];

    
    [containView addSubview:self.accountView];
    [_accountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(logImageView.mas_bottom).offset(30);
        make.left.mas_equalTo(40);
        make.right.mas_equalTo(-40);
        make.height.mas_equalTo(40);
    }];
    
    [containView addSubview:self.passwordView];
    [_passwordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_accountView.mas_bottom).offset(20);
        make.left.right.height.mas_equalTo(_accountView);
    }];
    
    /* 登录按钮 */
    UIButton * loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginBtn setBackgroundImage:[UIImage imageNamed:@"login_btn_back"] forState:UIControlStateNormal];
    [loginBtn setTitle:DS_STRINGS(@"kLoginImmediately") forState:UIControlStateNormal];
    loginBtn.titleLabel.font = FONT(16.0f);
    [loginBtn addTarget:self action:@selector(loginButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [containView addSubview:loginBtn];
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.height.mas_equalTo(IOS_SiZESCALE(50));
        make.width.mas_equalTo(IOS_SiZESCALE(300));
        make.top.mas_equalTo(_passwordView.mas_bottom).offset(25);
    }];

    // 注册按钮
    UIButton * signupBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [signupBtn setBackgroundImage:[UIImage imageNamed:@"login_btn_back"] forState:UIControlStateNormal];
    [signupBtn setTitle:DS_STRINGS(@"kSignupImmediately") forState:UIControlStateNormal];
    [signupBtn addTarget:self action:@selector(signUpButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    signupBtn.titleLabel.font = FONT(16.0f);
    [containView addSubview:signupBtn];
    [signupBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(loginBtn.mas_bottom).offset(10);
        make.left.right.height.mas_equalTo(loginBtn);
    }];
    
    [containView addSubview:self.advertView_1];
    [_advertView_1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(containView);
        make.top.mas_equalTo(signupBtn.mas_bottom).offset(70);
        make.height.mas_equalTo(DS_AdvertViewHeight);
    }];
    
    [containView addSubview:self.advertView_2];
    [_advertView_2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(containView);
        make.top.mas_equalTo(_advertView_1.mas_bottom).offset(-10);
        make.height.mas_equalTo(_advertView_1);
        make.bottom.mas_equalTo(containView).offset(-10);// 设置与容器View底部高度固定，contentLabel高度变化的时候，由于设置了容器View的高度动态变化，底部距离固定。 此时contentView的高度变化之后，ScrollView的contentSize就发生了变化，适配文字内容，滑动查看超出屏幕文字。
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
    // 非空判断，不然数组会闪退
    DS_AdvertModel * model_1 = [[DS_AdvertShare share] advertModelWithAdvertID:@"21"];
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

/* 忘记密码 */
- (void)rightButtonAction:(UIButton *)sender {
    [self showMessagetext:@"请联系在线客服"];
}

/* 登录 */
- (void)loginButtonAction:(UIButton *)sender {
    [self requestLoginInfo];
}

/* 注册 */
- (void)signUpButtonAction:(UIButton *)sender {
    DS_RegisterViewController * registerVC = [[DS_RegisterViewController alloc]init];
    [self.navigationController pushViewController:registerVC animated:YES];
    
    registerVC.signUpSuccessBlock = ^{
      [self dismissViewControllerAnimated:YES completion:nil];
    };
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

- (DS_AdvertView *)advertView_1 {
    if (!_advertView_1) {
        _advertView_1 = [[DS_AdvertView alloc] init];
    }
    return _advertView_1;
}

- (DS_AdvertView *)advertView_2 {
    if (!_advertView_2) {
        _advertView_2 = [[DS_AdvertView alloc] init];
    }
    return _advertView_2;
}

@end
