//
//  DS_AgreementViewController.m
//  DSLottery
//
//  Created by 黄玉洲 on 2018/5/24.
//  Copyright © 2018年 海南达生实业有限公司. All rights reserved.
//

#import "DS_AgreementViewController.h"

@interface DS_AgreementViewController ()

@property (strong, nonatomic) UILabel * contentLab;

@end

@implementation DS_AgreementViewController

- (instancetype)init {
    if ([super init]) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = DS_STRINGS(@"kUserAgreement");
    [self navLeftItem:[DS_FunctionTool leftNavBackTarget:self Item:@selector(leftBackAction)]];
    
    UIScrollView * scrollView = [[UIScrollView alloc] init];
    [self.view addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(NAVIGATIONBAR_HEIGHT);
        make.height.mas_equalTo(Screen_HEIGHT - NAVIGATIONBAR_HEIGHT);
    }];
    
    UIView * containView = [UIView new];
    [scrollView addSubview:containView];
    [containView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(scrollView);
        make.width.mas_equalTo(scrollView);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [containView addSubview:self.contentLab];
    [_contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.height.mas_greaterThanOrEqualTo(0);
        make.bottom.mas_equalTo(containView.mas_bottom).offset(-10);
    }];
    
    if ([DS_AreaLimitShare share].isAreaLimit) {
        [self requestUserAgreement];
    } else {
        _contentLab.text = @"尊敬的用户";
    }
}

// 请求用户协议
- (void)requestUserAgreement {
    weakifySelf
    [self showhud];
    [[DS_AreaLimitShare share] requestGengxinComplete:^{
        strongifySelf
        self.contentLab.text = [DS_AreaLimitShare share].content;
        [self hidehud];
    } fail:^(NSError *failure) {
        Request_Error_tip;
    }];
}

#pragma mark - 点击事件
-(void)leftBackAction{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 懒加载
- (UILabel *)contentLab {
    if (!_contentLab) {
        _contentLab = [[UILabel alloc] init];
        _contentLab.textColor = COLOR_Font83;
        _contentLab.numberOfLines = 0;
        _contentLab.font = [UIFont systemFontOfSize:15];
        [_contentLab sizeToFit];
    }
    return _contentLab;
}

@end
