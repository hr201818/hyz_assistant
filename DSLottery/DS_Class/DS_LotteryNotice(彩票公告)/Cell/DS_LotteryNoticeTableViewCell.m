//
//  DS_LotteryNoticeTableViewCell.m
//  DSLottery
//
//  Created by 黄玉洲 on 2018/5/14.
//  Copyright © 2018年 海南达生实业有限公司. All rights reserved.
//

#import "DS_LotteryNoticeTableViewCell.h"
#import "DS_DrawDigitalView.h"
@interface DS_LotteryNoticeTableViewCell ()

/** 分隔线左侧视图 */
@property (strong, nonatomic) UIView * leftContainView;

/** 分隔线右侧视图 */
@property (strong, nonatomic) UIView * rightContainView;

/* 存放开奖结果的View父视图 */
@property (strong, nonatomic) UIView  * backView;

/** 彩种图片 */
@property (strong, nonatomic) UIImageView * lotteryImageView;

/* 期号 */
@property (strong, nonatomic) UILabel * dateNumber;

@end

@implementation DS_LotteryNoticeTableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        /* 布局视图*/
        [self layoutView];
        
    }
    return self;
}

#pragma mark - 界面
/** 布局 */
- (void)layoutView {
    
    // 左侧容器视图
    [self.contentView addSubview:self.leftContainView];
    [_leftContainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo(90);
    }];
    
    // 图片
    [_leftContainView addSubview:self.lotteryImageView];
    [self.lotteryImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(55);
        make.centerX.mas_equalTo(_leftContainView);
        make.centerY.mas_equalTo(_leftContainView);
    }];
    
    UIView * lineVertical = [[UIView alloc]init];
    lineVertical.backgroundColor = COLOR_Line;
    [_leftContainView addSubview:lineVertical];
    [lineVertical mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(5);
        make.bottom.mas_equalTo(-5);
        make.right.mas_equalTo(0);
        make.width.mas_equalTo(1);
    }];
    
    // 右侧容器视图
    [self.contentView addSubview:self.rightContainView];
    [_rightContainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_leftContainView.mas_right);
        make.top.bottom.right.mas_equalTo(0);
    }];
    
    // 彩种期数
    [_rightContainView addSubview:self.dateNumber];
    [_dateNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(15);
        make.height.mas_equalTo(20);
    }];
    
    //圆球的父视图，方便清除
    [_rightContainView addSubview:self.backView];
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_dateNumber);
        make.right.mas_equalTo(-40);
        make.height.mas_equalTo(50);
        make.top.mas_equalTo(_dateNumber.mas_bottom).offset(10);
    }];
    
    //箭头
    UIImageView * arrowsIcon = [[UIImageView alloc] init];
    [arrowsIcon setImage:[UIImage imageNamed:@"shezhi_icon_jiantou"]];
    [_rightContainView addSubview:arrowsIcon];
    [arrowsIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-5));
        make.width.equalTo(@15);
        make.height.equalTo(@15);
        make.centerY.equalTo(@5);
    }];
    
    UIView * lineHorizontal = [[UIView alloc] init];
    lineHorizontal.backgroundColor = COLOR_Line;
    [self.contentView addSubview:lineHorizontal];
    [lineHorizontal mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
}

#pragma mark - setter
-(void)setModel:(DS_LotteryNoticeModel *)model {
    _model = model;
    
    NSString * weekStr = [DS_FunctionTool weekWithTime:[model.openTime integerValue] prefix:@"周"];
    NSString * dateSte = [DS_FunctionTool timestampTo:model.openTime formatter:@"yyyy-MM-dd"];
    self.dateNumber.text = [NSString stringWithFormat:@"%@期 %@（%@）",model.number, dateSte, weekStr];
    
    _lotteryImageView.image = [UIImage imageNamed:[DS_FunctionTool imageNameWithImageID:model.playGroupId]];
    
    
    NSArray *array = [model.openCode componentsSeparatedByString:@","];
    CGFloat left = IOS_SiZESCALE(0);
    CGFloat top = IOS_SiZESCALE(0);
    for (int i = 0; i < array.count; i++) {
        if (i % 7 == 0 && i != 0) {
            left = IOS_SiZESCALE(0);
            top += IOS_SiZESCALE(30);
        } else if (i != 0) {
            left += IOS_SiZESCALE(30);
        }
        
        DS_DrawDigitalView * digitalView = [[DS_DrawDigitalView alloc] initWithFrame:CGRectMake(left, top, IOS_SiZESCALE(25), IOS_SiZESCALE(25)) number:[array[i] integerValue]];
        [self.backView addSubview:digitalView];
        
        // 双色球单独处理
        if ([model.playGroupId isEqualToString:@"12"] && i == array.count - 1) {
            digitalView.textColor = [UIColor blueColor];
        }
    }
}

-(void)prepareForReuse{
    [super prepareForReuse];
    for (UIView *view in self.backView.subviews) {
        [view removeFromSuperview];
    }
}

#pragma mark - 懒加载
- (UIView *)leftContainView {
    if (!_leftContainView) {
        _leftContainView = [[UIView alloc] init];
    }
    return _leftContainView;
}

- (UIView *)rightContainView {
    if (!_rightContainView) {
        _rightContainView = [[UIView alloc] init];
    }
    return _rightContainView;
}

- (UIImageView *)lotteryImageView {
    if (!_lotteryImageView) {
        _lotteryImageView = [[UIImageView alloc] init];
        _lotteryImageView.image = [UIImage imageNamed:@"chongqing"];
    }
    return _lotteryImageView;
}

- (UILabel *)dateNumber {
    if (!_dateNumber) {
        _dateNumber = [[UILabel alloc]init];
        _dateNumber.textColor = COLOR_Font151;
        _dateNumber.font = [UIFont systemFontOfSize:12];
    }
    return _dateNumber;
}

- (UIView *)backView {
    if (!_backView) {
        _backView = [[UIView alloc] init];
    }
    return _backView;
}


@end
