//
//  DS_LotteryIssueView.m
//  DSLottery
//
//  Created by 黄玉洲 on 2018/5/29.
//  Copyright © 2018年 海南达生实业有限公司. All rights reserved.
//

#import "DS_LotteryIssueView.h"

@interface DS_LotteryIssueView ()

@end

@implementation DS_LotteryIssueView

- (instancetype)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        [self layoutView];
    }
    return self;
}

#pragma mark - 界面
- (void)layoutView {
    // 30 50 70期
    NSArray * titles = @[DS_STRINGS(@"kThirtyIssue"), DS_STRINGS(@"kFiftyIssue"),DS_STRINGS(@"kEightyIssue")];
    
    // 添加按钮
    for (NSInteger i = 0; i < 3; i++) {
        CGFloat width = Screen_WIDTH / 3;
        CGFloat x = width * i;
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:titles[i] forState:UIControlStateNormal];
        button.titleLabel.font = FONT(15.0f);
        if (i == 0) {
            [button setTitleColor:COLOR_HexRGB(@"#E62229") forState:UIControlStateNormal];
        } else {
            [button setTitleColor:COLOR_HexRGB(@"#5F646E") forState:UIControlStateNormal];
        }
        button.tag = 1000 + i;
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(0);
            make.width.mas_equalTo(width);
            make.left.mas_equalTo(x);
        }];
    }
}

#pragma mark - 按钮事件
- (void)buttonAction:(UIButton *)sender {
    if (self.issueBlock) {
        self.issueBlock(sender.tag - 1000);
    }
    for (int i = 0; i < 3; i++) {
        UIButton * button = [self viewWithTag:i + 1000];
        if ([button isEqual:sender]) {
            [button setTitleColor:COLOR_HexRGB(@"#E62229") forState:UIControlStateNormal];
        } else {
            [button setTitleColor:COLOR_HexRGB(@"#5F646E") forState:UIControlStateNormal];
        }
    }
}

#pragma mark - 懒加载


@end
