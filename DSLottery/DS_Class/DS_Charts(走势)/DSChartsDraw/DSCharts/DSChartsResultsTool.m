//
//  DSChartsResultsTool.m
//  ALLTIMELOTTERY
//
//  Created by wangzhijie on 2018/5/21.
//  Copyright © 2018年 科技有限公司. All rights reserved.
//

#import "DSChartsResultsTool.h"

@implementation DSChartsResultsTool
/**
 时时彩  号码走势
 @param modal 数据源模型a
 @param nper ndNper 每次请求的多少期
 @param block issueArr :0 ～ 10 数字; resultsArr: 开奖结果数组;
 */
+(void)handleResultWithModal:(DSChartModal *)modal andDigits:(NSInteger)digits andNper:(NSInteger)nper returenValue:(void(^) (NSArray * listArr,NSArray * issueArr,NSArray * resultsArr, NSArray * numberArr, NSArray * valuesArr, NSArray *maxValuesArr, NSArray *evenValueArr, NSArray * endArr))block{
    
    NSMutableArray * contentArr = [NSMutableArray new];
    NSMutableArray * issueArr = [NSMutableArray new];
    NSMutableArray * endArr = [NSMutableArray new];
    NSMutableArray * resultsArr = [NSMutableArray new];
    NSMutableArray * numberArr = [NSMutableArray new]; //出现次数
    NSMutableArray * valuesArr = [NSMutableArray new]; // 平均遗漏值
    NSMutableArray * maxValuesArr = [NSMutableArray new];// 最大遗漏值
    NSMutableArray * evenValueArr = [NSMutableArray new]; //最大连出值
    
    if (modal.sscHistoryList.count > 0) {
        if (nper >= modal.sscHistoryList.count) {
            nper = modal.sscHistoryList.count;
        }
        [modal.sscHistoryList enumerateObjectsUsingBlock:^(DSChartListModal * obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.number.length > 10) {
                [issueArr addObject:[obj.number substringWithRange:NSMakeRange(4, 7)]];
            }else if (obj.number.length > 9 ){
                [issueArr addObject:[obj.number substringWithRange:NSMakeRange(4, 6)]];
            }
            else{
                [issueArr addObject:obj.number];
            }
            NSArray * coceArr = [obj.openCode componentsSeparatedByString:@","];
            
            
            if (coceArr.count > digits) {
                [resultsArr addObject:coceArr[digits]];
            }
            [endArr addObject:coceArr];
            
        }];// 遍历 chartModal.sscHistoryList end
        
        NSArray * countArr ;
        if (endArr.count > 0) {
            countArr =  endArr[0];
        }
        if (countArr.count > 7) {
            for (int i = 0; i < 81; i++) {
                [contentArr addObject:@(i)];
            }
        }else{
            if (countArr.count > 5) {
                for (int i = 0; i < 34; i++) {
                    [contentArr addObject:@(i)];
                }
            }else{
                for (int i = 0; i < 10; i++) {
                    [contentArr addObject:@(i)];
                }
            }
        }
        
        
        if (countArr.count > 5) {
            // ********** 计算 总次数、平均遗漏值、最大遗漏值 、最大连出值
            for (NSInteger i = [contentArr[0] integerValue]; i< contentArr.count + 1; i++ ) { // 计算 总次数、平均遗漏值、最大遗漏值 、最大连出值
                // 出现的总次数
                int total = 0;
                for (NSString * value in resultsArr) {
                    if (i == [value integerValue]) {
                        total ++;
                    }
                }
                // 总次数
                [numberArr addObject:@{@(i):@(total)}];
                
                // 平均遗漏值 （总期数-出现总次数）/ 遗漏段数
                int  averageMissingCount = 0;
                BOOL  isEquesl = NO; //遍历时遇到开奖结果相等置为YES
                for (int j = 0; j < resultsArr.count; j++) {
                    if (i == [resultsArr[j] integerValue]) {
                        if (j != 0 && isEquesl == NO) {
                            averageMissingCount ++;
                        }
                        isEquesl = YES;
                    }else{
                        isEquesl = NO;
                        if (j == resultsArr.count - 1 && isEquesl == NO) {
                            averageMissingCount ++;
                        }
                    }
                }
                [valuesArr addObject:@{@(i):@((nper - total)/(averageMissingCount==0?1:averageMissingCount))}];
                // 最大遗漏值
                NSMutableArray * biggestMissingValueArr = [NSMutableArray new];
                NSInteger  biggestMissing = 0;
                // 最大连出值
                NSMutableArray * continuousAppearValueArr = [NSMutableArray new];
                NSInteger continuousAppear = 0;
                for (int j = 0; j < resultsArr.count; j ++) {
                    if (i == [resultsArr[j] integerValue]) {
                        continuousAppear ++;
                        biggestMissing = 0;
                    }else{
                        continuousAppear = 0;
                        biggestMissing ++;
                    }
                    [biggestMissingValueArr addObject:@(biggestMissing)];
                    [continuousAppearValueArr addObject:@(continuousAppear)];
                }
                [maxValuesArr addObject:@{@(i):[biggestMissingValueArr valueForKeyPath:@"@max.floatValue"]}];
                [evenValueArr addObject:@{@(i):[continuousAppearValueArr valueForKeyPath:@"@max.floatValue"]}];
            }//end
        }
        
        
        // ********** 计算 总次数、平均遗漏值、最大遗漏值 、最大连出值
    } // modal.list count > 0 end
    [issueArr addObject:@"出现总次数"];
    [issueArr addObject:@"平均遗漏值"];
    [issueArr addObject:@"最大遗漏值"];
    [issueArr addObject:@"最大连出值"];
    
    if (block) {
        block(contentArr,
              issueArr,
              resultsArr,
              numberArr,
              valuesArr,
              maxValuesArr,
              evenValueArr,
              endArr
              );
    }
}
/**
 定位走势
 @param modal 数据源模型a
 @param nper ndNper 每次请求的多少期
 @param block issueArr :0 ～ 10 数字; resultsArr: 开奖结果数组;
 */
