//
//  DS_HomeLotteryNoticeCell.h
//  DSLottery
//
//  Created by 黄玉洲 on 2018/5/23.
//  Copyright © 2018年 海南达生实业有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DS_LotteryNoticeListModel.h"


#import "DS_LotteryNoticeListModel.h"

static NSString * DS_HomeLotteryNoticeCellID = @"DS_HomeLotteryNoticeCell";
static CGFloat    DS_HomeLotteryNoticeCellMaxHeight = 150;
static CGFloat    DS_HomeLotteryNoticeCellMidHeight = 120;
static CGFloat    DS_HomeLotteryNoticeCellMinHeight = 120;

/** 首页开奖公告cell */
@interface DS_HomeLotteryNoticeCell : UITableViewCell

@property (strong, nonatomic) DS_LotteryNoticeModel * model;

/** 是否为开奖公告cell */
@property (assign, nonatomic) BOOL isLottery;

@end
