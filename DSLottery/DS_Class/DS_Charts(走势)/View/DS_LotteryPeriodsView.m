//
//  DS_LotteryPeriodsView.m
//  DS_AA6
//
//  Created by 黄玉洲 on 2018/5/30.
//  Copyright © 2018年 黄玉洲. All rights reserved.
//

#import "DS_LotteryPeriodsView.h"

@interface DS_LotteryPeriodsView  () {
    
}

@end

@implementation DS_LotteryPeriodsView

- (instancetype)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        self.backgroundColor = COLOR(255, 245, 245);
        [self layoutView];
    }
    return self;
}

#pragma mark - 界面
- (void)layoutView {
    
}

- (void)drawRect:(CGRect)rect {
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setAlignment:NSTextAlignmentCenter];
    UIFont *labelFont = [UIFont systemFontOfSize:13];
    UIColor *labelColor = COLOR(83, 83, 83);
    UIColor *labelBackColor = [UIColor clearColor];
    [COLOR(255, 242, 242) setFill];
    UIRectFill(rect);
    
    NSInteger listCount = _periodsNumber.count;
    
    CGFloat cellHeight = self.height/(listCount+4);
    
    for (int i=0; i<listCount+4; i++) {
        if (i%2==1) {
            [[UIColor whiteColor] setFill];
            UIRectFill(CGRectMake(0, i*cellHeight, self.width, cellHeight));
        }
        if(i == listCount){
            NSDictionary *dict = @{NSFontAttributeName:[UIFont systemFontOfSize:13],NSForegroundColorAttributeName:COLOR(100, 177, 249),NSParagraphStyleAttributeName:style,NSBackgroundColorAttributeName:labelBackColor};
            [@"出现总次数" drawInRect:CGRectMake(0,i*cellHeight+ (cellHeight - 18)/2,self.width, cellHeight) withAttributes:dict];
        }else if(i==listCount +1){
            NSDictionary *dict = @{NSFontAttributeName:[UIFont systemFontOfSize:13],NSForegroundColorAttributeName:COLOR(75, 211, 233),NSParagraphStyleAttributeName:style,NSBackgroundColorAttributeName:labelBackColor};
            [@"平均遗漏值" drawInRect:CGRectMake(0,i*cellHeight+ (cellHeight - 18)/2,self.width, cellHeight) withAttributes:dict];
        }else if(i==listCount +2){
            NSDictionary *dict = @{NSFontAttributeName:[UIFont systemFontOfSize:13],NSForegroundColorAttributeName:COLOR(252, 84, 87),NSParagraphStyleAttributeName:style,NSBackgroundColorAttributeName:labelBackColor};
            [@"最大遗漏值" drawInRect:CGRectMake(0,i*cellHeight+ (cellHeight - 18)/2,self.width, cellHeight) withAttributes:dict];
        }else if(i==listCount +3){
            NSDictionary *dict = @{NSFontAttributeName:[UIFont systemFontOfSize:13],NSForegroundColorAttributeName:COLOR(151, 82, 50),NSParagraphStyleAttributeName:style,NSBackgroundColorAttributeName:labelBackColor};
            [@"最大连出值" drawInRect:CGRectMake(0,i*cellHeight+ (cellHeight - 18)/2,self.width, cellHeight) withAttributes:dict];
        }else{
            NSDictionary *dict = @{NSFontAttributeName:labelFont,NSForegroundColorAttributeName:labelColor,NSParagraphStyleAttributeName:style,NSBackgroundColorAttributeName:labelBackColor};
            [self.periodsNumber[i] drawInRect:CGRectMake(0,i*cellHeight+ (cellHeight - 18)/2,self.width, cellHeight) withAttributes:dict];
        }
    }
    //获得处理的上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    //设置线的颜色
    CGContextSetStrokeColorWithColor(context, COLOR(220, 220, 220).CGColor);
    //起始点设置为(0,0):注意这是上下文对应区域中的相对坐标，
    CGContextMoveToPoint(context, self.width, 0);
    //设置下一个坐标点
    CGContextAddLineToPoint(context, self.width, self.height);
    //开始绘制
    CGContextStrokePath(context);
}

#pragma mark - 懒加载


@end
