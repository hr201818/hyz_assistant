//
//  DS_UserShare.m
//  DSLottery
//
//  Created by 黄玉洲 on 2018/5/9.
//  Copyright © 2018年 海南达生实业有限公司. All rights reserved.
//

#import "DS_UserShare.h"
#import "DS_UserModel.h"
#import "DS_DataTool.h"
/* 登录后将token和uid缓存到本地的文件名 */
#define DSUSER_INFO    @"user_info"

@interface DS_UserShare ()

@property (copy, nonatomic) NSString * token;

@property (copy, nonatomic) NSString * userID;

@property (strong, nonatomic) DS_UserModel * userModel;

@end

@implementation DS_UserShare


static DS_UserShare * user;
/** 实例 */
+ (DS_UserShare *)share {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        user = [[DS_UserShare alloc] init];
    });
    return user;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSMutableDictionary * dic = [DS_DataTool loadDataList:DSUSER_INFO];
        if (dic) {
            _token = [dic objectForKey:@"token"];
            _userID = [dic objectForKey:@"userId"];
        }else{
            _token = nil;
            _userID = nil;
        }
    }
    return self;
}

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
                    fail:(void(^)(NSError * failure))fail {
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
    [dic setObject:account forKey:@"account"];
    [dic setObject:password forKey:@"password"];
    [dic setObject:[DS_FunctionTool getIPAddress:NO] forKey:@"ip"];
    [dic setObject:@"4" forKey:@"loginType"];
    [DS_Networking postConectWithS:LOGIN Parameter:dic Succeed:^(id result) {
        if (Request_Success(result)) {
            _userModel = [DS_UserModel yy_modelWithJSON:result];
            _token = _userModel.token;
            _userID = _userModel.userId;
            [self loginSucceed];
        }
        if (complete) {
            complete(result);
        }
    } Failure:^(NSError *failure) {
        if (fail) {
            fail(failure);
        }
    }];
}

/**
 请求注销
 @param complete 请求完成
 @param fail     请求失败
 */
- (void)logoutComplete:(void(^)(id result))complete
                  fail:(void(^)(NSError * failure))fail {
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setObject:self.token forKey:@"token"];
    [dic setObject:self.userID forKey:@"uid"];
    [DS_Networking postConectWithS:SIGOUT Parameter:dic Succeed:^(id result) {
        if (Request_Success(result)) {
            [self logoutSucceed];
        } else if (Request_Code(result) == Request_Code_Timeout) {
            [self logoutSucceed];
        }
        if (complete) {
            complete(result);
        }
    } Failure:^(NSError *failure) {
        if (fail) {
            fail(failure);
        }
    }];
}

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
                              fail:(void(^)(NSError * failure))fail {
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
    [dic setObject:account forKey:@"phone"];
    [dic setObject:password forKey:@"password"];
    [dic setObject:[DS_FunctionTool getIPAddress:NO] forKey:@"ip"];
    
    [DS_Networking postConectWithS:REGISTER Parameter:dic Succeed:^(id result) {
        if (Request_Success(result)) {
            _userModel = [DS_UserModel yy_modelWithJSON:result];
            self.userID = _userModel.userId;
            self.token = _userModel.token;
            [self loginSucceed];
        }
        if (complete) {
            complete(result);
        }
    } Failure:^(NSError *failure) {
        if (fail) {
            fail(failure);
        }
    }];
}

#pragma mark - 登录操作
/** 登录成功 */
- (void)loginSucceed {
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
    [dic setValue:self.token forKey:@"token"];
    [dic setValue:self.userID forKey:@"userId"];
    [DS_DataTool saveDataList:dic fileName:DSUSER_INFO];
    
    // 发送通知，登录成功
    [[NSNotificationCenter defaultCenter] postNotificationName:Login_Notice object:nil];
}

/** 注销成功 */
-(void)logoutSucceed {
    self.token = nil;
    self.userID = nil;
    [DS_DataTool removeFile:DSUSER_INFO];
    
    //发送通知，注销成功
    [[NSNotificationCenter defaultCenter]postNotificationName:Logout_Notice object:nil];
}

@end
