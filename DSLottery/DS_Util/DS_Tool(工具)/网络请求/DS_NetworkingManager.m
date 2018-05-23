//
//  DS_NetworkingManager.m
//  DSLottery
//
//  Created by 黄玉洲 on 2018/4/26.
//  Copyright © 2018年 海南达生实业有限公司. All rights reserved.
//

#import "DS_NetworkingManager.h"

@implementation DS_NetworkingManager

static DS_NetworkingManager * network;
+(DS_NetworkingManager *)shared
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        network = [[DS_NetworkingManager alloc] init];
        
    });
    return network;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.manager = [AFHTTPSessionManager manager];
        AFJSONResponseSerializer *responseSerializer = [[AFJSONResponseSerializer alloc] init];
        responseSerializer.removesKeysWithNullValues = YES;
    }
    return self;
}

@end
