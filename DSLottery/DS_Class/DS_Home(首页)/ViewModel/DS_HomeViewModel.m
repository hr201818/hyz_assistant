//
//  DS_HomeViewModel.m
//  DSLottery
//
//  Created by 黄玉洲 on 2018/5/9.
//  Copyright © 2018年 海南达生实业有限公司. All rights reserved.
//

#import "DS_HomeViewModel.h"

/** cell */
#import "DS_AdvertTableViewCell.h"
#import "DS_NewsTableViewCell.h"

/** share */
#import "DS_AdvertShare.h"

/** model */
#import "DS_NoticeListModel.h"


@interface DS_HomeViewModel ()

/** 公告列表 */
@property (strong, nonatomic) DS_NoticeListModel * noticeListModel;

/** 资讯列表 */
@property (strong, nonatomic) DS_NewsListModel   * newsListModel;

/** 列表数据 */
@property (strong, nonatomic) NSMutableArray     * tableViewList;

/** 页码 */
@property (assign, nonatomic) NSInteger page;

@end

@implementation DS_HomeViewModel

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
            }
            // 加载
            else {
                DS_NewsListModel * newsListModel = [DS_NewsListModel yy_modelWithJSON:result];
                // 如果没有加载更多数据
                if (newsListModel.articleList.count == 0) {
                    _page--;
                    more = NO;
                } else {
                    [_newsListModel.articleList addObjectsFromArray:newsListModel.articleList];
                }
            }
            [self processNewsList];
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

/**
 请求公告数据
 @param complete 请求成功
 @param fail     请求失败
 */
- (void)requestNoticeComplete:(void(^)(id object))complete
                         fail:(void(^)(NSError *failure))fail {
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
    [DS_Networking postConectWithS:NOTICI Parameter:dic Succeed:^(id result) {
        self.noticeListModel = [DS_NoticeListModel yy_modelWithJSON:result];
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
/** 处理资讯数组数据 */
- (void)processNewsList {
    // 获取指定广告
    NSArray * advertModels = [[DS_AdvertShare share] advertModelsWithAdvertIDs:@[@"4", @"5"]];

    if (!_tableViewList) {
        _tableViewList = [NSMutableArray array];
    }
    [_tableViewList removeAllObjects];
    
    // 每三条资讯插入一条广告
    NSInteger advertIndex = 0;
    for (NSInteger i = 0; i < _newsListModel.articleList.count; i++) {
        [_tableViewList addObject:_newsListModel.articleList[i]];
        if (i % 2 != 0 && i != 0 && advertIndex < [advertModels count]) {
            [_tableViewList addObject:advertModels[advertIndex]];
            advertIndex++;
        }
    }
}

/**
 处理新的资讯数据
 @param newsModel 新的资讯数据
 */
- (void)processNewNews:(DS_NewsModel *)newsModel {
    for (DS_NewsModel * model in _newsListModel.articleList) {
        if ([model.ID isEqual:newsModel.ID]) {
            model.thumbsUpNumb = newsModel.thumbsUpNumb;
            model.readerNumb = newsModel.readerNumb;
            break;
        }
    }
    
    [self processNewsList];
}

#pragma mark - 数据获取
/** 获取公告列表 */
- (NSArray <NSString *> *)noticeList {
    NSMutableArray * noticeArray = [NSMutableArray array];
    for (DS_NoticeModel * noticeModel in self.noticeListModel.noticeList) {
        [noticeArray addObject:[NSString stringWithFormat:@"      %@",noticeModel.content]];
    }
    return noticeArray;
}

#pragma mark - <UITableViewDelegate,UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_tableViewList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // 广告
    if ([_tableViewList[indexPath.row] isKindOfClass:[DS_AdvertModel class]]) {
        DS_AdvertTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:DS_AdvertTableViewCellID];
        if (!cell) {
            cell = [[DS_AdvertTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:DS_AdvertTableViewCellID];
        }
        cell.model = (DS_AdvertModel *)_tableViewList[indexPath.row];
        return cell;
    }
    // 资讯
    else if ([_tableViewList[indexPath.row] isKindOfClass:[DS_NewsModel class]]) {
        DS_NewsTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:DS_NewsTableViewCellID];
        if (!cell) {
            cell = [[DS_NewsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:DS_NewsTableViewCellID];
        }
        cell.models = _newsListModel.articleList;
        cell.model = (DS_NewsModel *)_tableViewList[indexPath.row];
        return cell;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([_tableViewList[indexPath.row] isKindOfClass:[DS_AdvertModel class]]) {
        return DS_AdvertTableViewCellHeight;
    } else if ([_tableViewList[indexPath.row] isKindOfClass:[DS_NewsModel class]]) {
        return DS_NewsTableViewCellHeight;
    }
    return 0;
}


@end
