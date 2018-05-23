//
//  DS_VersionViewController.m
//  DSLottery
//
//  Created by 黄玉洲 on 2018/5/10.
//  Copyright © 2018年 海南达生实业有限公司. All rights reserved.
//

#import "DS_VersionViewController.h"

@interface DS_VersionViewController ()

/** icon图标 */
@property (strong, nonatomic) UIImageView * iconImageView;

/** 版本号 */
@property (strong, nonatomic) UILabel * versionLab;

@end

@implementation DS_VersionViewController

- (instancetype)init {
    if ([super init]) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutView];
}

#pragma mark - 界面
/** 布局 */
- (void)layoutView {
    
    self.title = DS_STRINGS(@"kVersion");
    
    [self navLeftItem:[DS_FunctionTool leftNavBackTarget:self Item:@selector(leftButtonAction:)]];
    
    // icon
    [self.view addSubview:self.iconImageView];
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.centerY.mas_equalTo(self.view).offset(-100);
        make.width.height.mas_equalTo(100);
    }];
    
    // 版本号
    [self.view addSubview:self.versionLab];
    [_versionLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.centerY.mas_equalTo(self.view);
        make.height.mas_equalTo(20);
    }];
}

#pragma mark - 按钮事件
- (void)leftButtonAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 懒加载
- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.image = [UIImage imageNamed:@"z_header"];
    }
    return _iconImageView;
}

- (UILabel *)versionLab {
    if (!_versionLab) {
        NSString * version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        
        _versionLab = [[UILabel alloc] init];
        _versionLab.font = FONT(15.0f);
        _versionLab.textColor = COLOR_Font83;
        _versionLab.textAlignment = NSTextAlignmentCenter;
        _versionLab.text = [NSString stringWithFormat:@"当前版本：%@",version];
    }
    return _versionLab;
}

@end
