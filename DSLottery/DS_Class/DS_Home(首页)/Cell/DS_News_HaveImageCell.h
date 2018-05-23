//
//  DS_News_HaveImageCell.h
//  DSLottery
//
//  Created by 黄玉洲 on 2018/5/23.
//  Copyright © 2018年 海南达生实业有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DS_NewsListModel.h"

static NSString * DS_News_HaveImageCellID = @"DS_News_HaveImageCell";
static CGFloat    DS_News_HaveImageCellHeight = 125;

/** 带图片的资讯cell */
@interface DS_News_HaveImageCell : UITableViewCell

/** 资讯详情 */
@property (strong, nonatomic) NSMutableArray <DS_NewsModel *> * models;

/** 资讯模型 */
@property (strong, nonatomic) DS_NewsModel * model;

@end
