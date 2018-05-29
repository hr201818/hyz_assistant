//
//  DSChartsView.m
//  ALLTIMELOTTERY
//
//  Created by wangzhijie on 2018/5/21.
//  Copyright © 2018年 科技有限公司. All rights reserved.
//

#import "DSChartsView.h"
#define TableView_cellHeight  ([[UIScreen mainScreen] bounds].size.width/14)
#define syxwWidth ([[UIScreen mainScreen] bounds].size.width/14)
#define DS_SCREEN_WIDTH                                                [[UIScreen mainScreen] bounds].size.width
#import "DSScrollMenu.h"
#import "DSChartsLeftCellView.h"
#import "DSChartsRightCellView.h"
#import "DSChartsLeftCellHeaderView.h"
#import "DSChartsRightCellHeaderView.h"
#import "DSChartModal.h"
#import "DSChartsResultsTool.h"
//#import "nper.h"

// 走势图 view
@interface DSChartsView()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

@property(nonatomic, strong) UITableView * tableView;
@property(nonatomic, strong) UITableView * rightTableView;
@property(nonatomic, assign) DSChartsType chartType; // 走势图种类
// 号码走势所需类
@property(nonatomic, assign) NSInteger  digits; // 位数
@property(nonatomic, assign) NSInteger  pageSize;// 期数
@property(nonatomic, assign) NSInteger clickDigital;// 点击 30 、 50 、80期
@property (nonatomic,strong) UIScrollView *buttomScrollView;

@property(nonatomic, strong) NSArray * openCodeArr;//
@property(nonatomic, strong) DSScrollMenu * scrollMenuView;

@property(nonatomic, strong) NSMutableArray * issueArr;// 期号
@property(nonatomic, strong) NSMutableArray * lotteryNumberArr;// 结果
@property(nonatomic, strong) NSMutableArray * contentArr; //号码表

// 当开奖结果很多时显示样式和定位走势 类似(需下面数组)
@property(nonatomic, strong) NSMutableArray * resultsArr; //开奖结果
@property(nonatomic, strong) NSMutableArray * numberArr; // 总次数
@property(nonatomic, strong) NSMutableArray * valuesArr; // 平均遗漏值
@property(nonatomic, strong) NSMutableArray * maxValuesArr; // 最大值遗漏
@property(nonatomic, strong) NSMutableArray * evenValueArr; // 连出值

@property(nonatomic, strong) NSArray * spanValues; // 跨度值
@property(nonatomic, assign) BOOL isClick; // 控制往上滚动时 点击位数 发生偏移


@property(nonatomic, strong) DSChartsLeftCellView * chartsLeftCellView;
@property(nonatomic, strong) DSChartsRightCellView * chartsRightCellView;



/**
  left  right  header view
 */
//@property(nonatomic, strong) DSChartsLeftCellHeaderView *  leftCellHeaderView;
//@property(nonatomic, strong) DSChartsRightCellHeaderView *  rightCellHeaderView;

