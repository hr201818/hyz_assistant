//
//  DSChartModal.h
//  ALLTIMELOTTERY
//
//  Created by wangzhijie on 2018/4/16.
//  Copyright © 2018年  . All rights reserved.
//

#import "DS_BaseObject.h"

#import "DSChartListModal.h"
@interface DSChartModal : DS_BaseObject
@property(nonatomic,assign) NSNumber * result;
@property(nonatomic, strong)  NSMutableArray * sscHistoryList;
@end
