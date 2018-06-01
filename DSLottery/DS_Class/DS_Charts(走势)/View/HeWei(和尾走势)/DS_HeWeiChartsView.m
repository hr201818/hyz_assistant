//
//  DS_HeWeiChartsView.m
//  DS_AA6
//
//  Created by 黄玉洲 on 2018/5/30.
//  Copyright © 2018年 黄玉洲. All rights reserved.
//

#import "DS_HeWeiChartsView.h"
#import "DS_ChartsListModel.h"

/** view */
#import "DS_LotterySumView.h"
#import "DS_LotteryOpenCodeView.h"
#import "DS_LotteryPeriodsView.h"
#import "DS_LotteryHeWeiPathView.h"

#define cellHeightDraw 30

@interface DS_HeWeiChartsView() <UIScrollViewDelegate>

/** 期数 */
@property (nonatomic,strong) UIScrollView         * qishuScrollView;

/** 号码 */
@property (nonatomic,strong) UIScrollView         * codeScrollView;

/** 标签 */
@property (nonatomic, strong)UIScrollView         * tagScrollView;

/** 期数数组 */
@property (strong, nonatomic) NSMutableArray * periodsNumber;

/** 开奖号码数组 */
@property (strong, nonatomic) NSMutableArray * openCode;

/** 和尾 */
@property (strong, nonatomic) NSMutableArray * sumText;

@end

@implementation DS_HeWeiChartsView

- (instancetype)initWithFrame:(CGRect)frame
                    modelList:(DS_ChartsListModel *)modelList
                    lotteryID:(NSString *)lotteryID {
    if ([super initWithFrame:frame]) {
        _sumText = [NSMutableArray arrayWithObjects:@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9", nil];
        _periodsNumber = [NSMutableArray new];
        _openCode = [NSMutableArray new];
        
        // 保存数据
        for (DS_ChartsModel * model in modelList.sscHistoryList) {
            [_periodsNumber addObject:model.number];
            [_openCode addObject:model.openCode];
        }
        
        // 数据逆序排序
        _periodsNumber = (NSMutableArray *)[[_periodsNumber reverseObjectEnumerator] allObjects];
        _openCode = (NSMutableArray *)[[_openCode reverseObjectEnumerator] allObjects];
        
        [self layoutView];
    }
    return self;
}

#pragma mark - 界面
- (void)layoutView {
    //标签
    [self addSubview:self.tagScrollView];
    
    //期数
    [self addSubview:self.qishuScrollView];
    
    //开奖号码
    [self addSubview:self.codeScrollView];
    
    //期号
    DS_LotteryPeriodsView *  issueView = [[DS_LotteryPeriodsView alloc]initWithFrame:CGRectMake(0, 0, 90, (_periodsNumber.count + 4) * cellHeightDraw)];
    issueView.periodsNumber = _periodsNumber;
    [_qishuScrollView addSubview:issueView];
    _qishuScrollView.contentSize = CGSizeMake(0, issueView.height);
    
    //期号固定按钮
    UILabel * qihaoName = [[UILabel alloc]initWithFrame:CGRectMake(issueView.x, 0, issueView.width, 25)];
    qihaoName.text = @"期号";
    qihaoName.backgroundColor = COLOR(255, 245, 245);
    qihaoName.textAlignment = NSTextAlignmentCenter;
    qihaoName.textColor = COLOR(83, 83, 83);
    qihaoName.font = [UIFont systemFontOfSize:13];
    [self addSubview:qihaoName];
    UIView * line1 = [[UIView alloc]initWithFrame:CGRectMake(qihaoName.width - 0.2, 0, 0.3, qihaoName.height)];
    line1.backgroundColor = COLOR(210, 210, 210);
    [self addSubview:line1];
    
    //开奖号码标题
    NSArray *codeArray = [[_openCode firstObject] componentsSeparatedByString:@","];
    DS_LotteryHeWeiPathView * openTopView = [[DS_LotteryHeWeiPathView alloc]initWithFrame:CGRectMake(0, 0, codeArray.count * 30, 25)];
    openTopView.rowCount = 1;
    NSMutableArray * openTopArray = [NSMutableArray arrayWithObjects:@"开奖号码",nil];
    openTopView.listArray = openTopArray;
    [_tagScrollView addSubview:openTopView];
    
    //开奖码列表
    DS_LotteryOpenCodeView *  openCodeView = [[DS_LotteryOpenCodeView alloc]initWithFrame:CGRectMake(0, 0, openTopView.width, (_openCode.count +4) * cellHeightDraw)];
    openCodeView.codeList = _openCode;
    openCodeView.lotteryId = @"12";
    [_codeScrollView addSubview:openCodeView];
    _codeScrollView.contentSize = CGSizeMake(270 + 180, _openCode.count * cellHeightDraw);
    
    //和值
    DS_LotteryHeWeiPathView * sumTopView = [[DS_LotteryHeWeiPathView alloc]initWithFrame:CGRectMake(openTopView.right, 0, 40, 25)];
    sumTopView.rowCount = 1;
    NSMutableArray * sumArray = [NSMutableArray arrayWithObjects:@"和尾",nil];
    sumTopView.listArray = sumArray;
    [_tagScrollView addSubview:sumTopView];
    
    //和值列表
    DS_LotterySumView * sumView = [[DS_LotterySumView alloc]initWithFrame:CGRectMake(openTopView.right, 0, sumTopView.width, cellHeightDraw*(_openCode.count +4))];
    sumView.codeArray = _openCode;
    [_codeScrollView addSubview:sumView];
    
    //走势图标题
    DS_LotteryHeWeiPathView * pathView = [[DS_LotteryHeWeiPathView alloc]initWithFrame:CGRectMake(sumView.right, 0, _sumText.count * 40, 25)];
    pathView.rowCount = 1;
    pathView.listArray = _sumText;
    [_tagScrollView addSubview:pathView];
    
    //走势图列表
    DS_LotteryHeWeiPathView * pathList = [[DS_LotteryHeWeiPathView alloc]initWithFrame:CGRectMake(sumView.right, 0, pathView.width, cellHeightDraw*(_openCode.count +4))];
    pathList.rowCount = _openCode.count;
    pathList.sectionArray = _sumText;
    pathList.codeArray = _openCode;
    pathList.listArray = _sumText;
    [_codeScrollView addSubview:pathList];
    
    _tagScrollView.contentSize = CGSizeMake(pathView.width + openTopView.width + sumTopView.width,0);
    _qishuScrollView.contentSize = CGSizeMake(0, issueView.height);
    _codeScrollView.contentSize = CGSizeMake(pathView.width + openTopView.width + sumTopView.width,issueView.height);
}

#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(scrollView == _qishuScrollView){
        _codeScrollView.contentOffset = CGPointMake(_codeScrollView.contentOffset.x, _qishuScrollView.contentOffset.y);
    }else if(scrollView == _codeScrollView){
        _qishuScrollView.contentOffset = CGPointMake(_qishuScrollView.contentOffset.x, _codeScrollView.contentOffset.y);
        _tagScrollView.contentOffset = CGPointMake(_codeScrollView.contentOffset.x, _tagScrollView.contentOffset.y);
    }else{
        _codeScrollView.contentOffset = CGPointMake(_tagScrollView.contentOffset.x, _codeScrollView.contentOffset.y);
    }
}

