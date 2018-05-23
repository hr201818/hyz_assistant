//
//  DS_NewsTableViewCell.h
//  DSLottery
//
//  Created by 黄玉洲 on 2018/5/9.
//  Copyright © 2018年 海南达生实业有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DS_NewsListModel.h"

static NSString * DS_NewsTableViewCellID = @"DS_NewsTableViewCell";
static CGFloat    DS_NewsTableViewCellHeight = 100;

/** 首页资讯 */
@interface DS_NewsTableViewCell : UITableViewCell

/** 资讯详情 */
@property (strong, nonatomic) NSMutableArray <DS_NewsModel *> * models;

/** 资讯模型 */
@property (strong, nonatomic) DS_NewsModel * model;

@end
