//
//  DS_HomeNormalCell.m
//  DSLottery
//
//  Created by 黄玉洲 on 2018/5/23.
//  Copyright © 2018年 海南达生实业有限公司. All rights reserved.
//

#import "DS_HomeNormalCell.h"

@interface DS_HomeNormalCell ()

/** 标题标签 */
@property (strong, nonatomic) UILabel * titleLab;

/** 左边蓝色视图 */
@property (strong, nonatomic) UIImageView * leftImageView;

/** 右边箭头 */
@property (strong, nonatomic) UIImageView * rightImageView;

@end

@implementation DS_HomeNormalCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTouch)];
        [self addGestureRecognizer:tap];
        
        [self layoutView];
    }
    return self;
}

#pragma mark - 界面
/** 界面布局 */
- (void)layoutView {
    [self.contentView addSubview:self.leftImageView];
    [_leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.bottom.mas_equalTo(0);
        make.width.mas_equalTo(5);
        make.height.mas_equalTo(20);
    }];
    
    [self.contentView addSubview:self.titleLab];
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_leftImageView.mas_right).offset(15);
        make.right.mas_equalTo(-30);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(20);
    }];
    
    [self.contentView addSubview:self.rightImageView];
    [_rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.bottom.mas_equalTo(0);
        make.width.mas_equalTo(15);
        make.height.mas_equalTo(15);
    }];
}

#pragma mark - setter
- (void)setCellTitle:(NSString *)cellTitle {
    if (cellTitle) {
        _cellTitle = cellTitle;
        
        _titleLab.text = cellTitle;
    }
}

#pragma mark - 手势
- (void)tapTouch {
    NSLog(@"点击了彩票资讯");
}

#pragma mark - 懒加载
- (UIImageView *)leftImageView {
    if (!_leftImageView) {
        _leftImageView = [[UIImageView alloc] init];
        _leftImageView.image = DS_UIImageName(@"lottery_news_icon");
    }
    return _leftImageView;
}

- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.font = FONT_BOLD(15.0f);
    }
    return _titleLab;
}

- (UIImageView *)rightImageView {
    if (!_rightImageView) {
        _rightImageView = [[UIImageView alloc] init];
        _rightImageView.image = DS_UIImageName(@"shezhi_icon_jiantou");
    }
    return _rightImageView;
}

@end
