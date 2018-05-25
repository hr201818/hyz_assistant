//
//  DS_CategoryShare.h
//  DSLottery
//
//  Created by 黄玉洲 on 2018/5/9.
//  Copyright © 2018年 海南达生实业有限公司. All rights reserved.
//

#import "DS_BaseObject.h"

/** model */
#import "DS_CategoryListModel.h"

/** 首页、地区分类单例 */
@interface DS_CategoryShare : DS_BaseObject

/** 实例 */
+ (DS_CategoryShare *)share;

/** 是否有网络数据 */
- (BOOL)haveNetworkData;

#pragma mark - 数据请求
/**
 请求分类列表
 @param complete 请求完成
 @param fail     请求失败
 */
- (void)requestCategoryListComplete:(void(^)(id object))complete
                               fail:(void(^)(NSError * failure))fail;

#pragma mark - 数据获取
/** 获取资讯模型列表 */
- (NSArray <DS_CategoryModel *> *)newsCategorys;

/** 获取资讯分类ID */
- (NSArray <NSString *> *)newsCategoryIDs;

/** 获取资讯分类name */
- (NSArray <NSString *> *)newsCategoryNames;

/**
 获取指定分类ID在数组中的下标
 @param categoryID 分类ID
 @return 下标
 */
- (NSInteger)newsCategoryIndexWithID:(NSString *)categoryID;

#pragma mark - 根据相关获取ID获取另一个相关ID
/**
 根据彩种ID获取资讯种类ID
 @param lotteryID 彩种ID
 @return 资讯种类ID
 */
- (NSString *)categoryIDWithLotteryID:(NSString *)lotteryID;

/**
 根据资讯种类ID获取彩种ID
 @param categoryID 资讯种类ID
 @return 彩种ID
 */
- (NSString *)lotteryIDWithCategoryID:(NSString *)categoryID;

@end
