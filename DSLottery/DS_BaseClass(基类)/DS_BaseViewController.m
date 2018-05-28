//
//  DS_BaseViewController.m
//  DSLottery
//
//  Created by 黄玉洲 on 2018/4/25.
//  Copyright © 2018年 海南达生实业有限公司. All rights reserved.
//

#import "DS_BaseViewController.h"
#import "UIView+Toast.h"
@interface DS_BaseViewController ()
{
    NSString * _title;
    // 是否透明导航栏
    BOOL _transparent;
}

@property (nonatomic, strong) UIImageView * navigationBar;

/* 标题名称 */
@property (strong, nonatomic) UILabel * titleName;

/** 标题图片（不能与titleName共用） */
@property (strong, nonatomic) UIImageView * titleImageView;

@end

@implementation DS_BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
        // 禁用掉自动设置的内边距，自行控制controller上index为0的控件以及scrollview控件的位置
        self.automaticallyAdjustsScrollViewInsets = NO;
        // 视图延伸不考虑透明的Bars(这里包含导航栏和状态栏)
        // 意思就是延伸到边界
        self.extendedLayoutIncludesOpaqueBars = YES;
    }
    
    [self initBaseUI];
}

#pragma mark - 初始化
/* 初始化 */
- (void)initBaseUI {
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 在主线程异步加载，使下面的方法最后执行，防止其他的控件挡住了导航栏
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.view addSubview:self.navigationBar];
        [self.navigationBar addSubview:self.titleName];
        [self.navigationBar addSubview:self.titleImageView];
    });
}

#pragma mark - setter/getter
- (void)setTitle:(NSString *)title {
    if (title) {
        _title = title;
        _titleName.text = title;
        _titleName.hidden = NO;
        _titleImageView.hidden = YES;
    }
}

- (NSString *)title {
    return _title;
}

- (void)setNavigationBarImage:(UIImage *)navigationBarImage {
    if (navigationBarImage) {
        _navigationBarImage = navigationBarImage;
        _titleImageView.hidden = NO;
        _titleName.hidden = YES;
        _titleImageView.image = navigationBarImage;
        
        _titleImageView.width = _navigationBarImage.size.width;
        _titleImageView.height = _navigationBarImage.size.height;
        _titleImageView.centerX = _navigationBar.width / 2;
        _titleImageView.centerY = _navigationBar.height / 2 + 10;
    }
}

#pragma mark - public
/**
 导航栏左侧视图
 @param leftItem 左侧元素
 */
- (void)navLeftItem:(UIView *)leftItem {
    [self.navigationBar addSubview:leftItem];
    leftItem.width = leftItem.width > Screen_WIDTH / 3 - 20? Screen_WIDTH / 3 - 20:leftItem.width;
    leftItem.height = leftItem.height > 30 ? 30 : leftItem.height;
    
    leftItem.frame = CGRectMake(15, (NAVIGATIONBAR_HEIGHT - STATUSBAR_HEIGHT -leftItem.height)/2 + STATUSBAR_HEIGHT , leftItem.width, leftItem.height);
}

/**
 导航栏右侧视图
 @param rightItem 右侧元素
 */
- (void)navRightItem:(UIView *)rightItem {
    [self.navigationBar addSubview:rightItem];
    rightItem.width = rightItem.width > Screen_WIDTH / 3 - 20? Screen_WIDTH / 3 - 20 : rightItem.width;
    rightItem.height = rightItem.height > 30 ? 30 : rightItem.height;
    rightItem.frame = CGRectMake(self.view.width - rightItem.width - 15, (NAVIGATIONBAR_HEIGHT - STATUSBAR_HEIGHT -rightItem.height)/2+ STATUSBAR_HEIGHT , rightItem.width, rightItem.height);
}

/**
 展示tost
 @param tostStr      tost内容
 @param timeInterval 保留时间
 */
-(void)showMakeTostWithText:(NSString *)tostStr
            andTimeInterval:(NSTimeInterval)timeInterval {
    CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
    style.backgroundColor = [UIColor colorWithRed:0.35 green:0.35 blue:0.35 alpha:1.00];
    [self.view makeToast:tostStr
                duration:timeInterval
                position:CSToastPositionCenter
                   style:style];
    [CSToastManager setSharedStyle:style];
    [CSToastManager setTapToDismissEnabled:YES];
    [CSToastManager setQueueEnabled:YES];
}

/**
 让导航栏透明
 */
- (void)transparentNavigationBar {
    _transparent = YES;
    
    _navigationBar.backgroundColor = [UIColor clearColor];
}

#pragma mark - 手势
/**
 标题点击手势
 @param tapGesture 手势对象
 */
- (void)titleTapAction:(UITapGestureRecognizer *)tapGesture {
    
}

#pragma mark - 懒加载
/* 导航栏 */
- (UIImageView *)navigationBar {
    if (!_navigationBar) {
        _navigationBar = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, Screen_WIDTH, NAVIGATIONBAR_HEIGHT)];
        _navigationBar.userInteractionEnabled = YES;
        if (_transparent != YES) {
            _navigationBar.image = DS_UIImageName(@"navigationBar");
        }
    }
    return _navigationBar;
}

/* 标题标签 */
- (UILabel *)titleName {
    if (!_titleName) {
        _titleName = [[UILabel alloc] init];
        _titleName.frame = CGRectMake(_navigationBar.width  /3, STATUSBAR_HEIGHT, _navigationBar.width / 3, _navigationBar.height - STATUSBAR_HEIGHT);
        _titleName.textColor = [UIColor whiteColor];
        _titleName.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
        _titleName.textAlignment = NSTextAlignmentCenter;
        _titleName.text = _title;
    }
    return _titleName;
}

- (UIImageView *)titleImageView {
    if (!_titleImageView) {
        _titleImageView = [[UIImageView alloc] init];
        _titleImageView.userInteractionEnabled = YES;
        if (_navigationBarImage) {
            _titleImageView.image = _navigationBarImage;
            _titleImageView.hidden = NO;
            _titleName.hidden = YES;
        } else {
            _titleImageView.hidden = YES;
            _titleName.hidden = NO;
        }
        _titleImageView.width = _navigationBarImage.size.width;
        _titleImageView.height = _navigationBarImage.size.height;
        _titleImageView.centerX = _navigationBar.width / 2;
        _titleImageView.centerY = _navigationBar.height / 2 + 10;
        
        UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleTapAction:)];
        [_titleImageView addGestureRecognizer:tapGesture];
    }
    return _titleImageView;
}

@end
