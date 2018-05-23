//
//  DS_BaseTabBarItem.h
//  DSLottery
//
//  Created by 黄玉洲 on 2018/4/25.
//  Copyright © 2018年 海南达生实业有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface DS_BaseTabBarItem : UIView

/**
 初始化方法
 @param infoDic tabbar信息
 @return tabbarItem
 */
- (instancetype)initWithTabbarInfo:(NSDictionary *)infoDic;

// 是否选中
@property (nonatomic, assign) BOOL isSelected;

@end
