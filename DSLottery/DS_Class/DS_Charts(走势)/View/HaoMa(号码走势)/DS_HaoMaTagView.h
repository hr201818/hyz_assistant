//
//  DS_HaoMaTagView.h
//  DSLottery
//
//  Created by 黄玉洲 on 2018/6/3.
//  Copyright © 2018年 海南达生实业有限公司. All rights reserved.
//

#import "DS_BaseView.h"

/** 号码标签（万位、千位、百位、十位、个位） */
@interface DS_HaoMaTagView : DS_BaseView

/**
 初始化
 @param frame 大小
 @param digitsTxt 位数（万位、千位、百位、十位、个位）
 @return 标签视图
 */
- (instancetype)initWithFrame:(CGRect)frame
                    digitsTxt:(NSString *)digitsTxt;

@end
