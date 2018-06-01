//
//  DS_HeWeiChartsView.h
//  DS_AA6
//
//  Created by 黄玉洲 on 2018/5/30.
//  Copyright © 2018年 黄玉洲. All rights reserved.
//

#import "DS_BaseView.h"
#import "DS_ChartsListModel.h"
@interface DS_HeWeiChartsView : DS_BaseView

/**
 初始化
 @param frame 尺寸
 @param modelList 数据模型
 @param lotteryID 彩种ID
 @return 和尾视图
 */
- (instancetype)initWithFrame:(CGRect)frame
                    modelList:(DS_ChartsListModel *)modelList
                    lotteryID:(NSString *)lotteryID;

@end
