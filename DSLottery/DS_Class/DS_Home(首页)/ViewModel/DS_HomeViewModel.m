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
#import "DS_HomeLotteryNoticeCell.h"
#import "DS_HomeNormalCell.h"
#import "DS_News_HaveImageCell.h"
#import "DS_News_NotImageCell.h"

/** share */
#import "DS_AdvertShare.h"

/** model */
#import "DS_NoticeListModel.h"
#import "DS_LotteryNoticeListModel.h"

@interface DS_HomeViewModel ()

/** 公告列表 */
@property (strong, nonatomic) DS_NoticeListModel * noticeListModel;

/** 开奖公告模型 */
@property (strong, nonatomic) DS_LotteryNoticeListModel * lotteryNoticeListModel;

/** 资讯列表 */
@property (strong, nonatomic) DS_NewsListModel   * newsListModel;

/** 列表数据 */
@property (strong, nonatomic) NSMutableArray     * tableViewList;

/** 页码 */
@property (assign, nonatomic) NSInteger page;

@end

@implementation DS_HomeViewModel

- (instancetype)init {
    if ([super init]) {
        _tableViewList = [NSMutableArray array];
    }
    return self;
}

#pragma mark - 数据请求
/**
 请求开奖公告
 @param complete 请求完成
 @param fail  请求失败
 */
- (void)requestLotteryNoticeComplete:(void(^)(id object))complete
                                fail:(void(^)(NSError * failure))fail {
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    [DS_Networking postConectWithS:GETALLSSCDATA Parameter:dic Succeed:^(id result) {
        if (Request_Success(result)) {
            _lotteryNoticeListModel = [DS_LotteryNoticeListModel yy_modelWithJSON:result];
            [self processDataSource];
        }
        if (complete) {
            complete(result);
        }
    } Failure:^(NSError *failure) {
        if (fail) {
            fail(failure);
        }
    }];
}

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
    
    // 插入开奖公告
    if ([_lotteryNoticeListModel.resultList count] > 0) {
        [_tableViewList addObjectsFromArray:_lotteryNoticeListModel.resultList];
    }
    
    // 插入第二条广告
    DS_AdvertModel * adverModel_2 = [[DS_AdvertShare share] advertModelWithAdvertID:@"5"];
    if (adverModel_2) {
        [_tableViewList addObject:adverModel_2];
    }
    
    // 插入资讯列表
    if ([_newsListModel.articleList count] > 0) {
        [_tableViewList addObject:@"彩票资讯"];
        [_tableViewList addObjectsFromArray:_newsListModel.articleList];
    }
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
        DS_NewsModel * model = (DS_NewsModel *)_tableViewList[indexPath.row];
        if ([model.imageIdList count] > 0) {
            DS_News_HaveImageCell * cell = [tableView dequeueReusableCellWithIdentifier:DS_News_HaveImageCellID];
            if (!cell) {
                cell = [[DS_News_HaveImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:DS_News_HaveImageCellID];
            }
            cell.models = _newsListModel.articleList;
            cell.model = (DS_NewsModel *)_tableViewList[indexPath.row];
            return cell;
        } else {
            DS_News_NotImageCell * cell = [tableView dequeueReusableCellWithIdentifier:DS_News_NotImageCellID];
            if (!cell) {
                cell = [[DS_News_NotImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:DS_News_NotImageCellID];
            }
            cell.models = _newsListModel.articleList;
            cell.model = (DS_NewsModel *)_tableViewList[indexPath.row];
            return cell;
        }
    }
    // 开奖公告
    else if ([_tableViewList[indexPath. row] isKindOfClass:[DS_LotteryNoticeModel class]]) {
        DS_HomeLotteryNoticeCell * cell = [tableView dequeueReusableCellWithIdentifier:DS_HomeLotteryNoticeCellID];
        if (!cell) {
            cell = [[DS_HomeLotteryNoticeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:DS_HomeLotteryNoticeCellID];
        }
        cell.model = (DS_LotteryNoticeModel *)_tableViewList[indexPath.row];
        return cell;
    }
    // 彩票资讯标题
    else {
        DS_HomeNormalCell * cell = [tableView dequeueReusableCellWithIdentifier:DS_HomeNormalCellID];
        if (!cell) {
            cell = [[DS_HomeNormalCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:DS_HomeNormalCellID];
        }
        cell.cellTitle = DS_STRINGS(@"kLotteryNews");
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([_tableViewList[indexPath.row] isKindOfClass:[DS_AdvertModel class]]) {
        return DS_AdvertTableViewCellHeight;
    } else if ([_tableViewList[indexPath.row] isKindOfClass:[DS_NewsModel class]]) {
        DS_NewsModel * model = (DS_NewsModel *)_tableViewList[indexPath.row];
        if ([model.imageIdList count] > 0) {
            return DS_News_HaveImageCellHeight;
        } else {
            return DS_News_NotImageCellHeight;
        }
    } else if ([_tableViewList[indexPath. row] isKindOfClass:[DS_LotteryNoticeModel class]]) {
        DS_LotteryNoticeModel * model = (DS_LotteryNoticeModel *)_tableViewList[indexPath.row];
        NSArray *array = [model.openCode componentsSeparatedByString:@","];
        if(array.count > 14){
            return DS_HomeLotteryNoticeCellMaxHeight;
        } else if (array.count > 7) {
            return DS_HomeLotteryNoticeCellMidHeight;
        }
        return DS_HomeLotteryNoticeCellMinHeight;
    } else {
        return DS_HomeNormalCellHeight;
    }
}


@end
