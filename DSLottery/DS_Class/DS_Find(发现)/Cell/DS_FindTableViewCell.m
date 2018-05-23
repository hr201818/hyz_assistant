//
//  DS_FindTableViewCell.m
//  DSLottery
//
//  Created by 黄玉洲 on 2018/5/15.
//  Copyright © 2018年 海南达生实业有限公司. All rights reserved.
//

#import "DS_FindTableViewCell.h"
#import "DS_BaseTabBarController.h"
#import "DS_HomeViewController.h"
@interface DS_FindTableViewCell ()

/** 左边视图 */
@property (strong, nonatomic) UIImageView * leftImageView;

/** 标题 */
@property (strong, nonatomic) UILabel * titleLab;

/** 右边箭头 */
@property (strong, nonatomic) UIImageView * arrowImageView;

@end

@implementation DS_FindTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self layoutView];
    }
    return self;
}

#pragma mark - 界面
/** 布局 */
- (void)layoutView {
    UIView * containView = [[UIView alloc] init];
    containView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:containView];
    [containView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
    }];
    
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [containView addGestureRecognizer:tapGesture];
    
    [containView addSubview:self.leftImageView];
    [_leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.width.height.mas_equalTo(30);
        make.centerY.mas_equalTo(self.contentView);
    }];
    
    [containView addSubview:self.titleLab];
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_leftImageView.mas_right).offset(10);
        make.right.mas_equalTo(-20);
        make.centerY.mas_equalTo(self.contentView);
        make.height.mas_equalTo(50);
    }];
    
    [containView addSubview:self.arrowImageView];
    [_arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.width.mas_equalTo(12);
        make.height.mas_equalTo(24);
        make.centerY.mas_equalTo(self.contentView);
    }];
}

#pragma mark - setter
- (void)setType:(DS_FindCellType)type {
    _type = type;
    if (type == DS_FindCellType_Place) {
        _titleLab.text = @"投注地点";
        _leftImageView.image = [UIImage imageNamed:@"place"];
    } else {
        _titleLab.text = @"分析预测";
        _leftImageView.image = [UIImage imageNamed:@"predict"];
    }
}

#pragma mark - 手势
- (void)tapAction:(UITapGestureRecognizer *)sender {
    DS_BaseTabBarController * viewController = (DS_BaseTabBarController *)KeyWindows.rootViewController;
    if (_type == DS_FindCellType_Place) {
        [viewController selectedIndex:4];
    } else {
        DS_BaseTabBarController * nav = (DS_BaseTabBarController *)[viewController.viewControllers firstObject];
        
        DS_HomeViewController * vc = (DS_HomeViewController *)[nav.viewControllers firstObject];
        [vc searchNewsWithLotteryID:_lotteryID];
        [viewController selectedIndex:0];
    }
    
}

#pragma mark - 懒加载
- (UIImageView *)leftImageView {
    if (!_leftImageView) {
        _leftImageView = [[UIImageView alloc] init];
    }
    return _leftImageView;
}

- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.font = [UIFont systemFontOfSize:15.0f];
    }
    return _titleLab;
}

- (UIImageView *)arrowImageView {
    if (!_arrowImageView) {
        _arrowImageView = [[UIImageView alloc] init];
        _arrowImageView.image = [UIImage imageNamed:@"xinjian_shoujihao_jiantou"];
    }
    return _arrowImageView;
}



@end
