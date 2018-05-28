//
//  DSChartsLeftCellView.h
//  ALLTIMELOTTERY
//
//  Created by wangzhijie on 2018/5/21.
//  Copyright © 2018年 科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DSChartsView.h"

@interface DSChartsLeftCellView : UIView
//  号码走势所需数组 issueArr:期号 listArr:0～n 数字数组 resultArr:当前位开奖结果素组 lotteryNumberArr: 开奖结果总数组
- (instancetype)initWithFrame:(CGRect)frame andIssueArr:(NSArray *)issueArr andListArr:(NSArray *)listArr andResutArr:(NSArray *)resultArr andLotteryNumberArr:(NSArray *)lotteryNumberArr andSpanValue:(NSArray *)spanValues andChartType:(DSChartsType)charType;


@end
