//
//  DSChartsLeftCellHeaderView.m
//  ALLTIMELOTTERY
//
//  Created by wangzhijie on 2018/5/21.
//  Copyright © 2018年 科技有限公司. All rights reserved.
//


#import "DSChartsLeftCellHeaderView.h"
#define UIColorFromHex(s)  [UIColor colorWithRed:(((s & 0xFF0000) >> 16))/255.0 green:(((s &0xFF00) >> 8))/255.0 blue:((s &0xFF))/255.0 alpha:1.0]
#define labelTextClor UIColorFromHex(0x5f646e)
#define lineColor  UIColorFromHex(0xe3e3e3)
#define syxwWidth ([[UIScreen mainScreen] bounds].size.width/14)
#define TextCOLOR(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
@interface DSChartsLeftCellHeaderView()
@property(nonatomic, strong) NSArray * issueArr;
@property(nonatomic, strong) NSArray * resultArr;

@property(nonatomic, assign) NSInteger  openCodeCount; // 开奖结果位数
@property(nonatomic, assign) DSChartsType  chartsType; //  走势图类型
@end

@implementation DSChartsLeftCellHeaderView
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
-(instancetype)initWithFrame:(CGRect)frame andOpenCodeArrCount:(NSInteger)opneCodeArrCount andChartType:(DSChartsType)chartsType{
    if (self = [super initWithFrame:frame]) {
        self.chartsType = chartsType;
        self.openCodeCount = opneCodeArrCount;
        _issueArr = @[@"期号"];
        _resultArr = @[@"开奖号码"];
    }
    return self;
}
- (void)drawRect:(CGRect)rect {
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setAlignment:NSTextAlignmentCenter];
    CGContextRef context = UIGraphicsGetCurrentContext();
    [[UIColor whiteColor] setFill];
    UIRectFill(rect);
    CGFloat widh = syxwWidth;
    
    if (self.chartsType == DSChartsBasicType) { // 号码走势
        if (self.openCodeCount > 5) {
            for (int i=0; i<=_issueArr.count; i++) { // star
                if (i<_issueArr.count) {
                    NSString *period = _issueArr[i];
                    //调用计算字符串的宽高的方法
                    CGSize size = [self CommentSizeContent:period Font:[UIFont systemFontOfSize:11] size:CGSizeMake((widh*2) , widh)];
                    [period drawInRect:CGRectMake(0,(widh-size.height)/2.0+widh*i, widh*2, widh) withAttributes:@{NSParagraphStyleAttributeName:style, NSFontAttributeName:[UIFont boldSystemFontOfSize:11],NSForegroundColorAttributeName:labelTextClor}];
                    
                    CGContextSetStrokeColorWithColor(context, lineColor.CGColor);
                    // 线宽度
                    CGContextSetLineWidth(context, .4);
                    // 开始坐标 x  y
                    CGContextMoveToPoint(context,widh*2 + 4, 0);
                    // 添加一条线条 开始坐标 结束坐标
                    CGContextAddLineToPoint(context, widh*2 + 4,  widh);
                    ////绘制路径加填充
                    CGContextDrawPath(context, kCGPathStroke);
                }
                
            } // end
        }else{
            for (int i=0; i<=_issueArr.count; i++) { // star
                if (i<_issueArr.count) {
                    NSString *period = _issueArr[i];
                    //调用计算字符串的宽高的方法
                    CGSize size = [self CommentSizeContent:period Font:[UIFont systemFontOfSize:11] size:CGSizeMake(widh*2 , widh * 2)];
                    [period drawInRect:CGRectMake(0,(widh * 2-size.height)/2.0+widh*i, widh*2, widh*2) withAttributes:@{NSParagraphStyleAttributeName:style, NSFontAttributeName:[UIFont boldSystemFontOfSize:11],NSForegroundColorAttributeName:labelTextClor}];
                    
                    CGContextSetStrokeColorWithColor(context, lineColor.CGColor);
                    // 线宽度
                    CGContextSetLineWidth(context, .4);
                    // 开始坐标 x  y
                    CGContextMoveToPoint(context,widh*2 + 4, 0);
                    // 添加一条线条 开始坐标 结束坐标
                    CGContextAddLineToPoint(context, widh*2 + 4,  widh  * 2);
                    ////绘制路径加填充
                    CGContextDrawPath(context, kCGPathStroke);
                }
            } // end
            
            // 开奖号码
            for (int i=0; i<=_resultArr.count; i++) { // star
                if (i<_resultArr.count) {
                    NSString *period = _resultArr[i];
                    //调用计算字符串的宽高的方法
                    CGSize size = [self CommentSizeContent:period Font:[UIFont systemFontOfSize:11] size:CGSizeMake(widh*self.openCodeCount , widh * 2)];
                    [period drawInRect:CGRectMake(widh*2 + 4,(widh * 2-size.height)/2.0+widh*i, widh*self.openCodeCount , widh * 2) withAttributes:@{NSParagraphStyleAttributeName:style, NSFontAttributeName:[UIFont systemFontOfSize:11],NSForegroundColorAttributeName:[UIColor redColor]}];
                }
            } // end
        }
        
    }else if (self.chartsType == DSChartsLocationType){ // 定位走势
        
        for (int i=0; i<=_issueArr.count; i++) { // star
            if (i<_issueArr.count) {
                NSString *period = _issueArr[i];
                //调用计算字符串的宽高的方法
                CGSize size = [self CommentSizeContent:period Font:[UIFont systemFontOfSize:11] size:CGSizeMake((widh*2) , widh)];
                [period drawInRect:CGRectMake(0,(widh-size.height)/2.0+widh*i, widh*2, widh) withAttributes:@{NSParagraphStyleAttributeName:style, NSFontAttributeName:[UIFont boldSystemFontOfSize:11],NSForegroundColorAttributeName:labelTextClor}];
                
                CGContextSetStrokeColorWithColor(context, lineColor.CGColor);
                // 线宽度
                CGContextSetLineWidth(context, .4);
                // 开始坐标 x  y
                CGContextMoveToPoint(context,widh*2 + 4, 0);
                // 添加一条线条 开始坐标 结束坐标
                CGContextAddLineToPoint(context, widh*2 + 4,  widh);
                ////绘制路径加填充
                CGContextDrawPath(context, kCGPathStroke);
            }
            
        } // end
    }else if (self.chartsType == DSChartsSpadType){ // 跨度走势
        
        // 期号
        for (int i=0; i<=_issueArr.count; i++) { // star
            if (i<_issueArr.count) {
                NSString *period = _issueArr[i];
                //调用计算字符串的宽高的方法
                CGSize size = [self CommentSizeContent:period Font:[UIFont systemFontOfSize:11] size:CGSizeMake(widh*2 , widh)];
                [period drawInRect:CGRectMake(0,(widh-size.height)/2.0+widh*i,widh*2, widh) withAttributes:@{NSParagraphStyleAttributeName:style, NSFontAttributeName:[UIFont boldSystemFontOfSize:11],NSForegroundColorAttributeName:labelTextClor}];
                
                CGContextSetStrokeColorWithColor(context, lineColor.CGColor);
                // 线宽度
                CGContextSetLineWidth(context, .4);
                // 开始坐标 x  y
                CGContextMoveToPoint(context,widh*2 + 4, 0);
                // 添加一条线条 开始坐标 结束坐标
                CGContextAddLineToPoint(context, widh*2 + 4,  widh);
                ////绘制路径加填充
                CGContextDrawPath(context, kCGPathStroke);
            }
            
        } // end
        
        // 开奖号码
        for (int i=0; i<=_resultArr.count; i++) { // star
            if (i<_resultArr.count) {
                NSString *period = _resultArr[i];
                //调用计算字符串的宽高的方法
                CGSize size = [self CommentSizeContent:period Font:[UIFont systemFontOfSize:11] size:CGSizeMake((widh*self.openCodeCount) , widh)];
                
                [period drawInRect:CGRectMake(widh*2,(widh-size.height)/2.0+widh*i, widh*self.openCodeCount, widh) withAttributes:@{NSParagraphStyleAttributeName:style, NSFontAttributeName:[UIFont systemFontOfSize:11],NSForegroundColorAttributeName:[UIColor redColor]}];
                CGContextSetStrokeColorWithColor(context, lineColor.CGColor);
                // 线宽度
                //                CGContextSetLineWidth(context, .4);
                //                // 开始坐标 x  y
                //                CGContextMoveToPoint(context,widh*(self.openCodeCount + 2), 0);
                //                // 添加一条线条 开始坐标 结束坐标
                //                CGContextAddLineToPoint(context, widh*(self.openCodeCount + 2) ,  widh);
                //                ////绘制路径加填充
                //                CGContextDrawPath(context, kCGPathStroke);
            }
        } // end
        
    }else if (self.chartsType == DSChartsThreeType){ // 除三余
        
        // 除三余走势
        // 期号
        for (int i=0; i<=_issueArr.count; i++) { // star
            if (i<_issueArr.count) {
                NSString *period = _issueArr[i];
                //调用计算字符串的宽高的方法
                CGSize size = [self CommentSizeContent:period Font:[UIFont systemFontOfSize:11] size:CGSizeMake((widh*2) , widh * 2)];
                [period drawInRect:CGRectMake(0,(widh * 2 - size.height)/2.0+widh*i, widh*2, widh*2) withAttributes:@{NSParagraphStyleAttributeName:style, NSFontAttributeName:[UIFont boldSystemFontOfSize:11],NSForegroundColorAttributeName:labelTextClor}];
                
                CGContextSetStrokeColorWithColor(context, lineColor.CGColor);
                // 线宽度
                CGContextSetLineWidth(context, .4);
                // 开始坐标 x  y
                CGContextMoveToPoint(context,widh*2 + 4, 0);
                // 添加一条线条 开始坐标 结束坐标
                CGContextAddLineToPoint(context, widh*2 + 4,  widh * 2);
                ////绘制路径加填充
                CGContextDrawPath(context, kCGPathStroke);
            }
            
        } // end
        
        // 开奖号码
        for (int i=0; i<=_resultArr.count; i++) { // star
            if (i<_resultArr.count) {
                NSString *period = _resultArr[i];
                //调用计算字符串的宽高的方法
                CGSize size = [self CommentSizeContent:period Font:[UIFont systemFontOfSize:11] size:CGSizeMake((widh*self.openCodeCount) , widh*2)];
                
                [period drawInRect:CGRectMake(widh*2,(widh*2-size.height)/2.0+widh*i, widh*self.openCodeCount, widh*2) withAttributes:@{NSParagraphStyleAttributeName:style, NSFontAttributeName:[UIFont systemFontOfSize:11],NSForegroundColorAttributeName:[UIColor redColor]}];
                
                //                CGContextSetStrokeColorWithColor(context, lineColor.CGColor);
                //                // 线宽度
                //                CGContextSetLineWidth(context, .4);
                //                // 开始坐标 x  y
                //                CGContextMoveToPoint(context,(2 + self.openCodeCount)* widh + 5, 0);
                //                // 添加一条线条 开始坐标 结束坐标
                //                CGContextAddLineToPoint(context, (2 + self.openCodeCount)* widh + 5,  widh*2);
                //                ////绘制路径加填充
                //                CGContextDrawPath(context, kCGPathStroke);
            }
        } // end
        
        
    }
    
    
    
}
@end



































































