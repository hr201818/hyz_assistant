//
//  DS_NewsListModel.h
//  DSLottery
//
//  Created by 黄玉洲 on 2018/5/9.
//  Copyright © 2018年 海南达生实业有限公司. All rights reserved.
//

#import "DS_BaseObject.h"

@interface DS_NewsListModel : DS_BaseObject

@property (strong, nonatomic) NSMutableArray * articleList;

@end

@interface DS_NewsModel : DS_BaseObject

@property (copy, nonatomic) NSString * ID;

@property (copy, nonatomic) NSString * title;

@property (copy, nonatomic) NSString * name;

@property (copy, nonatomic) NSString * crux;

@property (copy, nonatomic) NSString * remarks;

@property (copy, nonatomic) NSString * content;

@property (copy, nonatomic) NSString * sort;

@property (copy, nonatomic) NSString * createTime;

@property (copy, nonatomic) NSString * updateTime;

@property (copy, nonatomic) NSString * categoryId;

@property (copy, nonatomic) NSString * imageId;

@property (copy, nonatomic) NSString * exclusive;

@property (copy, nonatomic) NSString * hot;

@property (strong, nonatomic) NSMutableArray * imageIdList;

/** 点赞数 */
@property (copy, nonatomic) NSString * thumbsUpNumb;

/** 观看数 */
@property (copy, nonatomic) NSString * readerNumb;

@end
