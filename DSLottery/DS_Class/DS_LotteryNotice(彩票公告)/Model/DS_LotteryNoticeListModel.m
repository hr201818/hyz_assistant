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

@end

@implementation DS_LotteryNoticeModel

@end


