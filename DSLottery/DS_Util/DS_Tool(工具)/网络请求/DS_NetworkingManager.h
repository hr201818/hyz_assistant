//
//  DS_NetworkingManager.h
//  DSLottery
//
//  Created by 黄玉洲 on 2018/4/26.
//  Copyright © 2018年 海南达生实业有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DS_NetworkingManager : NSObject

+(DS_NetworkingManager *)shared;

@property (strong, nonatomic)  AFHTTPSessionManager * manager;

@end
