//
//  UIColor+MyColorCatagory.m
//  StudyClassMethod
//
//  Created by  新软软件 on 14-4-18.
//  Copyright (c) 2014年  新软软件. All rights reserved.
//

#import "UIColor+MyColorCatagory.h"

@implementation UIColor (MyColorCatagory)
+(UIColor *) myGolden {
    return [UIColor colorWithRed:1.0 green:0.894 blue:0.141 alpha:1.0f];
}

+(UIColor *) littleRed {
    return [UIColor colorFromHexRGB: @"#f36460"];
}

+(UIColor *) skyBlue {
    return [UIColor colorWithRed:0.0f green:0.4f blue:0.8f alpha:0.5f];
}

+(UIColor *) lightBlue {
    //return [UIColor colorWithRed:0.0f green:0.7f blue:0.75f alpha:0.95f];
    return [UIColor colorWithRed:0.0f green:0.6f blue:0.9f alpha:0.95f];
}

+(UIColor *) grayWhite {
    return [UIColor colorWithRed:0.973f green:0.973f blue:0.973f alpha:1.0f];
}

+(UIColor *) grayWhiteShadow {
    return [UIColor colorWithRed:0.882f green:0.882f blue:0.882f alpha:1.0f];
}

+(UIColor *) grayWhiteTransparent {
    return [UIColor colorWithRed:0.20f green:0.20f blue:0.20f alpha:0.5f];
}

+(UIColor *) barColor {
    return [UIColor colorWithRed:0.21875f green:0.7265625f blue:0.6875f alpha:1.0f];
}

+(UIColor *) transparentBarColor {
    return [UIColor colorWithRed:0.21875f green:0.7265625f blue:0.6875f alpha:0.95f];
}

+(UIColor *) transparentColor {
    return [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.0f];
}

+(UIColor *) redYellow {
    return [self colorFromHexRGB: @"#ef6540"];
}

+(UIColor *) orangeYellow {
    return [UIColor colorWithRed: 1.0f green:200/255.0 blue:0.0f alpha:1.0f];
}

+(UIColor *) lightYellow {
    return [UIColor colorWithRed: 0.957f green:0.867 blue:0.7f alpha:1.0f];
}

+(UIColor*) lightBgGray {
    return [UIColor colorWithRed: 0.93f green:0.93f blue:0.93f alpha:1.0f];
}

+(UIColor *) darkBlue {
    return [UIColor colorWithRed: 0.359f green:0.434f blue:0.563f alpha:1.0f];
}

+(UIColor *) nickBlue {
    return [self colorFromHexRGB: @"#5590d2"];
}

+(UIColor *) heathGreen {
    return [self colorFromHexRGB: @"#68c00a"];
}

+(UIColor *) hupoColor {
    return [self colorFromHexRGB: @"#ffbe00"];
}

+(UIColor *) disableBgColor {
    return [self colorFromHexRGB: @"#d7d7d7"];
}

+(UIColor *) disableTextColor {
    return [self colorFromHexRGB: @"#ababab"];
}

+(UIColor *) hupoColorBar
{
    return [self colorFromHexRGB: @"#fec625"];
}

//签到按钮颜色
+(UIColor *) signBlue {
    return [self colorFromHexRGB: @"#23b6d8"];
}
//签退按钮颜色
+(UIColor *) signYellow {
    return [self colorFromHexRGB: @"#fcbf24"];
}

+ (UIColor *)colorFromHexRGB:(NSString *)stringToConvert
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    
    if ([cString length] < 6)
        return [UIColor whiteColor];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor whiteColor];
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha {
    //删除字符串中的空格
    NSString *cString = [[color
                          stringByTrimmingCharactersInSet:[NSCharacterSet
                                                           whitespaceAndNewlineCharacterSet]]
                         uppercaseString];
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    // strip 0X if it appears
    //如果是0x开头的，那么截取字符串，字符串从索引为2的位置开始，一直到末尾
    if ([cString hasPrefix:@"0X"]) {
        cString = [cString substringFromIndex:2];
    }
    //如果是#开头的，那么截取字符串，字符串从索引为1的位置开始，一直到末尾
    if ([cString hasPrefix:@"#"]) {
        cString = [cString substringFromIndex:1];
    }
    if ([cString length] != 6) {
        return [UIColor clearColor];
    }
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    // r
    NSString *rString = [cString substringWithRange:range];
    // g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    // b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    return [UIColor colorWithRed:((float)r / 255.0f)
                           green:((float)g / 255.0f)
                            blue:((float)b / 255.0f)
                           alpha:alpha];
}


@end
