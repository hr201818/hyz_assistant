//
//  DS_LotteryNoticeListModel.m
//  DSLottery
//
//  Created by 黄玉洲 on 2018/5/14.
//  Copyright © 2018年 海南达生实业有限公司. All rights reserved.
//

#import "DS_LotteryNoticeListModel.h"

@implementation DS_LotteryNoticeListModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"resultList"  : [DS_LotteryNoticeModel class]};
}

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    [self processModel];
    return YES;
}

/** 处理数据 */
- (void)processModel {
    NSMutableArray * deleteArray = [NSMutableArray array];
    for (DS_LotteryNoticeModel * model in self.resultList) {
        BOOL allowShow = NO;
        for (NSNumber * lotteryID in [DS_FunctionTool allLottery]) {
            if ([model.playGroupId integerValue] == [lotteryID integerValue]) {
                allowShow = YES;
            }
        }
        if (!allowShow) {
            [deleteArray addObject:model];
        }
    }
    
    [self.resultList removeObjectsInArray:deleteArray];
}

@end

@implementation DS_LotteryNoticeModel

@end


