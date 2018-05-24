//
//  DS_AdvertView.m
//  DSLottery
//
//  Created by 黄玉洲 on 2018/5/9.
//  Copyright © 2018年 海南达生实业有限公司. All rights reserved.
//

#import "DS_AdvertView.h"

@interface DS_AdvertView()

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

@end

@implementation DS_AdvertView


- (instancetype)init {
    if ([super init]) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTouch)];
        [self addGestureRecognizer:tap];
        self.backgroundColor = COLOR_BACK;
        [self layoutView];
    }
    return self;
}

#pragma mark - 界面
- (void)layoutView {
    [self addSubview:self.containView];
    [_containView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(10);
        make.height.mas_equalTo(DS_AdvertViewHeight - 20);
    }];
    
    [_containView addSubview:self.startLabel];
    [_startLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(30);
    }];
    
    [_containView addSubview:self.advertImageView];
    [_advertImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(80);
        make.top.mas_equalTo(_startLabel.mas_bottom);
    }];
    
    [_containView addSubview:self.focusNumLab];
    [_focusNumLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.bottom.mas_equalTo(0);
        make.top.mas_equalTo(_advertImageView.mas_bottom);
        make.width.mas_equalTo(160);
    }];
    
    [_containView addSubview:self.tagLabel];
    [_tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.width.mas_equalTo(40);
        make.top.mas_equalTo(_advertImageView.mas_bottom);
        make.bottom.mas_equalTo(0);
    }];
}

#pragma mark - setter
- (void)setModel:(DS_AdvertModel *)model {
    _model = model;
    
    _startLabel.text = model.advertisTitle;
    [_advertImageView sd_setImageWithURL:model.imageURL placeholderImage:PLACEHOLDER_ADVERT];
    _focusNumLab.text = [NSString stringWithFormat:@"\%@位彩民关注过",model.advertisFollowNum];
}

#pragma mark - 手势
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
        _focusNumLab.textAlignment = NSTextAlignmentRight;
        _focusNumLab.font = [UIFont systemFontOfSize:12.0f];
        _focusNumLab.textColor = COLOR_Font83;
    }
    return _focusNumLab;
}

- (UILabel *)tagLabel {
    if (!_tagLabel) {
        _tagLabel = [[UILabel alloc] init];
        _tagLabel.textColor = COLOR_HexRGB(@"008ECE");
        _tagLabel.font = [UIFont systemFontOfSize:12];
        _tagLabel.layer.masksToBounds = YES;
        _tagLabel.layer.cornerRadius = 5;
        _tagLabel.textAlignment = NSTextAlignmentCenter;
        _tagLabel.text = @"广告";
    }
    return _tagLabel;
}


@end
