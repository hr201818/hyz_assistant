//
//  DS_DrawDigitalView.h
//  DSLottery
//
//  Created by 黄玉洲 on 2018/5/14.
//  Copyright © 2018年 海南达生实业有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 绘制圆形数字视图 */
@interface DS_DrawDigitalView : UIView

/**
 初始化
 @param frame  尺寸
 @param number 要绘制数字
 @return 绘制后的视图
 */
- (instancetype)initWithFrame:(CGRect)frame number:(NSInteger)number;

/** 字体颜色 */
@property (strong, nonatomic) UIColor * textColor;

/** 边框颜色 */
@property (strong, nonatomic) UIColor * borderColor;

@end
