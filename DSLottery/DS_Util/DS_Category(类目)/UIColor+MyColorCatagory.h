//
//  UIColor+MyColorCatagory.h
//  StudyClassMethod
//
//  Created by  新软软件 on 14-4-18.
//  Copyright (c) 2014年  新软软件. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (MyColorCatagory)
+(UIColor *) myGolden;
+(UIColor *) skyBlue;
+(UIColor *) lightBlue;
+(UIColor *) grayWhite;
+(UIColor *) grayWhiteShadow;
+(UIColor *) barColor;
+(UIColor *) transparentBarColor;
//认证未通过的红色底色
+(UIColor *) littleRed;
+(UIColor *) transparentColor;
+(UIColor *) redYellow;
+(UIColor *) orangeYellow;
+(UIColor *) lightYellow;
+(UIColor *) lightBgGray;
+(UIColor *) darkBlue;
+(UIColor *) nickBlue;
//认证通过的绿色底色
+(UIColor *) heathGreen;
+(UIColor *) grayWhiteTransparent;
//按钮未使能前背景色
+(UIColor *) disableBgColor;
//按钮未使能前文字颜色
+(UIColor *) disableTextColor;
//琥珀色
+(UIColor *) hupoColor;
//匹配导航栏的亚颜色
+(UIColor *) hupoColorBar;
//签到按钮颜色
+(UIColor *) signBlue;
//签退按钮颜色
+(UIColor *) signYellow;
+(UIColor *)colorFromHexRGB:(NSString *)inColorString;

+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;

@end
