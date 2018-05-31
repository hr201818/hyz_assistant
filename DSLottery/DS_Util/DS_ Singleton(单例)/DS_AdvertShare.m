//
//  DS_AdvertShare.m
//  DSLottery
//
//  Created by 黄玉洲 on 2018/5/9.
//  Copyright © 2018年 海南达生实业有限公司. All rights reserved.
//

#import "DS_AdvertShare.h"
#import "DS_LocalData.h"
@interface DS_AdvertShare ()

/** 轮播广告 */
@property (strong, nonatomic) NSMutableArray     * bannerAdverts;

/** 非轮播广告 */
@property (strong, nonatomic) NSMutableArray     * nonBannerAdverts;

@property (strong, nonatomic) DS_AdvertListModel * advertListModel;

@end

@implementation DS_AdvertShare

static DS_AdvertShare * advertObject;
/** 实例 */
+ (DS_AdvertShare *)share {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        advertObject = [[DS_AdvertShare alloc] init];
        id advertData = [DS_LocalData advertData];
        if (advertData) {
            advertObject.bannerAdverts = [NSMutableArray array];
            advertObject.nonBannerAdverts = [NSMutableArray array];
            advertObject.advertListModel = [DS_AdvertListModel yy_modelWithJSON:advertData];
            [advertObject progressAdvertListModel];
        }
    });
    return advertObject;
}

#pragma mark - 数据请求
/**
 请求广告列表
 @param complete 请求完成
 @param fail     请求失败
 */
- (void)requestAdvertListComplete:(void(^)(id object))complete
                             fail:(void(^)(NSError * failure))fail {
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    weakifySelf
    [DS_Networking postConectWithS:GET_ADVERT_LIST Parameter:dic Succeed:^(id result) {
        strongifySelf
        self.advertListModel = [DS_AdvertListModel yy_modelWithJSON:result];
        [DS_LocalData setAdvertData:result];
        [self progressAdvertListModel];
        if (complete) {
            complete(result);
        }
    } Failure:^(NSError *failure) {
        if (fail) {
            fail(failure);
        }
    }];
}

#pragma mark - 数据处理
/** 处理广告数据模型，将其分解为轮播和非轮播 */
- (void)progressAdvertListModel {
    [_bannerAdverts removeAllObjects];
    [_nonBannerAdverts removeAllObjects];
    for (DS_AdvertModel * advertModel in _advertListModel.list) {
        if ([advertModel.locationId integerValue] < 10) {
            [_bannerAdverts addObject:advertModel];
        } else {
            [_nonBannerAdverts addObject:advertModel];
        }
    }
}

#pragma mark - public
/**
 获取广告条数
 @return 广告条数
 */
- (NSInteger)advertCount {
    return [_nonBannerAdverts count];
}

/** 是否有广告数据 */
- (BOOL)haveAdvertData {
    if ([_nonBannerAdverts count] > 0) {
        return YES;
    }
    return NO;
}

#pragma mark private
/**
 获取指定广告ID的广告模型
 @param advertID 广告ID
 @return 广告模型
 */
- (DS_AdvertModel *)advertModelWithAdvertID:(NSString *)advertID {
    for (DS_AdvertModel * advertModel in _nonBannerAdverts) {
        if ([advertModel.locationId isEqual:advertID]) {
            return advertModel;
        }
    }
    return nil;
}

/**
 获取批量指定广告ID的广告模型
 @param advertIDs 广告ID数组
 @return 广告模型数组
 */
- (NSArray <DS_AdvertModel *> *)advertModelsWithAdvertIDs:(NSArray <NSString *> *)advertIDs {
    // 用于遍历操作的广告模型数组，在循环的时候可以删除其中的内容，提升搜索性能。
    NSMutableArray * adverts = [_nonBannerAdverts mutableCopy];
    
    // 用于保存指定广告模型的数组
    NSMutableArray * specifiedAdverts = [NSMutableArray array];
    
    // 循环获取指定的广告模型
    for (NSString * advertID in advertIDs) {
        for (DS_AdvertModel * advertModel in adverts) {
            if ([advertModel.locationId isEqual:advertID]) {
                [adverts removeObject:advertModel];
                [specifiedAdverts addObject:advertModel];
                break;
            }
        }
    }
    
    // 如果没有指定的广告，则返回nil；有则返回指定的广告模型数组。
    if ([specifiedAdverts count] > 0) {
        return specifiedAdverts;
    }
    return nil;
}

