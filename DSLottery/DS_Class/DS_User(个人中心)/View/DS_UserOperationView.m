
//
//  DS_UserOperationView.m
//  DSLottery
//
//  Created by 黄玉洲 on 2018/5/23.
//  Copyright © 2018年 海南达生实业有限公司. All rights reserved.
//

#import "DS_UserOperationView.h"

@interface DS_UserOperationView ()

@end

@implementation DS_UserOperationView

- (instancetype)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        [self layoutView];
    }
    return self;
}

#pragma mark - 界面
- (void)layoutView {
    
    self.backgroundColor = [UIColor whiteColor];
    
    // 在线客服
    UIButton * customerServiceBtn = [self buttonWithTitle:DS_STRINGS(@"kKefuTitle") imageName:nil tag:DS_OperationType_CustomerService];
    [self addSubview:customerServiceBtn];
    [customerServiceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.width.mas_equalTo(self.width / 2);
        make.height.mas_equalTo(self.height / 2);
    }];
    
    // 关于我们
    UIButton * aboutWeBtn = [self buttonWithTitle:DS_STRINGS(@"kAbountUsTitle") imageName:nil tag:DS_OperationType_AboutWe];
    [self addSubview:aboutWeBtn];
    [aboutWeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.width / 2);
        make.top.mas_equalTo(0);
        make.width.mas_equalTo(self.width / 2);
        make.height.mas_equalTo(self.height / 2);
    }];
    
    // 版本
    UIButton * versionBtn = [self buttonWithTitle:DS_STRINGS(@"kVersion") imageName:nil tag:DS_OperationType_Version];
    [self addSubview:versionBtn];
    [versionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(self.height / 2);
        make.width.mas_equalTo(self.width / 2);
        make.height.mas_equalTo(self.height / 2);
    }];
    
    // 缓存
    UIButton * cacheBtn = [self buttonWithTitle:DS_STRINGS(@"kClearCache") imageName:nil tag:DS_OperationType_Cache];
    [self addSubview:cacheBtn];
    [cacheBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.width / 2);
        make.top.mas_equalTo(self.height / 2);
        make.width.mas_equalTo(self.width / 2);
        make.height.mas_equalTo(self.height / 2);
    }];
    
    UIView * topLine = [[UIView alloc] init];
    topLine.backgroundColor = COLOR_Line;
    [self addSubview:topLine];
    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(15);
        make.width.mas_equalTo(1);
        make.height.mas_equalTo(self.height / 2 - 30);
    }];
    
    UIView * bottomLine = [[UIView alloc] init];
    bottomLine.backgroundColor = COLOR_Line;
    [self addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.bottom.mas_equalTo(-15);
        make.width.mas_equalTo(1);
        make.height.mas_equalTo(self.height / 2 - 30);
    }];
    
    UIView * verticalLine = [[UIView alloc] init];
    verticalLine.backgroundColor = COLOR_Line;
    [self addSubview:verticalLine];
    [verticalLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(1);
        make.centerY.mas_equalTo(self);
    }];
}

#pragma mark - 按钮事件
- (void)buttonAction:(UIButton *)sender {
    NSInteger tag = sender.tag - 1000;
    DS_OperationType operationType = (DS_OperationType)tag;
    if (self.operationBlock) {
        self.operationBlock(operationType);
    }
}

#pragma mark - 便利构造
- (UIButton *)buttonWithTitle:(NSString *)title imageName:(NSString *)imageName tag:(NSInteger)tag{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.tag = 1000 + tag;
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView * imageView = [[UIImageView alloc] init];
    imageView.image = DS_UIImageName(imageName);
    imageView.backgroundColor = [UIColor redColor];
    [button addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(button);
        make.width.height.mas_equalTo(30);
    }];
    
    UILabel * titleLabel = [[UILabel alloc] init];
    titleLabel.text = title;
    titleLabel.font = FONT(16.0f);
    titleLabel.textColor = COLOR_HexRGB(@"646566");
    [button addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(imageView.mas_right).offset(15);
        make.right.mas_equalTo(-10);
        make.centerY.mas_equalTo(button);
        make.height.mas_equalTo(20);
    }];
    
    // 如果是版本 修改样式
    if ([title isEqual:DS_STRINGS(@"kVersion")]) {
        NSString * version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        
        NSString * versionTitle = [NSString stringWithFormat:@"%@ V%@", title, version];
        NSRange range = [versionTitle rangeOfString:[NSString stringWithFormat:@"V%@",version]];
        
        titleLabel.text = versionTitle;
        
        NSMutableAttributedString * mAttribute = [[NSMutableAttributedString alloc] initWithString:versionTitle];
        [mAttribute addAttribute:NSForegroundColorAttributeName value:COLOR_HexRGB(@"646566") range:NSMakeRange(0, versionTitle.length)];
        [mAttribute addAttribute:NSForegroundColorAttributeName value:COLOR_HexRGB(@"B3B4B5") range:range];
        [mAttribute addAttribute:NSFontAttributeName value:FONT(13.0f) range:range];
        titleLabel.attributedText = mAttribute;
    }
    
    return button;
}

@end
