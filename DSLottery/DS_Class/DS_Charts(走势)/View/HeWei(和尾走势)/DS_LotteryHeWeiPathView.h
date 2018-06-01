//
//  DS_LotteryHeWeiPathView.h
//  DSLottery
//
//  Created by 黄玉洲 on 2018/6/1.
//  Copyright © 2018年 海南达生实业有限公司. All rights reserved.
//

#import "DS_BaseView.h"

@interface DS_LotteryHeWeiPathView : DS_BaseView

/** 行数 */
@property (assign, nonatomic) NSInteger rowCount;

/** 列数 */
@property (strong, nonatomic) NSMutableArray * listArray;

/** 区间数组 例：10-20  */
@property (strong, nonatomic) NSMutableArray * sectionArray;

/** 开奖码 */
@property (strong, nonatomic) NSMutableArray * codeArray;

/** 标题颜色 */
@property (strong, nonatomic) UIColor * titleColor;

@end
