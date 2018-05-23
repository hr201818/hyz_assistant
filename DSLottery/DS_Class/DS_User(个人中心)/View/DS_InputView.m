//
//  DS_InputView.m
//  DS_lottery
//
//  Created by 黄玉洲 on 2018/5/7.
//  Copyright © 2018年 海南达生实业有限公司. All rights reserved.
//

#import "DS_InputView.h"

@interface DS_InputView () <UITextFieldDelegate> {
    DS_InputViewType _type;
}

/** 左侧图标 */
@property (strong, nonatomic) UIImageView * leftImageView;

/** 标题 */
@property (strong, nonatomic) UILabel     * titleLab;

/** 输入框 */
@property (strong, nonatomic) UITextField * textField;

@end

@implementation DS_InputView


- (instancetype)initWithType:(DS_InputViewType)type {
    if ([super init]) {
        _type = type;
        [self layoutView];
    }
    return self;
}

#pragma mark - 界面
/** 布局 */
- (void)layoutView {
    [self addSubview:self.leftImageView];
    [_leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.centerY.mas_equalTo(self);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(30);
    }];
    
    CGFloat titleWidth = 0;
    CGFloat rightEdge = 0;
    switch (_type) {
        case DS_InputViewType_Account: {
            titleWidth = 50;
            rightEdge = 0;
            break;
        }
        case DS_InputViewType_Password: {
            titleWidth = 50;
            rightEdge = 0;
            break;
        }
        case DS_InputViewType_ConfirmPassword: {
            titleWidth = 85;
            rightEdge = 0;
            break;
        }
        case DS_InputViewType_VerificationCode: {
            titleWidth = 70;
            rightEdge = -90;
            break;
        }
            
        default:
            break;
    }
    
    [self addSubview:self.titleLab];
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_leftImageView.mas_right).offset(10);
        make.centerY.mas_equalTo(self);
        make.width.mas_equalTo(titleWidth);
        make.height.mas_equalTo(self);
    }];
    
    [self addSubview:self.textField];
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_titleLab.mas_right);
        make.right.mas_equalTo(rightEdge);
        make.centerY.mas_equalTo(self);
        make.height.mas_equalTo(self);
    }];
    
    if (_type == DS_InputViewType_VerificationCode) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"获取验证码" forState:UIControlStateNormal];
        [button setTitleColor:COLOR(250, 80, 50) forState:UIControlStateNormal];
        button.titleLabel.font = FONT(15.0f);
        button.layer.borderColor = COLOR(250, 80, 50).CGColor;
        button.layer.borderWidth = 0.5;
        [button addTarget:self action:@selector(verificatonCodeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(0);
            make.centerY.mas_equalTo(self);
            make.width.mas_equalTo(85);
            make.height.mas_equalTo(25);
        }];
    }
    
    UIView * bottomLine = [[UIView alloc] init];
    bottomLine.backgroundColor = COLOR_Line;
    [self addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
}

#pragma mark - public
/** 获取输入框内容 */
- (NSString *)getTextFieldContent {
    return _textField.text;
}

#pragma mark - <UITextFieldDelegate>
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@""]) {
        return YES;
    }
    if (_type == DS_InputViewType_Account) {
        if (textField.text.length > 10) {
            return NO;
        }
    }
    
    return YES;
}

#pragma mark - 按钮事件
- (void)verificatonCodeButtonAction:(UIButton *)sender {
    if (self.verificationBlock) {
        self.verificationBlock();
    }
}

#pragma mark - 懒加载
- (UIImageView *)leftImageView {
    if (!_leftImageView) {
        _leftImageView = [[UIImageView alloc] init];
        switch (_type) {
            case DS_InputViewType_Account: {
                _leftImageView.image = [UIImage imageNamed:@"phoneIcon"];
                break;
            }
            case DS_InputViewType_Password: {
                _leftImageView.image = [UIImage imageNamed:@"password"];
                break;
            }
            case DS_InputViewType_ConfirmPassword: {
                _leftImageView.image = [UIImage imageNamed:@"password"];
                break;
            }
            case DS_InputViewType_VerificationCode: {
                _leftImageView.image = [UIImage imageNamed:@"icon_eye"];
                break;
            }
            default:break;
        }
    }
    return _leftImageView;
}

- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.font = [UIFont systemFontOfSize:16];
        switch (_type) {
            case DS_InputViewType_Account: {
                _titleLab.text = @"手机：";
                break;
            }
            case DS_InputViewType_Password: {
                _titleLab.text = @"密码：";
                break;
            }
            case DS_InputViewType_ConfirmPassword: {
                _titleLab.text = @"确认密码：";
                break;
            }
            case DS_InputViewType_VerificationCode: {
                _titleLab.text = @"验证码：";
                break;
            }
            default:break;
        }
    }
    return _titleLab;
}

- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.font = [UIFont systemFontOfSize:16];
        _textField.textColor = COLOR_Font83;
        _textField.delegate = self;
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        switch (_type) {
            case DS_InputViewType_Account: {
                _textField.placeholder = @"";
                _textField.keyboardType = UIKeyboardTypePhonePad;
                break;
            }
            case DS_InputViewType_Password: {
                _textField.placeholder = @"至少6位字符";
                _textField.secureTextEntry = YES;
                break;
            }
            case DS_InputViewType_ConfirmPassword: {
                _textField.placeholder = @"";
                _textField.secureTextEntry = YES;
                break;
            }
            case DS_InputViewType_VerificationCode: {
                _textField.placeholder = @"";
                break;
            }
            default:break;
        }
    }
    return _textField;
}


@end
