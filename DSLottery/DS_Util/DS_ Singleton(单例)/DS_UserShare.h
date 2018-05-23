//
//  DS_UserShare.h
//  DSLottery
//
//  Created by 黄玉洲 on 2018/5/9.
//  Copyright © 2018年 海南达生实业有限公司. All rights reserved.
//

#import "DS_BaseObject.h"



@interface DS_UserShare : DS_BaseObject

/** 实例 */
+ (DS_UserShare *)share;

@property (copy, nonatomic, readonly) NSString * token;

@property (copy, nonatomic, readonly) NSString * userID;

#pragma mark - 数据请求
/**
 请求登录
 @param account 账号
 @param password 密码
 @param complete 请求完成
 @param fail     请求失败
 */
- (void)loginWithAccount:(NSString *)account
                password:(NSString *)password
                complete:(void(^)(id result))complete
                    fail:(void(^)(NSError * failure))fail;

/**
 请求注销
 @param complete 请求完成
 @param fail     请求失败
 */
- (void)logoutComplete:(void(^)(id result))complete
                  fail:(void(^)(NSError * failure))fail;

/**
 请求注册
 @param account  账号
 @param password 密码
 @param complete 请求成功
 @param fail     请求失败
 */
- (void)requestRegisterWithAccount:(NSString *)account
                          password:(NSString *)password
                          complete:(void(^)(id result))complete
                              fail:(void(^)(NSError * failure))fail;

#pragma mark - 登录操作
/** 登录成功 */
- (void)loginSucceed;

/** 注销成功 */
-(void)logoutSucceed;

@end
