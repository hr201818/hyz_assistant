//
//  DSChartModal.m
//  ALLTIMELOTTERY
//
//  Created by wangzhijie on 2018/4/16.
//  Copyright © 2018年  . All rights reserved.
//

#import "DSChartModal.h"

@implementation DSChartModal

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"sscHistoryList"  : [DSChartListModal class]};
}


@end
