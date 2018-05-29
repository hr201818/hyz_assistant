//
//  DS_LocalData.m
//  DSLottery
//
//  Created by 黄玉洲 on 2018/5/29.
//  Copyright © 2018年 海南达生实业有限公司. All rights reserved.
//

#import "DS_LocalData.h"
#import "DS_DataTool.h"
#import "DS_NewsListModel.h"
@interface DS_LocalData ()

@end

@implementation DS_LocalData

#pragma mark - 广告数据
static NSString * advertFileName = @"advertFileName";
/**
 保存广告数据
 @param advertData 网络请求下来的广告数据
 @return 保存结果
 */
+ (BOOL)setAdvertData:(id)advertData {
    BOOL result = NO;
    if (advertData) {
        result = [DS_DataTool saveDataList:advertData fileName:advertFileName];
    }
    return result;
}

/**
 获取广告数据
 @return 广告数据
 */
+ (id)advertData {
    id advertData = [DS_DataTool loadDataList:advertFileName];
    return advertData;
}

#pragma mark - 公告数据
static NSString * noticeFileName = @"noticeFileName";
/**
 保存公告数据
 @param noticeData 网络请求下来的公告数据
 @return 保存结果
 */
+ (BOOL)setNoticeData:(id)noticeData {
    BOOL result = NO;
    if (noticeData) {
        result = [DS_DataTool saveDataList:noticeData fileName:noticeFileName];
    }
    return result;
}

/**
 获取公告数据
 @return 公告数据
 */
+ (id)noticeData {
    id noticeData = [DS_DataTool loadDataList:noticeFileName];
    return noticeData;
}

#pragma mark - 彩票开奖信息
static NSString * lotteryFileName = @"lotteryFileName";
/**
 保存彩票开奖信息
 @param lotteryData 网络请求下来的彩票开奖信息
 @return 保存结果
 */
+ (BOOL)setLotteryData:(id)lotteryData {
    BOOL result = NO;
    if (lotteryData) {
        result = [DS_DataTool saveDataList:lotteryData fileName:lotteryFileName];
    }
    return result;
}

/**
 获取彩票开奖信息
 @return 彩票开奖信息
 */
+ (id)lotteryData {
    id lotteryData = [DS_DataTool loadDataList:lotteryFileName];
    return lotteryData;
}

#pragma mark - 资讯信息
static NSString * newsFileName = @"newsFileName";
/**
 保存资讯信息
 @param newsData 网络请求下来的资讯信息
 @param reset    是否重置
 @return 保存结果
 */
+ (BOOL)setNewsData:(id)newsData reset:(BOOL)reset{
    BOOL result = NO;
    if (newsData) {
        // 获取本地缓存，如果不存在则以传入的的数据作为缓存
        NSMutableDictionary * mDic = [[self newsData] mutableCopy];
        if (!mDic || reset) {
            mDic = [newsData mutableCopy];
            if (newsData) {
                result = [DS_DataTool saveDataList:newsData fileName:newsFileName];
            }
            return result;
        }
        
        NSMutableArray * mArray = [mDic[@"articleList"] mutableCopy];
        if (!mArray) {
            mArray = [NSMutableArray array];
        }
        
        // 用于比较的数组
        NSArray * compareArray = [mArray mutableCopy];
        
        // 存在的ID不存入数组 不存在的则存入
        NSArray * tempArray = newsData[@"articleList"];
        for (NSDictionary * dic_1 in tempArray) {
            BOOL isSave = YES;
            for (NSDictionary * dic_2 in compareArray) {
                NSString * news_id_1 = dic_1[@"id"];
                NSString * news_id_2 = dic_2[@"id"];
                if ([news_id_1 isEqual:news_id_2]) {
                    isSave = NO;
                    break;
                }
            }
            if (isSave) {
                [mArray addObject:dic_1];
            }
        }
        
        [mDic setObject:mArray forKey:@"articleList"];
        result = [DS_DataTool saveDataList:mDic fileName:newsFileName];
    }
    return result;
}

/**
 获取资讯信息
 @return 资讯信息
 */
+ (id)newsData {
    id newsData = [DS_DataTool loadDataList:newsFileName];
    return newsData;
}


@end
