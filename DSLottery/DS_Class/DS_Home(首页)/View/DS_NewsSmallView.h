//
//  DS_NewsSmallView.h
//  ALLTIMELOTTERY
//
//  Created by 黄玉洲 on 2018/5/3.
//  Copyright © 2018年 科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 新闻cell的小视图（点赞、阅读数） */
@interface DS_NewsSmallView : UIView

/**
 设置icon图标和数量
 @param imageName 图标名
 @param number 数量
 */
- (void)setImageName:(NSString *)imageName number:(NSString *)number;

/** 设置数量 */
- (void)setNumber:(NSString *)number;

/** 设置icon */
- (void)setImageName:(NSString *)imageName;

@end
