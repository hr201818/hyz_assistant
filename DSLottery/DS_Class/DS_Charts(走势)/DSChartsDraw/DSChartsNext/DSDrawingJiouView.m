//
//  DSDrawingJiouView.m
//  DS_lottery
//
//  Created by pro on 2018/5/10.
//  Copyright © 2018年 海南达生实业有限公司. All rights reserved.
//

#import "DSDrawingJiouView.h"
#import "DSLotteryIssueView.h"
#import "DSLotteryHeweiPathView.h"
#import "DSLotteryOpenCode.h"
#import "DSSumHeweiView.h"
#import "DSJiouDaxiaoTopView.h"
#import "DSLotteryJiouPathView.h"
#define cellHeightDraw 30

@interface DSDrawingJiouView()<UIScrollViewDelegate>

@property (nonatomic,strong) UIScrollView         * qishuScrollView;

@property (nonatomic,strong) UIScrollView         * codeScrollView;

@property (nonatomic, strong)UIScrollView         * tagScrollView;

/* 期数 例如：@["11234", "23412", "12344"]*/
@property (strong, nonatomic) NSMutableArray      * periodsNumber;
/* 开奖码  例如：@["01,30,20", "12,39,12", "12,45,13"]*/
@property (strong, nonatomic) NSMutableArray      * openCode;

@property (copy, nonatomic) NSString * LotteryID;

@end

@implementation DSDrawingJiouView

- (instancetype)initWithFrame:(CGRect)frame model:(DSChartModal *)model lotteryID:(NSString *)lotteryID
{
    self = [super initWithFrame:frame];
    if (self) {

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
    self.tagScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(90, 0, self.width - 90, 40)];
    self.tagScrollView.delegate = self;
    self.tagScrollView.bounces = NO;
    self.tagScrollView.showsVerticalScrollIndicator = NO;
    self.tagScrollView.showsHorizontalScrollIndicator = NO;
    self.tagScrollView.directionalLockEnabled = YES;  //定向锁定
    [self addSubview:self.tagScrollView];

    //期数
    self.qishuScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 40, 90, self.height - 40)];
    self.qishuScrollView.delegate = self;
    self.qishuScrollView.showsVerticalScrollIndicator = NO;
    self.qishuScrollView.showsHorizontalScrollIndicator = NO;
    self.qishuScrollView.bounces = NO;
    self.qishuScrollView.directionalLockEnabled = YES;  //定向锁定
    [self addSubview:self.qishuScrollView];

    //开奖号码
    self.codeScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(90, 40, self.width - 90, self.height - 40)];
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
    DSLotteryHeweiPathView * openTopView = [[DSLotteryHeweiPathView alloc]initWithFrame:CGRectMake(0, 0, codeArray.count * 30, 40)];
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

    NSMutableArray * codes = [[NSMutableArray alloc]init];
    for (NSString * code in self.openCode) {
        [codes addObject:[code componentsSeparatedByString:@","]];
    }

    CGFloat left = openTopView.right;
    for (int i = 1; i<=codeArray.count; i++) {
        DSJiouDaxiaoTopView * JiouDaxiaoTopView = [[DSJiouDaxiaoTopView alloc]initWithFrame:CGRectMake(left, 0, 90, 40) titleName:[NSString stringWithFormat:@"第%d位",i] leftName:@"奇" rightName:@"偶"];
        [self.tagScrollView addSubview:JiouDaxiaoTopView];

        NSMutableArray * oneCode = [[NSMutableArray alloc]init];
        for (NSArray * code in codes) {
            [oneCode addObject:code[i- 1]];
        }
        DSLotteryJiouPathView * JiouPathView = [[DSLotteryJiouPathView alloc]initWithFrame:CGRectMake(left, 0, JiouDaxiaoTopView.width,issueView.height)];
        JiouPathView.codeList = oneCode;
        [self.codeScrollView addSubview:JiouPathView];
        left += 90;
    }
    self.tagScrollView.contentSize = CGSizeMake(left,0);
    self.qishuScrollView.contentSize = CGSizeMake(0, issueView.height);
    self.codeScrollView.contentSize = CGSizeMake(left,issueView.height);
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
