//
//  DS_LotteryOpenCodeView.h
//  DS_AA6
//
//  Created by 黄玉洲 on 2018/5/30.
//  Copyright © 2018年 黄玉洲. All rights reserved.
//

#import "DS_BaseView.h"

@interface DS_LotteryOpenCodeView : DS_BaseView

/* 开奖码数组*/
@property (strong, nonatomic) NSMutableArray * codeList;

/* 彩种ID */
@property (copy, nonatomic)   NSString       * lotteryId;

@end
