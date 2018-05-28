//
//  DSChartsLeftCellView.m
//  ALLTIMELOTTERY
//
//  Created by wangzhijie on 2018/5/21.
//  Copyright © 2018年 科技有限公司. All rights reserved.
//

#import "DSChartsLeftCellView.h"
#define UIColorFromHex(s)  [UIColor colorWithRed:(((s & 0xFF0000) >> 16))/255.0 green:(((s &0xFF00) >> 8))/255.0 blue:((s &0xFF))/255.0 alpha:1.0]
#define labelTextClor UIColorFromHex(0x5f646e)
#define lineColor  UIColorFromHex(0xe3e3e3)
#define syxwWidth ([[UIScreen mainScreen] bounds].size.width/14)
#define TextCOLOR(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
@interface DSChartsLeftCellView()
@property(nonatomic, strong) NSMutableArray * issueArr; // 期号
@property(nonatomic, strong) NSMutableArray * frameArr; // 保存圆中心的位置、连线
@property(nonatomic, strong) NSMutableArray * lotteryNumberArr; // 开奖结果总数组
@property(nonatomic, strong) NSMutableArray * listArr; //当前位开奖结果素组
@property(nonatomic, strong) NSMutableArray * resultArr; //当前位开奖结果素组
@property(nonatomic, assign) DSChartsType chartType; // 走势类型
@property(nonatomic, strong) NSMutableArray * spanValues; // 号码表
@end