+(void)handleLocationResultWithModal:(DSChartModal *)modal andType:(NSInteger)ballType andNper:(NSInteger)nper returenValue:(void(^) (NSArray * listArr,NSArray * issueArr, NSArray * resultsArr, NSArray * numberArr, NSArray * valuesArr, NSArray *maxValuesArr, NSArray *evenValueArr,NSArray *lotteryNumberArr))block{
    NSMutableArray * contentArr = [NSMutableArray new];
    NSMutableArray * issueArr = [NSMutableArray new];
    NSMutableArray * resultsArr = [NSMutableArray new];
    // 万位的
    NSMutableArray * numberArr = [NSMutableArray new]; //出现次数
    NSMutableArray * valuesArr = [NSMutableArray new]; // 平均遗漏值
    NSMutableArray * maxValuesArr = [NSMutableArray new];// 最大遗漏值
    NSMutableArray * evenValueArr = [NSMutableArray new]; //最大连出值
    NSMutableArray * lotteryNumberArr = [NSMutableArray new]; // 结果数组
    
    if (modal.sscHistoryList.count > 0) {
        if (nper >= modal.sscHistoryList.count) {
            nper = modal.sscHistoryList.count;
        }
        [modal.sscHistoryList enumerateObjectsUsingBlock:^(DSChartListModal * obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.number.length > 10) {
                [issueArr addObject:[obj.number substringWithRange:NSMakeRange(4, 7)]];
            }else if (obj.number.length > 9 ){
                [issueArr addObject:[obj.number substringWithRange:NSMakeRange(4, 6)]];
            }
            else{
                [issueArr addObject:obj.number];
            }
            NSArray * coceArr = [obj.openCode componentsSeparatedByString:@","];
            if (coceArr.count > ballType) {
                [resultsArr addObject:coceArr[ballType]];
            }
            [lotteryNumberArr addObject:coceArr];
        }];// 遍历 chartModal.sscHistoryList end
        
        NSArray * countArr ;
        
        if (lotteryNumberArr.count > 0) {
            countArr =  lotteryNumberArr[0];
        }
        
        if (countArr.count > 7) {
            for (int i = 0; i < 81; i++) {
                [contentArr addObject:@(i)];
            }
        }else{
            
            if (countArr.count > 5) {
                for (int i = 0; i < 34; i++) {
                    [contentArr addObject:@(i)];
                }
            }else{
                for (int i = 0; i < 10; i++) {
                    [contentArr addObject:@(i)];
                }
            }
        }
        
        // ********** 计算 总次数、平均遗漏值、最大遗漏值 、最大连出值
        for (NSInteger i = [contentArr[0] integerValue]; i< contentArr.count + 1; i++ ) { // 计算 总次数、平均遗漏值、最大遗漏值 、最大连出值
            // 出现的总次数
            int total = 0;
            for (NSString * value in resultsArr) {
                if (i == [value integerValue]) {
                    total ++;
                }
            }
            // 总次数
            [numberArr addObject:@{@(i):@(total)}];
            
            // 平均遗漏值 （总期数-出现总次数）/ 遗漏段数
            int  averageMissingCount = 0;
            BOOL  isEquesl = NO; //遍历时遇到开奖结果相等置为YES
            for (int j = 0; j < resultsArr.count; j++) {
                if (i == [resultsArr[j] integerValue]) {
                    if (j != 0 && isEquesl == NO) {
                        averageMissingCount ++;
                    }
                    isEquesl = YES;
                }else{
                    isEquesl = NO;
                    if (j == resultsArr.count - 1 && isEquesl == NO) {
                        averageMissingCount ++;
                    }
                }
            }
            [valuesArr addObject:@{@(i):@((nper - total)/(averageMissingCount==0?1:averageMissingCount))}];
            // 最大遗漏值
            NSMutableArray * biggestMissingValueArr = [NSMutableArray new];
            NSInteger  biggestMissing = 0;
            // 最大连出值
            NSMutableArray * continuousAppearValueArr = [NSMutableArray new];
            NSInteger continuousAppear = 0;
            for (int j = 0; j < resultsArr.count; j ++) {
                if (i == [resultsArr[j] integerValue]) {
                    continuousAppear ++;
                    biggestMissing = 0;
                }else{
                    continuousAppear = 0;
                    biggestMissing ++;
                }
                [biggestMissingValueArr addObject:@(biggestMissing)];
                [continuousAppearValueArr addObject:@(continuousAppear)];
            }
            [maxValuesArr addObject:@{@(i):[biggestMissingValueArr valueForKeyPath:@"@max.floatValue"]}];
            [evenValueArr addObject:@{@(i):[continuousAppearValueArr valueForKeyPath:@"@max.floatValue"]}];
        }//end
        
    } // modal.list count > 0 end
    [issueArr addObject:@"出现总次数"];
    [issueArr addObject:@"平均遗漏值"];
    [issueArr addObject:@"最大遗漏值"];
    [issueArr addObject:@"最大连出值"];
    if (block) {
        block(contentArr,
              issueArr,
              resultsArr,
              numberArr,
              valuesArr,
              maxValuesArr,
              evenValueArr,
              lotteryNumberArr);
    }
}
/**
 跨度
 @param modal 数据源模型a
 @param nper ndNper 每次请求的多少期
 @param block issueArr :0 ～ 10 数字; resultsArr: 开奖结果数组;
 */
