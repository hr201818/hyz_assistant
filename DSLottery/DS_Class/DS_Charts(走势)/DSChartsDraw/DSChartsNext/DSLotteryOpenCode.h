//
//  DSLotteryOpenCode.h
//  DS_lottery
//
//  Created by pro on 2018/5/7.
//  Copyright © 2018年 海南达生实业有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

/* 开奖码 */
@interface DSLotteryOpenCode : UIView
/* 开奖码数组*/
@property (strong, nonatomic) NSMutableArray * codeList;
/* 彩种ID */
@property (copy, nonatomic)   NSString       * lotteryId;

@end
