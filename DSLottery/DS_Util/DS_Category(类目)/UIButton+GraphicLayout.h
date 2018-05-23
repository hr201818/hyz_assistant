//
//  UIButton+GraphicLayout.h
//  DS_lottery
//
//  Created by 黄玉洲 on 2018/5/8.
//  Copyright © 2018年 海南达生实业有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DS_ImagePosition) {
    DS_ImagePositionLeft = 0, //图片在左，文字在右，默认
    DS_ImagePositionRight = 1, //图片在右，文字在左
    DS_ImagePositionTop = 2, //图片在上，文字在下
    DS_ImagePositionBottom = 3, //图片在下，文字在上
};

@interface UIButton (GraphicLayout)

/**
 * 利用UIButton的titleEdgeInsets和imageEdgeInsets来实现文字和图片的自由排列
 * 注意：这个方法需要在设置图片和文字之后才可以调用，且button的大小要大于 图片大小+文字大小+spacing
 *
 * @param spacing 图片和文字的间隔 */
- (void)setImagePosition:(DS_ImagePosition)postion spacing:(CGFloat)spacing;

@end
