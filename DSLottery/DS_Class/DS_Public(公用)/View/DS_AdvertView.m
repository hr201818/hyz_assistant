//
//  DS_AdvertView.m
//  DSLottery
//
//  Created by 黄玉洲 on 2018/5/9.
//  Copyright © 2018年 海南达生实业有限公司. All rights reserved.
//

#import "DS_AdvertView.h"

@interface DS_AdvertView()

@property (strong, nonatomic) DS_BaseAdvertView * baseAdvertView;

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
    [self addSubview:self.baseAdvertView];
    [_baseAdvertView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(10);
        make.height.mas_equalTo(DS_BaseAdvertViewHeight);
    }];
}

#pragma mark - setter
- (void)setModel:(DS_AdvertModel *)model {
    _model = model;
    _baseAdvertView.model = model;
}

#pragma mark - 手势
- (void)tapTouch {
    [DS_FunctionTool openUrl:_model.advertisUrl];
}

#pragma mark - 懒加载
- (DS_BaseAdvertView *)baseAdvertView {
    if (!_baseAdvertView) {
        _baseAdvertView = [[DS_BaseAdvertView alloc] init];
    }
    return _baseAdvertView;
}
@end
