//
//  DSDrawingHezhiView.m
//  DS_lottery
//
//  Created by pro on 2018/5/7.
//  Copyright © 2018年 海南达生实业有限公司. All rights reserved.
//

#import "DSDrawingHeweiView.h"
#import "DSLotteryIssueView.h"
#import "DSLotteryHeweiPathView.h"
#import "DSLotteryOpenCode.h"
#import "DSSumHeweiView.h"
#define cellHeightDraw 30

@interface DSDrawingHeweiView()<UIScrollViewDelegate>;

@property (nonatomic,strong) UIScrollView         * qishuScrollView;

@property (nonatomic,strong) UIScrollView         * codeScrollView;

@property (nonatomic, strong)UIScrollView         * tagScrollView;


@property (strong, nonatomic) NSMutableArray * periodsNumber;

@property (strong, nonatomic) NSMutableArray * openCode;

@property (strong, nonatomic) NSMutableArray * sumText;
@property (copy, nonatomic) NSString * LotteryID;

@end

@implementation DSDrawingHeweiView

- (instancetype)initWithFrame:(CGRect)frame model:(DSChartModal *)model lotteryID:(NSString *)lotteryID;
{
    self = [super initWithFrame:frame];
    if (self) {

        _sumText = [NSMutableArray arrayWithObjects:@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9", nil];
        _periodsNumber = [[NSMutableArray alloc]init];
        _openCode = [[NSMutableArray alloc]init];
        for (DSChartListModal *modelList in model.sscHistoryList) {
            [_periodsNumber addObject:modelList.number];
            [_openCode addObject:modelList.openCode];
        }
        _periodsNumber = (NSMutableArray *)[[_periodsNumber reverseObjectEnumerator] allObjects];
        _openCode = (NSMutableArray *)[[_openCode reverseObjectEnumerator] allObjects];
        self.LotteryID = lotteryID;

        [self layoutView];
    }
    return self;
}

-(void)layoutView{

    //标签
    self.tagScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(90, 0, self.width - 90, 25)];
    self.tagScrollView.delegate = self;
    self.tagScrollView.bounces = NO;
    self.tagScrollView.showsVerticalScrollIndicator = NO;
    self.tagScrollView.showsHorizontalScrollIndicator = NO;
    self.tagScrollView.directionalLockEnabled = YES;  //定向锁定
    [self addSubview:self.tagScrollView];

    //期数
    self.qishuScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 25, 90, self.height - 25)];
    self.qishuScrollView.delegate = self;
    self.qishuScrollView.showsVerticalScrollIndicator = NO;
    self.qishuScrollView.showsHorizontalScrollIndicator = NO;
    self.qishuScrollView.bounces = NO;
    self.qishuScrollView.directionalLockEnabled = YES;  //定向锁定
    [self addSubview:self.qishuScrollView];

    //开奖号码
    self.codeScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(90, 25, self.width - 90, self.height - 25)];
    self.codeScrollView.delegate = self;
    self.codeScrollView.bounces = NO;
    self.codeScrollView.showsVerticalScrollIndicator = NO;
    self.codeScrollView.showsHorizontalScrollIndicator = NO;
    self.codeScrollView.directionalLockEnabled = YES;
    [self addSubview:self.codeScrollView];

    //期号
    DSLotteryIssueView *  issueView = [[DSLotteryIssueView alloc]initWithFrame:CGRectMake(0, 0, 90, (self.periodsNumber.count + 4) * cellHeightDraw)];
    issueView.periodsNumber = self.periodsNumber;
    [self.qishuScrollView addSubview:issueView];
    self.qishuScrollView.contentSize = CGSizeMake(0, issueView.height);

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
    NSArray *codeArray = [[self.openCode firstObject] componentsSeparatedByString:@","];
    DSLotteryHeweiPathView * openTopView = [[DSLotteryHeweiPathView alloc]initWithFrame:CGRectMake(0, 0, codeArray.count * 30, 25)];
    openTopView.rowCount = 1;
    NSMutableArray * openTopArray = [NSMutableArray arrayWithObjects:@"开奖号码",nil];
    openTopView.listArray = openTopArray;
    [self.tagScrollView addSubview:openTopView];

    //开奖码列表
    DSLotteryOpenCode *  openCodeView = [[DSLotteryOpenCode alloc]initWithFrame:CGRectMake(0, 0, openTopView.width, (self.openCode.count +4) * cellHeightDraw)];
    openCodeView.codeList = self.openCode;
    openCodeView.lotteryId = @"12";
    [self.codeScrollView addSubview:openCodeView];
    self.codeScrollView.contentSize = CGSizeMake(270 + 180, _openCode.count * cellHeightDraw);

    //和值
    DSLotteryHeweiPathView * sumTopView = [[DSLotteryHeweiPathView alloc]initWithFrame:CGRectMake(openTopView.right, 0, 40, 25)];
    sumTopView.rowCount = 1;
    NSMutableArray * sumArray = [NSMutableArray arrayWithObjects:@"和尾",nil];
    sumTopView.listArray = sumArray;
    [self.tagScrollView addSubview:sumTopView];

    //和值列表
    DSSumHeweiView * sumView = [[DSSumHeweiView alloc]initWithFrame:CGRectMake(openTopView.right, 0, sumTopView.width, cellHeightDraw*(self.openCode.count +4))];
    sumView.codeArray = self.openCode;
    [self.codeScrollView addSubview:sumView];

    //走势图标题
    DSLotteryHeweiPathView * pathView = [[DSLotteryHeweiPathView alloc]initWithFrame:CGRectMake(sumView.right, 0, _sumText.count * 40, 25)];
    pathView.rowCount = 1;
    pathView.listArray = self.sumText;
    [self.tagScrollView addSubview:pathView];

    //走势图列表
    DSLotteryHeweiPathView * pathList = [[DSLotteryHeweiPathView alloc]initWithFrame:CGRectMake(sumView.right, 0, pathView.width, cellHeightDraw*(self.openCode.count +4))];
    pathList.rowCount = self.openCode.count;
    pathList.sectionArray = self.sumText;
    pathList.codeArray = self.openCode;
    pathList.listArray = self.sumText;
    [self.codeScrollView addSubview:pathList];

    self.tagScrollView.contentSize = CGSizeMake(pathView.width + openTopView.width + sumTopView.width,0);
    self.qishuScrollView.contentSize = CGSizeMake(0, issueView.height);
    self.codeScrollView.contentSize = CGSizeMake(pathView.width + openTopView.width + sumTopView.width,issueView.height);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(scrollView == self.qishuScrollView){
        self.codeScrollView.contentOffset = CGPointMake(self.codeScrollView.contentOffset.x, self.qishuScrollView.contentOffset.y);
    }else if(scrollView == self.codeScrollView){
        self.qishuScrollView.contentOffset = CGPointMake(self.qishuScrollView.contentOffset.x, self.codeScrollView.contentOffset.y);
        self.tagScrollView.contentOffset = CGPointMake(self.codeScrollView.contentOffset.x, self.tagScrollView.contentOffset.y);
    }else{
        self.codeScrollView.contentOffset = CGPointMake(self.tagScrollView.contentOffset.x, self.codeScrollView.contentOffset.y);
    }
}

@end

