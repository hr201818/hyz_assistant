//
//  DS_LotteryListCell.m
//  DSLottery
//
//  Created by 黄玉洲 on 2018/5/28.
//  Copyright © 2018年 海南达生实业有限公司. All rights reserved.
//

#import "DS_LotteryListCell.h"

@interface DS_LotteryListCell ()

/** 彩种图标 */
@property (strong, nonatomic) UIImageView * lotteryImageView;

/** 彩种类型 */
@property (strong, nonatomic) UILabel     * lotteryTitleLab;

@end

@implementation DS_LotteryListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self layoutView];
    }
    return self;
}

#pragma mark - 界面
- (void)layoutView {
    // 图标
    [self.contentView addSubview:self.lotteryImageView];
    [_lotteryImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(36);
        make.left.mas_equalTo(10);
        make.centerY.mas_equalTo(self.contentView);
    }];
    
    // 彩种
    [self.contentView addSubview:self.lotteryTitleLab];
    [_lotteryTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.left.mas_equalTo(_lotteryImageView.mas_right).offset(10);
        make.right.mas_equalTo(-10);
    }];
}

#pragma mark - setter
- (void)setLotteryID:(NSString *)lotteryID {
    if (lotteryID) {
        _lotteryID = lotteryID;
        
        NSString * lotteryTitle = [DS_FunctionTool lotteryTitleWithLotteryID:lotteryID];
        _lotteryTitleLab.text = lotteryTitle;
        
        NSString * iconName = [DS_FunctionTool lotteryIconWithLotteryID:lotteryID];
        _lotteryImageView.image = DS_UIImageName(iconName);
        
    }
}

#pragma mark - 懒加载
- (UIImageView *)lotteryImageView {
    if (!_lotteryImageView) {
        _lotteryImageView = [[UIImageView alloc] init];
    }
    return _lotteryImageView;
}

- (UILabel *)lotteryTitleLab {
    if (!_lotteryTitleLab) {
        _lotteryTitleLab = [[UILabel alloc] init];
        _lotteryTitleLab.font = FONT(14.0f);
    }
    return _lotteryTitleLab;
}


@end
