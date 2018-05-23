//
//  DS_Networking.h
//  DSLottery
//
//  Created by 黄玉洲 on 2018/4/26.
//  Copyright © 2018年 海南达生实业有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

typedef NS_ENUM(NSInteger, Request_Code) {
    Request_Code_Success = 1, // 请求成功
    Request_Code_Timeout = 108, // 登录超时
    Request_Code_AnotherDevice = 109, // 其他设备
};

@interface DS_Networking : NSObject

/**
 *  监听网络变化
 *  back 回调网络状态
 */
+ (void)reach:(void(^)(AFNetworkReachabilityStatus status))back;

/**
 *  Get请求
 *  s  接口
 *  Parameter 字典，里面存放参数键值对
 *  Succeed   成功回调
 *  Failure   失败回调
 */
+ (void)getConectWithS:(NSString *)s Parameter:(NSDictionary *)parameter Succeed:(void(^)(id result))succeed Failure:(void(^)(NSError * failure))failure;

/**
 *  Post请求
 *  s   接口
 *  Parameter 字典，里面存放参数键值对
 *  Succeed   成功回调
 *  Failure   失败回调
 */
+ (void)postConectWithS:(NSString *)s Parameter:(NSDictionary *)parameter Succeed:(void(^)(id result))succeed Failure:(void(^)(NSError * failure))failure;

@end