+(void)handSpanMovementsResultWithModal:(DSChartModal *)modal andType:(NSInteger)ballType andNper:(NSInteger)nper returenValue:(void(^) (NSArray * listArr,NSArray * issueArr, NSArray * spanValues, NSArray * numberArr, NSArray * valuesArr, NSArray *maxValuesArr, NSArray *evenValueArr,NSArray * codeArr))block{
    
    
    NSMutableArray * contentArr = [NSMutableArray new];
    
    NSMutableArray * issueArr = [NSMutableArray new];
    // 万位的
    NSMutableArray * numberArr = [NSMutableArray new]; //出现次数
    NSMutableArray * valuesArr = [NSMutableArray new]; // 平均遗漏值
    NSMutableArray * maxValuesArr = [NSMutableArray new];// 最大遗漏值
    NSMutableArray * evenValueArr = [NSMutableArray new]; //最大连出值
    NSMutableArray * spanValues = [NSMutableArray new]; // 跨度值
    NSMutableArray * endArr = [NSMutableArray new]; // 结果数组
    
    if (modal.sscHistoryList.count > 0) {
        if (nper >= modal.sscHistoryList.count) {
            nper = modal.sscHistoryList.count;
        }
        
        [modal.sscHistoryList enumerateObjectsUsingBlock:^(DSChartListModal * obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.number.length > 10) {
                [issueArr addObject:[obj.number substringWithRange:NSMakeRange(4, 7)]];
            }else if (obj.number.length > 9 ){
                [issueArr addObject:[obj.number substringWithRange:NSMakeRange(4, 6)]];
            }
            else{
                [issueArr addObject:obj.number];
            }
            NSArray * coceArr = [obj.openCode componentsSeparatedByString:@","];
            NSNumber  * max = [coceArr valueForKeyPath:@"@max.floatValue"];
            NSNumber  * min = [coceArr valueForKeyPath:@"@min.floatValue"];
            NSInteger   maxIntager = [max integerValue];
            NSInteger   minInteger = [min integerValue];
            // 跨度值
            NSInteger  difference  = maxIntager  - minInteger;
            [spanValues addObject:[NSString stringWithFormat:@"%ld",(long)difference]];
            [endArr addObject:coceArr];
        }];// 遍历 chartModal.sscHistoryList end
        
        NSArray * countArr ;
        if (endArr.count > 0) {
            countArr =  endArr[0];
        }
        if (countArr.count > 7) {
            for (int i = 0; i < 81; i++) {
                [contentArr addObject:@(i)];
            }
        }else{
            if (countArr.count > 5) {
                for (int i = 0; i < 34; i++) {
                    [contentArr addObject:@(i)];
                }
            }else{
                for (int i = 0; i < 10; i++) {
                    [contentArr addObject:@(i)];
                }
            }
        }
        
        // ********** 计算 总次数、平均遗漏值、最大遗漏值 、最大连出值
        // ****
        for (NSInteger i = [contentArr[0] integerValue]; i< contentArr.count + 1; i++ ) { // 计算 总次数、平均遗漏值、最大遗漏值 、最大连出值
            // 出现的总次数
            int total = 0;
            for (NSString * value in spanValues) {
                if (i == [value integerValue]) {
                    total ++;
                }
            }
            // 总次数
            [numberArr addObject:@{@(i):@(total)}];
            
            // 平均遗漏值 （总期数-出现总次数）/ 遗漏段数
            int  averageMissingCount = 0;
            BOOL  isEquesl = NO; //遍历时遇到开奖结果相等置为YES
            for (int j = 0; j < spanValues.count; j++) {
                if (i == [spanValues[j] integerValue]) {
                    if (j != 0 && isEquesl == NO) {
                        averageMissingCount ++;
                    }
                    isEquesl = YES;
                }else{
                    isEquesl = NO;
                    if (j == spanValues.count - 1 && isEquesl == NO) {
                        averageMissingCount ++;
                    }
                }
            }
            [valuesArr addObject:@{@(i):@((nper - total)/(averageMissingCount==0?1:averageMissingCount))}];
            // 最大遗漏值
            NSMutableArray * biggestMissingValueArr = [NSMutableArray new];
            NSInteger  biggestMissing = 0;
            // 最大连出值
            NSMutableArray * continuousAppearValueArr = [NSMutableArray new];
            NSInteger continuousAppear = 0;
            for (int j = 0; j < spanValues.count; j ++) {
                if (i == [spanValues[j] integerValue]) {
                    continuousAppear ++;
                    biggestMissing = 0;
                }else{
                    continuousAppear = 0;
                    biggestMissing ++;
                }
                [biggestMissingValueArr addObject:@(biggestMissing)];
                [continuousAppearValueArr addObject:@(continuousAppear)];
            }
            [maxValuesArr addObject:@{@(i):[biggestMissingValueArr valueForKeyPath:@"@max.floatValue"]}];
            [evenValueArr addObject:@{@(i):[continuousAppearValueArr valueForKeyPath:@"@max.floatValue"]}];
        }//end
    } // modal.list count > 0 end
    [issueArr addObject:@"出现总次数"];
    [issueArr addObject:@"平均遗漏值"];
    [issueArr addObject:@"最大遗漏值"];
    [issueArr addObject:@"最大连出值"];
    if (block) {
        block(contentArr,
              issueArr,
              spanValues,
              numberArr,
              valuesArr,
              maxValuesArr,
              evenValueArr,
              endArr
              );
    }
}
/**
 除三余 走势
 @param modal 数据源模型a
 @param nper ndNper 每次请求的多少期
 @param block issueArr :0 ～ 10 数字; resultsArr: 开奖结果数组;  
 */
