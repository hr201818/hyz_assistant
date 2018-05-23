//
//  DS_HomeNormalCell.h
//  DSLottery
//
//  Created by 黄玉洲 on 2018/5/23.
//  Copyright © 2018年 海南达生实业有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString * DS_HomeNormalCellID = @"DS_HomeNormalCell";
static CGFloat    DS_HomeNormalCellHeight = 55;

/** 首页普通cell（彩票资讯标题） */
@interface DS_HomeNormalCell : UITableViewCell

/** cell标题 */
@property (copy, nonatomic) NSString * cellTitle;

@end
