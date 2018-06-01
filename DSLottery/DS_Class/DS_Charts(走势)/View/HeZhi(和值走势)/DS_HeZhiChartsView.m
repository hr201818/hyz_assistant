//
//  DS_HezhiChartsView.m
//  DS_AA6
//
//  Created by 黄玉洲 on 2018/5/30.
//  Copyright © 2018年 黄玉洲. All rights reserved.
//

#import "DS_HeZhiChartsView.h"
#import "DS_LotteryPeriodsView.h"
#import "DS_LotteryOpenCodeView.h"
#import "DS_LotteryPathView.h"
#import "DS_LotterySumView.h"
#define cellHeightDraw 30
@interface DS_HeZhiChartsView () <UIScrollViewDelegate>

/** 期数滚动 */
@property (strong, nonatomic) UIScrollView   * qishuScrollView;

/** 号码滚动 */
@property (strong, nonatomic) UIScrollView   * codeScrollView;

/** 号码标签滚动（开奖号码、和值、1-9...） */
@property (strong, nonatomic)UIScrollView    * tagScrollView;

/** 期号数组 */
@property (strong, nonatomic) NSMutableArray * periodsNumber;

/** 开奖号码数组 */
@property (strong, nonatomic) NSMutableArray * openCode;

/** 和值数组 */
@property (strong, nonatomic) NSMutableArray * sumText;

@end

@implementation DS_HeZhiChartsView

/**
 初始化
 @param frame 尺寸
 @param modelList 数据模型
 @param lotteryID 彩种ID
 @return 和值视图
 */
- (instancetype)initWithFrame:(CGRect)frame
                    modelList:(DS_ChartsListModel *)modelList
                    lotteryID:(NSString *)lotteryID {
    if ([super initWithFrame:frame]) {
        // 计算和值区间
        [self progressSum:lotteryID];
        
        // 保存期号和开奖号码
        _periodsNumber = [[NSMutableArray alloc]init];
        _openCode = [[NSMutableArray alloc]init];
        for (DS_ChartsModel * model in modelList.sscHistoryList) {
            [_periodsNumber addObject:model.number];
            [_openCode addObject:model.openCode];
        }
        
        // 将获取到的期号和开奖号码逆序排列
        _periodsNumber = (NSMutableArray *)[[_periodsNumber reverseObjectEnumerator] allObjects];
        _openCode = (NSMutableArray *)[[_openCode reverseObjectEnumerator] allObjects];
        
        [self layoutView];
    }
    return self;
}

#pragma mark - 数据处理
/**
 根据彩种ID来选定和值区间
 @param lotteryID 彩种ID
 */
- (void)progressSum:(NSString *)lotteryID {
    // 六合彩
    if([lotteryID integerValue] == 6){
        _sumText = [NSMutableArray arrayWithObjects:@"1-60",@"61-120",@"121-180",@"181-240",@"241-300",@"300-343",nil];
    }
    // 双色球
    else if([lotteryID integerValue] == 12){
        _sumText = [NSMutableArray arrayWithObjects:@"1-40",@"41-80",@"81-120",@"121-160",@"160-183",nil];
    }
    // 体彩排列3 福彩3D 北京28
    else if([lotteryID integerValue] == 4 ||
            [lotteryID integerValue] == 5 ||
            [lotteryID integerValue] == 7) {
        _sumText = [NSMutableArray arrayWithObjects:@"1-9",@"10-18",@"19-27",nil];
    }
    // 重庆时时彩 天津时时彩 新疆时时彩 三分时时彩
    // 分分时时彩 两分时时彩 五分时时彩 北京时时彩 吉林时时彩
    else if([lotteryID integerValue] == 1  ||
            [lotteryID integerValue] == 2  ||
            [lotteryID integerValue] == 3  ||
            [lotteryID integerValue] == 13 ||
            [lotteryID integerValue] == 15 ||
            [lotteryID integerValue] == 16 ||
            [lotteryID integerValue] == 17 ||
            [lotteryID integerValue] == 25 ||
            [lotteryID integerValue] == 26){
        _sumText = [NSMutableArray arrayWithObjects:@"1-9",@"10-18",@"19-27",@"28-36",@"37-45",nil];
    }
    // 江苏快3 湖北快3 安徽快3 吉林快3
    else if([lotteryID integerValue] == 18 ||
            [lotteryID integerValue] == 19 ||
            [lotteryID integerValue] == 20 ||
            [lotteryID integerValue] == 21){
        _sumText = [NSMutableArray arrayWithObjects:@"1-6",@"7-12",@"13-18",nil];
    }
    // 广东十一选五
    else if([lotteryID integerValue] == 24){
        _sumText = [NSMutableArray arrayWithObjects:@"1-10",@"11-20",@"21-30",@"31-40",@"41-50",nil];
    }
    // 北京PK10 幸运飞艇 极速PK10
    else if([lotteryID integerValue] == 9  ||
            [lotteryID integerValue] == 14 ||
            [lotteryID integerValue] == 23){
        _sumText = [NSMutableArray arrayWithObjects:@"1-20",@"21-40",@"41-60",@"61-80",@"81-100",nil];
    }
    // 北京快乐8
    else if ([lotteryID integerValue] == 8){
        _sumText = [NSMutableArray arrayWithObjects:@"1-300",@"301-600",@"601-900",@"901-1200",@"1201-1500",@"1501-1600",nil];
    }
    // 重庆幸运农场 广东快乐十分
    else if ([lotteryID integerValue] == 10 ||
              [lotteryID integerValue] == 11){
        _sumText = [NSMutableArray arrayWithObjects:@"1-40",@"41-80",@"81-120",@"121-160",nil];
    }
}

