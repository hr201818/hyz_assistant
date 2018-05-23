//
//  DS_UserModel.h
//  DSLottery
//
//  Created by 黄玉洲 on 2018/5/9.
//  Copyright © 2018年 海南达生实业有限公司. All rights reserved.
//

#import "DS_BaseObject.h"

@interface DS_UserModel : DS_BaseObject

/** 描述 */
@property (copy, nonatomic) NSString * description;

/** 请求结果 */
@property (copy, nonatomic) NSString * result;

/** token */
@property (copy, nonatomic) NSString * token;

/** 用户ID */
@property (copy, nonatomic) NSString * userId;

@end
