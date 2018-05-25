//
//  DS_NewsCategoryView.h
//  DSLottery
//
//  Created by 黄玉洲 on 2018/5/12.
//  Copyright © 2018年 海南达生实业有限公司. All rights reserved.
//

#import "DS_BaseView.h"
#import "DS_CategoryListModel.h"
@interface DS_NewsCategoryView : DS_BaseView

/** 分类数组 */
@property (strong, nonatomic) NSArray <DS_CategoryModel *> * newsCategorys;

/** 点击资讯类别后，回传类别ID */
@property (copy, nonatomic)   void(^newsCategoryBlock)(NSString * newsCategoryID);

@end
