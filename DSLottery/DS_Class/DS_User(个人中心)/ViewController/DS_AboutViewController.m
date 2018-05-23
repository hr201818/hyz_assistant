//
//  DS_AboutViewController.m
//  DSLottery
//
//  Created by 黄玉洲 on 2018/5/10.
//  Copyright © 2018年 海南达生实业有限公司. All rights reserved.
//

#import "DS_AboutViewController.h"

@interface DS_AboutViewController ()

@end

@implementation DS_AboutViewController


- (instancetype)init {
    if ([super init]) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = DS_STRINGS(@"kAbountUsTitle");
    
    [self navLeftItem:[DS_FunctionTool leftNavBackTarget:self Item:@selector(leftBackAction)]];
    
    UIScrollView * scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, NAVIGATIONBAR_HEIGHT, self.view.width, Screen_HEIGHT - NAVIGATIONBAR_HEIGHT - TABBAR_HEIGHT)];
    [self.view addSubview:scrollView];
    
    UILabel * content = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, self.view.width - 25, 1000)];
    content.text = @"预测大全是一款.....";
    content.textColor = COLOR_Font83;
    content.numberOfLines = 0;
    content.font = [UIFont systemFontOfSize:15];
    [scrollView addSubview:content];
    [content sizeToFit];
    scrollView.contentSize = CGSizeMake(0, content.height + 20);
}

#pragma mark - 点击事件
-(void)leftBackAction {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