#pragma mark - 界面
- (void)layoutView {
    
    // 标签
    [self addSubview:self.tagScrollView];
    
    // 期数
    [self addSubview:self.qishuScrollView];

    // 开奖号
    [self addSubview:self.codeScrollView];
    
    // 期号固定按钮
    UILabel * qihaoName = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 90, 25)];
    qihaoName.text = @"期号";
    qihaoName.backgroundColor = COLOR(255, 245, 245);
    qihaoName.textAlignment = NSTextAlignmentCenter;
    qihaoName.textColor = COLOR(83, 83, 83);
    qihaoName.font = [UIFont systemFontOfSize:13];
    [self addSubview:qihaoName];
    
    // 左侧期号数
    DS_LotteryPeriodsView *  issueView = [[DS_LotteryPeriodsView alloc] initWithFrame:CGRectMake(0, 0, 90, (_periodsNumber.count + 4) * cellHeightDraw)];
    issueView.periodsNumber = _periodsNumber;
    [_qishuScrollView addSubview:issueView];
    _qishuScrollView.contentSize = CGSizeMake(0, issueView.height);
    
    UIView * line1 = [[UIView alloc]initWithFrame:CGRectMake(qihaoName.width - 0.2, 0, 0.3, qihaoName.height)];
    line1.backgroundColor = COLOR(210, 210, 210);
    [self addSubview:line1];
    
    // 开奖号码标题
    NSArray *codeArray = [[_openCode firstObject] componentsSeparatedByString:@","];
    DS_LotteryPathView * openTopView = [[DS_LotteryPathView alloc]initWithFrame:CGRectMake(0, 0, codeArray.count * 30, 25)];
    openTopView.rowCount = 1;
    NSMutableArray * openTopArray = [NSMutableArray arrayWithObjects:@"开奖号码",nil];
    openTopView.listArray = openTopArray;
    [_tagScrollView addSubview:openTopView];

    // 开奖码列表
    DS_LotteryOpenCodeView *  openCodeView = [[DS_LotteryOpenCodeView alloc]initWithFrame:CGRectMake(0, 0, openTopView.width, (_openCode.count +4) * cellHeightDraw)];
    openCodeView.codeList = _openCode;
    [_codeScrollView addSubview:openCodeView];
    _codeScrollView.contentSize = CGSizeMake(270 + 180, _openCode.count * cellHeightDraw);

    // 和值标题
    DS_LotteryPathView * sumTopView = [[DS_LotteryPathView alloc]initWithFrame:CGRectMake(openTopView.right, 0, 60, 25)];
    sumTopView.rowCount = 1;
    NSMutableArray * sumArray = [NSMutableArray arrayWithObjects:@"和值",nil];
    sumTopView.listArray = sumArray;
    [_tagScrollView addSubview:sumTopView];

    // 和值列表
    DS_LotterySumView * sumView = [[DS_LotterySumView alloc]initWithFrame:CGRectMake(openTopView.right, 0, 60, cellHeightDraw*(_openCode.count +4))];
    sumView.codeArray = _openCode;
    [_codeScrollView addSubview:sumView];

    // 走势图标题
    DS_LotteryPathView * pathView = [[DS_LotteryPathView alloc]initWithFrame:CGRectMake(sumView.right, 0, _sumText.count * 65, 25)];
    pathView.rowCount = 1;
    pathView.listArray = _sumText;
    [_tagScrollView addSubview:pathView];

    // 走势图列表
    DS_LotteryPathView * pathList = [[DS_LotteryPathView alloc]initWithFrame:CGRectMake(sumView.right, 0, pathView.width, cellHeightDraw*(_openCode.count +4))];
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
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
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
