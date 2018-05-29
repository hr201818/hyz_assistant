//
//  DS_LocalData.h
//  DSLottery
//
//  Created by 黄玉洲 on 2018/5/29.
//  Copyright © 2018年 海南达生实业有限公司. All rights reserved.
//

#import "DS_BaseObject.h"
#import "DS_AdvertListModel.h"
@interface DS_LocalData : DS_BaseObject

#pragma mark - 广告数据
/**
 保存广告数据
 @param advertData 网络请求下来的广告数据
 @return 保存结果
 */
+ (BOOL)setAdvertData:(id)advertData;

/**
 获取广告数据
 @return 广告数据
 */
+ (id)advertData;

#pragma mark - 公告数据
/**
 保存公告数据
 @param noticeData 网络请求下来的公告数据
 @return 保存结果
 */
+ (BOOL)setNoticeData:(id)noticeData;

/**
 获取公告数据
 @return 公告数据
 */
+ (id)noticeData;

#pragma mark - 彩票开奖信息
/**
 保存彩票开奖信息
 @param lotteryData 网络请求下来的彩票开奖信息
 @return 保存结果
 */
+ (BOOL)setLotteryData:(id)lotteryData;

/**
 获取彩票开奖信息
 @return 彩票开奖信息
 */
+ (id)lotteryData;

#pragma mark - 资讯信息
/**
 保存资讯信息
 @param newsData 网络请求下来的资讯信息
 @param reset    是否重置
 @return 保存结果
 */
+ (BOOL)setNewsData:(id)newsData reset:(BOOL)reset;

/**
 获取资讯信息
 @return 资讯信息
 */
+ (id)newsData;

@end
