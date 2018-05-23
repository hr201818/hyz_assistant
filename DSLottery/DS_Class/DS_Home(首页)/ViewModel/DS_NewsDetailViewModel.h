//
//  DS_NewsDetailViewModel.h
//  DSLottery
//
//  Created by 黄玉洲 on 2018/5/12.
//  Copyright © 2018年 海南达生实业有限公司. All rights reserved.
//

#import "DS_BaseObject.h"
#import "DS_NewsListModel.h"

@interface DS_NewsDetailViewModel : DS_BaseObject <UITableViewDelegate, UITableViewDataSource>

/**
 初始化
 @param newModel 资讯详情
 @param models   资讯数组
 @return 实例
 */
- (instancetype)initWithModel:(DS_NewsModel *)newModel models:(NSArray <DS_NewsModel *> *)models;

#pragma mark - 数据请求
/** 请求阅读资讯 */
- (void)requestReadNewsComplete:(void(^)(id object))complete
                           fail:(void(^)(NSError * failure))fail;

/** 请求点赞资讯 */
- (void)requestSupportNewsComplete:(void(^)(id object))complete
                              fail:(void(^)(NSError * failure))fail;

#pragma mark - 数据处理
/**
 处理数据
 @param model 修改后的数据
 */
- (void)processNews:(DS_NewsModel *)model;

@property (strong, nonatomic) NSMutableArray <DS_NewsModel *> * models;

@property (strong, nonatomic) DS_NewsModel * model;

/** 打开子控制器回调 */
@property (copy, nonatomic) void(^childVCBlock)(DS_NewsModel * model, NSMutableArray <DS_NewsModel *> * models);

/** 支持一下回调 */
@property (copy, nonatomic) void(^supportBlock)(DS_NewsModel * model);

@end
