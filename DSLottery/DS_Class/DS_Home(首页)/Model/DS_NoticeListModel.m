//
//  DS_NoticeListModel.m
//  DSLottery
//
//  Created by 黄玉洲 on 2018/5/9.
//  Copyright © 2018年 海南达生实业有限公司. All rights reserved.
//

#import "DS_NoticeListModel.h"

@implementation DS_NoticeListModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"noticeList"  : [DS_NoticeModel class]};
}

@end

@implementation DS_NoticeModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"ID" : @"id"};
}


@end
