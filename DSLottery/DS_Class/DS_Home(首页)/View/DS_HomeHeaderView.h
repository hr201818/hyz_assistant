//
//  DS_HomeHeaderView.h
//  ALLTIMELOTTERY
//
//  Created by 黄玉洲 on 2018/5/4.
//  Copyright © 2018年 科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DS_HomeHeaderView : UIView

- (instancetype)initWithFrame:(CGRect)frame;

#pragma mark - 数据设置
/** 设置公告轮播 */
- (void)setNoticeCycleArray:(NSArray *)notices;

#pragma mark - 界面
/** 刷新轮播图 */
- (void)refreshBanner;

/**
 设置自动轮播
 @param autoScroll 是否自动轮播
 */
- (void)setAutoScroll:(BOOL)autoScroll;

@end
