//
//  DS_DrawDigitalView.m
//  DSLottery
//
//  Created by 黄玉洲 on 2018/5/14.
//  Copyright © 2018年 海南达生实业有限公司. All rights reserved.
//

#import "DS_DrawDigitalView.h"

@interface DS_DrawDigitalView () {
    NSInteger _number;
}

@end

@implementation DS_DrawDigitalView


/**
 初始化
 @param frame  尺寸
 @param number 要绘制数字
 @return 绘制后的视图
 */
- (instancetype)initWithFrame:(CGRect)frame number:(NSInteger)number {
    if ([super initWithFrame:frame]) {
        _number = number;
        self.backgroundColor = [UIColor clearColor];
        [self initData];
    }
    return self;
}

#pragma mark - 初始化
- (void)initData {
    _textColor = [UIColor redColor];
    _borderColor = [UIColor redColor];
}

- (void)drawRect:(CGRect)rect {
    
    CGFloat width = rect.size.width;
    NSString * numberStr = [NSString stringWithFormat:@"%ld", _number];
    
    // 获取上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // 绘制圆形
    CGContextSetLineWidth(context, 1);
    CGContextAddArc(context, width / 2, width / 2, width / 2 - 2, 0, M_PI * 2, YES);
    CGContextSetStrokeColorWithColor(context, _borderColor.CGColor);
    CGContextDrawPath(context, kCGPathStroke);
    
    // 水平居中
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setAlignment:NSTextAlignmentCenter];
    
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:13.0],NSParagraphStyleAttributeName:style,NSForegroundColorAttributeName:_textColor};
    
    // 获得size
    CGSize strSize = [numberStr sizeWithAttributes:attributes];
    CGFloat marginTop = (rect.size.height - strSize.height)/2;
    
    // 计算绘制的字符串位置
    CGRect strRect = CGRectMake(rect.origin.x, rect.origin.y + marginTop,rect.size.width, strSize.height);
    
    // 进行绘制
    [numberStr drawInRect:strRect withAttributes:attributes];
    
    CGContextDrawPath(context, kCGPathStroke);
    
    
}

#pragma mark - setter
- (void)setTextColor:(UIColor *)textColor {
    if (textColor) {
        _textColor = textColor;
        
        // 重绘
        [self setNeedsDisplay];
    }
}

- (void)setBorderColor:(UIColor *)borderColor {
    if (borderColor) {
        _borderColor = borderColor;
        
        // 重绘
        [self setNeedsDisplay];
    }
}

@end
