//
//  DS_NewsDetailAdvertTableViewCell.h
//  DSLottery
//
//  Created by 黄玉洲 on 2018/5/12.
//  Copyright © 2018年 海南达生实业有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DS_AdvertListModel.h"
static NSString * DS_NewsDetailAdvertTableViewCellID = @"DS_NewsDetailAdvertTableViewCell";
static CGFloat    DS_NewsDetailAdvertTableViewCellHeight = 145;

/** 资讯详情页广告 */
@interface DS_NewsDetailAdvertTableViewCell : UITableViewCell

@property (strong, nonatomic) DS_AdvertModel * model;

@end
