//
//  DS_RegisterViewController.m
//  DSLottery
//
//  Created by 黄玉洲 on 2018/5/10.
//  Copyright © 2018年 海南达生实业有限公司. All rights reserved.
//

#import "DS_RegisterViewController.h"

/** share */
#import "DS_AdvertShare.h"

/** view */
#import "DS_InputView.h"
#import "DS_AdvertView.h"

@interface DS_RegisterViewController ()

/** 手机号 */
@property (strong, nonatomic) DS_InputView * phoneView;

/** 密码 */
@property (strong, nonatomic) DS_InputView * passwordView;

/** 确认密码 */
@property (strong, nonatomic) DS_InputView * confirmPasswordView;

/** 广告 */
@property (strong, nonatomic) DS_AdvertView * advertView;


@end

@implementation DS_RegisterViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (instancetype)init {
    if ([super init]) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = DS_STRINGS(@"kRegister");
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTouch)];
    [self.view addGestureRecognizer:tap];
    
    UIButton * rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [rightBtn setTitle:@"登录" forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(leftBackAction) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rightBtn.frame = CGRectMake(0, 0, 50, 30);
    [self navRightItem:rightBtn];
    
    
    [self navLeftItem:[DS_FunctionTool leftNavBackTarget:self Item:@selector(leftBackAction)]];
    
    /* 视图布局 */
    [self layoutView];
    
    // 广告数据请求
    [self requestAdvert];
}

/* 视图布局 */
-(void)layoutView {
    
    UILabel * titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"输入您的手机号码";
    titleLabel.font = [UIFont systemFontOfSize:16.0f];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(NAVIGATIONBAR_HEIGHT);
        make.height.mas_equalTo(40);
    }];
    
    NSString * tipStr = @"不用担心，手机号码严格保密。注册即表明您同意我们的《服务协议》";
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:tipStr];
    NSRange strRange = [tipStr rangeOfString:@"《服务协议》"];
    [attributedString addAttribute:NSForegroundColorAttributeName
                             value:COLOR(250, 80, 50)
                             range:strRange];
    
    UILabel * tipLabel = [[UILabel alloc] init];
    tipLabel.font = [UIFont systemFontOfSize:11.0f];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.text = tipStr;
    tipLabel.textColor = COLOR_Font151;
    tipLabel.attributedText = attributedString;
    tipLabel.numberOfLines = 0;
    [self.view addSubview:tipLabel];
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(titleLabel.mas_bottom);
        make.height.mas_equalTo(30);
    }];
    
    [self.view addSubview:self.phoneView];
    [_phoneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(tipLabel.mas_bottom).offset(25);
        make.left.mas_equalTo(25);
        make.right.mas_equalTo(-25);
        make.height.mas_equalTo(40);
    }];
    
    [self.view addSubview:self.passwordView];
    [_passwordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_phoneView.mas_bottom).offset(30);
        make.left.right.height.mas_equalTo(_phoneView);
    }];
    
    [self.view addSubview:self.confirmPasswordView];
    [_confirmPasswordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_passwordView.mas_bottom).offset(30);
        make.left.right.height.mas_equalTo(_phoneView);
    }];
    
    // 注册
    UIButton * registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [registerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [registerButton setBackgroundImage:[UIImage imageNamed:@"regist_btn_icon"] forState:UIControlStateNormal];
    [registerButton addTarget:self action:@selector(doneAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerButton];
    [registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_confirmPasswordView.mas_bottom).offset(35);
        make.centerX.mas_equalTo(self.view);
        make.width.mas_equalTo(IOS_SiZESCALE(320));
        make.height.mas_equalTo(IOS_SiZESCALE(45));
    }];
    
    [self.view addSubview:self.advertView];
    [_advertView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(registerButton.mas_bottom).offset(45 / 2.0);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(156);
    }];
}

#pragma mark - 网络请求
/* 请求广告 */
-(void)requestAdvert{
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
    DS_AdvertModel * model = [[DS_AdvertShare share] advertModelWithAdvertID:@"20"];
    if (model) {
        _advertView.model = model;
        _advertView.hidden = NO;
    } else {
        _advertView.hidden = YES;
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
        if (Request_Success(result)) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        } else {
            [self hudErrorText:[result objectForKey:@"description"]];
        }
        [self hidehud];
    } fail:^(NSError *failure) {
        strongifySelf
        Request_Error_tip
    }];
}


#pragma  mark - 点击事件
/* 返回 */
-(void)leftBackAction{
    [self.navigationController popViewControllerAnimated:YES];
}

/* 完成 */
-(void)doneAction{
    [self requestRegister];
}

/* 键盘回收 */
-(void)tapTouch{
    HidenKeybory;
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

- (DS_AdvertView *)advertView {
    if (!_advertView) {
        _advertView = [[DS_AdvertView alloc] init];
        _advertView.hidden = YES;
    }
    return _advertView;
}


@end
