//
//  YM_DrawDigitalRoundView.h
//  YM_DrawDigitalAndRound
//
//  Created by 黄玉洲 on 2018/5/22.
//

#import <UIKit/UIKit.h>

/** 绘制圆形数字视图 */
@interface YM_DrawDigitalRoundView : UIView

/**
 初始化
 @param frame  尺寸
 @param number 要绘制数字
 @return 绘制后的视图
 */
- (instancetype)initWithFrame:(CGRect)frame number:(NSInteger)number;

/** 字体颜色 */
@property (strong, nonatomic) UIColor * textColor;

/** 字体大小 */
@property (strong, nonatomic) UIFont  * textFont;

/** 边框颜色 */
@property (strong, nonatomic) UIColor * borderColor;

/** 是否填满整个圆圈 */
@property (assign, nonatomic) BOOL isFill;

/** 设置了以上属性之后，需要调用一下这个方法重新绘制 */
- (void)redraw;

@end
