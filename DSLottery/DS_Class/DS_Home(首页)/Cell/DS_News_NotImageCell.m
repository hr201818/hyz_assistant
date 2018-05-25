
//
//  DS_News_NotImageCell.m
//  DSLottery
//
//  Created by 黄玉洲 on 2018/5/23.
//  Copyright © 2018年 海南达生实业有限公司. All rights reserved.
//

#import "DS_News_NotImageCell.h"
#import "DS_NewsDetailViewController.h"

/** model */
#import "DS_AdvertListModel.h"

/** view */
#import "DS_NewsSmallView.h"

/** share */
#import "DS_CategoryShare.h"

@interface DS_News_NotImageCell ()

/** 标题 */
@property (strong, nonatomic) UILabel     * titleLabel;

/** 广告图 */
@property (strong, nonatomic) UIImageView * adverImageView;

/** 时间 */
@property (strong, nonatomic) UILabel     * timeLabel;

/** 分割线 */
@property (strong, nonatomic) UIView      * separator;

@end

@implementation DS_News_NotImageCell

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
    [self.contentView addSubview:self.titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(20);
        make.top.mas_equalTo(15);
    }];
    
    [self.contentView addSubview:self.adverImageView];
    [_adverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(_titleLabel.mas_bottom).offset(10);
        make.height.mas_equalTo(60);
    }];
    
    [self.contentView addSubview:self.timeLabel];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_titleLabel);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(20);
        make.top.mas_equalTo(_adverImageView.mas_bottom).offset(15);
    }];
    
    [self.contentView addSubview:self.separator];
    [_separator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.bottom.mas_equalTo(self.contentView);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(1);
    }];
}

#pragma mark - settet
- (void)setModel:(DS_NewsModel *)model {
    _model = model;
    
    // 设置标题
    _titleLabel.text = _model.title;
    
    // 设置评论和时间
    NSInteger offsetTime = [DS_FunctionTool timeOffsetWithTimeInterval:[_model.createTime integerValue] / 1000];
    NSString * timeStr = @"";
    if (offsetTime <= 60 * 5) {
        timeStr = @"刚刚";
    } else if (offsetTime / 60 < 60) {
        timeStr = [NSString stringWithFormat:@"%ld分钟前", offsetTime / 60];
    } else if (offsetTime / 3600 < 24) {
        timeStr = [NSString stringWithFormat:@"%ld小时前", offsetTime / 3600];
    } else {
        timeStr = [NSString stringWithFormat:@"%ld天前", offsetTime / 3600 / 24];
    }
    _timeLabel.text = [NSString stringWithFormat:@"134评论   %@",timeStr];
    
    // 设置图片
    DS_AdvertModel * adverModel = (DS_AdvertModel *)_model.adverModel;
    [_adverImageView sd_setImageWithURL:adverModel.imageURL placeholderImage:PLACEHOLDER_ADVERT];
}

#pragma mark - 手势
/** 打开详情 */
- (void)tapTouch {
    DS_NewsDetailViewController * vc = [[DS_NewsDetailViewController alloc] init];
    vc.model = _model;
    vc.models = _models;
    [self.viewController.navigationController pushViewController:vc animated:YES];
}

/** 打开广告 */
- (void)adverActon {
    DS_AdvertModel * adverModel = (DS_AdvertModel *)_model.adverModel;
    [DS_FunctionTool openAdvert:adverModel];
}

#pragma mark - 懒加载
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = FONT_BOLD(15.0f);
        _titleLabel.numberOfLines = 0;
        _titleLabel.text = @"神人独揽118注头奖共1180万！领奖称很感谢彩票";
    }
    return _titleLabel;
}

- (UIImageView *)adverImageView {
    if (!_adverImageView) {
        _adverImageView = [[UIImageView alloc] init];
        _adverImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(adverActon)];
        [_adverImageView addGestureRecognizer:tapGesture];
    }
    return _adverImageView;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont systemFontOfSize:12.0f];
        _timeLabel.textColor = COLOR_Font151;
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


@end


