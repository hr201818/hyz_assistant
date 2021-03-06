//
//  DS_LotteryNoticeViewModel.m
//  DSLottery
//
//  Created by 黄玉洲 on 2018/5/14.
//  Copyright © 2018年 海南达生实业有限公司. All rights reserved.
//

#import "DS_LotteryNoticeViewModel.h"
#import "DS_LotteryNoticeDetailViewController.h"
#import "DS_LocalData.h"

/** model */
#import "DS_LotteryNoticeListModel.h"
#import "DS_AdvertListModel.h"

/** cell */
#import "DS_AdvertTableViewCell.h"
#import "DS_HomeLotteryNoticeCell.h"

/** share */
#import "DS_AdvertShare.h"

@interface DS_LotteryNoticeViewModel ()

@property (strong, nonatomic) DS_LotteryNoticeListModel * listModel;

/** 列表数据 */
@property (strong, nonatomic) NSMutableArray * listArray;

@end

@implementation DS_LotteryNoticeViewModel

- (instancetype)init {
    if ([super init]) {
        _listArray = [NSMutableArray array];
        
        // 开奖公告信息
        id lotteryData = [DS_LocalData lotteryData];
        if (lotteryData) {
            _listModel = [DS_LotteryNoticeListModel yy_modelWithJSON:lotteryData];
            [self processData];
            [self loadAdvertData];
        }
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
            _listModel = [DS_LotteryNoticeListModel yy_modelWithJSON:result];
            [self processData];
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

#pragma mark - 数据处理
- (void)processData {
    [_listArray removeAllObjects];
    for (DS_LotteryNoticeModel * model in _listModel.resultList) {
        [_listArray addObject:model];
    }
}

/** 加载广告数据 */
- (void)loadAdvertData {
    NSArray <DS_AdvertModel *> * adverts = [[DS_AdvertShare share] lotteryAdverts];
    if ([adverts count] > 0) {
        // 插入数组中的第5个位置放广告
        if ([_listArray count] > 5) {
            [_listArray insertObject:[adverts firstObject] atIndex:5];
        } else {
            [_listArray insertObject:[adverts firstObject] atIndex:0];
        }
    }

    if ([adverts count] > 1) {
        // 插入数组中的第5个位置放广告
        if ([_listArray count] > 10) {
            [_listArray insertObject:[adverts lastObject] atIndex:10];
        } else {
            [_listArray addObject:[adverts lastObject]];
        }
    }
}

#pragma mark - <UITableViewDelegate,UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_listArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 广告位
    if ([_listArray[indexPath.row] isKindOfClass:[DS_AdvertModel class]]) {
        DS_AdvertTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DS_AdvertTableViewCellID];
        if (cell == nil) {
            cell = [[DS_AdvertTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:DS_AdvertTableViewCellID];
        }
        cell.model = (DS_AdvertModel *)_listArray[indexPath.row];
        cell.showLine = YES;
        return cell;
    }else{
        DS_HomeLotteryNoticeCell *cell = [tableView dequeueReusableCellWithIdentifier:DS_HomeLotteryNoticeCellID];
        if (cell ==nil) {
            cell = [[DS_HomeLotteryNoticeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:DS_HomeLotteryNoticeCellID];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.isLottery = YES;
        cell.model = (DS_LotteryNoticeModel *)_listArray[indexPath.row];
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //广告位
    if ([_listArray[indexPath.row] isKindOfClass:[DS_AdvertModel class]]) {
        return DS_AdvertTableViewCellHeight;
    }else{
        DS_LotteryNoticeModel * model = (DS_LotteryNoticeModel *)_listArray[indexPath.row];
        NSArray *array = [model.openCode componentsSeparatedByString:@","];
        if(array.count > 14){
            return IOS_SiZESCALE(DS_HomeLotteryNoticeCellMaxHeight + 10);
        } else if (array.count > 7) {
            return IOS_SiZESCALE(DS_HomeLotteryNoticeCellMidHeight + 10);
        }
        return IOS_SiZESCALE(DS_HomeLotteryNoticeCellMinHeight + 10);
    }
    return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_listArray[indexPath.row] isKindOfClass:[DS_AdvertModel class]]) {
        DS_AdvertModel * model = (DS_AdvertModel *)_listArray[indexPath.row];
        [DS_FunctionTool openAdvert:model];
    }else{
        DS_LotteryNoticeDetailViewController * vc = [[DS_LotteryNoticeDetailViewController alloc] init];
        DS_LotteryNoticeModel * model = (DS_LotteryNoticeModel *)_listArray[indexPath.row];
        vc.playGroupId = model.playGroupId;
        vc.playGroupName = model.playGroupName;
        [tableView.viewController.navigationController pushViewController:vc animated:YES];
    }
}


@end
