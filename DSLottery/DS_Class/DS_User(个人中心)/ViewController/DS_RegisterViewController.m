//
//  DS_RegisterViewController.m
//  DSLottery
//
//  Created by 黄玉洲 on 2018/5/10.
//  Copyright © 2018年 海南达生实业有限公司. All rights reserved.
//

#import "DS_RegisterViewController.h"
#import "DS_AgreementViewController.h"

/** share */
#import "DS_AdvertShare.h"

/** view */
#import "DS_InputView.h"
#import "DS_AdvertView.h"

@interface DS_RegisterViewController () <UITextViewDelegate>

/** 手机号 */
@property (strong, nonatomic) DS_InputView * phoneView;

/** 密码 */
@property (strong, nonatomic) DS_InputView * passwordView;

/** 确认密码 */
@property (strong, nonatomic) DS_InputView * confirmPasswordView;

/** 广告 */
@property (strong, nonatomic) DS_AdvertView * advertView_1;
@property (strong, nonatomic) DS_AdvertView * advertView_2;


@end

@implementation DS_RegisterViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    
    // 广告数据请求
    [self requestAdvert];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
}

- (instancetype)init {
    if ([super init]) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self transparentNavigationBar];
    
    /* 视图布局 */
    [self layoutView];
    
    
}

/* 视图布局 */
-(void)layoutView {
    self.view.backgroundColor = [UIColor whiteColor];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTouch)];
    [self.view addGestureRecognizer:tap];
    
    UIButton * leftButton = [DS_FunctionTool leftNavBackTarget:self Item:@selector(leftBackAction)];
    [leftButton setImage:DS_UIImageName(@"cion_xinxi_fanhui_black") forState:UIControlStateNormal];
    [self navLeftItem:leftButton];
    
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
    
    // 手机号
    [containView addSubview:self.phoneView];
    [_phoneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(IOS_SiZESCALE(110));
        make.left.mas_equalTo(40);
        make.right.mas_equalTo(-40);
        make.height.mas_equalTo(40);
    }];
    
    // 密码
    [containView addSubview:self.passwordView];
    [_passwordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_phoneView.mas_bottom).offset(20);
        make.left.right.height.mas_equalTo(_phoneView);
    }];
    
    // 确认密码
    [containView addSubview:self.confirmPasswordView];
    [_confirmPasswordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_passwordView.mas_bottom).offset(20);
        make.left.right.height.mas_equalTo(_phoneView);
    }];
    
    // 用户协议
    UIImageView * agreement_icon = [UIImageView new];
    agreement_icon.image = DS_UIImageName(@"agreement_icon");
    [containView addSubview:agreement_icon];
    [agreement_icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_passwordView);
        make.width.height.mas_equalTo(17.5);
        make.top.mas_equalTo(_confirmPasswordView.mas_bottom).offset(20);
    }];
    
    NSString * tipStr = DS_STRINGS(@"kAgreeUserAgreement");
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:tipStr];
    NSRange strRange = [tipStr rangeOfString:DS_STRINGS(@"kUserAgreement")];
    [attributedString addAttribute:NSLinkAttributeName
                             value:@"openUrl://agreement"
                             range:strRange];

    UITextView * tipTextField = [[UITextView alloc] init];
    tipTextField.font = [UIFont systemFontOfSize:11.0f];
    tipTextField.text = tipStr;
    tipTextField.textColor = COLOR_Font151;
    tipTextField.tintColor = COLOR(250, 80, 50);
    tipTextField.attributedText = attributedString;
    tipTextField.editable = NO;
    tipTextField.delegate = self;
    [containView addSubview:tipTextField];
    [tipTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(agreement_icon.mas_right).offset(5);
        make.width.mas_equalTo(200);
        make.centerY.mas_equalTo(agreement_icon);
        make.height.mas_equalTo(30);
    }];
    
    // 注册
    UIButton * registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [registerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [registerButton setTitle:DS_STRINGS(@"kSignupImmediately") forState:UIControlStateNormal];
    registerButton.titleLabel.font = FONT(16.0f);
    [registerButton setBackgroundImage:[UIImage imageNamed:@"login_btn_back"] forState:UIControlStateNormal];
    [registerButton addTarget:self action:@selector(signUp) forControlEvents:UIControlEventTouchUpInside];
    [containView addSubview:registerButton];
    [registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.height.mas_equalTo(IOS_SiZESCALE(50));
        make.width.mas_equalTo(IOS_SiZESCALE(300));
        make.top.mas_equalTo(agreement_icon.mas_bottom).offset(20);
    }];
    
    // 登录
    UIButton * loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginButton setTitle:DS_STRINGS(@"kLoginImmediately") forState:UIControlStateNormal];
    loginButton.titleLabel.font = FONT(16.0f);
    [loginButton setBackgroundImage:[UIImage imageNamed:@"login_btn_back"] forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(leftBackAction) forControlEvents:UIControlEventTouchUpInside];
    [containView addSubview:loginButton];
    [loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(registerButton);
        make.height.mas_equalTo(registerButton);
        make.width.mas_equalTo(registerButton);
        make.top.mas_equalTo(registerButton.mas_bottom).offset(10);
    }];
    
    [containView addSubview:self.advertView_1];
    [_advertView_1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(containView);
        make.top.mas_equalTo(loginButton.mas_bottom).offset(30);
        make.height.mas_equalTo(DS_AdvertViewHeight);
    }];
    
    [containView addSubview:self.advertView_2];
    [_advertView_2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(containView);
        make.top.mas_equalTo(_advertView_1.mas_bottom).offset(-10);
        make.height.mas_equalTo(DS_AdvertViewHeight);
        make.bottom.mas_equalTo(containView).offset(-10);
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
    DS_AdvertModel * model_1 = [[DS_AdvertShare share] advertModelWithAdvertID:@"23"];
    DS_AdvertModel * model_2 = [[DS_AdvertShare share] advertModelWithAdvertID:@"24"];
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

/** 请求注册 */
-(void)requestRegister {
    if(![DS_FunctionTool isValidateMobile:[_phoneView getTextFieldContent]]){
        [self hudErrorText:@"手机格式不正确"];
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
    if([DS_FunctionTool isBlankString:[_confirmPasswordView getTextFieldContent]]){
        [self hudErrorText:@"确认密码不能为空"];
        return;
    }
    if(![[_passwordView getTextFieldContent] isEqualToString:[_confirmPasswordView getTextFieldContent]]){
        [self hudErrorText:@"两次密码不一致"];
        return;
    }
    
    [self showhud];
    weakifySelf
    [[DS_UserShare share] requestRegisterWithAccount:[_phoneView getTextFieldContent] password:[_passwordView getTextFieldContent] complete:^(id result) {
        strongifySelf
        [self hidehud];
        if (Request_Success(result)) {
            [self showMessagetext:@"注册成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (self.signUpSuccessBlock) {
                    self.signUpSuccessBlock();
                }
            });
        } else {
            [self hudErrorText:[result objectForKey:@"description"]];
        }
    } fail:^(NSError *failure) {
        strongifySelf
        Request_Error_tip
    }];
}


