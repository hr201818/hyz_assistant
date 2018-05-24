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
    
    NSString * imageName = @"login_gray_line";
    NSString * placeholder = @"";
    switch (_type) {
        case DS_InputViewType_Account: {
            imageName = @"login_light_line";
            placeholder = DS_STRINGS(@"kInputAccount");
            break;
        }
        case DS_InputViewType_Password: {
            placeholder = DS_STRINGS(@"kInputPassword");
            break;
        }
        case DS_InputViewType_ConfirmPassword: {
            placeholder = DS_STRINGS(@"kReInputPassword");
            break;
        }
        default:
            break;
    }
    
    [self addSubview:self.textField];
    _textField.placeholder = placeholder;
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.centerY.mas_equalTo(self);
        make.height.mas_equalTo(self);
    }];
    
    UIImageView * bottomLine = [UIImageView new];
    bottomLine.image = DS_UIImageName(imageName);
    [self addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(2);
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
            default:break;
        }
    }
    return _textField;
}


@end
