//
//  DSSumView.m
//  DS_lottery
//
//  Created by pro on 2018/5/10.
//  Copyright © 2018年 海南达生实业有限公司. All rights reserved.
//

#import "DSSumView.h"

@implementation DSSumView

-(void)drawRect:(CGRect)rect{
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setAlignment:NSTextAlignmentCenter];
    UIFont *labelFont = [UIFont systemFontOfSize:15];
    UIColor *labelColor = COLOR(26, 152, 248);
    UIColor *labelBackColor = [UIColor clearColor];
    [COLOR(255, 242, 242) setFill];
    UIRectFill(rect);

    NSInteger listCount = self.codeArray.count;
    CGFloat cellHeight = self.height/(listCount+4);

    for (int i=0; i<listCount+4; i++) {
        if (i%2==1) {
            [[UIColor whiteColor] setFill];
            UIRectFill(CGRectMake(0, i*cellHeight, self.width, cellHeight));
        }
        if(i<listCount){
            NSInteger all = 0;
            for (NSString * num in [self.codeArray[i] componentsSeparatedByString:@","]) {
                all+=[num integerValue];
            }
            NSDictionary *dict = @{NSFontAttributeName:labelFont,NSForegroundColorAttributeName:labelColor,NSParagraphStyleAttributeName:style,NSBackgroundColorAttributeName:labelBackColor};
            [[NSString stringWithFormat:@"%ld",all] drawInRect:CGRectMake(0,i*cellHeight+ (cellHeight - 18)/2,self.width, cellHeight) withAttributes:dict];
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

@end
