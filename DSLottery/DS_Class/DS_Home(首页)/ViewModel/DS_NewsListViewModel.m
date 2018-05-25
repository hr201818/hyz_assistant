//
//  DS_NewsListViewModel.m
//  DSLottery
//
//  Created by 黄玉洲 on 2018/5/25.
//  Copyright © 2018年 海南达生实业有限公司. All rights reserved.
//

#import "DS_NewsListViewModel.h"

/** cell */
#import "DS_NotBorderAdvertCell.h"
#import "DS_News_HaveImageCell.h"
#import "DS_News_NotImageCell.h"

/** share */
#import "DS_AdvertShare.h"

/** model */
#import "DS_NewsListModel.h"
#import "DS_AdvertListModel.h"

@interface DS_NewsListViewModel ()

/** 资讯列表 */
@property (strong, nonatomic) DS_NewsListModel   * newsListModel;

/** 列表数据 */
@property (strong, nonatomic) NSMutableArray     * tableViewList;

/** 页码 */
@property (assign, nonatomic) NSInteger page;

@end

@implementation DS_NewsListViewModel

- (instancetype)init {
    if ([super init]) {
        _tableViewList = [NSMutableArray array];
    }
    return self;
}

#pragma mark - 数据请求
/**
 请求首页资讯
 @param isRefresh  是否刷新（不为刷新时，page增1）
 @param categoryID 资讯分类ID
 @param complete   请求成功
 @param fail       请求失败
 */
- (void)requestNewsWithIsRefresh:(BOOL)isRefresh
                      categoryID:(NSString *)categoryID
                        complete:(void(^)(id object, BOOL more))complete
                            fail:(void(^)(NSError *failure))fail {
    
    if (isRefresh) {
        _page = 1;
    } else {
        _page++;
    }
    if (!categoryID) {
        categoryID = @"";
    }
    
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    [dic setValue:[NSString stringWithFormat:@"%ld", _page] forKey:@"offset"];
    [dic setValue:categoryID forKey:@"categoryId"];
    [DS_Networking postConectWithS:GETAPPNEWS Parameter:dic Succeed:^(id result) {
        BOOL more = YES;
        if (Request_Success(result)) {
            // 刷新
            if (isRefresh) {
                _newsListModel = [DS_NewsListModel yy_modelWithJSON:result];
                [self newsDataFilling:_newsListModel.articleList];
            }
            // 加载
            else {
                DS_NewsListModel * newsListModel = [DS_NewsListModel yy_modelWithJSON:result];
                // 如果没有加载更多数据
                if (newsListModel.articleList.count == 0) {
                    _page--;
                    more = NO;
                } else {
                    [self newsDataFilling:newsListModel.articleList];
                    [_newsListModel.articleList addObjectsFromArray:newsListModel.articleList];
                }
            }
            
            [self processDataSource];
        }else {
            _page--;
        }
        if (complete) {
            complete(result, more);
        }
    } Failure:^(NSError *failure) {
        _page--;
        if (fail) {
            fail(failure);
        }
    }];
}

#pragma mark - 数据处理
/** 资讯数据填充（给无图资讯增加广告模型） */
- (void)newsDataFilling:(NSMutableArray *)newsArray {
    for (DS_NewsModel * model in newsArray) {
        if ([model.imageIdList count] == 0) {
            DS_AdvertModel * adverModel = [[DS_AdvertShare share] randomAdverModel:@[@"4",@"5"]];
            model.adverModel = adverModel;
        }
    }
}

