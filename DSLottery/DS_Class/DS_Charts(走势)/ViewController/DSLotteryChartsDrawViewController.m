//
//  DSLotteryChartsDrawViewController.m
//  ALLTIMELOTTERY
//
//  Created by wangzhijie on 2018/5/25.
//  Copyright © 2018年 科技有限公司. All rights reserved.
//

#import "DSLotteryChartsDrawViewController.h"
#import "DSChartsView.h"
#import "DSChartModal.h"
#import "DSDrawingHezhiView.h" // 和值
#import "DSDrawingHeweiView.h" // 和尾
#import "DSDrawingDaxiaoView.h" // 大小
#import "DSDrawingJiouView.h" // 奇偶
#import "DSLotteryChartsDrawIssueClickVIew.h"
@interface DSLotteryChartsDrawViewController ()
// 合并  号码、定位、 跨度、除三余、
@property (nonatomic, strong) DSChartsView * chartsView;

// 和值
@property (nonatomic, strong) DSDrawingHezhiView * hezhiView;
// 和尾
@property (nonatomic, strong) DSDrawingHeweiView * heweiView;
// 大小
@property (nonatomic, strong) DSDrawingDaxiaoView *  daxiaoView;
// 奇偶
@property (nonatomic, strong) DSDrawingJiouView *  jiouView;

@property (nonatomic,strong) DSLotteryChartsDrawIssueClickVIew * issueView;

@end

@implementation DSLotteryChartsDrawViewController

- (instancetype)init {
    if ([super init]) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self requstDetailWithPageSize:30];
    [self layoutView];
}

#pragma mark - 数据请求
/**
 请求走势
 @param pageSize 期数
 */
- (void)requstDetailWithPageSize:(NSInteger)pageSize {
    
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    [dic setValue:@"1" forKey:@"pageIndex"];
    [dic setValue:self.playGroupId forKey:@"playGroupId"];
    [dic setValue:[NSString stringWithFormat:@"%ld",(long)pageSize] forKey:@"pageSize"];
    
    [self showhud];
    weakifySelf
    [DS_Networking postConectWithS:GETHISTORY Parameter:dic Succeed:^(id result) {
        strongifySelf
        [self hidehud];
        if (Request_Success(result)) {
            DSChartModal * modal = [DSChartModal yy_modelWithJSON:result];
            if (self.isMeCharts) { // 和值 // 和尾  // 大小   // 奇偶
                [self p_crateChartsViewWithModal:modal];
            }else{
                // 合并走势图
                self.chartsView.chartModal = modal;
            }
        }
    } Failure:^(NSError *failure) {
        Request_Error_tip
    }];
}
#pragma mark - 界面
/** 布局 */
- (void)layoutView {
    if (self.chartType == DSChartsBasicType) {
        self.title = @"号码走势";
    }else if (self.chartType == DSChartsLocationType){
        self.title = @"定位走势";
        
    }else if (self.chartType == DSChartsSpadType){
        self.title = @"跨度走势";
    }else if (self.chartType == DSChartsThreeType){
        self.title = @"除三余数走势";
    }else if (self.chartType == DSChartsHezhiType){
        self.title = @"和值走势";
        
    }else if (self.chartType == DSChartsJiouType){
        self.title = @"奇偶走势";
        
    }else if (self.chartType == DSChartsDaxiaoType){
        self.title = @"大小走势";
        
    }else if (self.chartType == DSChartsHeweiType){
        self.title = @"和尾走势";
    }
    
    [self navLeftItem:[DS_FunctionTool leftNavBackTarget:self Item:@selector(leftButtonAction:)]];
    
    if (!self.isMeCharts) {
        [self.view addSubview:self.chartsView];
        [self.chartsView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(NAVIGATIONBAR_HEIGHT);
            make.left.right.mas_equalTo(0);
            make.bottom.mas_equalTo(-(IOS_SiZESCALE(40)));
        }];
    }
    
    [self.view addSubview:self.issueView];
    [_issueView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(IOS_SiZESCALE(40));
    }];
}


-(void)p_crateChartsViewWithModal:(DSChartModal *)modal{

    CGRect  frame = CGRectMake(0, NAVIGATIONBAR_HEIGHT, Screen_WIDTH, Screen_HEIGHT - NAVIGATIONBAR_HEIGHT - 40 * IOS8_WINDTH - (IS_IPHONEX?34:0));
    if (self.chartType == DSChartsHezhiType){
          // 和值
        self.hezhiView = [[DSDrawingHezhiView alloc] initWithFrame:frame model:modal lotteryID:self.playGroupId];
        [self.view addSubview:self.hezhiView];
        
    }else if (self.chartType == DSChartsJiouType){
         // 奇偶
        self.jiouView = [[DSDrawingJiouView alloc] initWithFrame:frame model:modal lotteryID:self.playGroupId];
        [self.view addSubview:self.jiouView];
        
    }else if (self.chartType == DSChartsDaxiaoType){
         // 大小
        self.daxiaoView = [[DSDrawingDaxiaoView alloc] initWithFrame:frame model:modal lotteryID:self.playGroupId];
        [self.view addSubview:self.daxiaoView];
    }else if (self.chartType == DSChartsHeweiType){
         // 和尾
        self.heweiView = [[DSDrawingHeweiView alloc] initWithFrame:frame model:modal lotteryID:self.playGroupId];
        [self.view addSubview:self.heweiView];
    }
    
     [self.view bringSubviewToFront:self.issueView];
}

#pragma mark - 按钮事件
- (void)leftButtonAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 懒加载
/**
 走势图合并视图
 @return 走势图
 */
-(DSChartsView *)chartsView{
    if (!_chartsView) {
        _chartsView = [[DSChartsView alloc] initWithChartsType:self.chartType];
    }
    return _chartsView;
}

- (DSLotteryChartsDrawIssueClickVIew *)issueView {
    if (!_issueView) {
        _issueView = [DSLotteryChartsDrawIssueClickVIew lotteryChartsDrawIssueClickView];
        
        weakifySelf
        self.issueView.issueClickBlock = ^(NSInteger btnTag) {
            strongifySelf
            if (self.chartType == DSChartsHezhiType){
                [self.hezhiView removeFromSuperview];
                self.hezhiView = nil;
                // 和值
            }else if (self.chartType == DSChartsJiouType){
                // 奇偶
                [self.jiouView removeFromSuperview];
                self.jiouView = nil;
            }else if (self.chartType == DSChartsDaxiaoType){
                // 大小
                [self.daxiaoView  removeFromSuperview];
                self.daxiaoView = nil;
            }else if (weakSelf.chartType == DSChartsHeweiType){
                // 和尾
                [self.heweiView removeFromSuperview];
                self.heweiView = nil;
            }else{ // 合并  号码、定位、 跨度、除三余、
                [self.chartsView removeFromSuperview];
                self.chartsView  = nil;
                [self.view addSubview:self.chartsView];
                [self.chartsView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(NAVIGATIONBAR_HEIGHT);
                    make.left.right.mas_equalTo(0);
                    make.bottom.mas_equalTo(-(IOS_SiZESCALE(40)));
                }];
            }
            
            if (btnTag == 1) {
                [self requstDetailWithPageSize:30];
            }else if (btnTag == 2){
                [self requstDetailWithPageSize:50];
                
            }else if (btnTag == 3){
                [self requstDetailWithPageSize:80];
            }
        };
    }
    return _issueView;
}

@end







































