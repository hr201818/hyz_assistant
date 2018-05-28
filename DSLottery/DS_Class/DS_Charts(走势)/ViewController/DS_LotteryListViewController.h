//
//  DS_LotteryListViewController.h
//  DSLottery
//
//  Created by 黄玉洲 on 2018/5/28.
//  Copyright © 2018年 海南达生实业有限公司. All rights reserved.
//

#import "DS_BaseViewController.h"

@interface DS_LotteryListViewController : DS_BaseViewController

/** 选择彩种回调 */
@property (copy, nonatomic) void(^selectLotteryBlock)(NSString *lotterID);

@end
