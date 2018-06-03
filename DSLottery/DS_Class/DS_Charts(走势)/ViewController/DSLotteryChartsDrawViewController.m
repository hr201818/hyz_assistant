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

/** view */
#import "DS_HeZhiChartsView.h"  // 和值
#import "DS_HeWeiChartsView.h"  // 和尾
#import "DS_DaXiaoChartsView.h" // 大小
#import "DS_JiOuChartsView.h"   // 奇偶
#import "DS_HaoMaChartsView.h"  // 号码走势

/** view */
#import "DS_LotteryIssueView.h"


@interface DSLotteryChartsDrawViewController ()
// 合并  号码、定位、 跨度、除三余、
@property (nonatomic, strong) DSChartsView * chartsView;

// 和值
@property (nonatomic, strong) DS_HeZhiChartsView  * hezhiView;

/** 和尾 */
@property (nonatomic, strong) DS_HeWeiChartsView  * heweiView;

/** 大小 */
@property (nonatomic, strong) DS_DaXiaoChartsView *  daxiaoView;

/** 奇偶 */
@property (nonatomic, strong) DS_JiOuChartsView   *  jiouView;

/** 号码 */
@property (nonatomic, strong) DS_HaoMaChartsView  * haomaView;

/** 底部期数选择 */
@property (nonatomic,strong) DS_LotteryIssueView  * issueView;

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
            make.bottom.mas_equalTo(-(IOS8_HEIGHT * DS_LotteryIssueViewHeight));
        }];
    }
    
    [self.view addSubview:self.issueView];
    [_issueView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(IOS8_HEIGHT * DS_LotteryIssueViewHeight);
    }];
}


-(void)p_crateChartsViewWithModal:(id)model{

    CGRect  frame = CGRectMake(0, NAVIGATIONBAR_HEIGHT, Screen_WIDTH, Screen_HEIGHT - NAVIGATIONBAR_HEIGHT - IOS8_HEIGHT * DS_LotteryIssueViewHeight);
    if (self.chartType == DSChartsHezhiType){
          // 和值
        _hezhiView = [[DS_HeZhiChartsView alloc] initWithFrame:frame modelList:model lotteryID:_playGroupId];
        [self.view addSubview:_hezhiView];
        
    }else if (self.chartType == DSChartsJiouType){
         // 奇偶
        _jiouView = [[DS_JiOuChartsView alloc] initWithFrame:frame modelList:model lotteryID:_playGroupId];
        [self.view addSubview:_jiouView];
        
    }else if (self.chartType == DSChartsDaxiaoType){
         // 大小
        _daxiaoView = [[DS_DaXiaoChartsView alloc] initWithFrame:frame modelList:model lotteryID:_playGroupId];
        [self.view addSubview:_daxiaoView];
    }else if (self.chartType == DSChartsHeweiType){
         // 和尾
        _heweiView = [[DS_HeWeiChartsView alloc] initWithFrame:frame modelList:model lotteryID:_playGroupId];
        [self.view addSubview:_heweiView];
    } else if (self.chartType == DSChartsLocationType) {
        _haomaView = [[DS_HaoMaChartsView alloc] initWithFrame:frame modelList:model lotteryID:_playGroupId];
        [self.view addSubview:_haomaView];
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

- (DS_LotteryIssueView *)issueView {
    if (!_issueView) {
        _issueView = [DS_LotteryIssueView new];
        
        weakifySelf
        _issueView.issueBlock = ^(NSInteger tag) {
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
                    make.height.mas_equalTo(Screen_HEIGHT - NAVIGATIONBAR_HEIGHT - -(IOS8_HEIGHT * DS_LotteryIssueViewHeight));
                }];
            }
            
            if (tag == 0) {
                [self requstDetailWithPageSize:30];
            }else if (tag == 1){
                [self requstDetailWithPageSize:50];
                
            }else if (tag == 2){
                [self requstDetailWithPageSize:80];
            }
        };
    }
    return _issueView;
}

@end







































