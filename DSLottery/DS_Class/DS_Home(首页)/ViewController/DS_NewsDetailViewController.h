//
//  DS_NewsDetailViewController.h
//  DSLottery
//
//  Created by 黄玉洲 on 2018/5/12.
//  Copyright © 2018年 海南达生实业有限公司. All rights reserved.
//

#import "DS_BaseViewController.h"
#import "DS_NewsListModel.h"
@interface DS_NewsDetailViewController : DS_BaseViewController

@property (strong, nonatomic) NSMutableArray <DS_NewsModel *> * models;

@property (strong, nonatomic) DS_NewsModel * model;

@end
