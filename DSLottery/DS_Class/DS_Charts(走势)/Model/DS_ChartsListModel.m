//
//  DS_ChartListModel.m
//  DS_AA6
//
//  Created by 黄玉洲 on 2018/5/30.
//  Copyright © 2018年 黄玉洲. All rights reserved.
//

#import "DS_ChartsListModel.h"

@implementation DS_ChartsListModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"sscHistoryList"  : [DS_ChartsModel class]};
}


@end


@implementation DS_ChartsModel

@end
