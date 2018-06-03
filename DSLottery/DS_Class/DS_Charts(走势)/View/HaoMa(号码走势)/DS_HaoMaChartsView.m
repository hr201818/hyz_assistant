//
//  DS_HaoMaChartsView.m
//  DSLottery
//
//  Created by 黄玉洲 on 2018/6/3.
//  Copyright © 2018年 海南达生实业有限公司. All rights reserved.
//

#import "DS_HaoMaChartsView.h"
#import "DS_LotteryPeriodsView.h"
#import "DS_LotteryOpenCodeView.h"
#import "DS_LotteryHaoMaPathView.h"
#import "DS_LotteryPathView.h"
#import "DS_HaoMaTagView.h"
#define cellHeightDraw 30

@interface DS_HaoMaChartsView () <UIScrollViewDelegate>

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

@implementation DS_HaoMaChartsView

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

#pragma mark - 界面
- (void)layoutView {
    // 标签
    [self addSubview:self.tagScrollView];
    
    // 期数
    [self addSubview:self.qishuScrollView];
    
    // 开奖号
    [self addSubview:self.codeScrollView];
    
    // 期号固定按钮
    UILabel * qihaoName = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 90, _tagScrollView.height)];
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
    DS_LotteryPathView * openTopView = [[DS_LotteryPathView alloc]initWithFrame:CGRectMake(0, 0, codeArray.count * 30, 50)];
    openTopView.rowCount = 1;
    NSMutableArray * openTopArray = [NSMutableArray arrayWithObjects:@"开奖号码",nil];
    openTopView.listArray = openTopArray;
    [_tagScrollView addSubview:openTopView];
    
    // 开奖码列表
    DS_LotteryOpenCodeView *  openCodeView = [[DS_LotteryOpenCodeView alloc]initWithFrame:CGRectMake(0, 0, openTopView.width, (_openCode.count +4) * cellHeightDraw)];
    openCodeView.codeList = _openCode;
    [_codeScrollView addSubview:openCodeView];
    _codeScrollView.contentSize = CGSizeMake(270 + 180, _openCode.count * cellHeightDraw);
    
    CGFloat tagViewWidth = 30 * 10;
    for (NSInteger i = 0; i < 5; i++) {
        NSString * digitsTxt = @"";
        switch (i) {
            case 0: digitsTxt = @"万位"; break;
            case 1: digitsTxt = @"千位"; break;
            case 2: digitsTxt = @"百位"; break;
            case 3: digitsTxt = @"十位"; break;
            case 4: digitsTxt = @"个位"; break;
            default: break;
        }
        
        // 标签
        DS_HaoMaTagView * tagView = [[DS_HaoMaTagView alloc] initWithFrame:CGRectMake(openCodeView.right + tagViewWidth * i, 0, tagViewWidth, 50) digitsTxt:digitsTxt];
        [_tagScrollView addSubview:tagView];
        
//        // 号码走势
//        DS_LotteryHaoMaPathView * JiouPathView = [[DS_LotteryHaoMaPathView alloc]initWithFrame:CGRectMake(tagView.left, 0, tagViewWidth, issueView.height)];
////        JiouPathView.codeList = oneCode;
//        [self.codeScrollView addSubview:JiouPathView];
    }
    
    _tagScrollView.contentSize = CGSizeMake(tagViewWidth * 5 + openTopView.width + tagViewWidth * 5,0);
    _qishuScrollView.contentSize = CGSizeMake(0, issueView.height);
    _codeScrollView.contentSize = CGSizeMake(tagViewWidth * 5 + openTopView.width + tagViewWidth * 5,issueView.height);
}

#pragma mark - 懒加载
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
        _tagScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(90, 0, self.width - 90, 50)];
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
        _qishuScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, _tagScrollView.height, 90, self.height - _tagScrollView.height)];
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
        _codeScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(90, _tagScrollView.height, self.width - 90, self.height - _tagScrollView.height)];
        _codeScrollView.delegate = self;
        _codeScrollView.bounces = NO;
        _codeScrollView.showsVerticalScrollIndicator = NO;
        _codeScrollView.showsHorizontalScrollIndicator = NO;
        _codeScrollView.directionalLockEnabled = YES;
    }
    return _codeScrollView;
}

@end
