//
//  DS_LotteryOpenCodeView.m
//  DS_AA6
//
//  Created by 黄玉洲 on 2018/5/30.
//  Copyright © 2018年 黄玉洲. All rights reserved.
//

#import "DS_LotteryOpenCodeView.h"

@interface DS_LotteryOpenCodeView  () {
    
}

@end

@implementation DS_LotteryOpenCodeView

- (instancetype)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        
    }
    return self;
}

#pragma mark - 界面
- (void)layoutView {
    
}

- (void)drawRect:(CGRect)rect {
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setAlignment:NSTextAlignmentCenter];
    [COLOR(255, 242, 242) setFill];
    UIRectFill(rect);
    
    NSInteger listCount = self.codeList.count;
    CGFloat   cellHeight = self.height/(self.codeList.count +4);
    for (int i=0; i < listCount+4; i++) {
        if (i%2==1) {
            [[UIColor whiteColor] setFill];
            UIRectFill(CGRectMake(0, i*cellHeight, self.width, cellHeight));
        }
    }
    NSArray *codeArray = [[self.codeList firstObject] componentsSeparatedByString:@","];
    //画竖线
    for (int i = 1; i <= codeArray.count; i++) {
        //获得处理的上下文
        CGContextRef context = UIGraphicsGetCurrentContext();
        //设置线的颜色
        CGContextSetStrokeColorWithColor(context, COLOR(220, 220, 220).CGColor);
        CGContextMoveToPoint(context, i * self.width/codeArray.count, 0);
        CGContextAddLineToPoint(context, i * self.width/codeArray.count, self.height);
        //线宽
        CGContextSetLineWidth(context, 0.5);
        //开始绘制
        CGContextStrokePath(context);
    }
    //获得处理的上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGFloat top = (cellHeight-18)/2;
    CGFloat left = 0;
    for (int i = 0; i < self.codeList.count +4; i++) {
        if(i < self.codeList.count){
            for (int j = 0; j < codeArray.count; j++) {
                
                if([self.lotteryId isEqualToString:@"12"]){
                    UIColor*aColor = j == codeArray.count -1? COLOR( 26, 152, 248):COLOR(214, 31, 0);
                    [aColor set];
                    CGContextFillEllipseInRect(context, CGRectMake(j*self.width/codeArray.count +(self.width/codeArray.count - 24)/2, i*cellHeight + (cellHeight-24)/2,24,24));
                }else{
                    UIColor*aColor =COLOR(214, 31, 0);
                    [aColor set];
                    CGContextFillEllipseInRect(context, CGRectMake(j*self.width/codeArray.count +(self.width/codeArray.count - 24)/2, i*cellHeight + (cellHeight-24)/2,24,24));
                }
                
                NSArray *array = [self.codeList[i] componentsSeparatedByString:@","];
                UIFont  *labelFont = [UIFont systemFontOfSize:14];
                UIColor *labelColor = [UIColor whiteColor];
                UIColor *labelBackColor = [UIColor clearColor];
                NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
                style.alignment = NSTextAlignmentCenter;
                NSDictionary *dict = @{NSFontAttributeName:labelFont,NSForegroundColorAttributeName:labelColor,NSParagraphStyleAttributeName:style,NSBackgroundColorAttributeName:labelBackColor};
                [array[j] drawInRect:CGRectMake(left, i*cellHeight + top,self.width/array.count,self.height/self.codeList.count)withAttributes:dict];
                left += self.width/array.count;
            }
        }
        left = 0;
    }
}

#pragma mark - 懒加载


@end
