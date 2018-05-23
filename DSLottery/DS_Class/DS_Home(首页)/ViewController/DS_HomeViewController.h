//
//  DS_HomeViewController.h
//  DSLottery
//
//  Created by 黄玉洲 on 2018/5/9.
//  Copyright © 2018年 海南达生实业有限公司. All rights reserved.
//

#import "DS_BaseViewController.h"

@interface DS_HomeViewController : DS_BaseViewController

/** 搜索指定彩种的资讯 */
- (void)searchNewsWithLotteryID:(NSString *)lotteryID;

@end
