//
//  DSScrollMenu.h
//  ALLTIMELOTTERY
//
//  Created by wangzhijie on 2018/5/20.
//  Copyright © 2018年 科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
 typedef void (^SelectedItemBlock)(NSInteger item);
@interface DSScrollMenu : UIView
/**
 * 标题
 */
@property (nonatomic, strong) NSArray *menuTitles;

@property (nonatomic, assign) NSInteger currentIndex;
/**
 * 标题栏背景颜色
 */
@property (nonatomic, strong) UIColor *menuBackgroundColor;
@property (nonatomic, strong) UIColor *lineDsColor;
@property (nonatomic, strong) UIColor *normalFontColor;
@property (nonatomic, strong) UIColor *selectedFontColor;
@property (nonatomic, assign) int normalFontSize;
@property (nonatomic, assign) int selectedFontSize;
@property(nonatomic, copy) SelectedItemBlock  selectedItemBlock;
@end
