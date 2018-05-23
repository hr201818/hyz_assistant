//
//  DS_UserHeaderView.h
//  DSLottery
//
//  Created by 黄玉洲 on 2018/5/9.
//  Copyright © 2018年 海南达生实业有限公司. All rights reserved.
//

#import "DS_BaseView.h"

/** 个人中心顶部按钮父视图 */
@interface DS_UserHeaderView : DS_BaseView

/** 刷新界面（登录和注销后要调用） */
- (void)refreshView;

/** 登录或注销回调 */
@property (copy, nonatomic) void(^loginOrLogoutBlock)(void);

@end
