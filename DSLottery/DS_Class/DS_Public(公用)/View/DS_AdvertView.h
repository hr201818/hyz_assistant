//
//  DS_AdvertView.h
//  DSLottery
//
//  Created by 黄玉洲 on 2018/5/9.
//  Copyright © 2018年 海南达生实业有限公司. All rights reserved.
//

#import "DS_BaseView.h"
#import "DS_AdvertListModel.h"
#import "DS_BaseAdvertView.h"

static CGFloat DS_AdvertViewHeight = 160;

/** 广告图（带上下黑边） */
@interface DS_AdvertView : DS_BaseView

@property (strong, nonatomic) DS_AdvertModel * model;

@end
