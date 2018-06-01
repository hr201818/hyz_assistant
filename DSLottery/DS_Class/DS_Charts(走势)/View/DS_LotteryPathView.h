//
//  DS_LotteryPathView.h
//  DS_AA6
//
//  Created by 黄玉洲 on 2018/5/30.
//  Copyright © 2018年 黄玉洲. All rights reserved.
//

#import "DS_BaseView.h"

/** 走势图 */
@interface DS_LotteryPathView : DS_BaseView

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
