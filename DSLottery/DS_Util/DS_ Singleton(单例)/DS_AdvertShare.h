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
 获取指定广告ID的广告模型
 @param advertID 广告ID
 @return 广告模型
 */
- (DS_AdvertModel *)advertModelWithAdvertID:(NSString *)advertID;

/**
 获取批量指定广告ID的广告模型
 @param advertIDs 广告ID数组
 @return 广告模型数组
 */
- (NSArray <DS_AdvertModel *> *)advertModelsWithAdvertIDs:(NSArray <NSString *> *)advertIDs;

/**
 从指定的ID数组中，随机获取一个广告
 @param adverIDs 指定的ID数组。如果传nil，则在所有广告中随机
 @return 广告模型
 */
- (DS_AdvertModel *)randomAdverModel:(NSArray<NSString *> *)adverIDs;

/**
 获取轮播广告数组
 @return 轮播广告模型数组
 */
- (NSArray <DS_AdvertModel *> *)bannerAdverts;

/**
 获取广告条数
 @return 广告条数
 */
- (NSInteger)advertCount;

/** 打开彩票大厅 */
- (void)openFirstAdvert;

/** 是否有广告数据 */
- (BOOL)haveAdvertData;

@end
