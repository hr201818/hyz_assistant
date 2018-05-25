//
//  DS_NewsListViewModel.h
//  DSLottery
//
//  Created by 黄玉洲 on 2018/5/25.
//  Copyright © 2018年 海南达生实业有限公司. All rights reserved.
//

#import "DS_BaseObject.h"

@interface DS_NewsListViewModel : DS_BaseObject <UITableViewDelegate, UITableViewDataSource>

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

@end
