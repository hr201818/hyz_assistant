//
//  DS_LotteryJiOuPathView.m
//  DSLottery
//
//  Created by 黄玉洲 on 2018/6/1.
//  Copyright © 2018年 海南达生实业有限公司. All rights reserved.
//

#import "DS_LotteryJiOuPathView.h"

@interface DS_LotteryJiOuPathView ()

@end

@implementation DS_LotteryJiOuPathView

- (instancetype)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        [self layoutView];
    }
    return self;
}

#pragma mark - 界面
- (void)layoutView {
    
}

-(void)drawRect:(CGRect)rect{
    
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
    //画竖线
    for (int i = 0; i <3; i++) {
        //获得处理的上下文
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetStrokeColorWithColor(context, COLOR(220, 220, 220).CGColor);
        CGContextMoveToPoint(context, i * self.width/2, 0);
        CGContextAddLineToPoint(context, i * self.width/2, self.height);
        //线宽
        CGContextSetLineWidth(context, 0.5);
        //开始绘制
        CGContextStrokePath(context);
    }
    
    //连线
    NSMutableArray  * lineArray = [[NSMutableArray alloc]init];
    CGContextRef contextline = UIGraphicsGetCurrentContext();
    for (int i = 0; i < self.codeList.count; i++) {
        NSString * code = self.codeList[i];
        if([code integerValue]%2 == 0){
            NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
            [dic setValue:[NSString stringWithFormat:@"%f",self.width/4 + self.width/2] forKey:@"x"];
            [dic setValue:[NSString stringWithFormat:@"%f",i*cellHeight + cellHeight/2] forKey:@"y"];
            [lineArray addObject:dic];
        }else{
            NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
            [dic setValue:[NSString stringWithFormat:@"%f",self.width/4] forKey:@"x"];
            [dic setValue:[NSString stringWithFormat:@"%f",i*cellHeight + cellHeight/2] forKey:@"y"];
            [lineArray addObject:dic];
        }
    }
    //绘制连线
    for (int i = 0; i <lineArray.count ; i++) {
        NSDictionary * dic = lineArray[i];
        if(i == 0){
            CGContextMoveToPoint(contextline, [[dic objectForKey:@"x"]floatValue], [[dic objectForKey:@"y"]floatValue]);
        }else{
            CGContextAddLineToPoint(contextline, [[dic objectForKey:@"x"]floatValue], [[dic objectForKey:@"y"]floatValue]);
        }
    }
    CGContextSetStrokeColorWithColor(contextline, COLOR(214, 31, 0).CGColor);
    CGContextSetLineWidth(contextline, 1);
    CGContextStrokePath(contextline);
    
    
    //获得处理的上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGFloat top = (cellHeight-18)/2;
    CGFloat left = 0;
    //最大遗漏
    NSInteger  jiyilou = 0; NSInteger jizuidayilou = 0;
    NSInteger  ouyilou = 0; NSInteger ouzuidayilou = 0;
    //连出值
    NSInteger  jilianchu = 0; NSInteger jizuidalianchu = 0;
    NSInteger  oulianchu = 0; NSInteger ouzuidalianchu = 0;
    //总次数
    NSInteger  ji = 0;    NSInteger ou = 0;
    for (int i = 0; i < self.codeList.count; i++) {
        NSString * code = self.codeList[i];
        UIFont  *labelFont = [UIFont systemFontOfSize:14];
        UIColor *labelColor = [UIColor whiteColor];
        UIColor *labelBackColor = [UIColor clearColor];
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        style.alignment = NSTextAlignmentCenter;
        NSDictionary *dict = @{NSFontAttributeName:labelFont,NSForegroundColorAttributeName:labelColor,NSParagraphStyleAttributeName:style,NSBackgroundColorAttributeName:labelBackColor};
        
        if([code integerValue]%2 == 0){
            [COLOR(26, 152, 248)set];
            CGContextFillEllipseInRect(context, CGRectMake((self.width/4 -left)/2 + self.width/2, i*cellHeight + (cellHeight -24)/2,24,24));
            [code drawInRect:CGRectMake(self.width/2, i*cellHeight + top,self.width/2,self.height/self.codeList.count)withAttributes:dict];
            //遗漏
            jiyilou++;
            if(ouyilou > ouzuidayilou){
                ouzuidayilou = ouyilou;
            }
            ouyilou = 0;
            //连出
            oulianchu++;
            if(jizuidalianchu < jilianchu){
                jizuidalianchu = jilianchu;
            }
            jilianchu = 0;
            //总次数
            ou++;
        }else{
            [COLOR(228, 87, 34)set];
            CGContextFillEllipseInRect(context, CGRectMake((self.width/4 -left)/2, i*cellHeight + (cellHeight -24)/2,24,24));
            [code drawInRect:CGRectMake(left, i*cellHeight + top,self.width/2,self.height/self.codeList.count)withAttributes:dict];
            //遗漏
            if(jiyilou >jizuidayilou){
                jizuidayilou = jiyilou;
            }
            jiyilou = 0;
            ouyilou++;
            //连出
            if(ouzuidalianchu < oulianchu){
                ouzuidalianchu = oulianchu;
            }
            oulianchu = 0;
            jilianchu++;
            //总次数
            ji++;
        }
        if(i == self.codeList.count -1){
            if(ouyilou > ouzuidayilou){
                ouzuidayilou = ouyilou;
            }
            if(jizuidalianchu < jilianchu){
                jizuidalianchu = jilianchu;
            }
            if(ouzuidalianchu < oulianchu){
                ouzuidalianchu = oulianchu;
            }
            if(jiyilou >jizuidayilou){
                jizuidayilou = jiyilou;
            }
        }
    }
    
    for (NSInteger i = self.codeList.count; i < self.codeList.count + 4; i++) {
        UIFont  *labelFont = [UIFont systemFontOfSize:14];
        UIColor *labelBackColor = [UIColor clearColor];
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        style.alignment = NSTextAlignmentCenter;
        if(self.codeList.count == i){
            NSDictionary *dict = @{NSFontAttributeName:labelFont,NSForegroundColorAttributeName:COLOR(100, 177, 249),NSParagraphStyleAttributeName:style,NSBackgroundColorAttributeName:labelBackColor};
            [[NSString stringWithFormat:@"%ld",ji] drawInRect:CGRectMake(left, i*cellHeight + top,self.width/2,self.height/self.codeList.count)withAttributes:dict];
            [[NSString stringWithFormat:@"%ld",ou] drawInRect:CGRectMake(self.width/2, i*cellHeight + top,self.width/2,self.height/self.codeList.count)withAttributes:dict];
        }else if (self.codeList.count + 1 == i){
            NSDictionary *dict = @{NSFontAttributeName:labelFont,NSForegroundColorAttributeName:COLOR(75, 211, 233),NSParagraphStyleAttributeName:style,NSBackgroundColorAttributeName:labelBackColor};
            [[NSString stringWithFormat:@"%ld",self.codeList.count/ji] drawInRect:CGRectMake(left, i*cellHeight + top,self.width/2,self.height/self.codeList.count)withAttributes:dict];
            [[NSString stringWithFormat:@"%ld",self.codeList.count/ou] drawInRect:CGRectMake(self.width/2, i*cellHeight + top,self.width/2,self.height/self.codeList.count)withAttributes:dict];
        }else if (self.codeList.count + 2 == i){
            NSDictionary *dict = @{NSFontAttributeName:labelFont,NSForegroundColorAttributeName:COLOR(252, 84, 87),NSParagraphStyleAttributeName:style,NSBackgroundColorAttributeName:labelBackColor};
            [[NSString stringWithFormat:@"%ld",jizuidayilou] drawInRect:CGRectMake(left, i*cellHeight + top,self.width/2,self.height/self.codeList.count)withAttributes:dict];
            [[NSString stringWithFormat:@"%ld",ouzuidayilou] drawInRect:CGRectMake(self.width/2, i*cellHeight + top,self.width/2,self.height/self.codeList.count)withAttributes:dict];
        }else{
            NSDictionary *dict = @{NSFontAttributeName:labelFont,NSForegroundColorAttributeName:COLOR(151, 82, 50),NSParagraphStyleAttributeName:style,NSBackgroundColorAttributeName:labelBackColor};
            [[NSString stringWithFormat:@"%ld",jizuidalianchu] drawInRect:CGRectMake(left, i*cellHeight + top,self.width/2,self.height/self.codeList.count)withAttributes:dict];
            [[NSString stringWithFormat:@"%ld",ouzuidalianchu] drawInRect:CGRectMake(self.width/2, i*cellHeight + top,self.width/2,self.height/self.codeList.count)withAttributes:dict];
        }
    }
}

#pragma mark - 懒加载


@end
