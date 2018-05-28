//
//  DS_AdvertTableViewCell.h
//  DSLottery
//
//  Created by 黄玉洲 on 2018/5/9.
//  Copyright © 2018年 海南达生实业有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DS_AdvertListModel.h"
static NSString * DS_AdvertTableViewCellID = @"DS_AdvertTableViewCell";
static CGFloat    DS_AdvertTableViewCellHeight = 160;

/** 首页广告(带有上下灰色区域) */
@interface DS_AdvertTableViewCell : UITableViewCell

/** 显示分隔线 */
@property (assign, nonatomic) BOOL showLine;

/** 广告模型 */
@property (strong, nonatomic) DS_AdvertModel * model;

@end
