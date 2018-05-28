
//
//  DSChartsRightCellView.m
//  ALLTIMELOTTERY
//
//  Created by wangzhijie on 2018/5/21.
//  Copyright © 2018年 科技有限公司. All rights reserved.
//

#import "DSChartsRightCellView.h"
#define UIColorFromHex(s)  [UIColor colorWithRed:(((s & 0xFF0000) >> 16))/255.0 green:(((s &0xFF00) >> 8))/255.0 blue:((s &0xFF))/255.0 alpha:1.0]
#define labelTextClor UIColorFromHex(0x5f646e)
#define lineColor  UIColorFromHex(0xe3e3e3)
#define syxwWidth ([[UIScreen mainScreen] bounds].size.width/14)
#define TextCOLOR(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
@interface DSChartsRightCellView()

@property(nonatomic, assign) DSChartsType  chartsType; // 走势图种类

@property(nonatomic, strong) NSMutableArray * issueArr; // 期号
@property(nonatomic, strong) NSMutableArray * frameArr; // 保存圆中心的位置、连线
@property(nonatomic, strong) NSMutableArray * listArr; //  0~n  号码表
@property(nonatomic, strong) NSMutableArray * lotteryNumberArr; // 开奖结果总数组
@property(nonatomic, assign) NSInteger  nper; // 有多少期
@property(nonatomic, strong) NSMutableArray * resultsArr; //开奖结果
@property(nonatomic, strong) NSMutableArray * numberArr; // 总次数
@property(nonatomic, strong) NSMutableArray * valuesArr; // 平均遗漏值
@property(nonatomic, strong) NSMutableArray * maxValuesArr; // 最大值遗漏
@property(nonatomic, strong) NSMutableArray * evenValueArr; // 连出值

@property(nonatomic, strong) NSMutableArray * spanValues; // 跨度值表

