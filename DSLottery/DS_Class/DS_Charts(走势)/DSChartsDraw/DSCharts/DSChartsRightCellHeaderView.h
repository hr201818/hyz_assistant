//
//  DSChartsRightCellHeaderView.h
//  ALLTIMELOTTERY
//
//  Created by wangzhijie on 2018/5/21.
//  Copyright © 2018年 科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DSChartsView.h"
@interface DSChartsRightCellHeaderView : UIView
- (instancetype)initWithFrame:(CGRect)frame andList:(NSArray *)listArr andChartsType:(DSChartsType)chartsType andOpenCodeArrCount:(NSUInteger)openCodeArrCount;
@end
