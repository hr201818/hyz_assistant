//
//  DS_NewsHeaderView.m
//  DSLottery
//
//  Created by 黄玉洲 on 2018/5/12.
//  Copyright © 2018年 海南达生实业有限公司. All rights reserved.
//

#import "DS_NewsHeaderView.h"

@interface DS_NewsHeaderView ()

@property (strong, nonatomic) DS_NewsModel * model;

/** 标题 */
@property (strong, nonatomic) UILabel      * titleLab;

/** 时间 */
@property (strong, nonatomic) UILabel      * dateLab;

@end

@implementation DS_NewsHeaderView


- (instancetype)initWithFrame:(CGRect)frame model:(DS_NewsModel *)model
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = COLOR_BACK;
        _model = model;
        [self layoutView];
    }
    return self;
}

- (void)layoutView {
    UIView * backView = [[UIView alloc]init];
    backView.backgroundColor = [UIColor whiteColor];
    [self addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    
    //标题
    [backView addSubview:self.titleLab];
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(5);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(backView.mas_height).multipliedBy(0.5);
    }];
    
    // 时间和评论
    [backView addSubview:self.dateLab];
    [_dateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_titleLab);
        make.top.mas_equalTo(_titleLab.mas_bottom).offset(10);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(20);
    }];
}

#pragma mark - 懒加载
- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc]init];
        _titleLab.text = _model.title;
        _titleLab.textColor = COLOR_Font53;
        _titleLab.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
        _titleLab.numberOfLines = 0;
    }
    return _titleLab;
}

- (UILabel *)dateLab {
    if (!_dateLab) {
        _dateLab = [[UILabel alloc] init];
        _dateLab.font = FONT(13.0f);
        _dateLab.textColor = COLOR_Font151;
        
        NSString * dateStr = [DS_FunctionTool timestampTo:_model.createTime formatter:@"yyyy-MM-dd HH:mm:ss"];
        NSString * watchNumber = _model.readerNumb;
        
        _dateLab.text = [NSString stringWithFormat:@"%@ | %@人浏览", dateStr, watchNumber];
    }
    return _dateLab;
}


@end
