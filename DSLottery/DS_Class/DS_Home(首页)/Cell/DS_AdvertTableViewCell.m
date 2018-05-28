//
//  DS_AdvertTableViewCell.m
//  DSLottery
//
//  Created by 黄玉洲 on 2018/5/9.
//  Copyright © 2018年 海南达生实业有限公司. All rights reserved.
//

#import "DS_AdvertTableViewCell.h"
#import "DS_AdvertView.h"
@interface DS_AdvertTableViewCell()

@property (strong, nonatomic) DS_AdvertView * advertView;

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
    [self.contentView addSubview:self.advertView];
    [_advertView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

#pragma mark - setter
- (void)setModel:(DS_AdvertModel *)model {
    if (model) {
        _model = model;
        _advertView.model = model;
    }
}

//- (void)setShowLine:(BOOL)showLine {
//    _showLine = showLine;
//    _topLine.hidden = !showLine;
//    _bottomLine.hidden = !showLine;
//}

#pragma mark - 手势
/** 手势 */
- (void)tapTouch {
    [DS_FunctionTool openUrl:_model.advertisUrl];
}

#pragma mark - 懒加载
- (DS_AdvertView *)advertView {
    if (!_advertView) {
        _advertView = [DS_AdvertView new];
    }
    return _advertView;
}


@end
