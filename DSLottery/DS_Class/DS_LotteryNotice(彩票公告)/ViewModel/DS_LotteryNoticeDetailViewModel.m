//
//  DS_LotteryNoticeDetailViewModel.m
//  DSLottery
//
//  Created by 黄玉洲 on 2018/5/14.
//  Copyright © 2018年 海南达生实业有限公司. All rights reserved.
//

#import "DS_LotteryNoticeDetailViewModel.h"

/** share */
#import "DS_AdvertShare.h"

/** model */
#import "DS_LotteryNoticeListModel.h"
#import "DS_AdvertListModel.h"

/** cell */
#import "DS_AdvertTableViewCell.h"
#import "DS_LotteryNoticeDetailCell.h"

@interface DS_LotteryNoticeDetailViewModel ()
{
    // 彩种详情数量
    NSInteger _lotteryDetailCount;
}
/** 列表数据 */
@property (strong, nonatomic) NSMutableArray * listArray;

@end

@implementation DS_LotteryNoticeDetailViewModel

- (instancetype)init {
    if ([super init]) {
        _listArray = [NSMutableArray array];
    }
    return self;
}

#pragma mark - 数据请求
/**
 请求开奖公告详情
 @param lotteryID 彩种ID
 @param complete  请求完成
 @param fail      请求失败
 */
- (void)requestLotteryNoticeDetailWithLotteryID:(NSString *)lotteryID
                                       complete:(void(^)(id object))complete
                                           fail:(void(^)(NSError * failure))fail {
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
    [dic setValue:lotteryID forKey:@"playGroupId"];
    [DS_Networking postConectWithS:GETSSCTIMEDATA Parameter:dic Succeed:^(id result) {
        if (Request_Success(result)) {
            [_listArray removeAllObjects];
            _lotteryDetailCount = 0;
            for (NSDictionary * dic in [result objectForKey:@"sscHistoryList"]) {
                DS_LotteryNoticeModel * model = [DS_LotteryNoticeModel yy_modelWithJSON:dic];
                model.playGroupName = [result objectForKey:@"playGroupName"];
                [_listArray addObject:model];
                _lotteryDetailCount++;
            }
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

#pragma mark - 数据获取
/** 获取彩种详情的数据量 */
- (NSInteger)lotteryCount {
    return _lotteryDetailCount;
}

#pragma mark - 数据处理
/** 加载广告 */
- (void)loadAdvertData {
    DS_AdvertModel * advertModel_10 = [[DS_AdvertShare share] advertModelWithAdvertID:@"10"];
    if (advertModel_10) {
        // 插入数组中的第5个位置放广告
        if ([_listArray count] > 5) {
            [_listArray insertObject:advertModel_10 atIndex:5];
        } else {
            [_listArray insertObject:advertModel_10 atIndex:0];
        }
    }
    
    DS_AdvertModel * advertModel_11 = [[DS_AdvertShare share] advertModelWithAdvertID:@"11"];
    if (advertModel_11) {
        // 插入数组中的第5个位置放广告
        if ([_listArray count] > 10) {
            [_listArray insertObject:advertModel_11 atIndex:10];
        } else {
            [_listArray addObject:advertModel_11];
        }
    }
}

#pragma mark - <UITableViewDelegate,UITableViewDataSource>
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_listArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 广告位
    if ([_listArray[indexPath.row] isKindOfClass:[DS_AdvertModel class]]) {
        DS_AdvertTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:DS_AdvertTableViewCellID];
        if (!cell) {
            cell = [[DS_AdvertTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:DS_AdvertTableViewCellID];
        }
        cell.model = (DS_AdvertModel *)_listArray[indexPath.row];
        return cell;
    }else{
        DS_LotteryNoticeDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:DS_LotteryNoticeDetailCellID];
        if (!cell) {
            cell = [[DS_LotteryNoticeDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:DS_LotteryNoticeDetailCellID];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = (DS_LotteryNoticeModel *)_listArray[indexPath.row];
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //广告位
    if ([_listArray[indexPath.row] isKindOfClass:[DS_AdvertModel class]]) {
        return DS_AdvertTableViewCellHeight;
    } else {
        DS_LotteryNoticeModel * model = _listArray[indexPath.row];
        NSArray *array = [model.openCode componentsSeparatedByString:@","];
        if(array.count > 10){
            return DS_LotteryNoticeDetailCellMaxHeight;
        }
        return DS_LotteryNoticeDetailCellMinHeight;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

@end
