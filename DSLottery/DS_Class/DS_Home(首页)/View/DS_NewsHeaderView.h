//
//  DS_NewsHeaderView.h
//  DSLottery
//
//  Created by 黄玉洲 on 2018/5/12.
//  Copyright © 2018年 海南达生实业有限公司. All rights reserved.
//

#import "DS_BaseView.h"
#import "DS_NewsListModel.h"
@interface DS_NewsHeaderView : DS_BaseView

- (instancetype)initWithFrame:(CGRect)frame model:(DS_NewsModel *)model;

/** 设置点赞数量 */
- (void)setThumbNumber:(NSString *)thumbNumber;

/** 设置阅读数量 */
- (void)setReadNumber:(NSString *)readNumber;

@end
