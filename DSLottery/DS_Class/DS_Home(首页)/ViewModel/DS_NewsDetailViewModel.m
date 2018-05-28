//
//  DS_NewsDetailViewModel.m
//  DSLottery
//
//  Created by 黄玉洲 on 2018/5/12.
//  Copyright © 2018年 海南达生实业有限公司. All rights reserved.
//

#import "DS_NewsDetailViewModel.h"

/** share */
#import "DS_AdvertShare.h"

/** cell */
#import "DS_NewsDetailWebTableViewCell.h"
#import "DS_News_HaveImageCell.h"
#import "DS_News_NotImageCell.h"
#import "DS_NotBorderAdvertCell.h"

@interface DS_NewsDetailViewModel ()

/* webView返回的高 */
@property (assign, nonatomic) NSInteger     webHeight;

/** 相关阅读 */
@property (strong, nonatomic) NSMutableArray * relatedReads;

@end

@implementation DS_NewsDetailViewModel

/**
 初始化
 @param newModel 资讯详情
 @param models   资讯数组
 @param vc       控制器
 @return 实例
 */
- (instancetype)initWithModel:(DS_NewsModel *)newModel models:(NSArray <DS_NewsModel *> *)models {
    if ([super init]) {
        _webHeight = 0;
        _model = newModel;
        _models = [models mutableCopy];
        
        // 获取可操作的数据源
        NSMutableArray * dataSource = [NSMutableArray arrayWithArray:_models];
        
        _relatedReads = [NSMutableArray array];
        
        // 筛选掉无关资讯
        NSMutableArray * deleteArray = [NSMutableArray array];
        for (DS_NewsModel * newsModel in dataSource) {
            if (![newsModel.categoryId isEqual:_model.categoryId] ||
                [newsModel.ID isEqual:_model.ID]) {
                [deleteArray addObject:newsModel];
            }
        }
        [dataSource removeObjectsInArray:deleteArray];
        
        // 随机选取最多5个相关推荐
        NSInteger relatedCount = 1;
        while (dataSource.count) {
            if (relatedCount >= 5) {
                break;
            }
            
            NSInteger index = arc4random() % [dataSource count];
            [_relatedReads addObject:dataSource[index]];
            [dataSource removeObjectAtIndex:index];
            
            relatedCount++;
        }
    }
    return self;
}

#pragma mark - 数据请求
/** 请求阅读资讯 */
- (void)requestReadNewsComplete:(void(^)(id object))complete
                           fail:(void(^)(NSError * failure))fail {
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    [dic setValue:_model.ID forKey:@"newsId"];
    [DS_Networking postConectWithS:READ_NEWS Parameter:dic Succeed:^(id result) {
        if (Request_Success(result)) {
            // 增加阅读数
            NSInteger readerNumb = [_model.readerNumb integerValue] + 1;
            _model.readerNumb = [NSString stringWithFormat:@"%ld",readerNumb];

            [[NSNotificationCenter defaultCenter] postNotificationName:@"praise_read_number" object:_model];
        }
        if (complete) {
            complete(result);
        }
    } Failure:^(NSError *failure) {

    }];
}

/** 请求点赞资讯 */
- (void)requestSupportNewsComplete:(void(^)(id object))complete
                              fail:(void(^)(NSError * failure))fail {
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    [dic setValue:_model.ID forKey:@"newsId"];
    [DS_Networking postConectWithS:SUPPORT_NEWS Parameter:dic Succeed:^(id result) {
        if (Request_Success(result)) {
            // 增加点赞数
            NSInteger thumbNum = [_model.thumbsUpNumb integerValue] + 1;
            _model.thumbsUpNumb = [NSString stringWithFormat:@"%ld",thumbNum];
            _model.isPraised = YES;
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"praise_read_number" object:_model];
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
/**
 处理数据
 @param model 修改后的数据
 */
- (void)processNews:(DS_NewsModel *)model {
    for (DS_NewsModel * newsModel in _relatedReads) {
        if ([model.ID isEqual:newsModel.ID]) {
            newsModel.thumbsUpNumb = model.thumbsUpNumb;
            newsModel.readerNumb = model.readerNumb;
            if ([newsModel.imageIdList count] == 0) {
                DS_AdvertModel * adverModel = [[DS_AdvertShare share] randomAdverModel:@[@"11",@"12", @"13"]];
                newsModel.adverModel = adverModel;
            }
        }
    }
}

#pragma mark - <UITableViewDelegate, UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section < 3) {
        return 1;
    } else {
        return [_relatedReads count];;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 || indexPath.section == 2) {
        DS_NotBorderAdvertCell *cell = [tableView dequeueReusableCellWithIdentifier:DS_NotBorderAdvertCellID];
        if (cell ==nil) {
            cell = [[DS_NotBorderAdvertCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:DS_NotBorderAdvertCellID];
        }
        
        NSString * locationID = indexPath.section == 0 ? @"9" : @"10";
        DS_AdvertModel * model = [[DS_AdvertShare share] advertModelWithAdvertID:locationID];
        cell.model = model;
        return cell;
    }else if(indexPath.section == 1){
        DS_NewsDetailWebTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DS_NewsDetailWebTableViewCellID];
        if (cell ==nil) {
            cell = [[DS_NewsDetailWebTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:DS_NewsDetailWebTableViewCellID];
        }
        cell.model = _model;
        weakifySelf
        cell.webHeightBlock = ^(CGFloat height) {
            strongifySelf
            self.webHeight = height;
            [tableView reloadData];
        };
        
        /** 支持一下 */
        cell.supportBlock = ^{
            strongifySelf
            if (self.supportBlock) {
                self.supportBlock(_model);
            }
        };
        
        return cell;
    }else{
        DS_NewsModel * model = (DS_NewsModel *)_relatedReads[indexPath.row];
        if ([model.imageIdList count] > 0) {
            DS_News_HaveImageCell * cell = [tableView dequeueReusableCellWithIdentifier:DS_News_HaveImageCellID];
            if (!cell) {
                cell = [[DS_News_HaveImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:DS_News_HaveImageCellID];
            }
            cell.models = _models;
            cell.model = model;
            return cell;
        } else {
            DS_News_NotImageCell * cell = [tableView dequeueReusableCellWithIdentifier:DS_News_NotImageCellID];
            if (!cell) {
                cell = [[DS_News_NotImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:DS_News_NotImageCellID];
            }
            cell.models = _models;
            cell.model = model;
            return cell;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 || indexPath.section == 2) {
        return DS_NotBorderAdvertCellHeight;
    }else if(indexPath.section == 1){
        return  self.webHeight;
    } else if (indexPath.section == 3) {
        DS_NewsModel * model = (DS_NewsModel *)_relatedReads[indexPath.row];
        if ([model.imageIdList count] > 0) {
            return DS_News_HaveImageCellHeight;
        } else {
            return DS_News_NotImageCellHeight;
        }
    }
    return 46;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0 || section == 1) {
        return 0;
    } else {
        return 15;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView * sectionView = [[UIView alloc] init];
    sectionView.backgroundColor = COLOR_BACK;
    return sectionView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 3) {
        if (self.childVCBlock) {
            self.childVCBlock(_relatedReads[indexPath.row], _models);
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y <= 15 && scrollView.contentOffset.y >= 0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y >= 15) {
        scrollView.contentInset = UIEdgeInsetsMake(-15, 0, 0, 0);
    }
}

@end
