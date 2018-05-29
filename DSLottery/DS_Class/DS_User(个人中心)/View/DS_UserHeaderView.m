//
//  DS_UserHeaderView.m
//  DSLottery
//
//  Created by 黄玉洲 on 2018/5/9.
//  Copyright © 2018年 海南达生实业有限公司. All rights reserved.
//

#import "DS_UserHeaderView.h"
#import "UIButton+GraphicLayout.h"
#import "DS_UserShare.h"
@interface DS_UserHeaderView ()

/** 操作按钮（头像、登录、注册、箭头的父视图） */
@property (strong, nonatomic) UIButton * operationBtn;

/** 头像 */
@property (strong, nonatomic) UIImageView * portraitImageView;

/** 用户昵称（注册/登录） */
@property (strong, nonatomic) UILabel     * nameLab;

/** 箭头 */
@property (strong, nonatomic) UIImageView * arrowImageView;


@end

@implementation DS_UserHeaderView


- (instancetype)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        [self layoutView];
    }
    return self;
}

#pragma mark - 界面
/** 布局 */
- (void)layoutView {
    self.backgroundColor = [UIColor whiteColor];
    
    UIImageView * backImageView = [[UIImageView alloc] init];
    backImageView.image = DS_UIImageName(@"user_head_back");
    [self addSubview:backImageView];
    [backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    [self addSubview:self.operationBtn];
    [_operationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(45);
        make.centerY.mas_equalTo(backImageView.mas_centerY).offset(15);
    }];
    
    [_operationBtn addSubview:self.portraitImageView];
    [_portraitImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(15);
        make.width.height.mas_equalTo(45);
    }];
    
    [_operationBtn addSubview:self.nameLab];
    [_nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.left.mas_equalTo(_portraitImageView.mas_right).offset(15);
        make.right.mas_equalTo(-40);
    }];
    
    [_operationBtn addSubview:self.arrowImageView];
    [_arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.width.height.mas_equalTo(20);
        make.centerY.mas_equalTo(_operationBtn);
    }];
}

#pragma mark - 按钮事件
- (void)buttonAction:(UIButton *)sender {
    if (self.loginOrLogoutBlock) {
        self.loginOrLogoutBlock();
    }
}

#pragma mark - public
/** 重新布局界面 */
- (void)refreshView {
    if ([DS_UserShare share].userID) {
//        _nameLab.text = DS_STRINGS(@"kLogout");
        _nameLab.text = [NSString stringWithFormat:@"用户：%@",[DS_UserShare share].userID];
    } else {
        _nameLab.text = DS_STRINGS(@"kLoginOrRegister");
    }
}

#pragma mark - 懒加载
- (UIButton *)operationBtn {
    if (!_operationBtn) {
        _operationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_operationBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _operationBtn;
}

- (UIImageView *)portraitImageView {
    if (!_portraitImageView) {
        _portraitImageView = [[UIImageView alloc] init];
        _portraitImageView.image = DS_UIImageName(@"user_icon");
    }
    return _portraitImageView;
}

- (UILabel *)nameLab {
    if (!_nameLab) {
        _nameLab = [[UILabel alloc] init];
        if ([DS_UserShare share].userID) {
            _nameLab.text = DS_STRINGS(@"kLogout");
        } else {
            _nameLab.text = DS_STRINGS(@"kLoginOrRegister");
        }
        _nameLab.font = FONT_BOLD(15.0f);
        _nameLab.textColor = [UIColor whiteColor];
    }
    return _nameLab;
}

- (UIImageView *)arrowImageView {
    if (!_arrowImageView) {
        _arrowImageView = [[UIImageView alloc] init];
        _arrowImageView.image = DS_UIImageName(@"personal_arrow");
    }
    return _arrowImageView;
}


@end
