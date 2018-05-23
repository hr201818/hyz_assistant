//
//  DS_NewsCategoryCollectionViewCell.h
//  DSLottery
//
//  Created by 黄玉洲 on 2018/5/12.
//  Copyright © 2018年 海南达生实业有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DS_CategoryListModel.h"
static NSString * DS_NewsCategoryCollectionViewCellID = @"DS_NewsCategoryCollectionViewCell";

@interface DS_NewsCategoryCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) DS_CategoryModel * model;

@end
