//
//  DS_BaseTabBarController.m
//  DSLottery
//
//  Created by 黄玉洲 on 2018/4/25.
//  Copyright © 2018年 海南达生实业有限公司. All rights reserved.
//

#import "DS_BaseTabBarController.h"

#import "DS_BaseNavigationController.h"
#import "DS_BaseTabBar.h"

/** 五个基本控制器 */
#import "DS_HomeViewController.h"
#import "DS_ChartsViewController.h"
#import "DS_LotteryNoticeViewController.h"
#import "DS_UserViewController.h"
#import "DS_ShopsViewController.h"

@interface DS_BaseTabBarController ()

@property (strong, nonatomic) DS_BaseTabBar * Dtabbar;

@end

@implementation DS_BaseTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self layoutView];
}

#pragma mark - 初始化
- (void)layoutView {
    _Dtabbar = [[DS_BaseTabBar alloc] init];
    weakifySelf
    _Dtabbar.selectIndexBlock = ^(NSInteger index) {
        strongifySelf
        self.selectedIndex = index;
    };
    [self setValue:_Dtabbar forKeyPath:@"tabBar"];
    
    DS_HomeViewController * vc1 = [[DS_HomeViewController alloc] init];
    DS_BaseNavigationController * nav1 = [[DS_BaseNavigationController alloc] initWithRootViewController:vc1];

    DS_ShopsViewController * vc2 = [[DS_ShopsViewController alloc] init];
    DS_BaseNavigationController * nav2 = [[DS_BaseNavigationController alloc] initWithRootViewController:vc2];

    DS_LotteryNoticeViewController * vc3 = [[DS_LotteryNoticeViewController alloc] init];
    DS_BaseNavigationController * nav3 = [[DS_BaseNavigationController alloc] initWithRootViewController:vc3];
    
    DS_ChartsViewController * vc4 = [[DS_ChartsViewController alloc] init];
    DS_BaseNavigationController * nav4 = [[DS_BaseNavigationController alloc] initWithRootViewController:vc4];

    DS_UserViewController * vc5 = [[DS_UserViewController alloc] init];
    DS_BaseNavigationController * nav5 = [[DS_BaseNavigationController alloc] initWithRootViewController:vc5];

    

    [self setViewControllers: @[nav1, nav2, nav3, nav4, nav5]];
}

/** 选中 */
-(void)selectedIndex:(NSInteger )index {
    [_Dtabbar selectIndex:index];
}

@end
