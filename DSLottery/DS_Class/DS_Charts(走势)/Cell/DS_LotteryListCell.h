//
//  DS_LotteryListCell.h
//  DSLottery
//
//  Created by 黄玉洲 on 2018/5/28.
//  Copyright © 2018年 海南达生实业有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString * DS_LotteryListCellID = @"DS_LotteryListCell";
static CGFloat    DS_LotteryListCellHeight = 50;

/** 彩种列表cell */
@interface DS_LotteryListCell : UITableViewCell

/** 彩种ID */
@property (copy, nonatomic) NSString * lotteryID;

@end
