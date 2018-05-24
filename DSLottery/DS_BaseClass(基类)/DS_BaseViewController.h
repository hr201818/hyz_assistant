//
//  DS_BaseViewController.h
//  DSLottery
//
//  Created by 黄玉洲 on 2018/4/25.
//  Copyright © 2018年 海南达生实业有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewExt.h"
#import "Masonry.h"
#import "DS_FunctionTool.h"
#import "UIViewController+DSControllerHud.h"
#import "DS_BaseNavigationController.h"
@interface DS_BaseViewController : UIViewController

/* 导航条 */
@property (nonatomic, strong) UIImageView * navigationBar;

/** 导航条title图片 */
@property (strong, nonatomic) UIImage * navigationBarImage;

/**
 导航栏左侧视图
 @param leftItem 左侧元素
 */
- (void)navLeftItem:(UIView *)leftItem;

/**
 导航栏右侧视图
 @param rightItem 右侧元素
 */
- (void)navRightItem:(UIView *)rightItem;

/**
 展示tost
 @param tostStr      tost内容
 @param timeInterval 保留时间
 */
-(void)showMakeTostWithText:(NSString *)tostStr
            andTimeInterval:(NSTimeInterval)timeInterval;

/**
 让导航栏透明
 */
- (void)transparentNavigationBar;

#pragma mark - 用于重写的方法
/** 布局，仅仅用于重写 */
- (void)layoutView;

/** 左侧按钮事件 */
- (void)leftButtonAction:(UIButton *)sender;

/** 右侧按钮事件 */
- (void)rightButtonAction:(UIButton *)sender;


#pragma mark - 通知
/** 移除通知 */
- (void)removeNotification;

/** 注册通知 */
- (void)registerNotification;

@end
