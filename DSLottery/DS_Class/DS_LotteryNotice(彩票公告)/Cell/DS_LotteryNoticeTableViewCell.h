//
//  DS_LotteryNoticeTableViewCell.h
//  DSLottery
//
//  Created by 黄玉洲 on 2018/5/14.
//  Copyright © 2018年 海南达生实业有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DS_LotteryNoticeListModel.h"

static NSString * DS_LotteryNoticeTableViewCellID = @"DS_LotteryListTableViewCell";
static CGFloat DS_LotteryNoticeTableViewCellMaxHeight = 150;
static CGFloat DS_LotteryNoticeTableViewCellMidHeight = 120;
static CGFloat DS_LotteryNoticeTableViewCellMinHeight = 90;

@interface DS_LotteryNoticeTableViewCell : UITableViewCell

@property (strong, nonatomic) DS_LotteryNoticeModel * model;

@end
