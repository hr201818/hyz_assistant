//
//  DS_PanGestureRecognizer.h
//  DSLottery
//
//  Created by 黄玉洲 on 2018/4/26.
//  Copyright © 2018年 海南达生实业有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIGestureRecognizerSubclass.h>
@interface DS_PanGestureRecognizer : UIPanGestureRecognizer

/* 事件 */
@property (nonatomic, readonly) UIEvent *event;

/* 手势开始时的坐标 */
- (CGPoint)beganLocationInView:(UIView *)view;

@end
