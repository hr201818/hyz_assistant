//
//  DS_LotteryNoticeDetailCell.h
//  DSLottery
//
//  Created by 黄玉洲 on 2018/5/14.
//  Copyright © 2018年 海南达生实业有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DS_LotteryNoticeListModel.h"
static NSString * DS_LotteryNoticeDetailCellID = @"DS_LotteryDetailTableViewCell";
static CGFloat DS_LotteryNoticeDetailCellMaxHeight = 135;
static CGFloat DS_LotteryNoticeDetailCellMinHeight = 120;
@interface DS_LotteryNoticeDetailCell : UITableViewCell

@property (strong, nonatomic) DS_LotteryNoticeModel * model;

@end
