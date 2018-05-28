//
//  DSLotteryChartsDrawIssueClickVIew.h
//  ALLTIMELOTTERY
//
//  Created by wangzhijie on 2018/5/25.
//  Copyright © 2018年 科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^DSDSLotteryChartsDrawIssueClickBlock)(NSInteger btnTag);
@interface DSLotteryChartsDrawIssueClickVIew : UIView
+(DSLotteryChartsDrawIssueClickVIew *)lotteryChartsDrawIssueClickView;
@property(nonatomic, copy) DSDSLotteryChartsDrawIssueClickBlock  issueClickBlock;

@end
