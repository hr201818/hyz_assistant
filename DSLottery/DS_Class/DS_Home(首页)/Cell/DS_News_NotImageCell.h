//
//  DS_News_NotImageCell.h
//  DSLottery
//
//  Created by 黄玉洲 on 2018/5/23.
//  Copyright © 2018年 海南达生实业有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DS_NewsListModel.h"
static NSString * DS_News_NotImageCellID = @"DS_News_NotImageCell";
static CGFloat    DS_News_NotImageCellHeight = 155;

/** 不带图片的资讯cell */
@interface DS_News_NotImageCell : UITableViewCell

/** 资讯详情 */
@property (strong, nonatomic) NSMutableArray <DS_NewsModel *> * models;

/** 资讯模型 */
@property (strong, nonatomic) DS_NewsModel * model;

@end
