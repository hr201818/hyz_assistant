//
//  DS_Networking.m
//  DSLottery
//
//  Created by 黄玉洲 on 2018/4/26.
//  Copyright © 2018年 海南达生实业有限公司. All rights reserved.
//

#import "DS_Networking.h"
#import "DS_NetworkingManager.h"
@implementation DS_Networking

/**
 *  监听网络变化
 *  back 回调网络状态
 */
+ (void)reach:(void(^)(AFNetworkReachabilityStatus status))back {
    /**
     AFNetworkReachabilityStatusUnknown          = -1,   // 未知
     AFNetworkReachabilityStatusNotReachable     = 0,    // 无连接
     AFNetworkReachabilityStatusReachableViaWWAN = 1,    // WWAN
     AFNetworkReachabilityStatusReachableViaWiFi = 2,    // wifi
     */
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        back(status);
        [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
    }];
}

#pragma mark - GET请求
+ (void)getConectWithS:(NSString *)s Parameter:(NSDictionary *)parameter Succeed:(void(^)(id result))succeed Failure:(void(^)(NSError * failure))failure
{
    NSMutableDictionary * mDic = [NSMutableDictionary dictionary];
    [mDic setObject:COMPANYSHORTNAME forKey:@"companyShortName"];
    [mDic setValuesForKeysWithDictionary:parameter];
    
    DS_Networking * netWork = [[self alloc]init];
    [DS_NetworkingManager shared].manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", @"text/plain",nil];
    [DS_NetworkingManager shared].manager.requestSerializer.timeoutInterval = 15;
    NSLog(@"请求网址为%@",[netWork requestDic:mDic S:s]);
    [[DS_NetworkingManager shared].manager GET:[netWork requestDic:mDic S:s] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         succeed(responseObject);
         NSLog(@"网址%@请求回来的数据%@",[netWork requestDic:mDic S:s],responseObject);
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"网址%@请求发生错误,错误信息为%@",[netWork requestDic:mDic S:s],error);
         failure(error);
     }];
}

#pragma mark - POST请求
+ (void)postConectWithS:(NSString *)s Parameter:(NSDictionary *)parameter Succeed:(void(^)(id result))succeed Failure:(void(^)(NSError * failure))failure
{
    NSMutableDictionary * mDic = [NSMutableDictionary dictionary];
    [mDic setValue:CLIENTTYPE forKey:@"clientType"];
    [mDic setObject:COMPANYSHORTNAME forKey:@"companyShortName"];
    [mDic setValue:APPVERSION forKey:@"appVersion"];
    [mDic setValue:APPVERSION forKey:@"version"];
    [mDic setValuesForKeysWithDictionary:parameter];
    
    DS_Networking * netWork = [[self alloc] init];
    //设置接收的数据类型
    [DS_NetworkingManager shared].manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
    [DS_NetworkingManager shared].manager.requestSerializer.timeoutInterval = 15;
    NSLog(@"网址\"%@\" \n请求参数：%@", [netWork requestDic:mDic S:s], mDic);
    [[DS_NetworkingManager shared].manager POST:[netWork requestDic:nil S:s] parameters:mDic progress:^(NSProgress * _Nonnull uploadProgress)
     {
         
     } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         
         NSLog(@"网址\"%@\" \n", [netWork requestDic:mDic S:s]);
         NSLog(@"请求回来的数据：%@", responseObject);
         if (Request_Code(responseObject) == Request_Code_AnotherDevice) {
             
         } else {
             succeed(responseObject);
         }
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         NSLog(@"网址\"%@\"请求发生错误,错误信息为：",[netWork requestDic:mDic S:s]);
         NSLog(@"%@",error);
         failure(error);
     }];
}


//网址拼接,获取的网址,统一的前缀
-(NSString *)requestDic:(NSDictionary *)dic S:(NSString *)s
{
    NSString *value = @"";
    for (NSString *key in [dic allKeys])
    {
        if ([value length] == 0)
        {
            value = [NSString stringWithFormat:@"%@=%@",key,[dic objectForKey:key]];
        }
        else
        {
            value = [NSString stringWithFormat:@"%@&%@=%@",value,key,[dic objectForKey:key]];
        }
    }
    if (dic != nil) {
        return [NSString stringWithFormat:@"%@%@?%@",URLHTTP,s,value];
    }
    return  [NSString stringWithFormat:@"%@%@?",URLHTTP,s];
}

@end
