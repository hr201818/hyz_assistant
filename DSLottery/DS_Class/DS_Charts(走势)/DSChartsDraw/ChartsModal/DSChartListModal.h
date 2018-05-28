//
//  DSChartListModal.h
//  ALLTIMELOTTERY
//
//  Created by wangzhijie on 2018/4/16.
//  Copyright © 2018年  . All rights reserved.
//

#import "DS_BaseObject.h"

@protocol DSChartListModal
@end
@interface DSChartListModal : DS_BaseObject
@property(nonatomic,strong) NSString * date;
@property(nonatomic,strong) NSString * number;
@property(nonatomic,strong) NSString * openCode;
@property(nonatomic,strong) NSString * openTime;
@property(nonatomic,strong) NSString * playGroupId;
@property(nonatomic,strong) NSString * playGroupName;
@end
