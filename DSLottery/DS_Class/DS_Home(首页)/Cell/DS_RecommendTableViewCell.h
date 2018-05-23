//
//  DS_RecommendTableViewCell.h
//  DSLottery
//
//  Created by 黄玉洲 on 2018/5/12.
//  Copyright © 2018年 海南达生实业有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DS_NewsListModel.h"

static NSString * DS_RecommendTableViewCellID = @"DS_RecommendTableViewCell";
static CGFloat    DS_RecommendTableViewCellHeight = 85;

/** 资讯详情页-相关阅读 */
@interface DS_RecommendTableViewCell : UITableViewCell

/** 资讯 */
@property (strong, nonatomic) DS_NewsModel * model;

@end
