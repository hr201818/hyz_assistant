//
//  DSChartsRightCellHeaderView.m
//  ALLTIMELOTTERY
//
//  Created by wangzhijie on 2018/5/21.
//  Copyright © 2018年 科技有限公司. All rights reserved.
//

#import "DSChartsRightCellHeaderView.h"
#define UIColorFromHex(s)  [UIColor colorWithRed:(((s & 0xFF0000) >> 16))/255.0 green:(((s &0xFF00) >> 8))/255.0 blue:((s &0xFF))/255.0 alpha:1.0]
#define labelTextClor UIColorFromHex(0x5f646e)
#define lineColor  UIColorFromHex(0xe3e3e3)
#define syxwWidth ([[UIScreen mainScreen] bounds].size.width/14)
#define TextCOLOR(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

@interface DSChartsRightCellHeaderView()
@property(nonatomic, strong) NSMutableArray * numberList; // 号码表
@property(nonatomic, strong) NSMutableArray * digitArray; // 百十个
@property(nonatomic, assign) DSChartsType  chartsType;

@property(nonatomic, assign) NSInteger  openCodeArrCount; // 开奖结果位数
@end

@implementation DSChartsRightCellHeaderView
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

#pragma mark: init method
- (instancetype)initWithFrame:(CGRect)frame andList:(NSArray *)listArr andChartsType:(DSChartsType)chartsType andOpenCodeArrCount:(NSUInteger)openCodeArrCount{
    if (self = [super initWithFrame:frame]) {
        self.chartsType = chartsType;
        self.openCodeArrCount = openCodeArrCount;
        self.numberList = [[NSMutableArray alloc] initWithArray:listArr];
        if (openCodeArrCount > 5) {
            self.digitArray = [NSMutableArray array];
            for (NSInteger i = 1; i<openCodeArrCount+1; i++) {
                [self.digitArray addObject:[NSString stringWithFormat:@"第%ld位",(long)i]];
            }
        }else{
            if (openCodeArrCount < 5) {
                self.digitArray = [NSMutableArray arrayWithArray:@[@"百位",@"十位",@"个位"]];
            }else{
                self.digitArray = [NSMutableArray arrayWithArray:@[@"万位",@"千位",@"百位",@"十位",@"个位"]];
            }
        }
        
    }
    return self;
}
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGFloat widh = syxwWidth;
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setAlignment:NSTextAlignmentCenter];
    CGContextRef context = UIGraphicsGetCurrentContext();
    [[UIColor whiteColor] setFill];
    UIRectFill(rect);
    
    if (self.chartsType == DSChartsBasicType) { // 号码走势
        if (self.openCodeArrCount > 5) { // 当开奖结果 位数太多时作处理
            for (int j=0; j < _numberList.count; j++) {  // 0 ~ 9 期号码
                for (int i=0; i< 1; i++) {
                    NSString *period = [NSString stringWithFormat:@"%@",_numberList[j]];
                    CGSize size = [self CommentSizeContent:period Font:[UIFont systemFontOfSize:12] size:CGSizeMake(widh, widh)];
                    [period drawInRect:CGRectMake(j*widh,(widh-size.height)/2.0+i*widh, widh, widh) withAttributes:@{NSParagraphStyleAttributeName:style,NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[UIColor colorWithRed:0.60f green:0.40f blue:0.00f alpha:1.00f]}];
                    
                    CGContextSetStrokeColorWithColor(context, lineColor.CGColor);
                    CGContextSetLineWidth(context, .4);
                    CGContextMoveToPoint(context,j*widh, 0);
                    CGContextAddLineToPoint(context, j*widh,  widh);
                    CGContextDrawPath(context, kCGPathStroke);
                }
            }
        }else{
            for (int j=0; j < _digitArray.count; j++) {  // 头文字
                for (int i=0; i< 1; i++) {
                    NSString *period = [NSString stringWithFormat:@"%@",_digitArray[j]];
                    CGSize size = [self CommentSizeContent:period Font:[UIFont systemFontOfSize:12] size:CGSizeMake(widh * 10, widh)];
                    [period drawInRect:CGRectMake(j*10*widh,(widh - size.height)/2.0+i*widh, widh * 10, widh) withAttributes:@{NSParagraphStyleAttributeName:style,NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[UIColor colorWithRed:0.60f green:0.40f blue:0.00f alpha:1.00f]}];
                    CGContextSetStrokeColorWithColor(context, lineColor.CGColor);
                    CGContextSetLineWidth(context, .4);
                    CGContextMoveToPoint(context,j*10*widh, 0);
                    CGContextAddLineToPoint(context, j*widh * 10,  widh);
                    CGContextDrawPath(context, kCGPathStroke);
                }
            }
            for (int j=0; j < _numberList.count; j++) {  // 0 ~ 9 期号码
                for (int i=0; i< 1; i++) {
                    NSString *period = [NSString stringWithFormat:@"%@",_numberList[j]];
                    CGSize size = [self CommentSizeContent:period Font:[UIFont systemFontOfSize:12] size:CGSizeMake(widh, widh)];
                    [period drawInRect:CGRectMake(j*widh,(widh * 3 - size.height)/2.0+i*widh, widh, widh) withAttributes:@{NSParagraphStyleAttributeName:style,NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[UIColor colorWithRed:0.60f green:0.40f blue:0.00f alpha:1.00f]}];
                    CGContextSetStrokeColorWithColor(context, lineColor.CGColor);
                    CGContextSetLineWidth(context, .4);
                    CGContextMoveToPoint(context,j*widh, widh);
                    CGContextAddLineToPoint(context, j*widh,  widh * 3);
                    CGContextDrawPath(context, kCGPathStroke);
                }
            }
            for (int k = 0; k< self.openCodeArrCount; k++) {
                for (int j=0; j < _numberList.count; j++) {  // 0 ~ 9 期号码
                    for (int i=0; i< 1; i++) {
                        NSString *period = [NSString stringWithFormat:@"%@",_numberList[j]];
                        CGSize size = [self CommentSizeContent:period Font:[UIFont systemFontOfSize:12] size:CGSizeMake(widh, widh)];
                        [period drawInRect:CGRectMake(k*10*widh + j*widh,(widh * 3 - size.height)/2.0+i*widh, widh, widh) withAttributes:@{NSParagraphStyleAttributeName:style,NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[UIColor colorWithRed:0.60f green:0.40f blue:0.00f alpha:1.00f]}];
                        
                        CGContextSetStrokeColorWithColor(context, lineColor.CGColor);
                        CGContextSetLineWidth(context, .4);
                        CGContextMoveToPoint(context,k * 10*widh + j*widh, widh);
                        CGContextAddLineToPoint(context,k * 10*widh + j*widh,  widh * 3);
                        CGContextDrawPath(context, kCGPathStroke);
                    }
                }
            }
            //百位 、十位、个位下来的横线条
            CGContextSetStrokeColorWithColor(context, lineColor.CGColor);
            CGContextSetLineWidth(context, .4);
            // x x轴开始位置   y : y轴开始位置
            CGContextMoveToPoint(context, 0, widh);
            // x : 画多长
            CGContextAddLineToPoint(context,widh * self.openCodeArrCount * widh * 10, widh);
            CGContextDrawPath(context, kCGPathStroke);
        }
        
    }else if (self.chartsType == DSChartsLocationType){ // 定位走势
        
        for (int j=0; j < _numberList.count; j++) {  // 0 ~ 9 期号码
            for (int i=0; i< 1; i++) {
                NSString *period = [NSString stringWithFormat:@"%@",_numberList[j]];
                CGSize size = [self CommentSizeContent:period Font:[UIFont systemFontOfSize:12] size:CGSizeMake(widh, widh)];
                [period drawInRect:CGRectMake(j*widh,(widh-size.height)/2.0+i*widh, widh, widh) withAttributes:@{NSParagraphStyleAttributeName:style,NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[UIColor colorWithRed:0.60f green:0.40f blue:0.00f alpha:1.00f]}];
                
                CGContextSetStrokeColorWithColor(context, lineColor.CGColor);
                CGContextSetLineWidth(context, .4);
                CGContextMoveToPoint(context,j*widh, 0);
                CGContextAddLineToPoint(context, j*widh,  widh);
                CGContextDrawPath(context, kCGPathStroke);
            }
        }
    }else if (self.chartsType == DSChartsSpadType){ // 跨度走势
        for (int j=0; j < _numberList.count; j++) {  // 0 ~ 9 期号码
            for (int i=0; i< 1; i++) {
                NSString *period = [NSString stringWithFormat:@"%@",_numberList[j]];
                CGSize size = [self CommentSizeContent:period Font:[UIFont systemFontOfSize:12] size:CGSizeMake(widh, widh)];
                [period drawInRect:CGRectMake(j*widh,(widh-size.height)/2.0+i*widh, widh, widh) withAttributes:@{NSParagraphStyleAttributeName:style,NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[UIColor colorWithRed:0.60f green:0.40f blue:0.00f alpha:1.00f]}];
                
                CGContextSetStrokeColorWithColor(context, lineColor.CGColor);
                CGContextSetLineWidth(context, .4);
                CGContextMoveToPoint(context,j*widh, 0);
                CGContextAddLineToPoint(context, j*widh,  widh);
                CGContextDrawPath(context, kCGPathStroke);
            }
        }
    }else if (self.chartsType == DSChartsThreeType){ // 除三余
        
        for (int j=0; j < _digitArray.count; j++) {  // 百、十、个
            for (int i=0; i< 1; i++) {
                NSString *period = [NSString stringWithFormat:@"%@",_digitArray[j]];
                CGSize size = [self CommentSizeContent:period Font:[UIFont systemFontOfSize:12] size:CGSizeMake(widh * 3, widh)];
                [period drawInRect:CGRectMake(j*3*widh,(widh - size.height)/2.0+i*widh, widh * 3, widh) withAttributes:@{NSParagraphStyleAttributeName:style,NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[UIColor colorWithRed:0.60f green:0.40f blue:0.00f alpha:1.00f]}];
                CGContextSetStrokeColorWithColor(context, lineColor.CGColor);
                CGContextSetLineWidth(context, .4);
                CGContextMoveToPoint(context,j*3*widh, 0);
                CGContextAddLineToPoint(context, j*widh * 3,  widh);
                CGContextDrawPath(context, kCGPathStroke);
            }
        }
        // 0 1 2
        for (int k = 0; k< self.openCodeArrCount; k++) {
            for (int j=0; j < _numberList.count; j++) {  // 0 ~ 2 期号码
                for (int i=0; i< 1; i++) {
                    NSString *period = [NSString stringWithFormat:@"%@",_numberList[j]];
                    CGSize size = [self CommentSizeContent:period Font:[UIFont systemFontOfSize:12] size:CGSizeMake(widh, widh)];
                    [period drawInRect:CGRectMake( k*3*widh + j*widh,(widh * 3 - size.height)/2.0+i*widh, widh, widh) withAttributes:@{NSParagraphStyleAttributeName:style,NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[UIColor colorWithRed:0.60f green:0.40f blue:0.00f alpha:1.00f]}];
                    CGContextSetStrokeColorWithColor(context, lineColor.CGColor);
                    CGContextSetLineWidth(context, .4);
                    CGContextMoveToPoint(context, k*3*widh+j*widh, widh);
                    CGContextAddLineToPoint(context,  k*3*widh+j*widh,  widh * 3);
                    CGContextDrawPath(context, kCGPathStroke);
                }
            }
        }
        //百位 、十位、个位下来的横线条
        CGContextSetStrokeColorWithColor(context, lineColor.CGColor);
        CGContextSetLineWidth(context, .4);
        // x x轴开始位置   y : y轴开始位置
        CGContextMoveToPoint(context, 0, widh);
        // x : 画多长
        CGContextAddLineToPoint(context,self.openCodeArrCount*3*widh, widh);
        CGContextDrawPath(context, kCGPathStroke);
    }
    
    
    
}
@end




















