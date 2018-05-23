//
//  DS_BaseTabBar.m
//  DSLottery
//
//  Created by 黄玉洲 on 2018/4/25.
//  Copyright © 2018年 海南达生实业有限公司. All rights reserved.
//

#import "DS_BaseTabBar.h"
#import "DS_BaseTabBarItem.h"
#import "UIViewExt.h"
#import "YYModel.h"
#import "DS_TabbarInfo.h"
@interface DS_BaseTabBar () {
    DS_BaseTabBarItem * _item_1;
    DS_BaseTabBarItem * _item_2;
    DS_BaseTabBarItem * _item_3;
    DS_BaseTabBarItem * _item_4;
    DS_BaseTabBarItem * _item_5;
    NSArray           * _items; // item组
}
@end

@implementation DS_BaseTabBar

- (instancetype)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        [self layoutView];
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    // 防止原生的按钮挡住当前自定义的按钮
    Class class = NSClassFromString(@"UITabBarButton");
    for (UIView *btn in self.subviews) {
        if ([btn isKindOfClass:class]) {
            btn.hidden = YES;
        }
    }
}

#pragma mark - 初始化
- (void)layoutView {
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"DS_TabBarItemInfo" ofType:@"plist"];
    NSMutableArray *tabBarAry = [[NSMutableArray alloc] initWithContentsOfFile:plistPath];
    
    /* 添加tabbar item */
    _item_1 = [[DS_BaseTabBarItem alloc] initWithTabbarInfo:tabBarAry[0]];
    _item_1.isSelected = YES;
    _item_1.frame = CGRectMake(0, 0, Screen_WIDTH / 5, TABBAR_HEIGHT);
    [self addSubview:_item_1];
    
    _item_2 = [[DS_BaseTabBarItem alloc] initWithTabbarInfo:tabBarAry[1]];
    _item_2.frame = CGRectMake(_item_1.right, 0, Screen_WIDTH / 5, TABBAR_HEIGHT);
    [self addSubview:_item_2];
    
    _item_3 = [[DS_BaseTabBarItem alloc] initWithTabbarInfo:tabBarAry[2]];
    _item_3.frame = CGRectMake(_item_2.right, 0, Screen_WIDTH / 5, TABBAR_HEIGHT);
    [self addSubview:_item_3];
    
    _item_4 = [[DS_BaseTabBarItem alloc] initWithTabbarInfo:tabBarAry[3]];
    _item_4.frame = CGRectMake(_item_3.right, 0, Screen_WIDTH / 5, TABBAR_HEIGHT);
    [self addSubview:_item_4];
    
    _item_5 = [[DS_BaseTabBarItem alloc] initWithTabbarInfo:tabBarAry[4]];
    _item_5.frame = CGRectMake(_item_4.right, 0, Screen_WIDTH / 5, TABBAR_HEIGHT);
    [self addSubview:_item_5];
    
    _items = @[_item_1, _item_2, _item_3, _item_4, _item_5];
    
    /* 增加交互 */
    for (int i = 0; i < tabBarAry.count; i++) {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i * Screen_WIDTH / tabBarAry.count, 0, Screen_WIDTH / tabBarAry.count, TABBAR_HEIGHT);
        [btn addTarget:self action:@selector(itemAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        btn.tag = 1000 + i;
    }
}

/* 外部执行调用 */
- (void)selectIndex:(NSInteger)index {
    _item_1.isSelected = NO;
    _item_2.isSelected = NO;
    _item_3.isSelected = NO;
    _item_4.isSelected = NO;
    _item_5.isSelected = NO;
    switch (index + 1) {
        case 1:_item_1.isSelected = YES;break;
        case 2:_item_2.isSelected = YES;break;
        case 3:_item_3.isSelected = YES;break;
        case 4:_item_4.isSelected = YES;break;
        case 5:_item_5.isSelected = YES;break;
        default:
            break;
    }
    if(self.selectIndexBlock){
        self.selectIndexBlock(index);
    }
}

#pragma mark - 按钮事件
/**
 item点击事件
 @param sender 按钮
 */
- (void)itemAction:(UIButton *)sender {
    // 改变tabbar的状态
    for (int i = 0; i < _items.count; i++) {
        DS_BaseTabBarItem * item = (DS_BaseTabBarItem *)_items[i];
        if (i == sender.tag - 1000) {
            item.isSelected = YES;
        } else {
            item.isSelected = NO;
        }
    }
    
    // 事件回调
    if (self.selectIndexBlock && [self respondsToSelector:@selector(selectIndexBlock)]) {
        self.selectIndexBlock(sender.tag - 1000);
    }
}

@end
