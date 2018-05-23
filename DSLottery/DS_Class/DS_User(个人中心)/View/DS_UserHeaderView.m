//
//  DS_UserHeaderView.m
//  DSLottery
//
//  Created by 黄玉洲 on 2018/5/9.
//  Copyright © 2018年 海南达生实业有限公司. All rights reserved.
//

#import "DS_UserHeaderView.h"
#import "UIButton+GraphicLayout.h"

@interface DS_UserHeaderView ()

@end

@implementation DS_UserHeaderView


- (instancetype)init {
    if ([super init]) {
        [self layoutView];
    }
    return self;
}

#pragma mark - 界面
/** 布局 */
- (void)layoutView {
    self.backgroundColor = [UIColor whiteColor];
    
    NSArray * titles = [self titles];
    NSArray * imageNames = [self imageNames];
    
    // 循环设置图片
    CGFloat width = Screen_WIDTH / 3.0;
    CGFloat height = 80;
    CGFloat x = 0;
    CGFloat y = 0;
    for (int i = 0; i < [titles count]; i++) {
        UIButton * button = [self buttonWithTitle:titles[i] imageName:imageNames[i]];
        if (i % 3 == 0 && i != 0) {
            y = height * 1;
        }
        x = i % 3 * width;
        button.frame = CGRectMake(x, y, width, height);
        [button setImagePosition:DS_ImagePositionTop spacing:5.0f];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 1000 + i;
        [self addSubview:button];
    }
    
    // 分割线
    UIView * line_1 = [[UIView alloc] init];
    line_1.backgroundColor = COLOR_Line;
    line_1.frame = CGRectMake(0, height, Screen_WIDTH, 1);
    [self addSubview:line_1];
    
    // 分割线
    UIView * line_2 = [[UIView alloc] init];
    line_2.backgroundColor = COLOR_Line;
    line_2.frame = CGRectMake(0, height * 2, Screen_WIDTH, 1);
    [self addSubview:line_2];
    
}

#pragma mark - 按钮事件
- (void)buttonAction:(UIButton *)sender {
    // 判断点击的按钮类型
    NSInteger tag = sender.tag - 1000;
    DS_UserHeaderViewButtonType type;
    switch (tag) {
        case 0:
            type = DS_UserHeaderViewButtonType_Customer;
            break;
        case 1:
            type = DS_UserHeaderViewButtonType_Acount;
            break;
        case 2:
            type = DS_UserHeaderViewButtonType_Version;
            break;
        case 3:
            type = DS_UserHeaderViewButtonType_Cache;
            break;
        case 4:
            if ([DS_UserShare share].userID) {
                type = DS_UserHeaderViewButtonType_Logout;
            } else {
                type = DS_UserHeaderViewButtonType_Login;
            }
            break;
        case 5:
            type = DS_UserHeaderViewButtonType_Register;
            break;
        default:
            type = 0;
            break;
    }
    
    // 按钮回调
    if (self.headerButtonBlock) {
        self.headerButtonBlock(type);
    }
}

#pragma mark - public
/** 重新布局界面 */
- (void)refreshView {
    for (UIView * view in self.subviews) {
        [view removeFromSuperview];
    }
    [self layoutView];
}

#pragma mark - private

#pragma mark - getter
/** 获取标题 */
- (NSArray *)titles {
    if ([DS_UserShare share].userID) {
        return @[@"在线客服",@"关于我们",@"版本记录",@"清除缓存",@"注销"];
    } else {
        return @[@"在线客服",@"关于我们",@"版本记录",@"清除缓存",@"登录",@"注册"];
    }
}

/** 获取图标图片名 */
- (NSArray *)imageNames {
    if ([DS_UserShare share].userID) {
        return @[@"customer_icon",@"abount_icon",@"version_icon",@"cache_icon",@"login_icon"];
    } else {
        return @[@"customer_icon",@"abount_icon",@"version_icon",@"cache_icon",@"login_icon",@"register_icon"];
    }
}

#pragma mark - 便利构造
- (UIButton *)buttonWithTitle:(NSString *)title imageName:(NSString *)imageName {
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.titleLabel.font = FONT(15.0f);
    return button;
}


@end
