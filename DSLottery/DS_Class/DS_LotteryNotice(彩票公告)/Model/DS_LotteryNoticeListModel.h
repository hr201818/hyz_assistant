//
//  DS_LotteryNoticeListModel.h
//  DSLottery
//
//  Created by 黄玉洲 on 2018/5/14.
//  Copyright © 2018年 海南达生实业有限公司. All rights reserved.
//

#import "DS_BaseObject.h"

/** 开奖公告列表模型 */
@interface DS_LotteryNoticeListModel : DS_BaseObject

@property (strong, nonatomic) NSMutableArray * resultList;

@end

@interface DS_LotteryNoticeModel : NSObject

@property (copy, nonatomic) NSString * number;

@property (copy, nonatomic) NSString * openCode;

@property (copy, nonatomic) NSString * openTime;

@property (copy, nonatomic) NSString * playGroupId;

@property (copy, nonatomic) NSString * playGroupName;

@property (assign, nonatomic) NSInteger  leftTimer;

@end
