//
// Created by wangzhijie on 2016/8/10.
// Copyright (c) 2016 海狸先生. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JJMenuItemCell : UICollectionViewCell

@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) UIColor *normalFontColor;
@property (nonatomic, strong) UIColor *selectedFontColor;

@property (nonatomic, assign) int normalFontSize;
@property (nonatomic, assign) int selectedFontSize;

@end
