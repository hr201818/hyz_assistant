//
//  DS_LotteryNoticeDetailCell.m
//  DSLottery
//
//  Created by 黄玉洲 on 2018/5/14.
//  Copyright © 2018年 海南达生实业有限公司. All rights reserved.
//

#import "DS_LotteryNoticeDetailCell.h"
#import "DS_DrawDigitalView.h"
@interface DS_LotteryNoticeDetailCell ()

/** 分隔线右侧视图 */
@property (strong, nonatomic) UIView * rightContainView;

/* 存放开奖结果的View父视图 */
@property (strong, nonatomic) UIView  * backView;

/* 期号 */
@property (strong, nonatomic) UILabel * dateNumber;

@end

@implementation DS_LotteryNoticeDetailCell


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
    
    // 右侧容器视图
    [self.contentView addSubview:self.rightContainView];
    [_rightContainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
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
    if (model) {
        _model = model;
        
        NSString * weekStr = [DS_FunctionTool weekWithTime:[model.openTime integerValue] prefix:@"周"];
        NSString * dateStr = [DS_FunctionTool timestampTo:model.openTime formatter:@"yyyy-MM-dd"];
        NSString * dateAllStr = [NSString stringWithFormat:@"%@期 %@（%@）",model.number, dateStr, weekStr];
        NSMutableAttributedString * mAttribute = [[NSMutableAttributedString alloc] initWithString:dateAllStr];
        [mAttribute addAttribute:NSKernAttributeName value:@(IOS_SiZESCALE(1)) range:NSMakeRange(0, dateAllStr.length)];
        self.dateNumber.text = dateAllStr;
        self.dateNumber.attributedText = mAttribute;
        
        NSArray *array = [model.openCode componentsSeparatedByString:@","];
        CGFloat left = IOS_SiZESCALE(0);
        CGFloat top = IOS_SiZESCALE(0);
        for (int i = 0; i < array.count; i++) {
            
            DS_DrawDigitalView * digitalView = [[DS_DrawDigitalView alloc] initWithFrame:CGRectMake(left, top, IOS_SiZESCALE(25), IOS_SiZESCALE(25)) number:[array[i] integerValue]];
            [self.backView addSubview:digitalView];
            
            // 双色球单独处理
            if ([model.playGroupId isEqualToString:@"12"] && i == array.count - 1) {
                digitalView.textColor = [UIColor blueColor];
            }
            
            if(i == 9){
                left = IOS_SiZESCALE(0);
                top = IOS_SiZESCALE(30);
            }else{
                left += IOS_SiZESCALE(40);
            }
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
- (UIView *)rightContainView {
    if (!_rightContainView) {
        _rightContainView = [[UIView alloc] init];
    }
    return _rightContainView;
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
