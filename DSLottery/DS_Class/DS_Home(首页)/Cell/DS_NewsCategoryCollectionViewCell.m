//
//  DS_NewsCategoryCollectionViewCell.m
//  DSLottery
//
//  Created by 黄玉洲 on 2018/5/12.
//  Copyright © 2018年 海南达生实业有限公司. All rights reserved.
//

#import "DS_NewsCategoryCollectionViewCell.h"

/** share */
#import "DS_CategoryShare.h"

@interface DS_NewsCategoryCollectionViewCell ()

@property (strong, nonatomic) UIImageView * lotteryImageView;

@property (strong, nonatomic) UILabel * titleLabel;

@end

@implementation DS_NewsCategoryCollectionViewCell


- (instancetype)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        [self layoutView];
    }
    return self;
}

#pragma mark - 界面
- (void)layoutView {
    [self.contentView addSubview:self.lotteryImageView];
    _lotteryImageView.hidden = YES;
    [_lotteryImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.centerY.mas_equalTo(self.contentView);
        make.width.height.mas_equalTo(45);
    }];
    
    [self.contentView addSubview:self.titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.left.mas_equalTo(_lotteryImageView.mas_right).offset(5);
        //        make.right.mas_equalTo(0);
        //        make.top.bottom.mas_equalTo(0);
        make.edges.mas_equalTo(0);
    }];
}

#pragma mark - setter
- (void)setModel:(DS_CategoryModel *)model {
    if (model) {
        _model = model;
        _titleLabel.text = model.name;
        
        NSString * lotteryID = [[DS_CategoryShare share] lotteryIDWithCategoryID:model.ID];
        _lotteryImageView.image = [UIImage imageNamed:[DS_FunctionTool imageNameWithImageID:lotteryID]];
    }
}

#pragma mark - 懒加载
- (UIImageView *)lotteryImageView {
    if (!_lotteryImageView) {
        _lotteryImageView = [[UIImageView alloc] init];
    }
    return _lotteryImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = FONT(16.0f);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}


@end
