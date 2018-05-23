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

/** 设置下标 */
- (void)setIndex:(NSInteger)index;

#pragma mark - 界面
/** 刷新轮播图 */
- (void)refreshBanner;

/** 刷新分类 */
- (void)refreshCategory;

#pragma mark - 回调
/** 滚动条点击回调 */
@property (copy, nonatomic) void(^categoryIDBlock)(NSString * categoryID);

/** 扩展按钮回调 */
@property (copy, nonatomic) void(^extensionBlock)(void);

@end
