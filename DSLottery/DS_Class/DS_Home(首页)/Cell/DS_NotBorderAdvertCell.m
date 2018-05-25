//
//  DS_NotBorderAdvertCell.m
//  DSLottery
//
//  Created by 黄玉洲 on 2018/5/25.
//  Copyright © 2018年 海南达生实业有限公司. All rights reserved.
//

#import "DS_NotBorderAdvertCell.h"
#import "DS_BaseAdvertView.h"

@interface DS_NotBorderAdvertCell ()

@property (strong, nonatomic) DS_BaseAdvertView * advertView;

@end

@implementation DS_NotBorderAdvertCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self layoutView];
    }
    return self;
}

#pragma mark - 界面
/** 布局 */
- (void)layoutView {
    [self.contentView addSubview:self.advertView];
    [_advertView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView);
    }];
}

#pragma mark - setter
- (void)setModel:(DS_AdvertModel *)model {
    if (model) {
        _model = model;
        _advertView.model = model;
    }
}

#pragma mark - 懒加载
- (DS_BaseAdvertView *)advertView {
    if (!_advertView) {
        _advertView = [[DS_BaseAdvertView alloc] init];
    }
    return _advertView;
}

@end
