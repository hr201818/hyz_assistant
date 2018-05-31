//
//  DS_AdvertShare.h
//  DSLottery
//
//  Created by 黄玉洲 on 2018/5/9.
//  Copyright © 2018年 海南达生实业有限公司. All rights reserved.
//

#import "DS_BaseObject.h"

/** model */
#import "DS_AdvertListModel.h"

/** 广告数据单例 */
@interface DS_AdvertShare : DS_BaseObject

/** 实例 */
+ (DS_AdvertShare *)share;

#pragma mark - 数据请求
/**
 请求广告列表
 @param complete 请求完成
 @param fail     请求失败
 */
- (void)requestAdvertListComplete:(void(^)(id object))complete
                             fail:(void(^)(NSError * failure))fail;


#pragma mark - public
/**
 获取广告条数
 @return 广告条数
 */
- (NSInteger)advertCount;

/** 是否有广告数据 */
- (BOOL)haveAdvertData;

#pragma mark - 各部分广告获取
/** 获取轮播广告数组 */
- (NSArray <DS_AdvertModel *> *)bannerAdvertArray;

/** 非轮播广告数组 */
- (NSArray <DS_AdvertModel *> *)nonBannerAdvertArray;

#pragma mark - 首页相关
/** 打开彩票大厅 */
- (void)openFirstAdvert;

/**
 首页列表广告
 @param isList 是否是tableView中的数据
 @return 首页列表广告
 */
- (NSArray <DS_AdvertModel *> *)homeListAdverts:(BOOL)isList;

#pragma mark - 资讯列表相关
/**
 资讯列表广告
 @param isList 是否是tableView中的数据
 @return 首页列表广告
 */
- (NSArray <DS_AdvertModel *> *)newsListAdverts:(BOOL)isList;

#pragma mark - 资讯详情相关
/**
 资讯详情广告
 @param isList 是否是tableView中的数据
 @return 资讯详情广告
 */
- (NSArray <DS_AdvertModel *> *)newsDetailListAdverts:(BOOL)isList;

#pragma mark - 投注站相关
/**
 投注站广告
 @return 投注站广告
 */
- (NSArray <DS_AdvertModel *> *)shopsAdverts;

#pragma mark - 开奖公告相关
/**
 开奖公告广告
 @return 开奖公告广告
 */
- (NSArray <DS_AdvertModel *> *)lotteryAdverts;

#pragma mark - 走势相关
/**
 走势广告
 @return 走势广告
 */
- (NSArray <DS_AdvertModel *> *)chartsAdverts;

#pragma mark - 个人中心相关
/**
 个人中心广告
 @return 个人中心广告
 */
- (NSArray <DS_AdvertModel *> *)userCenterAdverts;

/**
 登录页广告
 @return 登录页广告
 */
- (NSArray <DS_AdvertModel *> *)loginAdverts;

/**
 注册页广告
 @return 注册页广告
 */
- (NSArray <DS_AdvertModel *> *)registerAdverts;

@end
