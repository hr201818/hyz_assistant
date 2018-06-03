//
//  DS_HaoMaTagView.m
//  DSLottery
//
//  Created by 黄玉洲 on 2018/6/3.
//  Copyright © 2018年 海南达生实业有限公司. All rights reserved.
//

#import "DS_HaoMaTagView.h"

@interface DS_HaoMaTagView () {
    // 位数
    NSString * _digitsTxt;
}
@end

@implementation DS_HaoMaTagView

/**
 初始化
 @param frame 大小
 @param digitsTxt 位数（万位、千位、百位、十位、个位）
 @return 标签视图
 */
- (instancetype)initWithFrame:(CGRect)frame
                    digitsTxt:(NSString *)digitsTxt {
    if ([super initWithFrame:frame]) {
        _digitsTxt = digitsTxt;
        [self layoutView];
    }
    return self;
}

#pragma mark - 界面
- (void)layoutView {
    
    self.backgroundColor = COLOR(255, 242, 242);
    
    // 位数
    UILabel * digitsLab = [[UILabel alloc] init];
    digitsLab.frame = CGRectMake(0, 0, self.width, self.height / 2.0);
    digitsLab.textAlignment = NSTextAlignmentCenter;
    digitsLab.text = _digitsTxt;
    digitsLab.font = FONT(13.0f);
    digitsLab.textColor = COLOR(83, 83, 83);
    [self addSubview:digitsLab];
    
    // 号码
    CGFloat x = 0;
    CGFloat y = self.height / 2.0;
    CGFloat width = self.width / 10;
    CGFloat height = y;
    for (NSInteger i = 0; i < 10; i++) {
        UILabel * numberLab = [[UILabel alloc] init];
        numberLab.frame = CGRectMake(x, height, width, height);
        numberLab.text = [NSString stringWithFormat:@"%ld", i];
        numberLab.textColor = COLOR(214, 31, 0);
        numberLab.textAlignment = NSTextAlignmentCenter;
        [self addSubview:numberLab];
        
        UIView * verticalVLine = [[UIView alloc] init];
        verticalVLine.frame = CGRectMake(x + width - 0.5, y, 0.5, height);
        verticalVLine.backgroundColor = COLOR(220, 220, 220);
        [self addSubview:verticalVLine];
        
        x += width;
    }
    
    UIView * right_verticalView = [[UIView alloc] init];
    right_verticalView.frame = CGRectMake(self.width - 0.5, 0, 0.5, self.height);
    right_verticalView.backgroundColor = COLOR(220, 220, 220);
    [self addSubview:right_verticalView];
    
    UIView * top_horizontalLine = [[UIView alloc] init];
    top_horizontalLine.frame = CGRectMake(0, self.height / 2, self.width, 0.3);
    top_horizontalLine.backgroundColor = COLOR(220, 220, 220);
    [self addSubview:top_horizontalLine];
    
    UIView * bottom_horizontalLine = [[UIView alloc] init];
    bottom_horizontalLine.frame = CGRectMake(0, self.height - 0.3, self.width, 0.3);
    bottom_horizontalLine.backgroundColor = COLOR(220, 220, 220);
    [self addSubview:bottom_horizontalLine];
}

#pragma mark - 懒加载


@end
