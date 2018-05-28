//
//  DS_AreaLimitShare.h
//  DSLottery
//
//  Created by 黄玉洲 on 2018/5/28.
//  Copyright © 2018年 海南达生实业有限公司. All rights reserved.
//

#import "DS_BaseObject.h"

@interface DS_AreaLimitShare : DS_BaseObject

/** 实例 */
+ (DS_AreaLimitShare *)share;

/**
 请求区域限制状态
 @param complete 请求完成
 @param fail 请求失败
 */
- (void)requestCheckIPComplete:(void(^)(void))complete
                          fail:(void(^)(NSError * failure))fail;

/** 是否区域限制 */
@property (assign, nonatomic, readonly) BOOL isAreaLimit;

@end
