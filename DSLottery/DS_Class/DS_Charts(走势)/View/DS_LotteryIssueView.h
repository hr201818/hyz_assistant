//
//  DS_LotteryIssueView.h
//  DSLottery
//
//  Created by 黄玉洲 on 2018/5/29.
//  Copyright © 2018年 海南达生实业有限公司. All rights reserved.
//

#import "DS_BaseView.h"

/** 期号视图 */
static CGFloat DS_LotteryIssueViewHeight = 50;
@interface DS_LotteryIssueView : DS_BaseView

@property (copy, nonatomic) void(^issueBlock)(NSInteger tag);

@end