@implementation DSChartsLeftCellView
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
- (instancetype)initWithFrame:(CGRect)frame andIssueArr:(NSArray *)issueArr andListArr:(NSArray *)listArr andResutArr:(NSArray *)resultArr andLotteryNumberArr:(NSArray *)lotteryNumberArr andSpanValue:(NSArray *)spanValues andChartType:(DSChartsType)charType{
    
    if (self = [super initWithFrame:frame]) {
        self.chartType = charType;
        self.issueArr = [[NSMutableArray alloc] initWithArray:issueArr];
        self.frameArr = [[NSMutableArray  alloc] initWithCapacity:0];
        self.listArr = [[NSMutableArray alloc] initWithArray:listArr];
        self.lotteryNumberArr = [[NSMutableArray alloc] initWithArray:lotteryNumberArr];
        self.resultArr = [[NSMutableArray alloc] initWithArray:resultArr];
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
    if (self.chartType == DSChartsBasicType) { // 号码走势start
        NSArray * openCodeArr;
        if (self.lotteryNumberArr.count > 0) {
            openCodeArr = self.lotteryNumberArr[0];
        }
        if (openCodeArr.count > 5) { // 开奖结果大于5位摆放不下 做特殊处理
            //widh 为格子的高度 7是离上边界的距离 不设置 就会出现显示边界的线不好控制
            for (int i=0; i<=_issueArr.count; i++) {
                if (i<_issueArr.count) {
                    NSString *period =[NSString stringWithFormat:@"%@",_issueArr[i]];
                    //调用计算字符串的宽高的方法
                    CGSize size = [self CommentSizeContent:period Font:[UIFont systemFontOfSize:11] size:CGSizeMake(i < _issueArr.count - 4 ? widh*2:widh*3 , widh)];
                    [period drawInRect:CGRectMake(0,(widh-size.height)/2.0+widh*i, i < _issueArr.count - 4?widh*2:widh*3, widh) withAttributes:@{NSParagraphStyleAttributeName:style, NSFontAttributeName:[UIFont systemFontOfSize:11],NSForegroundColorAttributeName:[self getTrendTextColor:i arrCount:_issueArr.count]}];
                }
            }
            // 颜色
            CGContextSetStrokeColorWithColor(context, lineColor.CGColor);
            // 线宽度
            CGContextSetLineWidth(context, .4);
            // 开始坐标 x  y
            CGContextMoveToPoint(context,widh*2 + 4, 0);
            // 添加一条线条 开始坐标 结束坐标
            // 这是一条长线
            CGContextAddLineToPoint(context, widh*2 + 4, _issueArr.count > 4? (_issueArr.count - 4)*widh:_issueArr.count * widh);
            ////绘制路径加填充
            CGContextDrawPath(context, kCGPathStroke);
            // 对应的位数开奖结果
            for (int i = 0; i < _resultArr.count; i++) {
                if (i < _resultArr.count) {
                    NSString *period =[NSString stringWithFormat:@"%@",_resultArr[i]];
                    //调用计算字符串的宽高的方法
                    CGSize size = [self CommentSizeContent:period Font:[UIFont systemFontOfSize:11] size:CGSizeMake( i < _resultArr.count?widh:0 , widh)];
                    //i < _endArr.count?widh*2:widh*4  判断 好给出现总次数、 平均遗漏值、最大遗漏值、最大连出值 的宽度
                    // 画文字  期号多少期
                    [period drawInRect:CGRectMake(widh*2 + 4,(widh-size.height)/2.0+widh*i,  i < _resultArr.count?widh:widh*4, widh) withAttributes:@{NSParagraphStyleAttributeName:style, NSFontAttributeName:[UIFont systemFontOfSize:11],NSForegroundColorAttributeName:[UIColor redColor]}];
                    //画线条
                }
            } //end
        }else{ // 开奖结果小于等于5位 全部显示
            //widh 为格子的高度 7是离上边界的距离 不设置 就会出现显示边界的线不好控制
            for (int i=0; i<=_issueArr.count; i++) {
                if (i<_issueArr.count) {
                    NSString *period =[NSString stringWithFormat:@"%@",_issueArr[i]];
                    if (openCodeArr.count > 7) {
                        CGSize size = [self CommentSizeContent:period Font:[UIFont systemFontOfSize:11] size:CGSizeMake(widh* 2 , widh)];
                        [period drawInRect:CGRectMake(0,(widh-size.height)/2.0+widh*i,   widh*2, widh) withAttributes:@{NSParagraphStyleAttributeName:style, NSFontAttributeName:[UIFont systemFontOfSize:11],NSForegroundColorAttributeName:[self getTrendTextColor:i arrCount:_issueArr.count]}];
                    }else{
                        //调用计算字符串的宽高的方法
                        CGSize size = [self CommentSizeContent:period Font:[UIFont systemFontOfSize:11] size:CGSizeMake( i < _issueArr.count - 4?widh*2:widh*(openCodeArr.count + 2) , widh)];
                        [period drawInRect:CGRectMake(0,(widh-size.height)/2.0+widh*i,  i < _issueArr.count - 4?widh*2:widh*(openCodeArr.count + 2), widh) withAttributes:@{NSParagraphStyleAttributeName:style, NSFontAttributeName:[UIFont systemFontOfSize:11],NSForegroundColorAttributeName:[self getTrendTextColor:i arrCount:_issueArr.count]}];
                    }
                }
            }
            //画线条
            // 颜色
            CGContextSetStrokeColorWithColor(context, lineColor.CGColor);
            // 线宽度
            CGContextSetLineWidth(context, .4);
            // 开始坐标 x  y
            CGContextMoveToPoint(context,widh*2 + 4, 0);
            // 添加一条线条 开始坐标 结束坐标
            // 这是一条长线
            CGContextAddLineToPoint(context, widh*2 + 4, _issueArr.count > 4? (_issueArr.count - 4)*widh:_issueArr.count * widh);
            ////绘制路径加填充
            CGContextDrawPath(context, kCGPathStroke);
            
            [self.lotteryNumberArr enumerateObjectsUsingBlock:^( NSArray * obj, NSUInteger idx, BOOL * _Nonnull stop) {
                // 开奖结果  万位 endArr 结果数组
                for (int i = 0; i < obj.count; i++) {
                    if (i < obj.count) {
                        NSString *period =[NSString stringWithFormat:@"%@",obj[i]];
                        //调用计算字符串的宽高的方法
                        CGSize size = [self CommentSizeContent:period Font:[UIFont systemFontOfSize:11] size:CGSizeMake(widh, widh)];
                        //((widh-size.height)/2.0+widh*i)  widh * idx
                        [period drawInRect:CGRectMake((widh*2 -2) + ((widh-size.height)/2.0+widh*i),widh * idx + (widh-size.height)/2.0, widh, widh) withAttributes:@{NSParagraphStyleAttributeName:style, NSFontAttributeName:[UIFont systemFontOfSize:11],NSForegroundColorAttributeName:[UIColor redColor]}];
                        //画线条
                        // 颜色
                        CGContextSetStrokeColorWithColor(context, lineColor.CGColor);
                        // 线宽度
                        CGContextSetLineWidth(context, .4);
                        // 开始坐标 x  y
                        CGContextMoveToPoint(context,(widh*2-2) + (widh-size.height)/2.0+widh*(i+1), 0);
                        // 添加一条线条 开始坐标 结束坐标
                        // 这是一条长线
                        CGContextAddLineToPoint(context, (widh*2 -2) + (widh-size.height)/2.0+widh*(i+1), _issueArr.count > 4? (_issueArr.count - 4)*widh:_issueArr.count * widh);
                        ////绘制路径加填充
                        CGContextDrawPath(context, kCGPathStroke);
                    }
                }
            }];
        }
    }else if (self.chartType == DSChartsLocationType){ // 定位走势
        
        for (int i=0; i<=_issueArr.count; i++) {
            if (i<_issueArr.count) {
                NSString *period =[NSString stringWithFormat:@"%@",_issueArr[i]];
                //调用计算字符串的宽高的方法
                CGSize size = [self CommentSizeContent:period Font:[UIFont systemFontOfSize:11] size:CGSizeMake(i < _issueArr.count - 4 ? widh*2:widh*3 , widh)];
                [period drawInRect:CGRectMake(0,(widh-size.height)/2.0+widh*i, i < _issueArr.count - 4?widh*2:widh*3, widh) withAttributes:@{NSParagraphStyleAttributeName:style, NSFontAttributeName:[UIFont systemFontOfSize:11],NSForegroundColorAttributeName:[self getTrendTextColor:i arrCount:_issueArr.count]}];
            }
        }
        // 颜色
        CGContextSetStrokeColorWithColor(context, lineColor.CGColor);
        // 线宽度
        CGContextSetLineWidth(context, .4);
        // 开始坐标 x  y
        CGContextMoveToPoint(context,widh*2 + 4, 0);
        // 添加一条线条 开始坐标 结束坐标
        // 这是一条长线
        CGContextAddLineToPoint(context, widh*2 + 4, _issueArr.count > 4? (_issueArr.count - 4)*widh:_issueArr.count * widh);
        ////绘制路径加填充
        CGContextDrawPath(context, kCGPathStroke);
        // 对应的位数开奖结果
        for (int i = 0; i < _resultArr.count; i++) {
            if (i < _resultArr.count) {
                NSString *period =[NSString stringWithFormat:@"%@",_resultArr[i]];
                //调用计算字符串的宽高的方法
                CGSize size = [self CommentSizeContent:period Font:[UIFont systemFontOfSize:11] size:CGSizeMake( i < _resultArr.count?widh:0 , widh)];
                //i < _endArr.count?widh*2:widh*4  判断 好给出现总次数、 平均遗漏值、最大遗漏值、最大连出值 的宽度
                // 画文字  期号多少期
                [period drawInRect:CGRectMake(widh*2 + 4,(widh-size.height)/2.0+widh*i,  i < _resultArr.count?widh:widh*4, widh) withAttributes:@{NSParagraphStyleAttributeName:style, NSFontAttributeName:[UIFont systemFontOfSize:11],NSForegroundColorAttributeName:[UIColor redColor]}];
                //画线条
            }
        } //  开奖结果 end
        
    }else if (self.chartType == DSChartsSpadType){ // 跨度走势
        NSArray * openCodeArr;
        if (self.lotteryNumberArr.count > 0) {
            openCodeArr = self.lotteryNumberArr[0];
        }
        
        // widh 为格子的高度 7是离上边界的距离 不设置 就会出现显示边界的线不好控制
        for (int i=0; i<=_issueArr.count; i++) { // 期号
            if (i<_issueArr.count) {
                NSString *period =[NSString stringWithFormat:@"%@",_issueArr[i]];
                //调用计算字符串的宽高的方法
                if (openCodeArr.count > 7) {
                    CGSize size = [self CommentSizeContent:period Font:[UIFont systemFontOfSize:11] size:CGSizeMake( 2 * widh , widh)];
                    [period drawInRect:CGRectMake(2,(widh-size.height)/2.0+widh*i,  2 * widh, widh) withAttributes:@{NSParagraphStyleAttributeName:style, NSFontAttributeName:[UIFont systemFontOfSize:11],NSForegroundColorAttributeName:[self getTrendTextColor:i arrCount:_issueArr.count]}];
                    
                }else{
                    CGSize size = [self CommentSizeContent:period Font:[UIFont systemFontOfSize:11] size:CGSizeMake(i < _issueArr.count - 4?(widh*2):widh*(2 + openCodeArr.count) , widh)];
                    [period drawInRect:CGRectMake(2,(widh-size.height)/2.0+widh*i,  i < _issueArr.count - 4?widh*2:widh*(2 + openCodeArr.count), widh) withAttributes:@{NSParagraphStyleAttributeName:style, NSFontAttributeName:[UIFont systemFontOfSize:11],NSForegroundColorAttributeName:[self getTrendTextColor:i arrCount:_issueArr.count]}];
                }
                //画线条
                // 颜色
                CGContextSetStrokeColorWithColor(context, lineColor.CGColor);
                // 线宽度
                CGContextSetLineWidth(context, .4);
                // 开始坐标 x  y
                CGContextMoveToPoint(context,widh*2 + 4, 0);
                // 添加一条线条 开始坐标 结束坐标
                // 这是一条长线
                CGContextAddLineToPoint(context, widh*2 + 4, _issueArr.count > 4? (_issueArr.count - 4)*widh:_issueArr.count * widh);
                //绘制路径加填充
                CGContextDrawPath(context, kCGPathStroke);
            }
        }
        
        if (openCodeArr.count > 7) {
            
        }else{
            [self.lotteryNumberArr enumerateObjectsUsingBlock:^( NSArray * obj, NSUInteger idx, BOOL * _Nonnull stop) {
                // 开奖结果  万位 endArr 结果数组
                for (int i = 0; i < obj.count; i++) {
                    if (i < obj.count) {
                        NSString *period =[NSString stringWithFormat:@"%@",obj[i]];
                        //调用计算字符串的宽高的方法
                        CGSize size = [self CommentSizeContent:period Font:[UIFont systemFontOfSize:11] size:CGSizeMake(widh, widh)];
                        //((widh-size.height)/2.0+widh*i)  widh * idx
                        [period drawInRect:CGRectMake((widh*2 -2) + ((widh-size.height)/2.0+widh*i),widh * idx + (widh-size.height)/2.0, widh, widh) withAttributes:@{NSParagraphStyleAttributeName:style, NSFontAttributeName:[UIFont systemFontOfSize:11],NSForegroundColorAttributeName:[UIColor redColor]}];
                        //画线条
                        // 颜色
                        CGContextSetStrokeColorWithColor(context, lineColor.CGColor);
                        // 线宽度
                        CGContextSetLineWidth(context, .4);
                        // 开始坐标 x  y
                        CGContextMoveToPoint(context,(widh*2-2) + (widh-size.height)/2.0+widh*(i+1), 0);
                        // 添加一条线条 开始坐标 结束坐标
                        // 这是一条长线
                        CGContextAddLineToPoint(context, (widh*2 -2) + (widh-size.height)/2.0+widh*(i+1), _issueArr.count > 4? (_issueArr.count - 4)*widh:_issueArr.count * widh);
                        ////绘制路径加填充
                        CGContextDrawPath(context, kCGPathStroke);
                    }
                }
            }];
        }
        
    }else if (self.chartType == DSChartsThreeType){ // 除三余
        
        NSArray * openCodeArr;
        if (self.lotteryNumberArr.count > 0) {
            openCodeArr = self.lotteryNumberArr[0];
        }
        
        // widh 为格子的高度 7是离上边界的距离 不设置 就会出现显示边界的线不好控制
        for (int i=0; i<=_issueArr.count; i++) {
            if (i<_issueArr.count) {
                NSString *period =[NSString stringWithFormat:@"%@",_issueArr[i]];
                
                if (openCodeArr.count > 7) {
                    //调用计算字符串的宽高的方法
                    CGSize size = [self CommentSizeContent:period Font:[UIFont systemFontOfSize:11] size:CGSizeMake( 2 * widh , widh)];
                    //i < _endArr.count?widh*2:widh*4  判断 好给出现总次数、 平均遗漏值、最大遗漏值、最大连出值 的宽度
                    // 画文字  期号多少期
                    [period drawInRect:CGRectMake(2,(widh-size.height)/2.0+widh*i,widh*2, widh) withAttributes:@{NSParagraphStyleAttributeName:style, NSFontAttributeName:[UIFont systemFontOfSize:11],NSForegroundColorAttributeName:[self getTrendTextColor:i arrCount:_issueArr.count]}];
                }else{
                    //调用计算字符串的宽高的方法
                    CGSize size = [self CommentSizeContent:period Font:[UIFont systemFontOfSize:11] size:CGSizeMake( i < _issueArr.count - 4?widh*2:widh*(openCodeArr.count+2) , widh)];
                    //i < _endArr.count?widh*2:widh*4  判断 好给出现总次数、 平均遗漏值、最大遗漏值、最大连出值 的宽度
                    // 画文字  期号多少期
                    [period drawInRect:CGRectMake(2,(widh-size.height)/2.0+widh*i,  i < _issueArr.count - 4?widh*2:widh*(openCodeArr.count+2), widh) withAttributes:@{NSParagraphStyleAttributeName:style, NSFontAttributeName:[UIFont systemFontOfSize:11],NSForegroundColorAttributeName:[self getTrendTextColor:i arrCount:_issueArr.count]}];
                }
                //画线条
                // 颜色
                CGContextSetStrokeColorWithColor(context, lineColor.CGColor);
                // 线宽度
                CGContextSetLineWidth(context, .4);
                
                // 开始坐标 x  y
                CGContextMoveToPoint(context,widh*2 + 4, 0);
                // 添加一条线条 开始坐标 结束坐标
                // 这是一条长线
                CGContextAddLineToPoint(context, widh*2 + 4, _issueArr.count > 4? (_issueArr.count - 4)*widh:_issueArr.count * widh);
                ////绘制路径加填充
                CGContextDrawPath(context, kCGPathStroke);
            }
        }
        
        if (openCodeArr.count > 7) {
            
        }else{
            [self.lotteryNumberArr enumerateObjectsUsingBlock:^( NSArray * obj, NSUInteger idx, BOOL * _Nonnull stop) {
                // 开奖结果
                for (int i = 0; i < obj.count; i++) {
                    if (i < obj.count) {
                        NSString *period =[NSString stringWithFormat:@"%@",obj[i]];
                        //调用计算字符串的宽高的方法
                        CGSize size = [self CommentSizeContent:period Font:[UIFont systemFontOfSize:11] size:CGSizeMake(widh, widh)];
                        //((widh-size.height)/2.0+widh*i)  widh * idx
                        [period drawInRect:CGRectMake((widh*2 -2) + ((widh-size.height)/2.0+widh*i),widh * idx + (widh-size.height)/2.0, widh, widh) withAttributes:@{NSParagraphStyleAttributeName:style, NSFontAttributeName:[UIFont systemFontOfSize:11],NSForegroundColorAttributeName:[UIColor redColor]}];
                        //画线条
                        // 颜色
                        CGContextSetStrokeColorWithColor(context, lineColor.CGColor);
                        // 线宽度
                        CGContextSetLineWidth(context, .4);
                        // 开始坐标 x  y
                        CGContextMoveToPoint(context,(widh*2-2) + (widh-size.height)/2.0+widh*(i+1), 0);
                        // 添加一条线条 开始坐标 结束坐标
                        // 这是一条长线
                        CGContextAddLineToPoint(context, (widh*2 -2) + (widh-size.height)/2.0+widh*(i+1), _issueArr.count > 4? (_issueArr.count - 4)*widh:_issueArr.count * widh);
                        ////绘制路径加填充
                        CGContextDrawPath(context, kCGPathStroke);
                    }
                }
            }];
        }
    }
    
}
- (void)dealloc{
    NSLog(@"%@",[self class]);
}
@end


























































