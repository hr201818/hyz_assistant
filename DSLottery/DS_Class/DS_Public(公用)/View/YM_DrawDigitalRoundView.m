//
//  YM_DrawDigitalRoundView.m
//  YM_DrawDigitalAndRound
//
//  Created by 黄玉洲 on 2018/5/22.
//

#import "YM_DrawDigitalRoundView.h"

@interface YM_DrawDigitalRoundView () {
    NSInteger _number;
}

@end

@implementation YM_DrawDigitalRoundView

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
    _textFont = [UIFont systemFontOfSize:13.0];
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
    // 是否填充整个圆形
    if (_isFill) {
        CGContextSetFillColorWithColor(context, _borderColor.CGColor);
        CGContextFillPath(context);
    }
    CGContextDrawPath(context, kCGPathStroke);
    
    // 水平居中
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setAlignment:NSTextAlignmentCenter];
    
    NSDictionary *attributes = @{NSFontAttributeName:_textFont,NSParagraphStyleAttributeName:style,NSForegroundColorAttributeName:_textColor};
    
    // 获得size
    CGSize strSize = [numberStr sizeWithAttributes:attributes];
    CGFloat marginTop = (rect.size.height - strSize.height)/2;
    
    // 计算绘制的字符串位置
    CGRect strRect = CGRectMake(rect.origin.x, rect.origin.y + marginTop,rect.size.width, strSize.height);
    
    // 进行绘制
    [numberStr drawInRect:strRect withAttributes:attributes];
    
    CGContextDrawPath(context, kCGPathStroke);
}

/** 设置了以上属性之后，需要调用一下这个方法重新绘制 */
- (void)redraw {
    [self setNeedsDisplay];
}

#pragma mark - setter
- (void)setTextColor:(UIColor *)textColor {
    if (textColor) {
        _textColor = textColor;
    }
}

- (void)setBorderColor:(UIColor *)borderColor {
    if (borderColor) {
        _borderColor = borderColor;
    }
}

- (void)setIsFill:(BOOL)isFill {
    _isFill = isFill;
}


@end