@end
@implementation DSChartsView
#pragma mark: 懒加载
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView =[[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = self.backgroundColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.bounces = NO;
        _tableView.showsVerticalScrollIndicator = NO;
    }
    return _tableView;
}
- (UITableView *)rightTableView{
    if (!_rightTableView) {
        _rightTableView =[[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _rightTableView.backgroundColor = self.backgroundColor;
        _rightTableView.delegate = self;
        _rightTableView.dataSource = self;
        _rightTableView.tableFooterView = [UIView new];
        _rightTableView.showsVerticalScrollIndicator = NO;
    }
    return _rightTableView;
}
/**
 城市标题栏
 */
- (DSScrollMenu *)scrollMenuView{
    if (!_scrollMenuView) {
        _scrollMenuView = [[DSScrollMenu alloc] initWithFrame:CGRectZero];
        __weak typeof(self) weakSelf = self;
        _scrollMenuView.selectedItemBlock = ^(NSInteger item) {
            weakSelf.digits = item;
            weakSelf.chartModal = weakSelf.chartModal;
            weakSelf.isClick = YES;
        };
    }
    return _scrollMenuView;
}

#pragma mark: 自定义初始化方法
-(instancetype)initWithChartsType:(DSChartsType)type{
    if (self = [super init]) {
        self.chartType = type;
         [self p_setupSubView];
    }
    return self;
}
- (void)setClickDigital:(NSInteger)clickDigital{
    _clickDigital = clickDigital;
    self.pageSize = self.clickDigital == 0 ? 30:self.clickDigital == 1 ? 50:80;
}
/**
 懒加载 防止 点击位数的时候 内存一直在暴涨
 */
- (DSChartsLeftCellView *)chartsLeftCellView{
    if (!_chartsLeftCellView) {
        _chartsLeftCellView = [[DSChartsLeftCellView alloc] initWithFrame:CGRectMake(0, 0, DS_SCREEN_WIDTH,  0) andIssueArr:_issueArr andListArr:_contentArr andResutArr:_resultsArr andLotteryNumberArr:_lotteryNumberArr andSpanValue:_spanValues andChartType:self.chartType];
    }
    return _chartsLeftCellView;
}
/**
 懒加载 防止 点击位数的时候 内存一直在暴涨
 */
- (DSChartsRightCellView *)chartsRightCellView{
    if (!_chartsRightCellView) {
        CGFloat rightTableWidth = 0.0f;
        if (self.chartType == DSChartsBasicType) {
            if (self.openCodeArr.count > 7) {
                rightTableWidth =  81 * TableView_cellHeight + 1;
            }else{
                if (self.openCodeArr.count > 5) {
                    rightTableWidth =  34 * TableView_cellHeight + 1;
                }else{
                    rightTableWidth = self.openCodeArr.count * 10 * TableView_cellHeight + 1;
                }
            }
        }else if (self.chartType == DSChartsLocationType){
            if (self.openCodeArr.count > 7) {
                rightTableWidth = 81 * TableView_cellHeight + 1;
            }else{
                if (self.openCodeArr.count > 5) {
                    rightTableWidth = 34 * TableView_cellHeight + 1;
                    
                }else{
                    rightTableWidth = 12 * TableView_cellHeight + 1;
                }
            }
        }else if (self.chartType == DSChartsSpadType){
            
            if (self.openCodeArr.count > 7) {
                rightTableWidth = 81 * TableView_cellHeight + 1;
            }else{
                if (self.openCodeArr.count > 5) {
                    rightTableWidth = 34 * TableView_cellHeight + 1;
                }else{
                    rightTableWidth = 10 * TableView_cellHeight + 1;
                }
            }
        }else if (self.chartType == DSChartsThreeType){
            rightTableWidth = self.openCodeArr.count * 3 * TableView_cellHeight + 1;
        }
        
        _chartsRightCellView = [[DSChartsRightCellView alloc] initWithFrame:CGRectMake(0, 0, rightTableWidth,  0) andIssueArr:_issueArr andListArr:_contentArr andLotteryNumberArr:_lotteryNumberArr andResultArr:_resultsArr andNumberArr:_numberArr andValuesArr:_valuesArr andMaxValuesArr:_maxValuesArr andEvenValuesArr:_evenValueArr  andSpanValue: _spanValues andNper:self.pageSize andChartType:self.chartType];
    }
    return _chartsRightCellView;
}
-(void)p_setupSubView{
    
    self.digits = 0;
    self.clickDigital  = 0;
    
    if (self.chartType == DSChartsBasicType) { // 号码走势
        [self addSubview:self.scrollMenuView];
        [self.scrollMenuView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.offset(0);
            make.height.offset(0);
        }];
        [self addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.offset(0);
        }];
        self.buttomScrollView = [[UIScrollView alloc] init];
        self.buttomScrollView.contentSize = CGSizeMake(self.rightTableView.bounds.size.width, 0);
        self.buttomScrollView.backgroundColor = self.backgroundColor;
        self.buttomScrollView.bounces = NO;
        self.buttomScrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:self.buttomScrollView];
        [self.buttomScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.tableView.mas_top);
            make.right.and.bottom.equalTo(self);
            make.left.equalTo(self.tableView.mas_right);
        }];
        [self.buttomScrollView addSubview:self.rightTableView];
        [self.rightTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.buttomScrollView);
            make.left.right.offset(0);
            make.height.equalTo(self.tableView);
        }];
    }else if (self.chartType == DSChartsLocationType){ // 定位走势
        
        [self addSubview:self.scrollMenuView];
        [self.scrollMenuView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.offset(0);
            make.height.offset(40);
        }];
        [self addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(40);
            make.bottom.left.offset(0);
            make.width.equalTo(@(2 + 3 * TableView_cellHeight + 3));
        }];
        self.buttomScrollView = [[UIScrollView alloc] init];
        self.buttomScrollView.contentSize = CGSizeMake(self.rightTableView.bounds.size.width, 0);
        self.buttomScrollView.backgroundColor = self.backgroundColor;
        self.buttomScrollView.bounces = NO;
        self.buttomScrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:self.buttomScrollView];
        [self.buttomScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.tableView.mas_top);
            make.right.and.bottom.equalTo(self);
            make.left.equalTo(self.tableView.mas_right);
        }];
        [self.buttomScrollView addSubview:self.rightTableView];
        [self.rightTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.buttomScrollView);
            make.left.right.offset(0);
            make.height.equalTo(self.tableView);
        }];
    }else if (self.chartType == DSChartsSpadType || self.chartType == DSChartsThreeType){ //除三余
        [self addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.left.offset(0);
        }];
        
        self.buttomScrollView = [[UIScrollView alloc] init];
        self.buttomScrollView.contentSize = CGSizeMake(self.rightTableView.bounds.size.width, 0);
        self.buttomScrollView.backgroundColor = self.backgroundColor;
        self.buttomScrollView.bounces = NO;
        self.buttomScrollView.showsHorizontalScrollIndicator = NO;
        
        [self addSubview:self.buttomScrollView];
        [self.buttomScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.and.top.and.bottom.equalTo(self);
            make.left.equalTo(self.tableView.mas_right);
        }];
        
        [self.buttomScrollView addSubview:self.rightTableView];
        [self.rightTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(0);
            make.height.mas_equalTo(self.buttomScrollView);
        }];
    }
}
#pragma mark: tableView dalegate and dataSource Method
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellName = @"cellName";
    UITableViewCell * cell  = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (tableView == self.tableView) { // left
        if (self.chartModal) {
             [cell.contentView addSubview:self.chartsLeftCellView];
        }

    }else{ // right
        if (self.chartModal) {
              [cell.contentView addSubview:self.chartsRightCellView];
        }
    } // end
    return cell;
}
#pragma mark: tableView headerView
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
  
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    view.backgroundColor = [UIColor whiteColor];
    if (tableView == self.tableView) { // left header view
        CGFloat leftVcHeight = 0.0f;
        if (self.chartType == DSChartsBasicType) {
            leftVcHeight = (self.openCodeArr.count > 5) ?syxwWidth:syxwWidth*2;
        }else if (self.chartType == DSChartsLocationType || self.chartType == DSChartsSpadType){
            leftVcHeight = syxwWidth;
        }else if (self.chartType == DSChartsThreeType){

             leftVcHeight = syxwWidth*2;
        }
        DSChartsLeftCellHeaderView * leftVc = [[DSChartsLeftCellHeaderView alloc] initWithFrame:CGRectMake(0, 0,  self.tableView.bounds.size.width, leftVcHeight)  andOpenCodeArrCount:self.openCodeArr.count andChartType:self.chartType];
        [view addSubview:leftVc];
    }else{ // right header view
        CGFloat rightVcHeight = 0.0f;
        if (self.chartType == DSChartsBasicType) {
            rightVcHeight = (self.openCodeArr.count > 5) ?syxwWidth:syxwWidth*2;
        }else if (self.chartType == DSChartsLocationType || self.chartType == DSChartsSpadType){
            rightVcHeight = syxwWidth;
        }else if (self.chartType == DSChartsThreeType){

            rightVcHeight = syxwWidth*2;
        }
        DSChartsRightCellHeaderView *rightVc = [[DSChartsRightCellHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.rightTableView.bounds.size.width,   rightVcHeight) andList:_contentArr andChartsType:self.chartType andOpenCodeArrCount:self.openCodeArr.count];
        [view addSubview:rightVc];
    }
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.chartType == DSChartsBasicType) {
        if (self.openCodeArr.count > 5) {
            return syxwWidth;
        }else{
            return syxwWidth * 2;
        }
    }else if (self.chartType == DSChartsLocationType || self.chartType == DSChartsSpadType){
        return syxwWidth;
    }else if (self.chartType == DSChartsThreeType){
          return syxwWidth * 2;
    }
    return 0.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  self.issueArr.count * TableView_cellHeight;
}

