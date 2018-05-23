//
//  DS_BaseTabBar.h
//  DSLottery
//
//  Created by 黄玉洲 on 2018/4/25.
//  Copyright © 2018年 海南达生实业有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DS_BaseTabBar : UITabBar

@property (nonatomic, copy) void(^selectIndexBlock)(NSInteger);

/* 外部执行调用 */
- (void)selectIndex:(NSInteger)index;

@end
