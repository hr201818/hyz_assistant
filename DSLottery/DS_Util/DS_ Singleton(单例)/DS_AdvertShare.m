//
//  DS_AdvertShare.m
//  DSLottery
//
//  Created by 黄玉洲 on 2018/5/9.
//  Copyright © 2018年 海南达生实业有限公司. All rights reserved.
//

#import "DS_AdvertShare.h"

@interface DS_AdvertShare ()

@property (strong, nonatomic) DS_AdvertListModel * advertListModel;

@end

@implementation DS_AdvertShare

static DS_AdvertShare * advertObject;
/** 实例 */
+ (DS_AdvertShare *)share {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        advertObject = [[DS_AdvertShare alloc] init];
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
        if (complete) {
            complete(result);
        }
    } Failure:^(NSError *failure) {
        if (fail) {
            fail(failure);
        }
    }];
}

#pragma mark - public
/**
 获取指定广告ID的广告模型
 @param advertID 广告ID
 @return 广告模型
 */
- (DS_AdvertModel *)advertModelWithAdvertID:(NSString *)advertID {
    for (DS_AdvertModel * advertModel in _advertListModel.advertList) {
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
    NSMutableArray * adverts = [_advertListModel.advertList mutableCopy];
    
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

/**
 从指定的ID数组中，随机获取一个广告
 @param adverIDs 指定的ID数组。如果传nil，则在所有广告中随机
 @return 广告模型
 */
- (DS_AdvertModel *)randomAdverModel:(NSArray<NSString *> *)adverIDs {
    DS_AdvertModel * model = nil;
    if (!adverIDs) {
        NSInteger index = arc4random() % [_advertListModel.advertList count];
        model = _advertListModel.advertList[index];
    } else {
        NSArray * array = [self advertModelsWithAdvertIDs:adverIDs];
        NSInteger index = arc4random() % [array count];
        model = array[index];
    }
    return model;
}

/**
 获取轮播广告数组
 @return 轮播广告模型数组
 */
- (NSArray <DS_AdvertModel *> *)bannerAdverts {
    return _advertListModel.bannerList;
}

/**
 获取广告条数
 @return 广告条数
 */
- (NSInteger)advertCount {
    return [_advertListModel.advertList count];
}

/** 打开彩票大厅 */
- (void)openFirstAdvert {
    DS_AdvertModel * advertModel = [self advertModelWithAdvertID:@"1"];
    [DS_FunctionTool openAdvert:advertModel];
}

@end