+(void)handThreeMovementsResultWithModal:(DSChartModal *)modal andType:(NSInteger)ballType andNper:(NSInteger)nper returenValue:(void(^) (NSArray * listArr,NSArray * issueArr, NSArray * endArr))block{
    
    NSMutableArray * contentArr = [NSMutableArray new];
    for (int i = 0; i < 3; i++) {
        [contentArr addObject:@(i)];
    }
    
    NSMutableArray * issueArr = [NSMutableArray new];
    NSMutableArray * endArr = [NSMutableArray new]; // 结果数组
    
    if (modal.sscHistoryList.count > 0) {
        if (nper >= modal.sscHistoryList.count) {
            nper = modal.sscHistoryList.count;
        }
        
        [modal.sscHistoryList enumerateObjectsUsingBlock:^(DSChartListModal * obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.number.length > 10) {
                [issueArr addObject:[obj.number substringWithRange:NSMakeRange(4, 7)]];
            }else if (obj.number.length > 9 ){
                [issueArr addObject:[obj.number substringWithRange:NSMakeRange(4, 6)]];
            }
            else{
                [issueArr addObject:obj.number];
            }
            NSArray * coceArr = [obj.openCode componentsSeparatedByString:@","];
            [endArr addObject:coceArr];
        }];// 遍历 chartModal.sscHistoryList end
        
        //end
    } // modal.list count > 0 end
    [issueArr addObject:@"出现总次数"];
    [issueArr addObject:@"平均遗漏值"];
    [issueArr addObject:@"最大遗漏值"];
    [issueArr addObject:@"最大连出值"];
    
    if (block) {
        block(contentArr,
              issueArr,
              endArr);
    }
}
@end




