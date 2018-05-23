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
#import "DS_NewsDetailAdvertTableViewCell.h"
#import "DS_NewsDetailWebTableViewCell.h"
#import "DS_RecommendTableViewCell.h"

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
        }
    }
}

#pragma mark - <UITableViewDelegate, UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section < 4) {
        return 1;
    } else {
        return [_relatedReads count];;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 || indexPath.section == 2 || indexPath.section == 3) {
        DS_NewsDetailAdvertTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DS_NewsDetailAdvertTableViewCellID];
        if (cell ==nil) {
            cell = [[DS_NewsDetailAdvertTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:DS_NewsDetailAdvertTableViewCellID];
        }
        
        NSString * locationID = indexPath.section == 0 ? @"6" : indexPath.section == 2 ? @"7" : @"8";
        DS_AdvertModel * model = [[DS_AdvertShare share] advertModelWithAdvertID:locationID];
        cell.model = model;
        return cell;
    }else if(indexPath.section == 1){
        DS_NewsDetailWebTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DS_NewsDetailWebTableViewCellID];
        if (cell ==nil) {
            cell = [[DS_NewsDetailWebTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:DS_NewsDetailWebTableViewCellID];
        }
        cell.webContent = self.model.content;
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
        DS_RecommendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DS_RecommendTableViewCellID];
        if (cell ==nil) {
            cell = [[DS_RecommendTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:DS_RecommendTableViewCellID];
        }
        cell.model = _relatedReads[indexPath.row];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 || indexPath.section == 2 || indexPath.section == 3) {
        return DS_NewsDetailAdvertTableViewCellHeight;
    }else if(indexPath.section == 1){
        return  self.webHeight;
    } else if (indexPath.section == 4) {
        return DS_RecommendTableViewCellHeight;
    }
    return 46;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 4) {
        return 5 + 45;
    } else {
        return 5;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView * sectionView = [[UIView alloc] init];
    sectionView.backgroundColor = COLOR_BACK;
    
    if (section == 4) {
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, tableView.width, 45)];
        label.text = @"    相关阅读";
        label.font = [UIFont systemFontOfSize:14.0f];
        label.backgroundColor = [UIColor whiteColor];
        [sectionView addSubview:label];
    }
    return sectionView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 4) {
        if (self.childVCBlock) {
            self.childVCBlock(_relatedReads[indexPath.row], _models);
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y <= 5 && scrollView.contentOffset.y >= 0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y >= 5) {
        scrollView.contentInset = UIEdgeInsetsMake(-5, 0, 0, 0);
    }
}

@end