#pragma mark - 各部分广告获取
/** 获取轮播广告数组 */
- (NSArray <DS_AdvertModel *> *)bannerAdvertArray {
    return _bannerAdverts;
}

/** 非轮播广告数组 */
- (NSArray <DS_AdvertModel *> *)nonBannerAdvertArray {
    return _nonBannerAdverts;
}

#pragma mark - 首页相关
/** 打开彩票大厅 */
- (void)openFirstAdvert {
    DS_AdvertModel * advertModel = [self advertModelWithAdvertID:@"10"];
    [DS_FunctionTool openAdvert:advertModel];
}

/**
 首页列表广告
 @param isList 是否是tableView中的数据
 @return 首页列表广告
 */
- (NSArray <DS_AdvertModel *> *)homeListAdverts:(BOOL)isList {
    NSArray * adverts = nil;
    if (isList) {
        adverts = [[self advertModelsWithAdvertIDs:@[@"13", @"14", @"15"]] mutableCopy];
    } else {
        adverts = [[self advertModelsWithAdvertIDs:@[@"11", @"12"]] mutableCopy];
    }
    
    return adverts;
}


#pragma mark - 资讯列表相关
/**
 资讯列表广告
 @param isList 是否是tableView中的数据
 @return 资讯列表广告
 */
- (NSArray <DS_AdvertModel *> *)newsListAdverts:(BOOL)isList {
    NSArray * adverts = nil;
    if (isList) {
        adverts = [[self advertModelsWithAdvertIDs:@[@"18", @"19", @"20"]] mutableCopy];
    } else {
        adverts = [[self advertModelsWithAdvertIDs:@[@"16", @"17"]] mutableCopy];
    }
    
    return adverts;
}

#pragma mark - 资讯详情相关
/**
 资讯详情广告
 @param isList 是否是tableView中的数据
 @return 资讯详情广告
 */
- (NSArray <DS_AdvertModel *> *)newsDetailListAdverts:(BOOL)isList {
    NSArray * adverts = nil;
    if (isList) {
        adverts = [[self advertModelsWithAdvertIDs:@[@"23", @"24", @"25"]] mutableCopy];
    } else {
        adverts = [[self advertModelsWithAdvertIDs:@[@"21", @"22"]] mutableCopy];
    }
    
    return adverts;
}

#pragma mark - 投注站相关
/**
 投注站广告
 @return 投注站广告
 */
- (NSArray <DS_AdvertModel *> *)shopsAdverts {
    NSArray * adverts = [[self advertModelsWithAdvertIDs:@[@"26", @"27"]] mutableCopy];
    return adverts;
}

#pragma mark - 开奖公告相关
/**
 开奖公告广告
 @return 开奖公告广告
 */
- (NSArray <DS_AdvertModel *> *)lotteryAdverts {
    NSArray * adverts = [[self advertModelsWithAdvertIDs:@[@"28", @"29"]] mutableCopy];
    return adverts;
}

#pragma mark - 走势相关
/**
 走势广告
 @return 走势广告
 */
- (NSArray <DS_AdvertModel *> *)chartsAdverts {
    NSArray * adverts = [[self advertModelsWithAdvertIDs:@[@"30", @"31"]] mutableCopy];
    return adverts;
}

#pragma mark - 个人中心相关
/**
 个人中心广告
 @return 个人中心广告
 */
- (NSArray <DS_AdvertModel *> *)userCenterAdverts {
    NSArray * adverts = [[self advertModelsWithAdvertIDs:@[@"32", @"33"]] mutableCopy];
    return adverts;
}

/**
 登录页广告
 @return 登录页广告
 */
- (NSArray <DS_AdvertModel *> *)loginAdverts {
    NSArray * adverts = [[self advertModelsWithAdvertIDs:@[@"34", @"35"]] mutableCopy];
    return adverts;
}


/**
 注册页广告
 @return 注册页广告
 */
- (NSArray <DS_AdvertModel *> *)registerAdverts {
    NSArray * adverts = [[self advertModelsWithAdvertIDs:@[@"36", @"37"]] mutableCopy];
    return adverts;
}

@end
