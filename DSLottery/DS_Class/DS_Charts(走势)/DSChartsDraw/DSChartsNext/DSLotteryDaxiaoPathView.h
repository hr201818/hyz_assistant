//
//  DSLotteryDaxiaoPathView.h
//  DS_lottery
//
//  Created by pro on 2018/5/11.
//  Copyright © 2018年 海南达生实业有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DSLotteryDaxiaoPathView : UIView
/* 开奖码数组*/
@property (strong, nonatomic) NSMutableArray * codeList;
/* 彩种ID */
@property (copy, nonatomic)   NSString       * lottery_ID;
@end
