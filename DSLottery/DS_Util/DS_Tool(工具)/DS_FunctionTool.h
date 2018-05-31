//
//  DS_FunctionTool.h
//  DSLottery
//
//  Created by 黄玉洲 on 2018/4/26.
//  Copyright © 2018年 海南达生实业有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

#define IOS_CELLULAR    @"pdp_ip0"
#define IOS_WIFI        @"en0"
#define IP_ADDR_IPv4    @"ipv4"
#define IP_ADDR_IPv6    @"ipv6"

@interface DS_FunctionTool : NSObject

/**
 * 导航栏返回按钮
 */
+(UIButton*)leftNavBackTarget:(id)target Item:(SEL)item;


/**
 计算文本应有宽度
 @param content     文本内容
 @param attributes  例如传 @{NSFontAttributeName:[UIFont systemFontOfSize:14.0]};
 @param height      文本默认高度
 */
+ (CGFloat)calculateWidthWithContent:(NSString *)content attributes:(NSDictionary *)attributes height:(CGFloat)height;




/* 获取IP地址 */
+(NSString *)getIPAddress:(BOOL)preferIPv4;


/* 手机号码判断 */
+(BOOL) isValidateMobile:(NSString*)mobile;

/* 判断字符串是否为空包括空格换行 */
+ (BOOL)isBlankString:(NSString *)string;

/**
 当前手机手否为iPhone4或者iPHone5
 @return 结果
 */
+ (BOOL)isCurrentScreenWithIphone4OrIphone5;

/**
 判断字符串是否可用
 @param string 要验证的字符串
 @return 结果
 */
+(BOOL)isValidString:(NSString *)string;


#pragma mark - 打开广告
/**
 打开广告
 @param advertModel 打开广告
 */
+ (void)openAdvert:(id)advertModel;

#pragma mark - 时间
/* 获取当前时间戳 */
+(NSString *)currentTimeStr;

/* 时间戳返回日期
 * timestamp 时间戳字符串
 * formatter 格式yyyy-MM-dd HH:mm:ss
 */
+(NSString *)timestampTo:(NSString *)timestamp formatter:(NSString *)formatter;

/**
 时间转换
 @param second 秒数
 @return 格式化时间
 */
+ (NSString *)timeFormater:(NSInteger)second;

/**
 由时间戳计算出星期
 @param timeInterval 时间戳
 @param prefix  前缀字符串 如“星期”
 @return 星期
 */
+ (NSString *)weekWithTime:(NSInteger)timeInterval prefix:(NSString *)prefix;

/**
 计算时间timeInterval与当前时间的间隔
 @param timeInterval 要比较的时间(秒)
 @return 相差间隔
 */
+ (NSInteger)timeOffsetWithTimeInterval:(NSTimeInterval)timeInterval;

#pragma mark - 彩种数据获取
/**
 通过图片ID获取彩种图片名
 @param lotteryID 图片ID
 @return 图片名
 */
+ (NSString *)lotteryIconWithLotteryID:(NSString *)lotteryID;

/**
 通过图片ID获取彩种图片名
 @param lotteryID 图片ID
 @return 图片名
 */
+ (NSString *)lotteryTitleWithLotteryID:(NSString *)lotteryID;

/**
 获取彩种字体颜色
 @param lotteryID 彩种ID
 @return 颜色
 */
+ (UIColor *)lotteryColorWithLotteryID:(NSString *)lotteryID;

/** 获取当前应用所支持的所有彩种ID */
+ (NSArray *)allLottery;

#pragma mark - 缓存
/** 获取缓存 */
+ (float)getCacheSize;

/** 清除缓存 */
+ (void)clearCache;

@end