#pragma mark - 懒加载
- (UIScrollView *)tagScrollView {
    if (!_tagScrollView) {
        _tagScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(90, 0, self.width - 90, 25)];
        _tagScrollView.delegate = self;
        _tagScrollView.bounces = NO;
        _tagScrollView.showsVerticalScrollIndicator = NO;
        _tagScrollView.showsHorizontalScrollIndicator = NO;
        _tagScrollView.directionalLockEnabled = YES;  //定向锁定
    }
    return _tagScrollView;
}

- (UIScrollView *)qishuScrollView {
    if (!_qishuScrollView) {
        _qishuScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 25, 90, self.height - 25)];
        _qishuScrollView.delegate = self;
        _qishuScrollView.showsVerticalScrollIndicator = NO;
        _qishuScrollView.showsHorizontalScrollIndicator = NO;
        _qishuScrollView.bounces = NO;
        _qishuScrollView.directionalLockEnabled = YES;  //定向锁定
    }
    return _qishuScrollView;
}

- (UIScrollView *)codeScrollView {
    if (!_codeScrollView) {
        _codeScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(90, 25, self.width - 90, self.height - 25)];
        _codeScrollView.delegate = self;
        _codeScrollView.bounces = NO;
        _codeScrollView.showsVerticalScrollIndicator = NO;
        _codeScrollView.showsHorizontalScrollIndicator = NO;
        _codeScrollView.directionalLockEnabled = YES;
    }
    return _codeScrollView;
}



@end
