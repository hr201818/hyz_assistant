//
//  DSLotteryChartsDrawViewController.h
//  ALLTIMELOTTERY
//
//  Created by wangzhijie on 2018/5/25.
//  Copyright © 2018年 科技有限公司. All rights reserved.
//

#import "DS_BaseViewController.h"
#import "DSChartsView.h"
@interface DSLotteryChartsDrawViewController : DS_BaseViewController
@property(nonatomic, assign) DSChartsType chartType; // 走势图种类
@property(nonatomic, strong) NSString * playGroupId;
@property(nonatomic, assign) BOOL isMeCharts;
@end
