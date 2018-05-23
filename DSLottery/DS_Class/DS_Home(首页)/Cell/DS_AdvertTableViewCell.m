//
//  DS_AdvertTableViewCell.m
//  DSLottery
//
//  Created by 黄玉洲 on 2018/5/9.
//  Copyright © 2018年 海南达生实业有限公司. All rights reserved.
//

#import "DS_AdvertTableViewCell.h"

@interface DS_AdvertTableViewCell()

/** 容器视图 */
@property (strong, nonatomic) UIView * containView;

/** 星级推荐 */
@property (strong, nonatomic) UILabel * startLabel;

/** 广告图片 */
@property (strong, nonatomic) UIImageView * advertImageView;

/** 关注人数 */
@property (strong, nonatomic) UILabel * focusNumLab;

/** 标签 */
@property (strong, nonatomic) UILabel * tagLabel;

/** 上面的线条 */
@property (strong, nonatomic) UIView *  topLine;

/** 下面的线条 */
@property (strong, nonatomic) UIView *  bottomLine;


@end

@implementation DS_AdvertTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSeparatorStyleNone;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTouch)];
        [self addGestureRecognizer:tap];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = COLOR_BACK;
        [self layoutView];
    }
    return self;
}

#pragma mark - 界面
- (void)layoutView {
    [self.contentView addSubview:self.containView];
    [_containView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.centerY.mas_equalTo(self.contentView);
        make.height.mas_equalTo(145);
    }];
    
    [_containView addSubview:self.startLabel];
    [_startLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(25);
    }];
    
    [_containView addSubview:self.advertImageView];
    [_advertImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(90);
        make.top.mas_equalTo(_startLabel.mas_bottom);
    }];
    
    [_containView addSubview:self.focusNumLab];
    [_focusNumLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(25);
    }];
    
    [_containView addSubview:self.tagLabel];
    [_tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.bottom.mas_equalTo(-5);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(20);
    }];
    
    [_containView addSubview:self.topLine];
    [_topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
    
    [_containView addSubview:self.bottomLine];
    [_bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
}

#pragma mark - setter
- (void)setModel:(DS_AdvertModel *)model {
    _model = model;
    
    _startLabel.text = model.advertisTitle;
    [_advertImageView sd_setImageWithURL:model.imageURL placeholderImage:PLACEHOLDER_ADVERT];
    _focusNumLab.text = [NSString stringWithFormat:@"\%@位彩民关注过",model.advertisFollowNum];
}

- (void)setShowLine:(BOOL)showLine {
    _showLine = showLine;
    _topLine.hidden = !showLine;
    _bottomLine.hidden = !showLine;
}

#pragma mark - 手势
/** 手势 */
- (void)tapTouch {
    [DS_FunctionTool openUrl:_model.advertisUrl];
}

#pragma mark - 懒加载
- (UIView *)containView {
    if (!_containView) {
        _containView = [[UIView alloc] init];
        _containView.backgroundColor = [UIColor whiteColor];
    }
    return _containView;
}

- (UILabel *)startLabel {
    if (!_startLabel) {
        _startLabel = [[UILabel alloc] init];
        _startLabel.text = @"5星推荐，这个游戏2G也能玩";
        _startLabel.font = [UIFont systemFontOfSize:12.0f];
        _startLabel.textColor = COLOR_Font83;
    }
    return _startLabel;
}

- (UIImageView *)advertImageView {
    if (!_advertImageView) {
        _advertImageView = [[UIImageView alloc] init];
        _advertImageView.backgroundColor = [UIColor blackColor];
    }
    return _advertImageView;
}

- (UILabel *)focusNumLab {
    if (!_focusNumLab) {
        _focusNumLab = [[UILabel alloc] init];
        _focusNumLab.text = @"13388位彩民关注过";
        _focusNumLab.font = [UIFont systemFontOfSize:10.0f];
        _focusNumLab.textColor = COLOR_Font83;
    }
    return _focusNumLab;
}

- (UILabel *)tagLabel {
    if (!_tagLabel) {
        _tagLabel = [[UILabel alloc]init];
        _tagLabel.textColor = COLOR(234, 74, 46);
        _tagLabel.font = [UIFont systemFontOfSize:10];
        _tagLabel.layer.masksToBounds = YES;
        _tagLabel.layer.cornerRadius = 5;
        _tagLabel.textAlignment = NSTextAlignmentCenter;
        _tagLabel.layer.borderColor = COLOR(234, 74, 46).CGColor;
        _tagLabel.layer.borderWidth = 1;
        _tagLabel.text = @"广告";
    }
    return _tagLabel;
}

- (UIView *)topLine {
    if (!_topLine) {
        _topLine = [[UIView alloc] init];
        _topLine.backgroundColor = COLOR_Line;
        _topLine.hidden = YES;
    }
    return _topLine;
}

- (UIView *)bottomLine {
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc] init];
        _bottomLine.backgroundColor = COLOR_Line;
        _bottomLine.hidden = YES;
    }
    return _bottomLine;
}


@end
