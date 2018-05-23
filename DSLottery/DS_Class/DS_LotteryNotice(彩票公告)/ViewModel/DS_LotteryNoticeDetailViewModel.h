//
//  DS_LotteryNoticeDetailViewModel.h
//  DSLottery
//
//  Created by 黄玉洲 on 2018/5/14.
//  Copyright © 2018年 海南达生实业有限公司. All rights reserved.
//

#import "DS_BaseObject.h"

@interface DS_LotteryNoticeDetailViewModel : DS_BaseObject <UITableViewDelegate,UITableViewDataSource>

#pragma mark - 数据请求
/**
 请求开奖公告详情
 @param lotteryID 彩种ID
 @param complete  请求完成
 @param fail      请求失败
 */
- (void)requestLotteryNoticeDetailWithLotteryID:(NSString *)lotteryID
                                       complete:(void(^)(id object))complete
                                           fail:(void(^)(NSError * failure))fail;

#pragma mark - 数据获取
/** 获取彩种详情的数据量 */
- (NSInteger)lotteryCount;

#pragma mark - 数据处理
/** 加载广告 */
- (void)loadAdvertData;


@end
