//
//  DS_AreaLimitShare.m
//  DSLottery
//
//  Created by 黄玉洲 on 2018/5/28.
//  Copyright © 2018年 海南达生实业有限公司. All rights reserved.
//

#import "DS_AreaLimitShare.h"

@interface DS_AreaLimitShare ()

/** 是否区域限制 */
@property (assign, nonatomic) BOOL isAreaLimit;

@end

@implementation DS_AreaLimitShare

static DS_AreaLimitShare * areaLmitShare;
/** 实例 */
+ (DS_AreaLimitShare *)share {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        areaLmitShare = [[DS_AreaLimitShare alloc] init];
        areaLmitShare.isAreaLimit = YES;
    });
    return areaLmitShare;
}

/**
 请求区域限制状态
 @param complete 请求完成
 @param fail 请求失败
 */
- (void)requestCheckIPComplete:(void(^)(void))complete
                          fail:(void(^)(NSError * failure))fail {
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
    [DS_Networking postConectWithS:CHECKIP Parameter:dic Succeed:^(id result) {
        if ([result[@"result"] integerValue] == 1 ) {
            if ([result[@"status"] integerValue]==1) {
                self.isAreaLimit = YES;
            }else {
                self.isAreaLimit = NO;
            }
        }
        if (complete) {
            complete();
        }
    } Failure:^(NSError *failure) {
        if (fail) {
            fail(failure);
        }
    }];
}

@end