@end
@implementation DSChartsRightCellView
- (UIColor *)getTrendTextColor:(NSUInteger)i arrCount:(NSUInteger)count
{
    UIColor *color = labelTextClor;
    if (i == count-4) {
        color = TextCOLOR(100, 177, 249);
    }else if (i == count-3) {
        color = TextCOLOR(75, 211, 233);
    }else if (i == count-2) {
        color = TextCOLOR(252, 84, 87);
    }else if (i == count-1) {
        color = TextCOLOR(151, 82, 50);
    }
    return color;
}
-(CGSize)CommentSizeContent:(NSString*)Text Font:(UIFont *)font size:(CGSize)size
{
    NSDictionary *attributes = @{NSFontAttributeName:font};
    CGSize sizes = [Text boundingRectWithSize:size options:NSStringDrawingTruncatesLastVisibleLine| NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil].size;
    
    return sizes;
}
- (instancetype)initWithFrame:(CGRect)frame andIssueArr:(NSArray *)issueArr andListArr:(NSArray *)listArr andLotteryNumberArr:(NSArray *)lotteryNumberArr andResultArr:(NSArray *)resultsArr andNumberArr:(NSArray *)numberArr andValuesArr:(NSArray *)valuesArr andMaxValuesArr:(NSArray *)maxValuesArr andEvenValuesArr:(NSArray *)evenValueArr andSpanValue:(NSArray *)spanValues andNper:(NSInteger)nper andChartType:(DSChartsType)charType{
    if (self = [super initWithFrame:frame]) {
        self.frameArr = [[NSMutableArray  alloc] initWithCapacity:0];
        self.issueArr = [[NSMutableArray alloc] initWithArray:issueArr];
        self.nper = nper;
        self.chartsType = charType;
        self.lotteryNumberArr = [[NSMutableArray alloc] initWithArray:lotteryNumberArr];
        self.listArr = [[NSMutableArray alloc] initWithArray:listArr];
        self.resultsArr = [[NSMutableArray alloc] initWithArray:resultsArr];
        self.numberArr = [[NSMutableArray alloc] initWithArray:numberArr];
        self.valuesArr = [[NSMutableArray alloc] initWithArray:valuesArr];
        self.maxValuesArr = [[NSMutableArray alloc] initWithArray:maxValuesArr];
        self.evenValueArr = [[NSMutableArray alloc] initWithArray:evenValueArr];
        self.spanValues = [[NSMutableArray  alloc] initWithArray:spanValues];
        
        CGRect rect = self.frame;
        CGFloat width = syxwWidth;
        rect.size.height = self.issueArr.count * width;
        self.frame = rect;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
    [_frameArr removeAllObjects];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setAlignment:NSTextAlignmentCenter];
    CGContextRef context = UIGraphicsGetCurrentContext();
    [COLOR(255, 245, 245) setFill];
    UIRectFill(rect);
    CGFloat widh = syxwWidth;
    for (int i=0; i<_issueArr.count; i++) {
        if (i%2==1) {
            [[UIColor whiteColor] setFill];
            UIRectFill(CGRectMake(0, i*widh, rect.size.width, widh));
        }
    }
    
    if (self.chartsType == DSChartsBasicType) { // 号码走势
        
        NSMutableArray * openArr = [NSMutableArray new];
        if (self.lotteryNumberArr.count > 0) {
            openArr = self.lotteryNumberArr[0];
        }
        if (openArr.count > 5) { // 某一行的开奖结果 位数大于5时显示
            //  0 ～ n 数字 内容数组
            for (int j=0; j < _listArr.count; j++) {
                // _issueArr  期号数组
                for (int i=0; i<_issueArr.count; i++) { // 期号数组开始位置
                    if (i<_issueArr.count-4) {  //创建 0 ~ 9 数字
                        
                        NSString *period = [NSString stringWithFormat:@"%@",_listArr[j]];
                        CGSize size = [self CommentSizeContent:period Font:[UIFont systemFontOfSize:12] size:CGSizeMake(widh , widh)];
                        // 开始位置 x   (widh*4 -1)+j*widh
                        [period drawInRect:CGRectMake(j*widh,(widh-size.height)/2.0+i*widh, widh, widh) withAttributes:@{NSParagraphStyleAttributeName:style,NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[self getTrendTextColor:i arrCount:_issueArr.count]}];
                        
                    } else if (i<_issueArr.count-3 && _numberArr.count > 0){ //_numberArr 出现总次数 数组
                        // 出现总次数
                        NSString *period =@"0";
                        NSDictionary *dict  = _numberArr[j]; //出现总次数 数组 结果
                        for (NSString *keys in [dict allKeys]) {
                            if ([keys integerValue]==[_listArr[j] integerValue]) {
                                period = [NSString stringWithFormat:@"%@",dict[keys]];
                            }
                        }
                        CGSize size = [self CommentSizeContent:period Font:[UIFont systemFontOfSize:12] size:CGSizeMake(widh , widh)];
                        
                        [period drawInRect:CGRectMake(j*widh,(widh-size.height)/2.0+i*widh, widh, widh) withAttributes:@{NSParagraphStyleAttributeName:style,NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[self getTrendTextColor:i arrCount:_issueArr.count]}];
                        
                    }else if (i<_issueArr.count-2&&_valuesArr.count>0){  // 平均遗漏值 数组
                        
                        // 平均遗漏值
                        NSString *period =@"0";
                        NSDictionary *dict  = _valuesArr[j];
                        for (NSString *keys in [dict allKeys]) {
                            if ([keys integerValue]==[_listArr[j] integerValue]) {
                                period = [NSString stringWithFormat:@"%@",dict[keys]];
                            }
                        }
                        CGSize size = [self CommentSizeContent:period Font:[UIFont systemFontOfSize:12] size:CGSizeMake(widh , widh)];
                        [period drawInRect:CGRectMake(j*widh,(widh-size.height)/2.0+i*widh, widh, widh) withAttributes:@{NSParagraphStyleAttributeName:style,NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[self getTrendTextColor:i arrCount:_issueArr.count]}];
                        
                    }else if (i<_issueArr.count-1 && _maxValuesArr.count>0){  // 最大遗漏值 数组
                        // 最大遗漏值
                        NSString *period =@"0";
                        NSDictionary *dict  = _maxValuesArr[j];
                        for (NSString *keys in [dict allKeys]) {
                            if ([keys integerValue]==[_listArr[j] integerValue]) {
                                period = [NSString stringWithFormat:@"%@",dict[keys]];
                            }
                        }
                        CGSize size = [self CommentSizeContent:period Font:[UIFont systemFontOfSize:12] size:CGSizeMake(widh , widh)];
                        [period drawInRect:CGRectMake(j*widh,(widh-size.height)/2.0+i*widh, widh, widh) withAttributes:@{NSParagraphStyleAttributeName:style,NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[self getTrendTextColor:i arrCount:_issueArr.count]}];
                        
                    }else if (i<_issueArr.count&&_evenValueArr.count>0){  // 最大连出值 数组
                        // 最大连出值
                        NSString *period =@"0";
                        NSDictionary *dict  = _evenValueArr[j];
                        for (NSString *keys in [dict allKeys]) {
                            if ([keys integerValue]==[_listArr[j] integerValue]) {
                                period = [NSString stringWithFormat:@"%@",dict[keys]];
                            }
                        }
                        CGSize size = [self CommentSizeContent:period Font:[UIFont systemFontOfSize:12] size:CGSizeMake(widh , widh)];
                        [period drawInRect:CGRectMake(j*widh,(widh-size.height)/2.0+i*widh, widh, widh) withAttributes:@{NSParagraphStyleAttributeName:style,NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[self getTrendTextColor:i arrCount:_issueArr.count]}];
                    }
                    
                    CGContextSetStrokeColorWithColor(context, lineColor.CGColor);
                    CGContextSetLineWidth(context, .4);
                    // 开始坐标 x  y
                    CGContextMoveToPoint(context,j * (i+1)*widh, 0);
                    
                    // 添加一条线条 开始坐标 结束坐标
                    CGContextAddLineToPoint(context,j * (i+1)*widh, _issueArr.count*widh);
                    CGContextDrawPath(context, kCGPathStroke);
                } // 期号数组结束位置
            }
            // 画圆 未填充颜色
            for (int i = 0; i<_resultsArr.count; i++) {// start  // 开奖号码 位置数组。万位、百位、十位、个位 元素数组
                // 颜色
                CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
                // 线宽度
                CGContextSetLineWidth(context, .4);
                NSString * number = _resultsArr[i];
                for (NSInteger x = [_listArr[0] integerValue]; x <_listArr.count+1 ; x++) {
                    if ([number intValue] ==x) {
                        //画圆圈
                        [_listArr[0] integerValue] == 1  ? CGContextAddArc(context, widh*(x-1)+widh/2, widh*i+widh/2, widh/3, 0, M_PI*2, 1):
                        
                        CGContextAddArc(context, widh*x+widh/2, widh*i+widh/2, widh/3, 0, M_PI*2, 1);
                        //
                        CGPoint point = [_listArr[0] integerValue] == 1  ? CGPointMake(widh*(x-1)+widh/2, widh*i+widh/2):
                        CGPointMake(widh*x+widh/2, widh*i+widh/2);
                        NSString *str = NSStringFromCGPoint(point);
                        //保存圆中心的位置 给下面的连线
                        [_frameArr addObject:str];
                        CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
                        CGContextDrawPath(context, kCGPathStroke);
                    }
                }
            } // end
            // 连线
            for (int i=0; i<_frameArr.count; i++) {
                NSString *str = [_frameArr objectAtIndex:i];
                CGPoint point = CGPointFromString(str);
                // 设置画笔颜色
                CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
                // 线宽度
                CGContextSetLineWidth(context, 1);
                if (i==0) {
                    // 画笔的起始坐标
                    CGContextMoveToPoint(context, point.x, point.y);
                }else{
                    NSString *str1 = [_frameArr objectAtIndex:i-1];
                    CGPoint point1 = CGPointFromString(str1);
                    CGContextMoveToPoint(context, point1.x, point1.y);
                    CGContextAddLineToPoint(context, point.x,  point.y);
                }
                CGContextDrawPath(context, kCGPathStroke);
            }
            
            //  给圆填充颜色
            for (int i = 0; i<_resultsArr.count; i++) { // start
                CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
                CGContextSetLineWidth(context, .4);
                NSString *number =  _resultsArr[i];
                for (NSInteger x = [_listArr[0] integerValue]; x <_listArr.count+1 ; x++) {
                    if ([number intValue] ==x) {
                        //填满整个圆
                        [_listArr[0] integerValue] == 1  ? CGContextAddArc (context,  widh*(x-1)+widh/2, widh*i+widh/2, widh/3, 0, M_PI*2, 1):
                        CGContextAddArc(context, widh*x+widh/2, widh*i+widh/2, widh/3, 0, M_PI*2, 1);
                        CGContextSetFillColorWithColor(context, [UIColor redColor].CGColor);
                        CGContextDrawPath(context, kCGPathFill);
                        NSString *numberStr = [NSString stringWithFormat:@"%@",number];
                        CGSize size = [self CommentSizeContent:numberStr Font:[UIFont systemFontOfSize:12] size:CGSizeMake(widh , widh)];
                        //画内容
                        [numberStr drawInRect: [_listArr[0] integerValue] == 1  ? CGRectMake( (x-1)*widh,(widh-size.height)/2.0+i*widh, widh, widh) :CGRectMake(x*widh,(widh-size.height)/2.0+i*widh, widh, widh) withAttributes:@{NSParagraphStyleAttributeName:style,NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[UIColor whiteColor]}];
                    }
                }
            } // end
        }else{ // 开奖结果位数 小于5时 显示的样式
            //画圆 、连线 、给圆填充颜色
            NSMutableArray * reslutArr = [NSMutableArray new];
            NSMutableArray * numberArr = [NSMutableArray new]; //出现次数
            NSMutableArray * valuesArr = [NSMutableArray new]; // 平均遗漏值
            NSMutableArray * maxValuesArr = [NSMutableArray new];// 最大遗漏值
            NSMutableArray * evenValueArr = [NSMutableArray new]; //最大连出值
            [openArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger openIdx, BOOL * _Nonnull stop) { //openArr star
                [self.lotteryNumberArr enumerateObjectsUsingBlock:^(NSArray * resultObj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [reslutArr addObject:resultObj[openIdx]];
                }];
                // ********** 计算 总次数、平均遗漏值、最大遗漏值 、最大连出值
                for (NSInteger i = [_listArr[0] integerValue]; i< _listArr.count + 1; i++ ) {
                    // 万位的总次数
                    // 出现的总次数
                    int total = 0;
                    for (NSString * value in reslutArr) {
                        if (i == [value integerValue]) {
                            total ++;
                        }
                    }
                    // 万总次数
                    [numberArr addObject:@{@(i):@(total)}];
                    // 平均遗漏值 （总期数-出现总次数）/ 遗漏段数
                    // 平均遗漏万位
                    int  averageMissingCount = 0;
                    BOOL  isEquesl = NO; //遍历时遇到开奖结果相等置为YES
                    for (int j = 0; j < reslutArr.count; j++) {
                        if (i == [reslutArr[j] integerValue]) {
                            if (j != 0 && isEquesl == NO) {
                                averageMissingCount ++;
                            }
                            isEquesl = YES;
                        }else{
                            isEquesl = NO;
                            if (j == reslutArr.count - 1 && isEquesl == NO) {
                                averageMissingCount ++;
                            }
                        }
                    }
                    [valuesArr addObject:@{@(i):@((self.nper - total)/(averageMissingCount==0?1:averageMissingCount))}];
                    // 最大遗漏值
                    NSMutableArray * biggestMissingValueArr = [NSMutableArray new];
                    NSInteger  biggestMissing = 0;
                    // 最大连出值
                    NSMutableArray * continuousAppearValueArr = [NSMutableArray new];
                    NSInteger continuousAppear = 0;
                    for (int j = 0; j < reslutArr.count; j ++) {
                        if (i == [reslutArr[j] integerValue]) {
                            continuousAppear ++;
                            biggestMissing = 0;
                        }else{
                            continuousAppear = 0;
                            biggestMissing ++;
                        }
                        [biggestMissingValueArr addObject:@(biggestMissing)];
                        [continuousAppearValueArr addObject:@(continuousAppear)];
                    }
                    [maxValuesArr addObject:@{@(i):[biggestMissingValueArr valueForKeyPath:@"@max.floatValue"]}];
                    [evenValueArr addObject:@{@(i):[continuousAppearValueArr valueForKeyPath:@"@max.floatValue"]}];
                    // 千位
                    // 置为最初值 除去万位 添加的结果
                    [biggestMissingValueArr removeAllObjects];
                    [continuousAppearValueArr removeAllObjects];
                    biggestMissing = 0;
                    continuousAppear = 0;
                }// 计算方法end
                
                for (int j=0; j < _listArr.count; j++) {
                    // _issueArr  期号数组
                    for (int i=0; i<_issueArr.count; i++) { // 期号数组开始位置
                        if (i<_issueArr.count-4) {  //创建 0 ~ 9 数字
                            NSString *period = [NSString stringWithFormat:@"%@",_listArr[j]];
                            CGSize size = [self CommentSizeContent:period Font:[UIFont systemFontOfSize:12] size:CGSizeMake(widh , widh)];
                            // 开始位置 x   (widh*4 -1)+j*widh
                            [period drawInRect:CGRectMake(openIdx*10*widh + j*widh,(widh-size.height)/2.0+i*widh, widh, widh) withAttributes:@{NSParagraphStyleAttributeName:style,NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[self getTrendTextColor:i arrCount:_issueArr.count]}];
                            
                        } else if (i<_issueArr.count-3 && numberArr.count > 0){ //_numberArr 出现总次数 数组
                            // 出现总次数
                            NSString *period =@"0";
                            NSDictionary *dict  = numberArr[j]; //出现总次数 数组 结果
                            for (NSString *keys in [dict allKeys]) {
                                if ([keys integerValue]==[_listArr[j] integerValue]) {
                                    period = [NSString stringWithFormat:@"%@",dict[keys]];
                                }
                            }
                            CGSize size = [self CommentSizeContent:period Font:[UIFont systemFontOfSize:12] size:CGSizeMake(widh , widh)];
                            
                            [period drawInRect:CGRectMake(openIdx*10*widh +j*widh,(widh-size.height)/2.0+i*widh, widh, widh) withAttributes:@{NSParagraphStyleAttributeName:style,NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[self getTrendTextColor:i arrCount:_issueArr.count]}];
                            
                        }else if (i<_issueArr.count-2&&valuesArr.count>0){  // 平均遗漏值 数组
                            // 平均遗漏值
                            NSString *period =@"0";
                            NSDictionary *dict  = valuesArr[j];
                            for (NSString *keys in [dict allKeys]) {
                                if ([keys integerValue]==[_listArr[j] integerValue]) {
                                    period = [NSString stringWithFormat:@"%@",dict[keys]];
                                }
                            }
                            CGSize size = [self CommentSizeContent:period Font:[UIFont systemFontOfSize:12] size:CGSizeMake(widh , widh)];
                            [period drawInRect:CGRectMake(openIdx*10*widh +j*widh,(widh-size.height)/2.0+i*widh, widh, widh) withAttributes:@{NSParagraphStyleAttributeName:style,NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[self getTrendTextColor:i arrCount:_issueArr.count]}];
                            
                        }else if (i<_issueArr.count-1 && maxValuesArr.count>0){  // 最大遗漏值 数组
                            // 最大遗漏值
                            NSString *period =@"0";
                            NSDictionary *dict  = maxValuesArr[j];
                            for (NSString *keys in [dict allKeys]) {
                                if ([keys integerValue]==[_listArr[j] integerValue]) {
                                    period = [NSString stringWithFormat:@"%@",dict[keys]];
                                }
                            }
                            CGSize size = [self CommentSizeContent:period Font:[UIFont systemFontOfSize:12] size:CGSizeMake(widh , widh)];
                            [period drawInRect:CGRectMake(openIdx*10*widh +j*widh,(widh-size.height)/2.0+i*widh, widh, widh) withAttributes:@{NSParagraphStyleAttributeName:style,NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[self getTrendTextColor:i arrCount:_issueArr.count]}];
                            
                        }else if (i<_issueArr.count&&evenValueArr.count>0){  // 最大连出值 数组
                            //                        // 最大连出值
                            NSString *period =@"0";
                            NSDictionary *dict  = evenValueArr[j];
                            for (NSString *keys in [dict allKeys]) {
                                if ([keys integerValue]==[_listArr[j] integerValue]) {
                                    period = [NSString stringWithFormat:@"%@",dict[keys]];
                                }
                            }
                            CGSize size = [self CommentSizeContent:period Font:[UIFont systemFontOfSize:12] size:CGSizeMake(widh , widh)];
                            [period drawInRect:CGRectMake(openIdx*10*widh +j*widh,(widh-size.height)/2.0+i*widh, widh, widh) withAttributes:@{NSParagraphStyleAttributeName:style,NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[self getTrendTextColor:i arrCount:_issueArr.count]}];
                        }
                        CGContextSetStrokeColorWithColor(context, lineColor.CGColor);
                        CGContextSetLineWidth(context, .4);
                        CGContextMoveToPoint(context,openIdx*10*widh+i*widh, 0);
                        // 添加一条线条 开始坐标 结束坐标
                        CGContextAddLineToPoint(context, openIdx*10*widh+i*widh, _issueArr.count*widh);
                        CGContextDrawPath(context, kCGPathStroke);
                    } // 期号数组结束位置
                } // end
                [numberArr removeAllObjects];
                [valuesArr removeAllObjects];
                [maxValuesArr removeAllObjects];
                [evenValueArr removeAllObjects];
                
                // 画圆 未填充颜色
                for (int i = 0; i<reslutArr.count; i++) {// start  // 开奖号码 位置数组。万位、百位、十位、个位 元素数组
                    // 颜色
                    CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
                    // 线宽度
                    CGContextSetLineWidth(context, .4);
                    NSString * number = reslutArr[i];
                    for (NSInteger x = [_listArr[0] integerValue]; x <_listArr.count+1 ; x++) {
                        if ([number intValue] ==x) {
                            //画圆圈
                            CGContextAddArc(context, openIdx*10*widh + widh*x+widh/2, widh*i+widh/2, widh/3, 0, M_PI*2, 1);
                            CGPoint point =  CGPointMake(openIdx*10*widh + widh*x+widh/2, widh*i+widh/2);
                            NSString *str = NSStringFromCGPoint(point);
                            //保存圆中心的位置 给下面的连线
                            [_frameArr addObject:str];
                            CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
                            CGContextDrawPath(context, kCGPathStroke);
                        }
                    }
                } // end
                
                // 连线
                for (int i=0; i<_frameArr.count; i++) {
                    NSString *str = [_frameArr objectAtIndex:i];
                    CGPoint point = CGPointFromString(str);
                    // 设置画笔颜色
                    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
                    // 线宽度
                    CGContextSetLineWidth(context, 1);
                    if (i==0) {
                        // 画笔的起始坐标
                        CGContextMoveToPoint(context, point.x, point.y);
                    }else{
                        NSString *str1 = [_frameArr objectAtIndex:i-1];
                        CGPoint point1 = CGPointFromString(str1);
                        CGContextMoveToPoint(context, point1.x, point1.y);
                        CGContextAddLineToPoint(context, point.x,  point.y);
                    }
                    CGContextDrawPath(context, kCGPathStroke);
                }
                //  给圆填充颜色
                for (int i = 0; i<reslutArr.count; i++) { // start
                    CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
                    CGContextSetLineWidth(context, .4);
                    NSString *number = reslutArr[i];
                    
                    for (NSInteger x = [_listArr[0] integerValue]; x <_listArr.count+1 ; x++) {
                        
                        if ([number intValue] ==x) {
                            //填满整个圆
                            [_listArr[0] integerValue] == 1  ? CGContextAddArc (context,openIdx*10*widh + widh*(x-1)+widh/2, widh*i+widh/2, widh/3, 0, M_PI*2, 1):
                            CGContextAddArc(context,openIdx*10*widh+widh*x+widh/2, widh*i+widh/2, widh/3, 0, M_PI*2, 1);
                            CGContextSetFillColorWithColor(context, [UIColor redColor].CGColor);
                            CGContextDrawPath(context, kCGPathFill);
                            NSString *numberStr = [NSString stringWithFormat:@"%@",number];
                            CGSize size = [self CommentSizeContent:numberStr Font:[UIFont systemFontOfSize:12] size:CGSizeMake(widh , widh)];
                            //画内容
                            [numberStr drawInRect:CGRectMake(openIdx*10*widh+x*widh,(widh-size.height)/2.0+i*widh, widh, widh) withAttributes:@{NSParagraphStyleAttributeName:style,NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[UIColor whiteColor]}];
                        }
                    }
                } // end
                [_frameArr removeAllObjects];
                [reslutArr removeAllObjects];
            }]; // openArr end
        }
        
    }else if (self.chartsType == DSChartsLocationType){ // 定位走势
        
        for (int j=0; j < _listArr.count; j++) {
            // _issueArr  期号数组
            for (int i=0; i<_issueArr.count; i++) { // 期号数组开始位置
                if (i<_issueArr.count-4) {  //创建 0 ~ 9 数字
                    
                    NSString *period = [NSString stringWithFormat:@"%@",_listArr[j]];
                    CGSize size = [self CommentSizeContent:period Font:[UIFont systemFontOfSize:12] size:CGSizeMake(widh , widh)];
                    // 开始位置 x (widh*4 -1)+j*widh
                    [period drawInRect:CGRectMake(j*widh,(widh-size.height)/2.0+i*widh, widh, widh) withAttributes:@{NSParagraphStyleAttributeName:style,NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[self getTrendTextColor:i arrCount:_issueArr.count]}];
                    
                } else if (i<_issueArr.count-3 && _numberArr.count > 0){ //_numberArr 出现总次数 数组
                    // 出现总次数
                    NSString *period =@"0";
                    NSDictionary *dict  = _numberArr[j]; //出现总次数 数组 结果
                    for (NSString *keys in [dict allKeys]) {
                        if ([keys integerValue]==[_listArr[j] integerValue]) {
                            period = [NSString stringWithFormat:@"%@",dict[keys]];
                        }
                    }
                    CGSize size = [self CommentSizeContent:period Font:[UIFont systemFontOfSize:12] size:CGSizeMake(widh , widh)];
                    
                    [period drawInRect:CGRectMake(j*widh,(widh-size.height)/2.0+i*widh, widh, widh) withAttributes:@{NSParagraphStyleAttributeName:style,NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[self getTrendTextColor:i arrCount:_issueArr.count]}];
                    
                }else if (i<_issueArr.count-2&&_valuesArr.count>0){  // 平均遗漏值 数组
                    
                    // 平均遗漏值
                    NSString *period =@"0";
                    NSDictionary *dict  = _valuesArr[j];
                    for (NSString *keys in [dict allKeys]) {
                        if ([keys integerValue]==[_listArr[j] integerValue]) {
                            period = [NSString stringWithFormat:@"%@",dict[keys]];
                        }
                    }
                    CGSize size = [self CommentSizeContent:period Font:[UIFont systemFontOfSize:12] size:CGSizeMake(widh , widh)];
                    [period drawInRect:CGRectMake(j*widh,(widh-size.height)/2.0+i*widh, widh, widh) withAttributes:@{NSParagraphStyleAttributeName:style,NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[self getTrendTextColor:i arrCount:_issueArr.count]}];
                    
                }else if (i<_issueArr.count-1 && _maxValuesArr.count>0){  // 最大遗漏值 数组
                    
                    // 最大遗漏值
                    NSString *period =@"0";
                    NSDictionary *dict  = _maxValuesArr[j];
                    for (NSString *keys in [dict allKeys]) {
                        if ([keys integerValue]==[_listArr[j] integerValue]) {
                            period = [NSString stringWithFormat:@"%@",dict[keys]];
                        }
                    }
                    CGSize size = [self CommentSizeContent:period Font:[UIFont systemFontOfSize:12] size:CGSizeMake(widh , widh)];
                    [period drawInRect:CGRectMake(j*widh,(widh-size.height)/2.0+i*widh, widh, widh) withAttributes:@{NSParagraphStyleAttributeName:style,NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[self getTrendTextColor:i arrCount:_issueArr.count]}];
                    
                    
                }else if (i<_issueArr.count&&_evenValueArr.count>0){  // 最大连出值 数组
                    // 最大连出值
                    NSString *period =@"0";
                    NSDictionary *dict  = _evenValueArr[j];
                    for (NSString *keys in [dict allKeys]) {
                        if ([keys integerValue]==[_listArr[j] integerValue]) {
                            period = [NSString stringWithFormat:@"%@",dict[keys]];
                        }
                    }
                    CGSize size = [self CommentSizeContent:period Font:[UIFont systemFontOfSize:12] size:CGSizeMake(widh , widh)];
                    [period drawInRect:CGRectMake(j*widh,(widh-size.height)/2.0+i*widh, widh, widh) withAttributes:@{NSParagraphStyleAttributeName:style,NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[self getTrendTextColor:i arrCount:_issueArr.count]}];
                }
                
                CGContextSetStrokeColorWithColor(context, lineColor.CGColor);
                CGContextSetLineWidth(context, .4);
                // 开始坐标 x  y
                CGContextMoveToPoint(context,j * (i+1)*widh, 0);
                
                // 添加一条线条 开始坐标 结束坐标
                CGContextAddLineToPoint(context,j * (i+1)*widh, _issueArr.count*widh);
                CGContextDrawPath(context, kCGPathStroke);
            } // 期号数组结束位置
        }
        // 画圆 未填充颜色
        for (int i = 0; i<_resultsArr.count; i++) {// start  // 开奖号码 位置数组。万位、百位、十位、个位 元素数组
            
            // 颜色
            CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
            // 线宽度
            CGContextSetLineWidth(context, .4);
            NSString * number = _resultsArr[i];
            for (NSInteger x = [_listArr[0] integerValue]; x <_listArr.count+1 ; x++) {
                if ([number intValue] ==x) {
                    //画圆圈
                    [_listArr[0] integerValue] == 1  ? CGContextAddArc(context, widh*(x-1)+widh/2, widh*i+widh/2, widh/3, 0, M_PI*2, 1):
                    
                    CGContextAddArc(context, widh*x+widh/2, widh*i+widh/2, widh/3, 0, M_PI*2, 1);
                    //
                    CGPoint point = [_listArr[0] integerValue] == 1  ? CGPointMake(widh*(x-1)+widh/2, widh*i+widh/2):
                    CGPointMake(widh*x+widh/2, widh*i+widh/2);
                    NSString *str = NSStringFromCGPoint(point);
                    //保存圆中心的位置 给下面的连线
                    [_frameArr addObject:str];
                    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
                    CGContextDrawPath(context, kCGPathStroke);
                }
            }
        } // end
        // 连线
        for (int i=0; i<_frameArr.count; i++) {
            NSString *str = [_frameArr objectAtIndex:i];
            CGPoint point = CGPointFromString(str);
            // 设置画笔颜色
            CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
            // 线宽度
            CGContextSetLineWidth(context, 1);
            if (i==0) {
                // 画笔的起始坐标
                CGContextMoveToPoint(context, point.x, point.y);
            }else{
                NSString *str1 = [_frameArr objectAtIndex:i-1];
                CGPoint point1 = CGPointFromString(str1);
                CGContextMoveToPoint(context, point1.x, point1.y);
                CGContextAddLineToPoint(context, point.x,  point.y);
            }
            CGContextDrawPath(context, kCGPathStroke);
        }
        
        //  给圆填充颜色
        for (int i = 0; i<_resultsArr.count; i++) { // start
            CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
            CGContextSetLineWidth(context, .4);
            NSString *number = _resultsArr[i];
            for (NSInteger x = [_listArr[0] integerValue]; x <_listArr.count+1 ; x++) {
                if ([number intValue] ==x) {
                    //填满整个圆
                    [_listArr[0] integerValue] == 1  ? CGContextAddArc (context,  widh*(x-1)+widh/2, widh*i+widh/2, widh/3, 0, M_PI*2, 1):
                    CGContextAddArc(context, widh*x+widh/2, widh*i+widh/2, widh/3, 0, M_PI*2, 1);
                    CGContextSetFillColorWithColor(context, [UIColor redColor].CGColor);
                    CGContextDrawPath(context, kCGPathFill);
                    NSString *numberStr = [NSString stringWithFormat:@"%@",number];
                    CGSize size = [self CommentSizeContent:numberStr Font:[UIFont systemFontOfSize:12] size:CGSizeMake(widh , widh)];
                    //画内容
                    [numberStr drawInRect: [_listArr[0] integerValue] == 1  ? CGRectMake( (x-1)*widh,(widh-size.height)/2.0+i*widh, widh, widh) :CGRectMake(x*widh,(widh-size.height)/2.0+i*widh, widh, widh) withAttributes:@{NSParagraphStyleAttributeName:style,NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[UIColor whiteColor]}];
                }
            }
        } // end
        
    }else if (self.chartsType == DSChartsSpadType){ // 跨度走势
        
        // 数字 内容数组
        for (int j=0; j < _listArr.count; j++) {
            // _issueArr  期号数组
            for (int i=0; i<_issueArr.count; i++) { // 期号数组开始位置
                if (i<_issueArr.count-4) {  //创建  数字
                    NSString *period = [NSString stringWithFormat:@"%@",_listArr[j]];
                    CGSize size = [self CommentSizeContent:period Font:[UIFont systemFontOfSize:12] size:CGSizeMake(widh , widh)];
                    [period drawInRect:CGRectMake(j*widh,(widh-size.height)/2.0+i*widh, widh, widh) withAttributes:@{NSParagraphStyleAttributeName:style,NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[UIColor colorWithRed:0.60f green:0.40f blue:0.00f alpha:1.00f]}];
                    
                } else if (i<_issueArr.count-3 && _numberArr.count > 0){ //_numberArr 出现总次数 数组
                    //                     出现总次数
                    NSString *period =@"0";
                    NSDictionary *dict  = self.numberArr[j]; //出现总次数 数组 结果
                    for (NSString *keys in [dict allKeys]) {
                        if ([keys integerValue]==[_listArr[j] integerValue]) {
                            period = [NSString stringWithFormat:@"%@",dict[keys]];
                        }
                    }
                    CGSize size = [self CommentSizeContent:period Font:[UIFont systemFontOfSize:12] size:CGSizeMake(widh , widh)];
                    [period drawInRect:CGRectMake(j*widh,(widh-size.height)/2.0+i*widh, widh, widh) withAttributes:@{NSParagraphStyleAttributeName:style,NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[self getTrendTextColor:i arrCount:_issueArr.count]}];
                }else if (i<_issueArr.count-2&&_valuesArr.count>0){  // 平均遗漏值 数组
                    // 平均遗漏值
                    NSString *period =@"0";
                    NSDictionary *dict  = _valuesArr[j];
                    for (NSString *keys in [dict allKeys]) {
                        if ([keys integerValue]==[_listArr[j] integerValue]) {
                            period = [NSString stringWithFormat:@"%@",dict[keys]];
                        }
                    }
                    CGSize size = [self CommentSizeContent:period Font:[UIFont systemFontOfSize:12] size:CGSizeMake(widh , widh)];
                    [period drawInRect:CGRectMake(j*widh,(widh-size.height)/2.0+i*widh, widh, widh) withAttributes:@{NSParagraphStyleAttributeName:style,NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[self getTrendTextColor:i arrCount:_issueArr.count]}];
                    
                }else if (i<_issueArr.count-1 && _maxValuesArr.count>0){  // 最大遗漏值 数组
                    // 最大遗漏值
                    NSString *period =@"0";
                    NSDictionary *dict  = _maxValuesArr[j];
                    for (NSString *keys in [dict allKeys]) {
                        if ([keys integerValue]==[_listArr[j] integerValue]) {
                            period = [NSString stringWithFormat:@"%@",dict[keys]];
                        }
                    }
                    CGSize size = [self CommentSizeContent:period Font:[UIFont systemFontOfSize:12] size:CGSizeMake(widh , widh)];
                    [period drawInRect:CGRectMake(j*widh,(widh-size.height)/2.0+i*widh, widh, widh) withAttributes:@{NSParagraphStyleAttributeName:style,NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[self getTrendTextColor:i arrCount:_issueArr.count]}];
                }else if (i<_issueArr.count&&_evenValueArr.count>0){  // 最大连出值 数组
                    // 最大连出值
                    NSString *period =@"0";
                    NSDictionary *dict  = _evenValueArr[j];
                    for (NSString *keys in [dict allKeys]) {
                        if ([keys integerValue]==[_listArr[j] integerValue]) {
                            period = [NSString stringWithFormat:@"%@",dict[keys]];
                        }
                    }
                    CGSize size = [self CommentSizeContent:period Font:[UIFont systemFontOfSize:12] size:CGSizeMake(widh , widh)];
                    [period drawInRect:CGRectMake(j*widh,(widh-size.height)/2.0+i*widh, widh, widh) withAttributes:@{NSParagraphStyleAttributeName:style,NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[self getTrendTextColor:i arrCount:_issueArr.count]}];
                    
                }
                CGContextSetStrokeColorWithColor(context, lineColor.CGColor);
                CGContextSetLineWidth(context, .4);
                // 开始坐标 x  y
                CGContextMoveToPoint(context, j * (i+1)*widh, 0);
                // 添加一条线条 开始坐标 结束坐标
                CGContextAddLineToPoint(context, j * (i+1)*widh, _issueArr.count*widh);
                CGContextDrawPath(context, kCGPathStroke);
            } // 期号数组结束位置
        }
        // 画圆 未填充颜色  跨度 结果
        for (int i = 0; i<_spanValues.count; i++) {// start  //
            // 颜色
            CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
            // 线宽度
            CGContextSetLineWidth(context, .4);
            NSString * number = _spanValues[i];
            for (NSInteger x = [_listArr[0] integerValue]; x <_listArr.count+1 ; x++) {
                if ([number intValue] ==x) {
                    //画圆圈
                    CGContextAddArc(context, widh*x+widh/2, widh*i+widh/2, widh/3, 0, M_PI*2, 1);
                    //
                    CGPoint point = CGPointMake(widh*x+widh/2, widh*i+widh/2);
                    NSString *str = NSStringFromCGPoint(point);
                    //保存圆中心的位置 给下面的连线
                    [_frameArr addObject:str];
                    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
                    CGContextDrawPath(context, kCGPathStroke);
                }
            }
        } // end
        
        // 连线
        for (int i=0; i<_frameArr.count; i++) {
            NSString *str = [_frameArr objectAtIndex:i];
            CGPoint point = CGPointFromString(str);
            // 设置画笔颜色
            CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
            // 线宽度
            CGContextSetLineWidth(context, 1);
            if (i==0) {
                // 画笔的起始坐标
                CGContextMoveToPoint(context, point.x, point.y);
            }else{
                NSString *str1 = [_frameArr objectAtIndex:i-1];
                CGPoint point1 = CGPointFromString(str1);
                CGContextMoveToPoint(context, point1.x, point1.y);
                CGContextAddLineToPoint(context, point.x,  point.y);
            }
            CGContextDrawPath(context, kCGPathStroke);
        }
        //  给圆填充颜色  _spanValues.count - 1 减去1 去掉 add 进数组的"跨度"文字
        for (int i = 0; i<_spanValues.count; i++) { // start
            CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
            CGContextSetLineWidth(context, .4);
            NSString *number =  _spanValues[i];
            for (NSInteger x = [_listArr[0] integerValue]; x <_listArr.count+1 ; x++) {
                if ([number intValue] ==x) {
                    //填满整个圆
                    CGContextAddArc(context,widh*x+widh/2, widh*i+widh/2, widh/3, 0, M_PI*2, 1);
                    CGContextSetFillColorWithColor(context, [UIColor redColor].CGColor);
                    CGContextDrawPath(context, kCGPathFill);
                    NSString *numberStr = [NSString stringWithFormat:@"%@",number];
                    CGSize size = [self CommentSizeContent:numberStr Font:[UIFont systemFontOfSize:12] size:CGSizeMake(widh , widh)];
                    //画内容
                    [numberStr drawInRect:CGRectMake(x*widh,(widh-size.height)/2.0+i*widh, widh, widh) withAttributes:@{NSParagraphStyleAttributeName:style,NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[UIColor whiteColor]}];
                }
            }
        } // end
        
    }else if (self.chartsType == DSChartsThreeType){ //除三余
        
        NSMutableArray * openArr = [NSMutableArray new];
        if (self.lotteryNumberArr.count > 0) {
            openArr = self.lotteryNumberArr[0];
        }
        NSMutableArray * reslutArr = [NSMutableArray new];
        NSMutableArray * numberArr = [NSMutableArray new]; //出现次数
        NSMutableArray * valuesArr = [NSMutableArray new]; // 平均遗漏值
        NSMutableArray * maxValuesArr = [NSMutableArray new];// 最大遗漏值
        NSMutableArray * evenValueArr = [NSMutableArray new]; //最大连出值
        [openArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger openIdx, BOOL * _Nonnull stop) {
            [self.lotteryNumberArr enumerateObjectsUsingBlock:^( NSArray * resultObj, NSUInteger idx, BOOL * _Nonnull stop) {
                [reslutArr addObject:resultObj[openIdx]];
            }];
            for (NSInteger i = [_listArr[0] integerValue]; i< _listArr.count + 1; i++ ) {
                int total = 0;
                for (NSString * value in reslutArr) {
                    if (i == ([value integerValue] % 3)) {
                        total ++;
                    }
                }
                [numberArr addObject:@{@(i):@(total)}];
                // 百位 平均遗漏值 （总期数-出现总次数）/ 遗漏段数
                int  averageMissingCount = 0;
                BOOL  isEquesl = NO; //遍历时遇到开奖结果相等置为YES
                for (int j = 0; j < reslutArr.count; j++) {
                    if (i == ([reslutArr[j] integerValue] % 3)) {
                        if (j != 0 && isEquesl == NO) {
                            averageMissingCount ++;
                        }
                        isEquesl = YES;
                    }else{
                        isEquesl = NO;
                        if (j == reslutArr.count - 1 && isEquesl == NO) {
                            averageMissingCount ++;
                        }
                    }
                }
                [valuesArr addObject:@{@(i):@((_nper - total)/(averageMissingCount==0?1:averageMissingCount))}];
                // 最大遗漏值 百位
                NSMutableArray * biggestMissingValueArr = [NSMutableArray new];
                NSInteger  biggestMissing = 0;
                // 最大连出值
                NSMutableArray * continuousAppearValueArr = [NSMutableArray new];
                NSInteger continuousAppear = 0;
                if (reslutArr.count > 0) {
                    for (int j = 0; j < reslutArr.count; j ++) {
                        if (i == ([reslutArr[j] integerValue] % 3)) {
                            continuousAppear ++;
                            biggestMissing = 0;
                        }else{
                            continuousAppear = 0;
                            biggestMissing ++;
                        }
                        [biggestMissingValueArr addObject:@(biggestMissing)];
                        [continuousAppearValueArr addObject:@(continuousAppear)];
                    }
                    [maxValuesArr addObject:@{@(i):[biggestMissingValueArr valueForKeyPath:@"@max.floatValue"]}];
                    [evenValueArr addObject:@{@(i):[continuousAppearValueArr valueForKeyPath:@"@max.floatValue"]}];
                }
                // 最大遗漏值  十位
                // 最大连出值  十位
                // 归零
                [biggestMissingValueArr removeAllObjects];
                [continuousAppearValueArr removeAllObjects];
                biggestMissing = 0;
                continuousAppear = 0;
            }
            for (int j=0; j < _listArr.count; j++) {
                // _issueArr  期号数组
                for (int i=0; i<_issueArr.count; i++) { // 期号数组开始位置
                    if (i<_issueArr.count-4) {  //创建 0 ~ 9 数字
                        //                    NSString *period = [NSString stringWithFormat:@"%@",_listArr[j]];
                        // 这里给个随机数 是为了和 0 1 2 不一样 这样是为了 走势图效果
                        int value = (arc4random() % 9) + 1;
                        NSString *period = [NSString stringWithFormat:@"%d",value];
                        
                        CGSize size = [self CommentSizeContent:period Font:[UIFont systemFontOfSize:12] size:CGSizeMake(widh , widh)];
                        [period drawInRect:CGRectMake(openIdx*3*widh+j*widh,(widh-size.height)/2.0+i*widh, widh, widh) withAttributes:@{NSParagraphStyleAttributeName:style,NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[UIColor colorWithRed:0.60f green:0.40f blue:0.00f alpha:1.00f]}];
                    } else if (i<_issueArr.count-3 && numberArr.count > 0){ //_numberArr 出现总次数 数组
                        //出现总次数
                        NSString *period =@"0";
                        NSDictionary *dict  = numberArr[j]; //出现总次数 数组 结果
                        for (NSString *keys in [dict allKeys]) {
                            if ([keys integerValue]==[_listArr[j] integerValue]) {
                                period = [NSString stringWithFormat:@"%@",dict[keys]];
                            }
                        }
                        CGSize size = [self CommentSizeContent:period Font:[UIFont systemFontOfSize:12] size:CGSizeMake(widh , widh)];
                        [period drawInRect:CGRectMake(openIdx*3*widh+j*widh,(widh-size.height)/2.0+i*widh, widh, widh) withAttributes:@{NSParagraphStyleAttributeName:style,NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[self getTrendTextColor:i arrCount:_issueArr.count]}];
                        
                    }else if (i<_issueArr.count-2&&valuesArr.count>0){  // 平均遗漏值 数组
                        // 平均遗漏值
                        NSString *period =@"0";
                        NSDictionary *dict  = valuesArr[j];
                        for (NSString *keys in [dict allKeys]) {
                            if ([keys integerValue]==[_listArr[j] integerValue]) {
                                period = [NSString stringWithFormat:@"%@",dict[keys]];
                            }
                        }
                        CGSize size = [self CommentSizeContent:period Font:[UIFont systemFontOfSize:12] size:CGSizeMake(widh , widh)];
                        [period drawInRect:CGRectMake(openIdx*3*widh+j*widh,(widh-size.height)/2.0+i*widh, widh, widh) withAttributes:@{NSParagraphStyleAttributeName:style,NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[self getTrendTextColor:i arrCount:_issueArr.count]}];
                        
                    }else if (i<_issueArr.count-1 && maxValuesArr.count>0){  // 最大遗漏值 数组
                        // 最大遗漏值
                        NSString *period =@"0";
                        NSDictionary *dict  = maxValuesArr[j];
                        for (NSString *keys in [dict allKeys]) {
                            if ([keys integerValue]==[_listArr[j] integerValue]) {
                                period = [NSString stringWithFormat:@"%@",dict[keys]];
                            }
                        }
                        CGSize size = [self CommentSizeContent:period Font:[UIFont systemFontOfSize:12] size:CGSizeMake(widh , widh)];
                        [period drawInRect:CGRectMake(openIdx*3*widh+j*widh,(widh-size.height)/2.0+i*widh, widh, widh) withAttributes:@{NSParagraphStyleAttributeName:style,NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[self getTrendTextColor:i arrCount:_issueArr.count]}];
                        
                    }else if (i<_issueArr.count&&evenValueArr.count>0){  // 最大连出值 数组
                        // 最大连出值
                        NSString *period =@"0";
                        NSDictionary *dict  = evenValueArr[j];
                        for (NSString *keys in [dict allKeys]) {
                            if ([keys integerValue]==[_listArr[j] integerValue]) {
                                period = [NSString stringWithFormat:@"%@",dict[keys]];
                            }
                        }
                        CGSize size = [self CommentSizeContent:period Font:[UIFont systemFontOfSize:12] size:CGSizeMake(widh , widh)];
                        [period drawInRect:CGRectMake(openIdx*3*widh+j*widh,(widh-size.height)/2.0+i*widh, widh, widh) withAttributes:@{NSParagraphStyleAttributeName:style,NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[self getTrendTextColor:i arrCount:_issueArr.count]}];
                        
                    }
                    CGContextSetStrokeColorWithColor(context, lineColor.CGColor);
                    CGContextSetLineWidth(context, .4);
                    // 开始坐标 x  y
                    CGContextMoveToPoint(context,openIdx*3*widh+(i+1)*widh, 0);
                    // 添加一条线条 开始坐标 结束坐标
                    CGContextAddLineToPoint(context, openIdx*3*widh+(i+1)*widh, _issueArr.count*widh);
                    CGContextDrawPath(context, kCGPathStroke);
                } // 期号数组结束位置
            }
            [numberArr removeAllObjects];
            [valuesArr removeAllObjects];
            [maxValuesArr removeAllObjects];
            [evenValueArr removeAllObjects];
            
            // 画圆 未填充颜色
            for (int i = 0; i<reslutArr.count; i++) {// start  //
                // 颜色
                CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
                // 线宽度
                CGContextSetLineWidth(context, .4);
                NSString * number = reslutArr[i];
                for (NSInteger x = [_listArr[0] integerValue]; x <_listArr.count ; x++) {
                    int c =  [number intValue] % 3;
                    if (c ==x) {
                        //画圆圈
                        CGContextAddArc(context, openIdx*3*widh+widh*x+widh/2, widh*i+widh/2, widh/3, 0, M_PI*2, 1);
                        CGPoint point = CGPointMake(openIdx*3*widh+widh*x+widh/2, widh*i+widh/2);
                        NSString *str = NSStringFromCGPoint(point);
                        //保存圆中心的位置 给下面的连线
                        [_frameArr addObject:str];
                        CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
                        CGContextDrawPath(context, kCGPathStroke);
                    }
                }
            } // end
            for (int i=0; i<_frameArr.count; i++) {
                NSString *str = [_frameArr objectAtIndex:i];
                CGPoint point = CGPointFromString(str);
                // 设置画笔颜色
                CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
                // 线宽度
                CGContextSetLineWidth(context, 1);
                if (i==0) {
                    // 画笔的起始坐标
                    CGContextMoveToPoint(context, point.x, point.y);
                }else{
                    NSString *str1 = [_frameArr objectAtIndex:i-1];
                    CGPoint point1 = CGPointFromString(str1);
                    CGContextMoveToPoint(context, point1.x, point1.y);
                    CGContextAddLineToPoint(context, point.x,  point.y);
                }
                CGContextDrawPath(context, kCGPathStroke);
            }
            //  给圆填充颜色
            for (int i = 0; i<reslutArr.count; i++) { // start
                CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
                CGContextSetLineWidth(context, .4);
                NSString *number =  reslutArr[i];
                for (NSInteger x = [_listArr[0] integerValue]; x <_listArr.count+1 ; x++) {
                    int c =  [number intValue] % 3;
                    if (c == x) {
                        //填满整个圆
                        CGContextAddArc(context,openIdx*3*widh+widh*x+widh/2, widh*i+widh/2, widh/3, 0, M_PI*2, 1);
                        CGContextSetFillColorWithColor(context, [UIColor redColor].CGColor);
                        CGContextDrawPath(context, kCGPathFill);
                        //  NSString *numberStr = [NSString stringWithFormat:@"%@",number];
                        NSString *numberStr = [NSString stringWithFormat:@"%ld",(long)x];
                        
                        CGSize size = [self CommentSizeContent:numberStr Font:[UIFont systemFontOfSize:12] size:CGSizeMake(widh , widh)];
                        //画内容
                        [numberStr drawInRect:CGRectMake(openIdx*3*widh+x*widh,(widh-size.height)/2.0+i*widh, widh, widh) withAttributes:@{NSParagraphStyleAttributeName:style,NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[UIColor whiteColor]}];
                    }
                }
            } // end
            [_frameArr removeAllObjects];
            [reslutArr removeAllObjects];
        }];
    }
    
}
@end

































