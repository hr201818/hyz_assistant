//
//  DS_NewsHeaderView.m
//  DSLottery
//
//  Created by 黄玉洲 on 2018/5/12.
//  Copyright © 2018年 海南达生实业有限公司. All rights reserved.
//

#import "DS_NewsHeaderView.h"

/** view */
#import "DS_NewsSmallView.h"

@interface DS_NewsHeaderView ()

@property (strong, nonatomic) DS_NewsModel * model;

// 点赞
@property (strong, nonatomic) DS_NewsSmallView * praiseView;

// 阅读
@property (strong, nonatomic) DS_NewsSmallView * lookView;

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

-(void)layoutView{
    UIView * backView = [[UIView alloc]init];
    backView.backgroundColor = [UIColor whiteColor];
    [self addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.top.equalTo(@0);
        make.bottom.equalTo(@0);
    }];
    
    //标题
    UILabel * titleName = [[UILabel alloc]init];
    titleName.text = _model.title;
    titleName.textColor = COLOR_Font53;
    titleName.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
    titleName.numberOfLines = 0;
    [backView addSubview:titleName];
    [titleName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@5);
        make.left.equalTo(@10);
        make.right.equalTo(@(-10));
        make.height.equalTo(backView.mas_height).multipliedBy(0.5);
    }];
    
    [backView addSubview:self.praiseView];
    [_praiseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-80);
        make.bottom.mas_equalTo(0);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(40);
    }];
    
    [backView addSubview:self.lookView];
    [_lookView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.bottom.mas_equalTo(0);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(40);
    }];
}

#pragma mark - public
/** 设置点赞数量 */
- (void)setThumbNumber:(NSString *)thumbNumber {
    [_praiseView setNumber:thumbNumber];
}

/** 设置阅读数量 */
- (void)setReadNumber:(NSString *)readNumber {
    [_lookView setNumber:readNumber];
}

#pragma mark - 懒加载
- (DS_NewsSmallView *)praiseView {
    if (!_praiseView) {
        _praiseView = [[DS_NewsSmallView alloc] init];
        [_praiseView setImageName:@"thumb_icon" number:_model.thumbsUpNumb];
    }
    return _praiseView;
}

- (DS_NewsSmallView *)lookView {
    if (!_lookView) {
        _lookView = [[DS_NewsSmallView alloc] init];
        [_lookView setImageName:@"read_icon" number:_model.readerNumb];
    }
    return _lookView;
}


@end
