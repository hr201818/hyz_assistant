//
//  DS_BaseTabBarItem.m
//  DSLottery
//
//  Created by 黄玉洲 on 2018/4/25.
//  Copyright © 2018年 海南达生实业有限公司. All rights reserved.
//

#import "DS_BaseTabBarItem.h"
#import "Masonry.h"
#import "DS_TabbarInfo.h"
@interface DS_BaseTabBarItem()
{
    UIImage * _normalImage;  // 常态时的图片
    UIImage * _selectedImage;  // 选中时的图片
    NSString * _title;       // 标题
}

// 元素图片
@property (nonatomic, strong) UIImageView * itemImageView;

// 标题
@property (nonatomic, strong) UILabel     * titleLab;

@end

@implementation DS_BaseTabBarItem

- (instancetype)initWithTabbarInfo:(NSDictionary *)infoDic {
    if ([super init]) {
        // 字典数据转为模型
        DS_TabbarInfo * tabbar_info = [DS_TabbarInfo yy_modelWithDictionary:infoDic];
        
        // 容错处理
        _title = tabbar_info.title != nil ? tabbar_info.title : @"";
        _normalImage = tabbar_info.normalImageName != nil ? [UIImage imageNamed:tabbar_info.normalImageName] : [UIImage imageNamed:TABBAR_NORMAL_IMAGE];
        _selectedImage = tabbar_info.selectedImageName != nil ? [UIImage imageNamed:tabbar_info.selectedImageName] : [UIImage imageNamed:TABBAR_NORMAL_IMAGE];
        
        [self layoutView];
    }
    return self;
}

- (instancetype)initWithNormalName:(NSString *)normalName selectedName:(NSString *)selectedName title:(NSString *)title {
    if ([super init]) {
        // 容错处理
        _title = title != nil ? title : @"";
        _normalImage = normalName != nil ? [UIImage imageNamed:normalName] : [UIImage imageNamed:TABBAR_NORMAL_IMAGE];
        _selectedImage = selectedName != nil ? [UIImage imageNamed:selectedName] : [UIImage imageNamed:TABBAR_NORMAL_IMAGE];
        
        [self layoutView];
    }
    return self;
}

#pragma mark - 初始化
/**
 界面初始化
 */
- (void)layoutView {
    [self addSubview:self.itemImageView];
    [_itemImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.width.height.mas_equalTo(28);
        make.top.mas_equalTo(2);
    }];
    
    [self addSubview:self.titleLab];
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(19);
        make.top.mas_equalTo(_itemImageView.mas_bottom);
    }];
}

#pragma mark - setter
/**
 设置是否选中
 @param isSelected 是否选中
 */
- (void)setIsSelected:(BOOL)isSelected {
    _isSelected = isSelected;
    UIImage * currentImage = isSelected == YES ? _selectedImage : _normalImage;
    _itemImageView.image = currentImage;
}

#pragma mark - 懒加载
- (UIImageView *)itemImageView {
    if (!_itemImageView) {
        _itemImageView = [[UIImageView alloc] initWithImage:_normalImage];
    }
    return _itemImageView;
}

- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.text = _title;
        _titleLab.font = [UIFont systemFontOfSize:11];
        _titleLab.textColor = [UIColor grayColor];
        _titleLab.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLab;
}

@end
