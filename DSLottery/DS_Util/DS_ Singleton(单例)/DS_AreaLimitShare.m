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

/** 区域限制内容 */
@property (copy, nonatomic) NSString * content;

@end

@implementation DS_AreaLimitShare

static DS_AreaLimitShare * areaLmitShare;
/** 实例 */
+ (DS_AreaLimitShare *)share {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        areaLmitShare = [[DS_AreaLimitShare alloc] init];
        areaLmitShare.isAreaLimit = YES;
        areaLmitShare.content = @"";
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
    [dic setValue:@"AA6" forKey:@"tip"];
    [DS_Networking postConectWithS:Link_AreaLimit Parameter:dic Succeed:^(id result) {
        if ([result[@"result"] integerValue] == 1 ) {
            if ([result[@"pass"] integerValue] == 1) {
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

/** 请求版本 */
- (void)requestGengxinComplete:(void(^)(void))complete
                          fail:(void(^)(NSError * failure))fail {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [DS_Networking postConectWithS:GETAPPGENXIN Parameter:dic Succeed:^(id result) {
        if (Request_Success(result)) {
            self.content = result[@"lawStatement"];
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
