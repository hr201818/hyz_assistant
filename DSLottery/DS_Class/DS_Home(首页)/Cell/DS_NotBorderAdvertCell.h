//
//  DS_NotBorderAdvertCell.h
//  DSLottery
//
//  Created by 黄玉洲 on 2018/5/25.
//  Copyright © 2018年 海南达生实业有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DS_AdvertListModel.h"

static NSString * DS_NotBorderAdvertCellID = @"DS_NotBorderAdvertCell";
static CGFloat    DS_NotBorderAdvertCellHeight = 140;

@interface DS_NotBorderAdvertCell : UITableViewCell

@property (strong, nonatomic) DS_AdvertModel * model;

@end
