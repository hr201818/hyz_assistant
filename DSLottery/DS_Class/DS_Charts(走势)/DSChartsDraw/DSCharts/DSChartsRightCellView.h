//
//  DSChartsRightCellView.h
//  ALLTIMELOTTERY
//
//  Created by wangzhijie on 2018/5/21.
//  Copyright © 2018年 科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DSChartsView.h"

@interface DSChartsRightCellView : UIView

/**
 走势图 right cell 
 @param frame <#frame description#>
 @param issueArr <#issueArr description#>
 @param listArr <#listArr description#>
 @param lotteryNumberArr <#openCodeArr description#>
 @param resultsArr <#resultsArr description#>
 @param numberArr <#numberArr description#>
 @param valuesArr <#valuesArr description#>
 @param maxValuesArr <#maxValuesArr description#>
 @param evenValueArr <#evenValueArr description#>
 @param nper <#nper description#>
 @param charType <#charType description#>
 @return <#return value description#>
 */
- (instancetype)initWithFrame:(CGRect)frame andIssueArr:(NSArray *)issueArr andListArr:(NSArray *)listArr andLotteryNumberArr:(NSArray *)lotteryNumberArr andResultArr:(NSArray *)resultsArr andNumberArr:(NSArray *)numberArr andValuesArr:(NSArray *)valuesArr andMaxValuesArr:(NSArray *)maxValuesArr andEvenValuesArr:(NSArray *)evenValueArr andSpanValue:(NSArray *)spanValues andNper:(NSInteger)nper andChartType:(DSChartsType)charType;
@end
