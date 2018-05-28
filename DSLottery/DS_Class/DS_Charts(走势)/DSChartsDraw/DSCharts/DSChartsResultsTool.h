//
//  DSChartsResultsTool.h
//  ALLTIMELOTTERY
//
//  Created by wangzhijie on 2018/5/21.
//  Copyright © 2018年 科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DSChartModal.h"
@interface DSChartsResultsTool : NSObject
/**
号码走势 工具类
 @param modal 数据源模型a
 @param nper ndNper 每次请求的多少期
 @param block issueArr :0 ～ 10 数字; resultsArr: 开奖结果数组;
 */
+(void)handleResultWithModal:(DSChartModal *)modal andDigits:(NSInteger)digits andNper:(NSInteger)nper returenValue:(void(^) (NSArray * listArr,NSArray * issueArr,NSArray * resultsArr, NSArray * numberArr, NSArray * valuesArr, NSArray *maxValuesArr, NSArray *evenValueArr, NSArray * endArr))block;
/**
 定位走势
 @param modal 数据源模型a
 @param nper ndNper 每次请求的多少期
 @param block issueArr :0 ～ 10 数字; resultsArr: 开奖结果数组;  ;
 */
+(void)handleLocationResultWithModal:(DSChartModal *)modal andType:(NSInteger)ballType andNper:(NSInteger)nper returenValue:(void(^) (NSArray * listArr,NSArray * issueArr, NSArray * resultsArr, NSArray * numberArr, NSArray * valuesArr, NSArray *maxValuesArr, NSArray *evenValueArr,NSArray *lotteryNumberArr))block;
/**
 跨度
 @param modal 数据源模型a
 @param nper ndNper 每次请求的多少期
 @param block issueArr :0 ～ 10 数字; resultsArr: 开奖结果数组;  数组;
 */
+(void)handSpanMovementsResultWithModal:(DSChartModal *)modal andType:(NSInteger)ballType andNper:(NSInteger)nper returenValue:(void(^) (NSArray * listArr,NSArray * issueArr, NSArray * spanValues, NSArray * numberArr, NSArray * valuesArr, NSArray *maxValuesArr, NSArray *evenValueArr,NSArray * codeArr))block;
/**
 除三余 走势
 @param modal 数据源模型a
 @param nper ndNper 每次请求的多少期
 @param block issueArr :0 ～ 10 数字; resultsArr: 开奖结果数组;
 */
+(void)handThreeMovementsResultWithModal:(DSChartModal *)modal andType:(NSInteger)ballType andNper:(NSInteger)nper returenValue:(void(^) (NSArray * listArr,NSArray * issueArr, NSArray * endArr))block;

@end
