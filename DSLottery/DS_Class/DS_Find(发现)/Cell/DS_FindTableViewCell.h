//
//  DS_FindTableViewCell.h
//  DSLottery
//
//  Created by 黄玉洲 on 2018/5/15.
//  Copyright © 2018年 海南达生实业有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString * DS_FindTableViewCellID = @"DS_FindTableViewCell";
static CGFloat    DS_FindTableViewCellHeight = 50;

/** 界面类型 */
typedef NS_ENUM(NSInteger, DS_FindCellType) {
    DS_FindCellType_Place = 0,
    DS_FindCellType_Predict = 1
};

/** 标注地点、分析预测 */

@interface DS_FindTableViewCell : UITableViewCell

@property (assign, nonatomic) DS_FindCellType type;

/** 彩种ID，仅限于分析预测使用 */
@property (copy, nonatomic) NSString * lotteryID;

@end
