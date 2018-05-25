//
//  DS_NewsDetailWebTableViewCell.h
//  DSLottery
//
//  Created by 黄玉洲 on 2018/5/12.
//  Copyright © 2018年 海南达生实业有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DS_NewsListModel.h"
static NSString * DS_NewsDetailWebTableViewCellID = @"DS_NewsDetailWebTableViewCell";
@interface DS_NewsDetailWebTableViewCell : UITableViewCell

@property (strong, nonatomic) DS_NewsModel * model;

@property (copy, nonatomic) void(^webHeightBlock)(CGFloat height);

/** 支持一下按钮回调 */
@property (copy, nonatomic) void(^supportBlock)(void);

@end
