//
//  DS_CategoryListModel.h
//  DSLottery
//
//  Created by 黄玉洲 on 2018/5/9.
//  Copyright © 2018年 海南达生实业有限公司. All rights reserved.
//

#import "DS_BaseObject.h"

/** 资讯、投注站地区分类接口 */
@interface DS_CategoryListModel : DS_BaseObject

@property (strong, nonatomic) NSMutableArray * appNewsCategorys;

#pragma mark - 非接口返回数据
@property (strong, nonatomic) NSMutableArray * newsCategory;

@property (strong, nonatomic) NSMutableArray * cityCategory;

@end

@interface DS_CategoryModel : DS_BaseObject

/** DS_NewsCategoryModel */
@property (strong, nonatomic) NSMutableArray * children;

/** 种类ID */
@property (copy, nonatomic)   NSString       * ID;

/** 种类名 */
@property (copy, nonatomic)   NSString       * name;

@property (copy, nonatomic)   NSString       * remarks;

@end
