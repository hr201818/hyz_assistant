//
//  DS_HaoMaChartsView.h
//  DSLottery
//
//  Created by 黄玉洲 on 2018/6/3.
//  Copyright © 2018年 海南达生实业有限公司. All rights reserved.
//

#import "DS_BaseView.h"
#import "DS_ChartsListModel.h"
@interface DS_HaoMaChartsView : DS_BaseView

/**
 初始化
 @param frame 尺寸
 @param modelList 数据模型
 @param lotteryID 彩种ID
 @return 和值视图
 */
- (instancetype)initWithFrame:(CGRect)frame
                    modelList:(DS_ChartsListModel *)modelList
                    lotteryID:(NSString *)lotteryID;

@end
