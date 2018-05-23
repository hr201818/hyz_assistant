//
//  DS_UserOperationView.h
//  DSLottery
//
//  Created by 黄玉洲 on 2018/5/23.
//  Copyright © 2018年 海南达生实业有限公司. All rights reserved.
//

#import "DS_BaseView.h"

/**
 操作按钮类型
 - DS_OperationType_CustomerService: 客服
 - DS_OperationType_AboutWe: 关于我们
 - DS_OperationType_Version: 版本
 - DS_OperationType_Cache: 缓存
 */
typedef NS_ENUM(NSInteger, DS_OperationType) {
    DS_OperationType_CustomerService,
    DS_OperationType_AboutWe,
    DS_OperationType_Version,
    DS_OperationType_Cache
};

@interface DS_UserOperationView : DS_BaseView

@property (copy, nonatomic) void(^operationBlock)(DS_OperationType type);

@end
