//
//  DS_RegisterViewController.h
//  DSLottery
//
//  Created by 黄玉洲 on 2018/5/10.
//  Copyright © 2018年 海南达生实业有限公司. All rights reserved.
//

#import "DS_BaseViewController.h"
/** 注册 */
@interface DS_RegisterViewController : DS_BaseViewController

/** 注册成功回调 */
@property (copy, nonatomic) void(^signUpSuccessBlock)(void);

@end
