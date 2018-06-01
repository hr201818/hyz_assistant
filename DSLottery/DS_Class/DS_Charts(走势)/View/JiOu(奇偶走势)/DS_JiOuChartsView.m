//
//  DS_JiOuChartsView.m
//  DSLottery
//
//  Created by 黄玉洲 on 2018/6/1.
//  Copyright © 2018年 海南达生实业有限公司. All rights reserved.
//

#import "DS_JiOuChartsView.h"

/** view */
#import "DS_LotteryPeriodsView.h"
#import "DS_LotteryOpenCodeView.h"
#import "DS_LotteryPathView.h"
#import "DS_LotterySumView.h"
#import "DS_LotteryHeWeiPathView.h"
#import "DS_JiOuDaxiaoTopView.h"
#import "DS_LotteryJiOuPathView.h"
#define cellHeightDraw 30

@interface DS_JiOuChartsView () <UIScrollViewDelegate>

/** 期数滚动 */
@property (nonatomic,strong) UIScrollView         * qishuScrollView;

/** 号码滚动 */
@property (nonatomic,strong) UIScrollView         * codeScrollView;

/** 号码标签滚动（开奖号码、和值、1-9...） */
@property (nonatomic, strong)UIScrollView         * tagScrollView;

/* 期数 例如：@["11234", "23412", "12344"]*/
@property (strong, nonatomic) NSMutableArray      * periodsNumber;

/* 开奖码  例如：@["01,30,20", "12,39,12", "12,45,13"]*/
@property (strong, nonatomic) NSMutableArray      * openCode;

/* 彩种ID */
@property (copy, nonatomic) NSString              * LotteryID;

@end

@implementation DS_JiOuChartsView

/**
 初始化
 @param frame 尺寸
 @param modelList 数据模型
 @param lotteryID 彩种ID
 @return 大小走势视图
 */
- (instancetype)initWithFrame:(CGRect)frame
                    modelList:(DS_ChartsListModel *)modelList
                    lotteryID:(NSString *)lotteryID {
    if ([super initWithFrame:frame]) {
        _periodsNumber = [[NSMutableArray alloc] init];
        _openCode = [[NSMutableArray alloc]init];
        
        for (DS_ChartsModel * model in modelList.sscHistoryList) {
            [_periodsNumber addObject:model.number];
            [_openCode addObject:model.openCode];
        }
        
        _periodsNumber = (NSMutableArray *)[[_periodsNumber reverseObjectEnumerator] allObjects];
        _openCode = (NSMutableArray *)[[_openCode reverseObjectEnumerator] allObjects];
        
        self.LotteryID = lotteryID;
        
        [self layoutView];
    }
    return self;
}

#pragma mark - 界面
- (void)layoutView {
    // 标签
    [self addSubview:self.tagScrollView];
    
    // 期数
    [self addSubview:self.qishuScrollView];
    
    // 开奖号码
    [self addSubview:self.codeScrollView];
    
    //期号
    DS_LotteryPeriodsView *  issueView = [[DS_LotteryPeriodsView alloc]initWithFrame:CGRectMake(0, 0, 90, (self.periodsNumber.count + 4) * cellHeightDraw)];
    issueView.periodsNumber = self.periodsNumber;
    [self.qishuScrollView addSubview:issueView];
    self.qishuScrollView.contentSize = CGSizeMake(0, issueView.height);
    
    //期号固定按钮
    UILabel * qihaoName = [[UILabel alloc]initWithFrame:CGRectMake(issueView.x, 0, issueView.width, 40)];
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
    NSArray *codeArray = nil;
    if([[self.openCode firstObject] componentsSeparatedByString:@","].count){
        codeArray = [[self.openCode firstObject] componentsSeparatedByString:@","];
    }
    DS_LotteryHeWeiPathView * openTopView = [[DS_LotteryHeWeiPathView alloc]initWithFrame:CGRectMake(0, 0, codeArray.count * 30, 40)];
    openTopView.rowCount = 1;
    NSMutableArray * openTopArray = [NSMutableArray arrayWithObjects:@"开奖号码",nil];
    openTopView.listArray = openTopArray;
    [self.tagScrollView addSubview:openTopView];
    
    //开奖码列表
    DS_LotteryOpenCodeView *  openCodeView = [[DS_LotteryOpenCodeView alloc]initWithFrame:CGRectMake(0, 0, openTopView.width, (self.openCode.count +4) * cellHeightDraw)];
    openCodeView.codeList = self.openCode;
    openCodeView.lotteryId = @"12";
    [self.codeScrollView addSubview:openCodeView];
    self.codeScrollView.contentSize = CGSizeMake(270 + 180, _openCode.count * cellHeightDraw);
    
    NSMutableArray * codes = [[NSMutableArray alloc]init];
    for (NSString * code in self.openCode) {
        [codes addObject:[code componentsSeparatedByString:@","]];
    }
    
    CGFloat left = openTopView.right;
    for (int i = 1; i<=codeArray.count; i++) {
        DS_JiOuDaxiaoTopView * JiouDaxiaoTopView = [[DS_JiOuDaxiaoTopView alloc]initWithFrame:CGRectMake(left, 0, 90, 40) titleName:[NSString stringWithFormat:@"第%d位",i] leftName:@"奇" rightName:@"偶"];
        [self.tagScrollView addSubview:JiouDaxiaoTopView];
        
        NSMutableArray * oneCode = [[NSMutableArray alloc]init];
        for (NSArray * code in codes) {
            [oneCode addObject:code[i- 1]];
        }
        
        DS_LotteryJiOuPathView * JiouPathView = [[DS_LotteryJiOuPathView alloc]initWithFrame:CGRectMake(left, 0, JiouDaxiaoTopView.width,issueView.height)];
        JiouPathView.codeList = oneCode;
        [self.codeScrollView addSubview:JiouPathView];
        left += 90;
    }
    self.tagScrollView.contentSize = CGSizeMake(left,0);
    self.qishuScrollView.contentSize = CGSizeMake(0, issueView.height);
    self.codeScrollView.contentSize = CGSizeMake(left,issueView.height);
}

#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if(scrollView == self.qishuScrollView){
        self.codeScrollView.contentOffset = CGPointMake(self.codeScrollView.contentOffset.x, self.qishuScrollView.contentOffset.y);
    }else if(scrollView == self.codeScrollView){
        self.qishuScrollView.contentOffset = CGPointMake(self.qishuScrollView.contentOffset.x, self.codeScrollView.contentOffset.y);
        self.tagScrollView.contentOffset = CGPointMake(self.codeScrollView.contentOffset.x, self.tagScrollView.contentOffset.y);
    }else{
        self.codeScrollView.contentOffset = CGPointMake(self.tagScrollView.contentOffset.x, self.codeScrollView.contentOffset.y);
    }
}
#pragma mark - 懒加载
- (UIScrollView *)tagScrollView {
    if (!_tagScrollView) {
        _tagScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(90, 0, self.width - 90, 40)];
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
        _qishuScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 40, 90, self.height - 40)];
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
        _codeScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(90, 40, self.width - 90, self.height - 40)];
        _codeScrollView.delegate = self;
        _codeScrollView.bounces = NO;
        _codeScrollView.showsVerticalScrollIndicator = NO;
        _codeScrollView.showsHorizontalScrollIndicator = NO;
        _codeScrollView.directionalLockEnabled = YES;
    }
    return _codeScrollView;
}

@end