#pragma  mark - 点击事件
/* 返回 */
- (void)leftBackAction {
    [self.navigationController popViewControllerAnimated:YES];
}

/* 注册 */
-(void)signUp{
    [self requestRegister];
}

/* 键盘回收 */
- (void)tapTouch {
    HidenKeybory;
}

#pragma mark - <UITextViewDelegate>
- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {
    NSString * URLStr = URL.absoluteString;
    if ([URLStr isEqual:@"openUrl://agreement"]) {
        DS_AgreementViewController * vc = [[DS_AgreementViewController alloc] init];
        DS_BaseNavigationController * nav = [[DS_BaseNavigationController alloc] initWithRootViewController:vc];
        [self presentViewController:nav animated:YES completion:nil];
    }
    return NO;
}

#pragma mark - 懒加载
- (DS_InputView *)phoneView {
    if (!_phoneView) {
        _phoneView = [[DS_InputView alloc] initWithType:DS_InputViewType_Account];
    }
    return _phoneView;
}

- (DS_InputView *)passwordView {
    if (!_passwordView) {
        _passwordView = [[DS_InputView alloc] initWithType:DS_InputViewType_Password];
    }
    return _passwordView;
}

- (DS_InputView *)confirmPasswordView {
    if (!_confirmPasswordView) {
        _confirmPasswordView = [[DS_InputView alloc] initWithType:DS_InputViewType_ConfirmPassword];
    }
    return _confirmPasswordView;
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
