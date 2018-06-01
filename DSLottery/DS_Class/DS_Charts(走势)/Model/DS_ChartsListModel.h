//
//  DS_ChartListModel.m
//  DS_AA6
//
//  Created by 黄玉洲 on 2018/5/30.
//  Copyright © 2018年 黄玉洲. All rights reserved.
//

#import "DS_BaseObject.h"

@interface DS_ChartsListModel : DS_BaseObject

/** 请求结果 */
@property(nonatomic,assign) NSNumber * result;

/** 数据列表 */
@property(nonatomic, strong)  NSMutableArray * sscHistoryList;

@end

@interface DS_ChartsModel : DS_BaseObject

@property(nonatomic,strong) NSString * date;

@property(nonatomic,strong) NSString * number;

@property(nonatomic,strong) NSString * openCode;

@property(nonatomic,strong) NSString * openTime;

@property(nonatomic,strong) NSString * playGroupId;

@property(nonatomic,strong) NSString * playGroupName;

@end
