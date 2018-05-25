//
//  DS_BaseAdvertView.h
//  DSLottery
//
//  Created by 黄玉洲 on 2018/5/25.
//  Copyright © 2018年 海南达生实业有限公司. All rights reserved.
//

#import "DS_BaseView.h"
#import "DS_AdvertListModel.h"

static CGFloat DS_BaseAdvertViewHeight = 140;

/** 广告图（不带上下黑边） */
@interface DS_BaseAdvertView : DS_BaseView

@property (strong, nonatomic) DS_AdvertModel * model;

@end
