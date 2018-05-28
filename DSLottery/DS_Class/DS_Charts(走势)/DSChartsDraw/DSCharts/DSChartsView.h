//
//  DSChartsView.h
//  ALLTIMELOTTERY
//
//  Created by wangzhijie on 2018/5/21.
//  Copyright © 2018年 科技有限公司. All rights reserved.
//
#import <UIKit/UIKit.h>
@class DSChartModal;
typedef NS_ENUM(NSInteger, DSChartsType){
    DSChartsBasicType, //号码走势
    DSChartsLocationType, //定位走势
    DSChartsSpadType, //跨度走势
    DSChartsThreeType, //除三余走势
    DSChartsHezhiType, //和值
    DSChartsJiouType, //奇偶
    DSChartsDaxiaoType, //大小
    DSChartsHeweiType //和尾
    
};
@interface DSChartsView : UIView
- (instancetype)initWithChartsType:(DSChartsType)type;
@property (nonatomic, strong) DSChartModal * chartModal;
@end


