/**
 @param chartModal 数据源模型 设置值所用
 */
- (void)setChartModal:(DSChartModal *)chartModal{
      _chartModal = chartModal;
    
    // 防止点击位数的时候 内存暴涨
    if (self.chartsLeftCellView) {
        [self.chartsLeftCellView removeFromSuperview];
        self.chartsLeftCellView = nil;
    }
    if (self.chartsRightCellView) {
        [self.chartsRightCellView removeFromSuperview];
        self.chartsRightCellView = nil;
    }
    
    if (self.chartType == DSChartsBasicType) {
        [self.contentArr removeAllObjects];
        [self.issueArr removeAllObjects];
        [self.lotteryNumberArr removeAllObjects];
        [self.resultsArr removeAllObjects];
        [self.numberArr removeAllObjects];
        [self.valuesArr removeAllObjects];
        [self.maxValuesArr removeAllObjects];
        [self.evenValueArr removeAllObjects];
        
        if (chartModal) { // modal star
            __weak typeof(self) weakSelf = self;
      [DSChartsResultsTool handleResultWithModal:chartModal andDigits:self.digits
        andNper:self.pageSize returenValue:^(NSArray *listArr, NSArray *issueArr, NSArray *resultsArr, NSArray *numberArr, NSArray *valuesArr, NSArray *maxValuesArr, NSArray *evenValueArr, NSArray *endArr) {
                weakSelf.contentArr = [NSMutableArray arrayWithArray:listArr];
                weakSelf.issueArr = [NSMutableArray arrayWithArray:issueArr];
                weakSelf.lotteryNumberArr = [NSMutableArray arrayWithArray:endArr];
                weakSelf.resultsArr = [NSMutableArray arrayWithArray:resultsArr];
                weakSelf.numberArr = [NSMutableArray arrayWithArray:numberArr];
                weakSelf.valuesArr = [NSMutableArray arrayWithArray:valuesArr];
                weakSelf.maxValuesArr = [NSMutableArray arrayWithArray:maxValuesArr];
                weakSelf.evenValueArr = [NSMutableArray arrayWithArray:evenValueArr];
            }];
        }// modal end
        
        // 更新UI
        CGFloat tableWith = 0.0f;
        if (self.lotteryNumberArr.count > 0) {
            self.openCodeArr = self.lotteryNumberArr[0];
            if (self.openCodeArr.count > 5) {
                tableWith  = 2 +  3 * TableView_cellHeight + 3;
            }else{
                tableWith  = 2 + (self.openCodeArr.count + 2) * TableView_cellHeight + 3;
            }
            
            NSMutableArray *  digitArray;
            if (self.openCodeArr.count > 5) {
                digitArray = [NSMutableArray array];
                for (NSInteger i = 1; i<self.openCodeArr.count+1; i++) {
                    [digitArray addObject:[NSString stringWithFormat:@"第%ld位",(long)i]];
                }
            }else{
                if (self.openCodeArr.count < 5) {
                    digitArray = [NSMutableArray arrayWithArray:@[@"百位",@"十位",@"个位"]];
                }else{
                    digitArray = [NSMutableArray arrayWithArray:@[@"万位",@"千位",@"百位",@"十位",@"个位"]];
                }
            }
            
            if (self.openCodeArr.count > 5) {
                self.scrollMenuView.hidden = NO;
                [self.scrollMenuView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.offset(40);
                }];
                [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.scrollMenuView.mas_bottom);
                    make.width.offset(tableWith);
                }];
            }else{
                self.scrollMenuView.hidden = YES;
                [self.scrollMenuView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.offset(0);
                }];
                [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.offset(0);
                    make.width.offset(tableWith);
                }];
            }
            CGFloat rightTableWidth = 0.0f;
            if (self.openCodeArr.count > 7) {
                rightTableWidth =   81 * TableView_cellHeight + 1;
            }else{
                if (self.openCodeArr.count > 5) {
                    rightTableWidth =  34 * TableView_cellHeight + 1;
                }else{
                    rightTableWidth = self.openCodeArr.count * 10 * TableView_cellHeight + 1;
                }
            }
            [self.rightTableView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.offset(rightTableWidth);
            }];
            self.scrollMenuView.menuTitles = digitArray;
        }
    }else if (self.chartType == DSChartsLocationType){ // 定位走势
        
        [self.issueArr removeAllObjects];
        [self.contentArr removeAllObjects];
        [self.resultsArr removeAllObjects];
        [self.numberArr removeAllObjects];
        [self.valuesArr removeAllObjects];
        [self.maxValuesArr removeAllObjects];
        [self.evenValueArr removeAllObjects];
        [self.lotteryNumberArr removeAllObjects];
        
        if (chartModal) {
            __weak typeof(self) weakSelf = self;
            [DSChartsResultsTool handleLocationResultWithModal:chartModal andType:self.digits  andNper:self.pageSize returenValue:^(NSArray *listArr, NSArray *issueArr, NSArray *resultsArr, NSArray *numberArr, NSArray *valuesArr, NSArray *maxValuesArr, NSArray *evenValueArr,NSArray * lotteryNumberArr) {
                weakSelf.issueArr =  [NSMutableArray arrayWithArray:issueArr];
                weakSelf.contentArr = [NSMutableArray arrayWithArray:listArr];
                weakSelf.resultsArr =[NSMutableArray arrayWithArray:resultsArr];
                weakSelf.numberArr = [NSMutableArray arrayWithArray:numberArr];
                weakSelf.valuesArr = [NSMutableArray arrayWithArray:valuesArr];
                weakSelf.maxValuesArr = [NSMutableArray arrayWithArray:maxValuesArr];
                weakSelf.evenValueArr = [NSMutableArray arrayWithArray:evenValueArr];
                weakSelf.lotteryNumberArr =  [NSMutableArray arrayWithArray:lotteryNumberArr];
            }];
        }
        
        if (self.lotteryNumberArr.count >0) {
            self.openCodeArr = self.lotteryNumberArr[0];
            CGFloat rightTableWidth = 0.0f;
            if (self.openCodeArr.count > 7) {
                rightTableWidth = 81 * TableView_cellHeight + 1;
            }else{
                if (self.openCodeArr.count > 5) {
                    rightTableWidth = 34 * TableView_cellHeight + 1;
                }else{
                    rightTableWidth = 12 * TableView_cellHeight + 1;
                }
            }
            [self.rightTableView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.offset(rightTableWidth);
            }];
        }
        NSMutableArray *  digitArray;
        if (self.openCodeArr.count > 5) {
            digitArray = [NSMutableArray array];
            for (NSInteger i = 1; i<self.openCodeArr.count+1; i++) {
                [digitArray addObject:[NSString stringWithFormat:@"第%ld位",(long)i]];
            }
        }else{
            if (self.openCodeArr.count < 5) {
                digitArray = [NSMutableArray arrayWithArray:@[@"百位",@"十位",@"个位"]];
            }else{
                digitArray = [NSMutableArray arrayWithArray:@[@"万位",@"千位",@"百位",@"十位",@"个位"]];
            }
        }
        self.scrollMenuView.menuTitles = digitArray;
    }else if (self.chartType == DSChartsSpadType){ // 跨度走势
        if (chartModal) {
            __weak typeof(self) weakSelf = self;
            [DSChartsResultsTool handSpanMovementsResultWithModal:chartModal andType:0 andNper:self.pageSize returenValue:^(NSArray *listArr, NSArray *issueArr, NSArray *spanValues, NSArray *numberArr, NSArray *valuesArr, NSArray *maxValuesArr, NSArray *evenValueArr, NSArray *codeArr) {
                weakSelf.contentArr = [listArr copy];
                weakSelf.issueArr = [issueArr copy];
                weakSelf.spanValues = [spanValues copy];
                weakSelf.numberArr = [numberArr copy];
                weakSelf.valuesArr = [valuesArr copy];
                weakSelf.maxValuesArr = [maxValuesArr copy];
                weakSelf.evenValueArr = [evenValueArr copy];
                weakSelf.lotteryNumberArr = [codeArr copy];
            }];
        }
        // 更新UI
        CGFloat tableWith = 0.0f;
        if (self.lotteryNumberArr.count > 0) {
            self.openCodeArr = self.lotteryNumberArr[0];
            if (self.openCodeArr.count > 7) {
                tableWith  =  2 + 2 * TableView_cellHeight + 3;
            }else{
                tableWith  = 2 + (self.openCodeArr.count + 2) * TableView_cellHeight + 3;
            }
            [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.offset(tableWith);
            }];
            CGFloat rightTableWidth = 0.0f;
            if (self.openCodeArr.count > 7) {
                rightTableWidth = 81 * TableView_cellHeight + 1;
            }else{
                if (self.openCodeArr.count > 5) {
                    rightTableWidth = 34 * TableView_cellHeight + 1;
                    
                }else{
                    rightTableWidth = 10 * TableView_cellHeight + 1;
                }
            }
            [self.rightTableView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.offset(rightTableWidth);
            }];
        }
    }else if (self.chartType == DSChartsThreeType){ //除三余
        
        if (chartModal) {
            __weak typeof(self) weakSelf = self;
            [DSChartsResultsTool handThreeMovementsResultWithModal:chartModal andType:self.pageSize andNper:0 returenValue:^(NSArray *listArr, NSArray *issueArr, NSArray *endArr) {
                weakSelf.contentArr = [listArr copy];
                weakSelf.issueArr = [issueArr copy];
                weakSelf.lotteryNumberArr = [endArr copy];
            }];
            
            // 更新UI
            CGFloat tableWith = 0.0f;
            if (self.lotteryNumberArr.count > 0) {
                self.openCodeArr = self.lotteryNumberArr[0];
                if (self.openCodeArr.count > 7) {
                    tableWith  = 2 +  2 * TableView_cellHeight + 3;
                }else{
                    tableWith  = 2 + (self.openCodeArr.count + 2) * TableView_cellHeight + 3;
                }
                [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.width.offset(tableWith);
                }];
                
                CGFloat rightTableWidth = 0.0f;
                rightTableWidth = self.openCodeArr.count * 3 * TableView_cellHeight + 1;
                [self.rightTableView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.width.offset(rightTableWidth);
                }];
            }
        } // modal end
    }
    
    [self.tableView reloadData];
    [self.rightTableView reloadData];
}

#pragma mark - 两个tableView联动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.chartType == DSChartsSpadType || self.chartType == DSChartsThreeType) {
        if (scrollView == self.tableView) {
            [self tableView:self.rightTableView scrollFollowTheOther:self.tableView];
        }else{
            [self tableView:self.tableView scrollFollowTheOther:self.rightTableView];
        }
    }else{
        if (self.isClick) {
            
        }else{
            if (scrollView == self.tableView) {
                [self tableView:self.rightTableView scrollFollowTheOther:self.tableView];
            }else{
                [self tableView:self.tableView scrollFollowTheOther:self.rightTableView];
            }
        }
    }
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    self.isClick = NO;
}
- (void)tableView:(UITableView *)tableView scrollFollowTheOther:(UITableView *)other{
    CGFloat offsetY= other.contentOffset.y;
    CGPoint offset=tableView.contentOffset;
    offset.y=offsetY;
    tableView.contentOffset=offset;
}
- (void)dealloc{
    NSLog(@"%@",[self class]);
}
@end






