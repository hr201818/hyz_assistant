//
//  DS_NewsTableViewCell.m
//  DSLottery
//
//  Created by 黄玉洲 on 2018/5/9.
//  Copyright © 2018年 海南达生实业有限公司. All rights reserved.
//

#import "DS_NewsTableViewCell.h"
#import "DS_NewsDetailViewController.h"

/** view */
#import "DS_NewsSmallView.h"

/** share */
#import "DS_CategoryShare.h"

@interface DS_NewsTableViewCell ()

/** 左边图片 */
@property (strong, nonatomic) UIImageView * leftImageView;

/** 标题 */
@property (strong, nonatomic) UILabel     * titleLabel;

/** 时间 */
@property (strong, nonatomic) UILabel     * timeLabel;

/** 分割线 */
@property (strong, nonatomic) UIView      * separator;

/** 点赞数视图 */
@property (strong, nonatomic) DS_NewsSmallView * praiseView;

/** 查阅数视图 */
@property (strong, nonatomic) DS_NewsSmallView * lookView;

@end

@implementation DS_NewsTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self layoutView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTouch)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

#pragma mark - 布局
- (void)layoutView {
    [self.contentView addSubview:self.leftImageView];
    [_leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.width.height.mas_equalTo(50);
    }];
    
    [self.contentView addSubview:self.titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_leftImageView.mas_right).offset(10);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(35);
        make.top.mas_equalTo(25);
    }];
    
    [self.contentView addSubview:self.timeLabel];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_titleLabel);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(20);
        make.top.mas_equalTo(70);
    }];
    
    [self.contentView addSubview:self.praiseView];
    [_praiseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-80);
        make.centerY.mas_equalTo(_timeLabel);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(40);
    }];
    
    [self.contentView addSubview:self.lookView];
    [_lookView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_timeLabel);
        make.width.mas_equalTo(60);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(40);
    }];
    
    [self.contentView addSubview:self.separator];
    [_separator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.bottom.mas_equalTo(self.contentView);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
}


#pragma mark - settet
- (void)setModel:(DS_NewsModel *)model {
    _model = model;
    _titleLabel.text = _model.title;
    _timeLabel.text = [DS_FunctionTool timestampTo:_model.createTime formatter:@"yyyy-MM-dd"];
    [_praiseView setNumber:_model.thumbsUpNumb];
    [_lookView setNumber:_model.readerNumb];
    
    NSString * lotteryID = [[DS_CategoryShare share] lotteryIDWithCategoryID:_model.categoryId];
    NSString * imageName = [DS_FunctionTool imageNameWithImageID:lotteryID];
    _leftImageView.image = [UIImage imageNamed:imageName];
}

#pragma mark - 手势
- (void)tapTouch {
    DS_NewsDetailViewController * vc = [[DS_NewsDetailViewController alloc] init];
    vc.model = _model;
    vc.models = _models;
    [self.viewController.navigationController pushViewController:vc animated:YES];
}


#pragma mark - 懒加载
- (UIImageView *)leftImageView {
    if (!_leftImageView) {
        _leftImageView = [[UIImageView alloc] init];
        _leftImageView.image = [UIImage imageNamed:@"kaij_29"];
    }
    return _leftImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:14.0f];
        _titleLabel.numberOfLines = 0;
        _titleLabel.text = @"神人独揽118注头奖共1180万！领奖称很感谢彩票";
    }
    return _titleLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont systemFontOfSize:12.0f];
        _timeLabel.textColor = COLOR_Font83;
        _timeLabel.text = @"2018-04-01";
    }
    return _timeLabel;
}

- (UIView *)separator {
    if (!_separator) {
        _separator = [UIView new];
        _separator.backgroundColor = COLOR_Line;
    }
    return _separator;
}

- (DS_NewsSmallView *)praiseView {
    if (!_praiseView) {
        _praiseView = [[DS_NewsSmallView alloc] init];
        [_praiseView setImageName:@"thumb_icon"];
    }
    return _praiseView;
}

- (DS_NewsSmallView *)lookView {
    if (!_lookView) {
        _lookView = [[DS_NewsSmallView alloc] init];
        [_lookView setImageName:@"read_icon"];
    }
    return _lookView;
}

@end
