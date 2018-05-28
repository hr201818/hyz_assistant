//
//  DSLotteryHeweiPathView.h
//  DS_lottery
//
//  Created by pro on 2018/5/10.
//  Copyright © 2018年 海南达生实业有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DSLotteryHeweiPathView : UIView
/* 行数 */
@property (assign, nonatomic) NSInteger rowCount;
/* 列数 */
@property (strong, nonatomic) NSMutableArray * listArray;
/* 区间数组 例：10-20  */
@property (strong, nonatomic) NSMutableArray * sectionArray;
/* 开奖码 */
@property (strong, nonatomic) NSMutableArray * codeArray;
/* 标题颜色 */
@property (strong, nonatomic) UIColor * titleColor;
@end
