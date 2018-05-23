//
//  DS_FindViewModel.h
//  DSLottery
//
//  Created by 黄玉洲 on 2018/5/15.
//  Copyright © 2018年 海南达生实业有限公司. All rights reserved.
//

#import "DS_BaseObject.h"

@interface DS_FindViewModel : DS_BaseObject <UITableViewDelegate, UITableViewDataSource>


/**
 请求开奖公告
 @param complete 请求成功
 @param fail     请求失败
 */
-(void)requestLotteryNoticeComplete:(void(^)(id object))complete
                               fail:(void(^)(NSError * failure))fail;

/** 重置数据 */
- (void)resetData;

@end
