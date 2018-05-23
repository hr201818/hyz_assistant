//
//  DS_ShopTableViewCell.h
//  DSLottery
//
//  Created by 黄玉洲 on 2018/5/15.
//  Copyright © 2018年 海南达生实业有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h> //引入检索功能所有的头文件

static NSString * DS_ShopTableViewCellID = @"DS_ShopTableViewCell";
static CGFloat    DS_ShopTableViewCellHeight = 78;

@interface DS_ShopTableViewCell : UITableViewCell

@property (strong, nonatomic) BMKPoiInfo * model;

@end
