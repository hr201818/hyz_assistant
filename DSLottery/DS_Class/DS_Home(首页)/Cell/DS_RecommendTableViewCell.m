//
//  DS_RecommendTableViewCell.m
//  DSLottery
//
//  Created by 黄玉洲 on 2018/5/12.
//  Copyright © 2018年 海南达生实业有限公司. All rights reserved.
//

#import "DS_RecommendTableViewCell.h"
#import "DS_NewsSmallView.h"

@interface DS_RecommendTableViewCell ()

@property (strong, nonatomic) UIView  * topLine;

@property (strong, nonatomic) UILabel * contentLab;

@property (strong, nonatomic) UILabel * timeLab;

@property (strong, nonatomic) DS_NewsSmallView * lookView;

@end

@implementation DS_RecommendTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self layoutView];
    }
    return self;
}

#pragma mark - 界面
- (void)layoutView {
    
    [self.contentView addSubview:self.topLine];
    [_topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(1);
        make.left.right.mas_equalTo(0);
    }];
    
    [self.contentView addSubview:self.contentLab];
    [_contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(20);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(30);
    }];
    
    [self.contentView addSubview:self.timeLab];
    [_timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.width.mas_equalTo(100);
        make.top.mas_equalTo(_contentLab.mas_bottom).offset(5);
        make.height.mas_equalTo(20);
    }];
    
    [self.contentView addSubview:self.lookView];
    [_lookView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(_timeLab.mas_centerY);
        make.width.mas_equalTo(55);
        make.height.mas_equalTo(40);
    }];
}

#pragma mark - setter
- (void)setModel:(DS_NewsModel *)model {
    if (model) {
        _model = model;
        _contentLab.text = model.title;
        _timeLab.text = [DS_FunctionTool timestampTo:_model.createTime formatter:@"yyyy-MM-dd"];
        [_lookView setNumber:_model.readerNumb];
    }
}

#pragma mark - 懒加载
- (UIView *)topLine {
    if (!_topLine) {
        _topLine = [[UIView alloc] init];
        _topLine.backgroundColor = COLOR_Line;
    }
    return _topLine;
}


- (UILabel *)contentLab {
    if (!_contentLab) {
        _contentLab = [[UILabel alloc] init];
        _contentLab.text = @"[老李]福彩3D第18084期赞赏推荐：三胆159";
        _contentLab.font = FONT(14.0f);
    }
    return _contentLab;
}

- (UILabel *)timeLab {
    if (!_timeLab) {
        _timeLab = [[UILabel alloc] init];
        _timeLab.text = @"2018-04-01";
        _timeLab.textColor = COLOR_Font83;
        _timeLab.font = FONT(12.0f);
    }
    return _timeLab;
}

- (DS_NewsSmallView *)lookView {
    if (!_lookView) {
        _lookView = [[DS_NewsSmallView alloc] init];
        [_lookView setImageName:@"read_icon"];
    }
    return _lookView;
}

@end
