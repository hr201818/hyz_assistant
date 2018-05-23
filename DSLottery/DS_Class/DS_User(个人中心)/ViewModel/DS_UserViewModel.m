//
//  DS_UserViewModel.m
//  DSLottery
//
//  Created by 黄玉洲 on 2018/5/12.
//  Copyright © 2018年 海南达生实业有限公司. All rights reserved.
//

#import "DS_UserViewModel.h"

@implementation DS_UserViewModel

/**
 请求客服路径
 @param complete 请求完成
 @param fail     请求失败
 */
- (void)requestCustomerServiceComplete:(void(^)(id object))complete
                                  fail:(void(^)(NSError * failure))fail {
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    [DS_Networking postConectWithS:GETKEFU Parameter:dic Succeed:^(id result) {
        if (complete) {
            complete(result);
        }
    } Failure:^(NSError *failure) {
        if (fail) {
            fail(failure);
        }
    }];
}

@end
