//
//  DS_LotteryNoticeViewModel.h
//  DSLottery
//
//  Created by 黄玉洲 on 2018/5/14.
//  Copyright © 2018年 海南达生实业有限公司. All rights reserved.
//

#import "DS_BaseObject.h"

@interface DS_LotteryNoticeViewModel : DS_BaseObject <UITableViewDelegate,UITableViewDataSource>

#pragma mark - 数据请求
/**
 请求开奖公告
 @param complete 请求完成
 @param fail  请求失败
 */
- (void)requestLotteryNoticeComplete:(void(^)(id object))complete
                                fail:(void(^)(NSError * failure))fail;

#pragma mark - 数据处理
/** 加载广告数据 */
- (void)loadAdvertData;
@end
