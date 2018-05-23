//
//  DS_BaseNavigationController.h
//  DSLottery
//
//  Created by 黄玉洲 on 2018/4/25.
//  Copyright © 2018年 海南达生实业有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DS_BaseNavigationController : UINavigationController<UINavigationControllerDelegate,UIGestureRecognizerDelegate>

@property (readonly, nonatomic) UIPanGestureRecognizer * panGestureRecognizer;

/* 拖拽开关(默认开启) */
@property (assign, nonatomic) BOOL  backhandlepan;

/* 全局侧拉(默认开启,关闭后是只有左边才可拉动) */
@property (assign, nonatomic) BOOL  overallSituation;

/* 根导航控制器(默认关闭,截图的原因需要添加) */
@property (assign, nonatomic) BOOL  moduleRoot;

@end

@protocol DS_PanGestureDelegate <NSObject>
/* 手势可用 */
- (BOOL)enablePanBack:(DS_BaseNavigationController *)panNavigationController;

/* 手势开始 */
- (void)startPanBack:(DS_BaseNavigationController *)panNavigationController;

/* 完成手势 */
- (void)finshPanBack:(DS_BaseNavigationController *)panNavigationController;

/* 重置手势 */
- (void)resetPanBack:(DS_BaseNavigationController *)panNavigationController;

@end
