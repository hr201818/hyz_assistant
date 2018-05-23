//
//  DS_NewsSmallView.m
//  ALLTIMELOTTERY
//
//  Created by 黄玉洲 on 2018/5/3.
//  Copyright © 2018年 科技有限公司. All rights reserved.
//

#import "DS_NewsSmallView.h"

@interface DS_NewsSmallView ()

/** 小图标 */
@property (strong, nonatomic) UIImageView * smallImageView;

/** 数量 */
@property (strong, nonatomic) UILabel     * numberLabel;

@end

@implementation DS_NewsSmallView

- (instancetype)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        [self layoutView];
    }
    return self;
}

/**
 设置icon图标和数量
 @param imageName 图标名
 @param number 数量
 */
- (void)setImageName:(NSString *)imageName number:(NSString *)number {
    _smallImageView.image = [UIImage imageNamed:imageName];
    _numberLabel.text = number;
}

/** 设置数量 */
- (void)setNumber:(NSString *)number {
    _numberLabel.text = number;
}

/** 设置icon */
- (void)setImageName:(NSString *)imageName {
    _smallImageView.image = [UIImage imageNamed:imageName];
}

#pragma mark - 初始化
- (void)layoutView {
    [self addSubview:self.smallImageView];
    [_smallImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.width.height.mas_equalTo(18);
        make.centerY.mas_equalTo(self);
    }];
    
    [self addSubview:self.numberLabel];
    [_numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_smallImageView.mas_right).offset(5);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(self);
        make.top.mas_equalTo(0);
        
    }];
}

#pragma mark - 懒加载
- (UIImageView *)smallImageView {
    if (!_smallImageView) {
        _smallImageView = [[UIImageView alloc] init];
        _smallImageView.image = [UIImage imageNamed:@"PYB_icon_result_status_success"];
    }
    return _smallImageView;
}

- (UILabel *)numberLabel {
    if (!_numberLabel) {
        _numberLabel = [[UILabel alloc] init];
        _numberLabel.text = @"10000";
        _numberLabel.textColor = COLOR_Font53;
        _numberLabel.font = [UIFont systemFontOfSize:10.0f];
    }
    return _numberLabel;
}

@end
