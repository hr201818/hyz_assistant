//
//  DS_FindViewModel.m
//  DSLottery
//
//  Created by 黄玉洲 on 2018/5/15.
//  Copyright © 2018年 海南达生实业有限公司. All rights reserved.
//

#import "DS_FindViewModel.h"

/** share */
#import "DS_AdvertShare.h"

/** viewController */
#import "DS_LotteryNoticeDetailViewController.h"

/** cell */
#import "DS_LotteryNoticeTableViewCell.h"
#import "DS_NewsDetailAdvertTableViewCell.h"
#import "DS_FindTableViewCell.h"

/** model */
#import "DS_LotteryNoticeListModel.h"
#import "DS_AdvertListModel.h"

@interface DS_FindViewModel ()

@property (strong, nonatomic) NSMutableArray * mArray;

@property (strong, nonatomic) DS_LotteryNoticeListModel * listModel;

/** 彩种ID */
@property (copy, nonatomic)   NSString * lotteryID;

@end


@implementation DS_FindViewModel


/** 重置数据 */
- (void)resetData {
    [self dealDataFromModel:_listModel];
}

#pragma mark - 数据处理
/**
 处理数据
 @param listArray 开奖公告数据
 */
- (void)dealDataFromModel:(DS_LotteryNoticeListModel *)listArray {
    
    if (!_mArray) {
        _mArray = [NSMutableArray array];
    } else {
        [_mArray removeAllObjects];
    }
    
    // 添加彩种推荐
    if ([listArray.resultList count] > 0) {
        NSInteger random = arc4random() % [listArray.resultList count];
        DS_LotteryNoticeModel * model = listArray.resultList[random];
        _lotteryID = model.playGroupId;
        [_mArray addObject:model];
    }
    
    // 添加广告
    DS_AdvertModel * bannerModel_1 = [[DS_AdvertShare share] advertModelWithAdvertID:@"12"];
    if (bannerModel_1) {
        [_mArray addObject:bannerModel_1];
    }

    // 添加投注地点
    [_mArray addObject:@(DS_FindCellType_Place)];

    // 添加广告
    DS_AdvertModel * bannerModel_2 = [[DS_AdvertShare share] advertModelWithAdvertID:@"13"];
    if (bannerModel_2) {
        [_mArray addObject:bannerModel_2];
    }

    // 添加分析预测
    [_mArray addObject:@(DS_FindCellType_Predict)];

    // 添加广告
    NSArray * adverts = [[DS_AdvertShare share] advertModelsWithAdvertIDs:@[@"14",@"15",@"16"]];
    if (adverts) {
        [_mArray addObjectsFromArray:adverts];
    }
}

#pragma mark - 数据请求
/**
 请求开奖公告
 @param complete 请求成功
 @param fail     请求失败
 */
-(void)requestLotteryNoticeComplete:(void(^)(id object))complete
                               fail:(void(^)(NSError * failure))fail {
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    [dic setValue:APPVERSION forKey:@"version"];
    [DS_Networking postConectWithS:GETALLSSCDATA Parameter:dic Succeed:^(id result) {
        if (Request_Success(result)) {
            _listModel = [DS_LotteryNoticeListModel yy_modelWithJSON:result];
            [self dealDataFromModel:_listModel];
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

#pragma mark - <UITableViewDelegate, UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_mArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    id object = _mArray[indexPath.section];
    // 广告
    if ([object isKindOfClass:[DS_AdvertModel class]]) {
        DS_NewsDetailAdvertTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:DS_NewsDetailAdvertTableViewCellID];
        if (!cell) {
            cell = [[DS_NewsDetailAdvertTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:DS_NewsDetailAdvertTableViewCellID];
        }
        
        cell.model = (DS_AdvertModel *)object;
        return cell;
        
    }
    // 彩种
    else if ([object isKindOfClass:[DS_LotteryNoticeModel class]]){
        DS_LotteryNoticeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:DS_LotteryNoticeTableViewCellID];
        if (!cell) {
            cell = [[DS_LotteryNoticeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:DS_LotteryNoticeTableViewCellID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.model = (DS_LotteryNoticeModel *)object;
        return cell;
    }
    // 操作
    else {
        DS_FindTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:DS_FindTableViewCellID];
        if (!cell) {
            cell = [[DS_FindTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:DS_FindTableViewCellID];
        }
        cell.type = (DS_FindCellType)[object integerValue];
        cell.lotteryID = _lotteryID;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    id object = _mArray[indexPath.section];
    // 广告
    if ([object isKindOfClass:[DS_AdvertModel class]]) {
        return DS_NewsDetailAdvertTableViewCellHeight;
    }
    // 彩种
    else if ([object isKindOfClass:[DS_LotteryNoticeModel class]]){
        DS_LotteryNoticeModel * model = (DS_LotteryNoticeModel *)object;
        NSArray *array = [model.openCode componentsSeparatedByString:@","];
        if(array.count > 14){
            return DS_LotteryNoticeTableViewCellMaxHeight;
        } else if (array.count > 7) {
            return DS_LotteryNoticeTableViewCellMidHeight;
        }
        return DS_LotteryNoticeTableViewCellMinHeight;
    }
    // 操作
    else {
        return DS_FindTableViewCellHeight;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section != 0) {
        return 10;
    } else {
        return 0;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([_mArray[indexPath.section] isKindOfClass:[DS_LotteryNoticeModel class]]) {
        DS_LotteryNoticeDetailViewController * oepnAwardVC = [[DS_LotteryNoticeDetailViewController alloc] init];
        oepnAwardVC.hidesBottomBarWhenPushed = YES;
        DS_LotteryNoticeModel * model = _mArray[indexPath.section];
        oepnAwardVC.playGroupId = model.playGroupId;
        oepnAwardVC.playGroupName = model.playGroupName;
        [tableView.viewController.navigationController pushViewController:oepnAwardVC animated:YES];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView * view = [[UIView alloc] init];
    view.backgroundColor = COLOR_BACK;
    return view;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y <= 10 && scrollView.contentOffset.y >= 0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y > 10) {
        scrollView.contentInset = UIEdgeInsetsMake(-10, 0, 0, 0);
    }
}


@end
