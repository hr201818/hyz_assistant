//
//  DS_UserHeaderView.h
//  DSLottery
//
//  Created by 黄玉洲 on 2018/5/9.
//  Copyright © 2018年 海南达生实业有限公司. All rights reserved.
//

#import "DS_BaseView.h"

/**
 按钮类型
 - DS_UserHeaderViewButtonType_Customer:  客服
 - DS_UserHeaderViewButtonType_Acount:    关于我们
 - DS_UserHeaderViewButtonType_Version:   版本
 - DS_UserHeaderViewButtonType_Cache:     缓存
 - DS_UserHeaderViewButtonType_Login:     登录
 - DS_UserHeaderViewButtonType_Register:  注册
 - DS_UserHeaderViewButtonType_Logout:    注销
 */
typedef NS_ENUM(NSInteger, DS_UserHeaderViewButtonType) {
    DS_UserHeaderViewButtonType_Customer,
    DS_UserHeaderViewButtonType_Acount,
    DS_UserHeaderViewButtonType_Version,
    DS_UserHeaderViewButtonType_Cache,
    DS_UserHeaderViewButtonType_Login,
    DS_UserHeaderViewButtonType_Register,
    DS_UserHeaderViewButtonType_Logout
};

/** 个人中心顶部按钮父视图 */
@interface DS_UserHeaderView : DS_BaseView

/** 刷新界面（登录和注销后要调用） */
- (void)refreshView;

/** 个人中心顶部按钮交互回调 */
@property (copy, nonatomic) void(^headerButtonBlock)(DS_UserHeaderViewButtonType type);

@end
