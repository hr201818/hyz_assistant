//
//  DS_HomeViewModel.h
//  DSLottery
//
//  Created by 黄玉洲 on 2018/5/9.
//  Copyright © 2018年 海南达生实业有限公司. All rights reserved.
//

#import "DS_BaseObject.h"
#import "DS_NewsListModel.h"
@interface DS_HomeViewModel : DS_BaseObject <UITableViewDelegate,UITableViewDataSource>

#pragma mark - 数据请求
/**
 请求开奖公告
 @param complete 请求完成
 @param fail  请求失败
 */
- (void)requestLotteryNoticeComplete:(void(^)(id object))complete
                                fail:(void(^)(NSError * failure))fail;

/**
 请求首页资讯
 @param isRefresh  是否刷新（不为刷新时，page增1）
 @param categoryID 资讯分类ID
 @param complete   请求成功
 @param fail       请求失败
 */
- (void)requestNewsWithIsRefresh:(BOOL)isRefresh
                      categoryID:(NSString *)categoryID
                        complete:(void(^)(id object, BOOL more))complete
                            fail:(void(^)(NSError *failure))fail;

/**
 请求公告数据
 @param complete 请求成功
 @param fail     请求失败
 */
- (void)requestNoticeComplete:(void(^)(id object))complete
                         fail:(void(^)(NSError *failure))fail;



#pragma mark - 数据获取
/** 获取公告列表 */
- (NSArray <NSString *> *)noticeList;


@end
