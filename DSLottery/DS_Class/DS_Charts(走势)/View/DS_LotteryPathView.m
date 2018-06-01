//
//  DS_LotteryPathView.m
//  DS_AA6
//
//  Created by 黄玉洲 on 2018/5/30.
//  Copyright © 2018年 黄玉洲. All rights reserved.
//

#import "DS_LotteryPathView.h"

@interface DS_LotteryPathView  () {
    
}

@end

@implementation DS_LotteryPathView

- (instancetype)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        self.backgroundColor = COLOR(255, 245, 245);
        self.titleColor = COLOR(83, 83, 83);
        [self layoutView];
    }
    return self;
}

#pragma mark - 界面
- (void)layoutView {
    
}

- (void)drawRect:(CGRect)rect {
    //设置分行颜色
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setAlignment:NSTextAlignmentCenter];
    [COLOR(255, 242, 242) setFill];
    UIRectFill(rect);
    CGFloat cellHeight = self.rowCount > 2?self.height/(self.rowCount+4):self.height/self.rowCount;
    for (int i=0; i< (self.rowCount > 2?self.rowCount+4:self.rowCount); i++) {
        if (i%2==1) {
            [[UIColor whiteColor] setFill];
            UIRectFill(CGRectMake(0, i*cellHeight, self.width,cellHeight));
        }
    }
    //画竖线
    for (int i = 1; i < self.listArray.count+ 1; i++) {
        //获得处理的上下文
        CGContextRef context = UIGraphicsGetCurrentContext();
        //设置线的颜色
        CGContextSetStrokeColorWithColor(context, COLOR(220, 220, 220).CGColor);
        //起始点设置为(0,0):注意这是上下文对应区域中的相对坐标，
        CGContextMoveToPoint(context, i * self.width/self.listArray.count, 0);
        //设置下一个坐标点
        CGContextAddLineToPoint(context, i * self.width/self.listArray.count, self.height);
        //线宽
        CGContextSetLineWidth(context, 0.5);
        //开始绘制
        CGContextStrokePath(context);
        
        if(self.rowCount < 2){
            UIFont  *labelFont = [UIFont systemFontOfSize:12];
            UIColor *labelColor = self.titleColor;
            UIColor *labelBackColor = [UIColor clearColor];
            NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
            style.alignment = NSTextAlignmentCenter;
            NSDictionary *dict = @{NSFontAttributeName:labelFont,NSForegroundColorAttributeName:labelColor,NSParagraphStyleAttributeName:style,NSBackgroundColorAttributeName:labelBackColor};
            [self.listArray[i - 1] drawInRect:CGRectMake((i-1) * self.width/self.listArray.count, (cellHeight -15)/2,self.width/self.listArray.count,cellHeight)withAttributes:dict];
            
        }
    }
    
    
    //连线
    NSMutableArray  * lineArray = [[NSMutableArray alloc]init];
    CGContextRef contextline = UIGraphicsGetCurrentContext();
    for (int j = 0; j < self.rowCount; j++) {
        for (int i = 0; i < self.sectionArray.count; i++) {
            NSArray *array = [self.sectionArray[i] componentsSeparatedByString:@"-"];
            NSInteger all = 0;
            for (NSString * num in [self.codeArray[j] componentsSeparatedByString:@","]) {
                all+=[num integerValue];
            }
            if([array[0]integerValue] <=all && [array[1]integerValue]>=all){
                //将这些点存在数组里
                NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
                [dic setValue:[NSString stringWithFormat:@"%f",i*self.width/self.listArray.count + self.width/self.listArray.count/2] forKey:@"x"];
                [dic setValue:[NSString stringWithFormat:@"%f",j*cellHeight + cellHeight/2] forKey:@"y"];
                [lineArray addObject:dic];
                
                break;
            }
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
    
    
    //显示点
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGFloat top = (cellHeight-15)/2;
    
    for (int j = 0; j < self.rowCount; j++) {
        for (int i = 0; i < self.sectionArray.count; i++) {
            NSArray *array = [self.sectionArray[i] componentsSeparatedByString:@"-"];
            NSInteger all = 0;
            for (NSString * num in [self.codeArray[j] componentsSeparatedByString:@","]) {
                all+=[num integerValue];
            }
            if([array[0]integerValue] <=all && [array[1]integerValue]>=all){
                //                UIColor*aColor = COLOR(214, 31, 0);
                //                CGContextSetFillColorWithColor(context, aColor.CGColor);//填充颜色
                //                CGContextAddArc(context, i*self.width/self.listArray.count + 12 + (self.width/self.listArray.count-24)/2,  j*cellHeight + 12 + (cellHeight-24)/2, 12, 0, 360, 0); //添加一个圆
                //                CGContextDrawPath(context, kCGPathFill);//绘制填充
                [COLOR(214, 31, 0)set];
                CGContextFillEllipseInRect(context, CGRectMake(i*self.width/self.listArray.count + (self.width/self.listArray.count - 24)/2 , j*cellHeight + (cellHeight -24)/2,24,24));
                //和值
                UIFont  *labelFont = [UIFont systemFontOfSize:13];
                UIColor *labelColor = [UIColor whiteColor];
                UIColor *labelBackColor = [UIColor clearColor];
                NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
                style.alignment = NSTextAlignmentCenter;
                NSDictionary *dict = @{NSFontAttributeName:labelFont,NSForegroundColorAttributeName:labelColor,NSParagraphStyleAttributeName:style,NSBackgroundColorAttributeName:labelBackColor};
                [[NSString stringWithFormat:@"%ld",all] drawInRect:CGRectMake(i*self.width/self.listArray.count, j*cellHeight + top,self.width/self.listArray.count,cellHeight)withAttributes:dict];
                
            }else{//随机生成一个数
                NSInteger y = [array[0]integerValue] +  (arc4random() % ([array[1]integerValue] - [array[0]integerValue] +1));
                UIFont  *labelFont = [UIFont systemFontOfSize:14];
                UIColor *labelColor = COLOR(83, 83, 83);
                UIColor *labelBackColor = [UIColor clearColor];
                NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
                style.alignment = NSTextAlignmentCenter;
                NSDictionary *dict = @{NSFontAttributeName:labelFont,NSForegroundColorAttributeName:labelColor,NSParagraphStyleAttributeName:style,NSBackgroundColorAttributeName:labelBackColor};
                [[NSString stringWithFormat:@"%ld",y] drawInRect:CGRectMake(i*self.width/self.listArray.count, j*cellHeight + top,self.width/self.listArray.count,cellHeight)withAttributes:dict];
            }
        }
    }
    
    NSMutableArray * arrs = [[NSMutableArray alloc]init];
    for (int i = 0; i < self.sectionArray.count; i++) {
        NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
        //总共出现次数
        NSInteger allpage = 0;
        //最大遗漏值
        NSInteger yilou = 0; NSInteger gudingyilou = 0;
        //最大连出值
        NSInteger lianchu = 0; NSInteger gudinglianchu = 0;
        NSArray *array = [self.sectionArray[i] componentsSeparatedByString:@"-"];
        for (int j = 0; j < self.codeArray.count; j++) {
            NSInteger all = 0;
            for (NSString * num in [self.codeArray[j] componentsSeparatedByString:@","]) {
                all+=[num integerValue];
            }
            if([array[0]integerValue] <=all && [array[1]integerValue]>=all){
                allpage++;
                if(gudingyilou < yilou){
                    gudingyilou = yilou;
                }
                yilou = 0;
                //记录连出值
                lianchu++;
            }else{
                if(gudinglianchu<lianchu){
                    gudinglianchu = lianchu;
                }
                lianchu = 0;
                //记录遗漏值
                yilou++;
            }
        }
        if(gudingyilou < yilou){
            gudingyilou = yilou;
        }
        if(gudinglianchu<lianchu){
            gudinglianchu = lianchu;
        }
        [dic setValue:[NSString stringWithFormat:@"%ld",allpage] forKey:@"all"];
        [dic setValue:[NSString stringWithFormat:@"%ld",gudingyilou] forKey:@"yilou"];
        [dic setValue:[NSString stringWithFormat:@"%ld",gudinglianchu] forKey:@"lianchu"];
        [arrs addObject:dic];
    }
    
    for (NSInteger j = self.rowCount; j < self.rowCount + 4; j++){
        for (int i = 0; i < self.sectionArray.count; i++) {
            UIFont  *labelFont = [UIFont systemFontOfSize:14];
            
            UIColor *labelBackColor = [UIColor clearColor];
            NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
            style.alignment = NSTextAlignmentCenter;
            NSDictionary * dic = arrs[i];
            if(j - self.rowCount == 0) {
                NSDictionary *dict = @{NSFontAttributeName:labelFont,NSForegroundColorAttributeName:COLOR(100, 177, 249),NSParagraphStyleAttributeName:style,NSBackgroundColorAttributeName:labelBackColor};
                [[dic objectForKey:@"all"] drawInRect:CGRectMake(i*self.width/self.listArray.count, j*cellHeight + top,self.width/self.listArray.count,cellHeight)withAttributes:dict];
            }else if (j - self.rowCount == 1){
                NSDictionary *dict = @{NSFontAttributeName:labelFont,NSForegroundColorAttributeName:COLOR(75, 211, 233),NSParagraphStyleAttributeName:style,NSBackgroundColorAttributeName:labelBackColor};
                
                NSInteger all = [[dic objectForKey:@"all"] integerValue];
                if (all != 0) {
                    NSString * drawString = [NSString stringWithFormat:@"%ld",self.rowCount / all];
                    [drawString drawInRect:CGRectMake(i*self.width/self.listArray.count, j*cellHeight + top,self.width/self.listArray.count,cellHeight) withAttributes:dict];
                }
            }else if (j - self.rowCount == 2){
                NSDictionary *dict = @{NSFontAttributeName:labelFont,NSForegroundColorAttributeName:COLOR(252, 84, 87),NSParagraphStyleAttributeName:style,NSBackgroundColorAttributeName:labelBackColor};
                [[dic objectForKey:@"yilou"] drawInRect:CGRectMake(i*self.width/self.listArray.count, j*cellHeight + top,self.width/self.listArray.count,cellHeight)withAttributes:dict];
            }else{
                NSDictionary *dict = @{NSFontAttributeName:labelFont,NSForegroundColorAttributeName:COLOR(151, 82, 50),NSParagraphStyleAttributeName:style,NSBackgroundColorAttributeName:labelBackColor};
                [[dic objectForKey:@"lianchu"] drawInRect:CGRectMake(i*self.width/self.listArray.count, j*cellHeight + top,self.width/self.listArray.count,cellHeight)withAttributes:dict];
            }
        }
    }
}


#pragma mark - 懒加载


@end
