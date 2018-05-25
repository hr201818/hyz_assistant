//
//  DS_CategoryShare.m
//  DSLottery
//
//  Created by 黄玉洲 on 2018/5/9.
//  Copyright © 2018年 海南达生实业有限公司. All rights reserved.
//

#import "DS_CategoryShare.h"

@interface DS_CategoryShare ()

@property (strong, nonatomic) DS_CategoryListModel * categoryListModel;

@end

@implementation DS_CategoryShare

static DS_CategoryShare * categoryObject;
/** 实例 */
+ (DS_CategoryShare *)share {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        categoryObject = [[DS_CategoryShare alloc] init];
    });
    return categoryObject;
}

/** 是否有网络数据 */
- (BOOL)haveNetworkData {
    if ([_categoryListModel.newsCategory count] == 0) {
        return NO;
    } else {
        return YES;
    }
}

#pragma mark - 数据请求
/**
 请求分类列表
 @param complete 请求完成
 @param fail     请求失败
 */
- (void)requestCategoryListComplete:(void(^)(id object))complete
                               fail:(void(^)(NSError * failure))fail {
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
    [DS_Networking postConectWithS:CATEGORYS Parameter:dic Succeed:^(id result) {
        _categoryListModel = [DS_CategoryListModel yy_modelWithJSON:result];
        if (complete) {
            complete(result);
        }
    } Failure:^(NSError *failure) {
        if (fail) {
            fail(failure);
        }
    }];
}

#pragma mark - 数据获取
/** 获取资讯模型列表 */
- (NSArray <DS_CategoryModel *> *)newsCategorys {
    if ([_categoryListModel.newsCategory count] == 0) {
        NSArray * categoryIDs = [self newsCategoryIDs];
        NSArray * categoryTitle = [self newsCategoryNames];
        NSMutableArray * newsCategorys = [NSMutableArray array];
        for (int i = 0; i < [categoryIDs count]; i++) {
            DS_CategoryModel * model = [DS_CategoryModel new];
            model.ID = categoryIDs[i];
            model.name = categoryTitle[i];
            [newsCategorys addObject:model];
        }
        return newsCategorys;
    } else {
        return _categoryListModel.newsCategory;
    }
    
}

/** 获取资讯分类ID */
- (NSArray <NSString *> *)newsCategoryIDs {
    NSMutableArray * categoryIDs = [NSMutableArray array];
    
    // 当没有网络数据时
    if ([_categoryListModel.newsCategory count] == 0) {
        for (NSDictionary * dic in [self localNewsCategory]) {
            [categoryIDs addObject:dic[@"categoryID"]];
        }
    } else {
        [categoryIDs addObject:@""];
        for (DS_CategoryModel * model in _categoryListModel.newsCategory) {
            [categoryIDs addObject:model.ID];
        }
    }
    
    return categoryIDs;
}

/** 获取资讯分类name */
- (NSArray <NSString *> *)newsCategoryNames {
    
    NSMutableArray * categoryNames = [NSMutableArray array];
    
    // 当没有网络数据时
    if ([_categoryListModel.newsCategory count] == 0) {
        for (NSDictionary * dic in [self localNewsCategory]) {
            [categoryNames addObject:dic[@"categoryName"]];
        }
    } else {
        [categoryNames addObject:@"推荐"];
        for (DS_CategoryModel * model in _categoryListModel.newsCategory) {
            [categoryNames addObject:model.name];
        }
    }
    
    return categoryNames;
}

/**
 获取指定分类ID在数组中的下标
 @param categoryID 分类ID
 @return 下标
 */
- (NSInteger)newsCategoryIndexWithID:(NSString *)categoryID {
    // 获取分类组
    NSArray * categorys = [self newsCategoryIDs];
    
    // 遍历找到对应的分类ID在数组中的下标
    NSInteger index = 0;
    for (NSString * categoryID_1 in categorys) {
        if ([categoryID_1 isEqual:categoryID]) {
            return index;
        }
        index++;
    }
    return 0;
}

#pragma mark - 根据相关获取ID获取另一个相关ID
/**
 根据彩种ID获取资讯种类ID
 @param lotteryID 彩种ID
 @return 资讯种类ID
 */
- (NSString *)categoryIDWithLotteryID:(NSString *)lotteryID {
    for (DS_CategoryModel * categoryModel in _categoryListModel.newsCategory) {
        if ([categoryModel.remarks isEqual:lotteryID]) {
            return categoryModel.ID;
        }
    }
    return @"";
}

/**
 根据资讯种类ID获取彩种ID
 @param categoryID 资讯种类ID
 @return 彩种ID
 */
- (NSString *)lotteryIDWithCategoryID:(NSString *)categoryID {
    for (DS_CategoryModel * categoryModel in _categoryListModel.newsCategory) {
        if ([categoryModel.ID isEqual:categoryID]) {
            return categoryModel.remarks;
        }
    }
    return @"";
}

#pragma mark - private
/** 获取本地的资讯分类 */
- (NSArray <NSDictionary *> *)localNewsCategory {
    NSString * filePath = [[NSBundle mainBundle] pathForResource:@"DS_NewsCategory" ofType:@"plist"];
    NSArray * array = [[NSArray alloc] initWithContentsOfFile:filePath];
    return array;
}

@end
