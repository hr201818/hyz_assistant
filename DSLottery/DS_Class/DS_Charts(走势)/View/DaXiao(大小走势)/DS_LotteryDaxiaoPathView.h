//
//  DS_LotteryDaxiaoPathView.h
//  DSLottery
//
//  Created by 黄玉洲 on 2018/6/1.
//  Copyright © 2018年 海南达生实业有限公司. All rights reserved.
//

#import "DS_BaseView.h"

@interface DS_LotteryDaxiaoPathView : DS_BaseView

/* 开奖码数组*/
@property (strong, nonatomic) NSMutableArray * codeList;

/* 彩种ID */
@property (copy, nonatomic)   NSString       * lottery_ID;

@end
