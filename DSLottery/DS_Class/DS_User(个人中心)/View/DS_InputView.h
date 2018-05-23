//
//  DS_InputView.h
//  DS_lottery
//
//  Created by 黄玉洲 on 2018/5/7.
//  Copyright © 2018年 海南达生实业有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 输入框类型
 
 - DS_InputViewType_Account:   账号
 - DS_InputViewType_Password:  密码
 - DS_InputViewType_ConfirmPassword: 确认密码
 - DS_InputViewType_VerificationCode: 验证码
 */
typedef NS_ENUM(NSInteger, DS_InputViewType) {
    DS_InputViewType_Account,
    DS_InputViewType_Password,
    DS_InputViewType_ConfirmPassword,
    DS_InputViewType_VerificationCode,
};

@interface DS_InputView : UIView

- (instancetype)initWithType:(DS_InputViewType)type;

/** 获取输入框内容 */
- (NSString *)getTextFieldContent;

/** 验证码按钮回调 */
@property (copy, nonatomic) void(^verificationBlock)(void);

@end