/** 处理列表数据源 */
- (void)processDataSource {
    [_tableViewList removeAllObjects];
    
    // 插入第一条广告
    DS_AdvertModel * adverModel_1 = [[DS_AdvertShare share] advertModelWithAdvertID:@"4"];
    if (adverModel_1) {
        [_tableViewList addObject:adverModel_1];
    }
    
    // 每两条资讯搭配一条广告
    NSMutableArray * mArray = nil;
    for (NSInteger i = 0; i < [_newsListModel.articleList count]; i++) {
        if (i % 2 == 0) {
            // 防止i=0时，mArray为nil导致的崩溃
            if (mArray) {
                // 放入一条随机广告
                DS_AdvertModel * adverModel = [[DS_AdvertShare share] randomAdverModel:nil];
                if (adverModel) {
                    [mArray addObject:adverModel];
                }
                [_tableViewList addObject:mArray];
            }
            
            // 数组重新初始化，以保存新的数据
            mArray = [NSMutableArray array];
        }
        
        [mArray addObject:_newsListModel.articleList[i]];
    }
    
    // 插入第二条广告
    DS_AdvertModel * adverModel_2 = [[DS_AdvertShare share] advertModelWithAdvertID:@"5"];
    if (adverModel_2) {
        [_tableViewList addObject:adverModel_2];
    }
}

#pragma mark - <UITableViewDelegate,UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_tableViewList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    id object = _tableViewList[section];
    if ([object isKindOfClass:[NSArray class]]) {
        return [((NSArray *)object) count];
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    id object = _tableViewList[indexPath.section];
    id object_1 = nil;
    if ([object isKindOfClass:[NSArray class]]) {
        NSArray * array = (NSArray *)object;
        object_1 = array[indexPath.row];
    } else {
        object_1 = object;
    }
    
    // 广告
    if ([object_1 isKindOfClass:[DS_AdvertModel class]]) {
        DS_NotBorderAdvertCell * cell = [tableView dequeueReusableCellWithIdentifier:DS_NotBorderAdvertCellID];
        if (!cell) {
            cell = [[DS_NotBorderAdvertCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:DS_NotBorderAdvertCellID];
        }
        cell.model = (DS_AdvertModel *)object_1;
        return cell;
    }
    // 资讯
    else if ([object_1 isKindOfClass:[DS_NewsModel class]]) {
        DS_NewsModel * model = object_1;
        if ([model.imageIdList count] > 0) {
            DS_News_HaveImageCell * cell = [tableView dequeueReusableCellWithIdentifier:DS_News_HaveImageCellID];
            if (!cell) {
                cell = [[DS_News_HaveImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:DS_News_HaveImageCellID];
            }
            cell.models = _newsListModel.articleList;
            cell.model = (DS_NewsModel *)object_1;
            return cell;
        } else {
            DS_News_NotImageCell * cell = [tableView dequeueReusableCellWithIdentifier:DS_News_NotImageCellID];
            if (!cell) {
                cell = [[DS_News_NotImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:DS_News_NotImageCellID];
            }
            cell.models = _newsListModel.articleList;
            cell.model = (DS_NewsModel *)object_1;
            return cell;
        }
    } else {
        static NSString * identity = @"cellID";
        UITableViewCell * tableViewCell = [tableView dequeueReusableCellWithIdentifier:identity];
        if (!tableViewCell) {
            tableViewCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identity];
        }
        return tableViewCell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    id object = _tableViewList[indexPath.section];
    id object_1 = nil;
    if ([object isKindOfClass:[NSArray class]]) {
        NSArray * array = (NSArray *)object;
        object_1 = array[indexPath.row];
    } else {
        object_1 = object;
    }
    
    if ([object_1 isKindOfClass:[DS_AdvertModel class]]) {
        return DS_NotBorderAdvertCellHeight;
    } else if ([object_1 isKindOfClass:[DS_NewsModel class]]) {
        DS_NewsModel * model = (DS_NewsModel *)object_1;
        if ([model.imageIdList count] > 0) {
            return DS_News_HaveImageCellHeight;
        } else {
            return DS_News_NotImageCellHeight;
        }
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    } else {
        return 15;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView * headerView = [UIView new];
    headerView.backgroundColor = COLOR_BACK;
    return headerView;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y <= 15 && scrollView.contentOffset.y >= 0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y >= 15) {
        scrollView.contentInset = UIEdgeInsetsMake(-15, 0, 0, 0);
    }
}


@end
