//
//  DS_FunctionTool.m
//  DSLottery
//
//  Created by 黄玉洲 on 2018/4/26.
//  Copyright © 2018年 海南达生实业有限公司. All rights reserved.
//

#import "DS_FunctionTool.h"
#include <ifaddrs.h>
#include <arpa/inet.h>
#include <net/if.h>
#import "DS_AdvertListModel.h"
#import "DS_WebViewController.h"
#import "DS_AreaLimitShare.h"
@implementation DS_FunctionTool


+(UIButton*)leftNavBackTarget:(id)target Item:(SEL)item {
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 40, 30);
    [button setImage:[UIImage imageNamed:@"cion_xinxi_fanhui"] forState:UIControlStateNormal];
    [button addTarget:target action:item forControlEvents:UIControlEventTouchUpInside];
    return button;
}

+ (CGFloat)calculateWidthWithContent:(NSString *)content attributes:(NSDictionary *)attributes height:(CGFloat)height
{
    NSDictionary * tempAttributes = nil;
    if (!attributes) {
        tempAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14.0]};
    }else{
        tempAttributes = attributes;
    }
    
    CGSize size = [content boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, height)
                                        options:NSStringDrawingTruncatesLastVisibleLine |
                   NSStringDrawingUsesLineFragmentOrigin |
                   NSStringDrawingUsesFontLeading
                                     attributes:tempAttributes
                                        context:nil].size;
    size.width = ceilf(size.width);
    return size.width;
}

+(NSString *)getIPAddress:(BOOL)preferIPv4
{
    NSArray *searchArray = preferIPv4 ?
    @[ /*IOS_VPN @"/" IP_ADDR_IPv4, IOS_VPN @"/" IP_ADDR_IPv6,*/ IOS_WIFI @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6 ] :
    @[ /*IOS_VPN @"/" IP_ADDR_IPv6, IOS_VPN @"/" IP_ADDR_IPv4,*/ IOS_WIFI @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4 ] ;
    
    NSDictionary *addresses = [self getIPAddresses];
    NSLog(@"addresses: %@", addresses);
    
    __block NSString *address;
    [searchArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop)
     {
         address = addresses[key];
         if(address) *stop = YES;
     } ];
    return address ? address : @"0.0.0.0";
}

//获取所有相关IP信息
+(NSDictionary *)getIPAddresses
{
    NSMutableDictionary *addresses = [NSMutableDictionary dictionaryWithCapacity:8];
    
    // retrieve the current interfaces - returns 0 on success
    struct ifaddrs *interfaces;
    if(!getifaddrs(&interfaces)) {
        // Loop through linked list of interfaces
        struct ifaddrs *interface;
        for(interface=interfaces; interface; interface=interface->ifa_next) {
            if(!(interface->ifa_flags & IFF_UP) /* || (interface->ifa_flags & IFF_LOOPBACK) */ ) {
                continue; // deeply nested code harder to read
            }
            const struct sockaddr_in *addr = (const struct sockaddr_in*)interface->ifa_addr;
            char addrBuf[ MAX(INET_ADDRSTRLEN, INET6_ADDRSTRLEN) ];
            if(addr && (addr->sin_family==AF_INET || addr->sin_family==AF_INET6)) {
                NSString *name = [NSString stringWithUTF8String:interface->ifa_name];
                NSString *type;
                if(addr->sin_family == AF_INET) {
                    if(inet_ntop(AF_INET, &addr->sin_addr, addrBuf, INET_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv4;
                    }
                } else {
                    const struct sockaddr_in6 *addr6 = (const struct sockaddr_in6*)interface->ifa_addr;
                    if(inet_ntop(AF_INET6, &addr6->sin6_addr, addrBuf, INET6_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv6;
                    }
                }
                if(type) {
                    NSString *key = [NSString stringWithFormat:@"%@/%@", name, type];
                    addresses[key] = [NSString stringWithUTF8String:addrBuf];
                }
            }
        }
        // Free memory
        freeifaddrs(interfaces);
    }
    return [addresses count] ? addresses : nil;
}

/*手机号码验证 MODIFIED BY HELENSONG*/

+(BOOL) isValidateMobile:(NSString*)mobile {
    
    if(mobile == nil || mobile.length == 0) {
        return NO;
    }
    //手机号以13， 15，18开头，八个 \d 数字字符
    
    NSString*phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9])|(17[0,0-9]))\\d{8}$";
    
    NSPredicate*phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    
    //NSLog(@"phoneTest is %@",phoneTest);
    
    return[phoneTest evaluateWithObject:mobile];
    
}
/* 判断字符串是否为空包括空格换行 */
+(BOOL)isBlankString:(NSString *)string{
    
    if (string == nil) {
        
        return YES;
        
    }
    
    if (string == NULL) {
        
        return YES;
        
    }
    
    if ([string isKindOfClass:[NSNull class]]) {
        
        return YES;
        
    }
    
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0) {
        
        return YES;
        
    }
    
    return NO;
    
}


/**
 当前手机手否为iPhone4或者iPHone5
 @return 结果
 */
+ (BOOL)isCurrentScreenWithIphone4OrIphone5 {
    return [UIScreen mainScreen].bounds.size.width == 320;
}


/**
 判断字符串是否可用
 @param string 要验证的字符串
 @return 结果
 */
+(BOOL)isValidString:(NSString *)string {
    if (string!=nil
        && ![string isKindOfClass:[NSNull class]]
        && ![@"<null>" isEqualToString:string]
        && ![@"" isEqualToString:string]) {
        if ([string isKindOfClass:[NSString class]]) {
            if ([DS_FunctionTool isEmpty:string]) {
                return NO;
            }
        }
        return YES;
    }
    return NO;
}

#pragma mark - 打开广告
/**
 打开广告
 @param advertModel 打开广告
 */
+ (void)openAdvert:(DS_AdvertModel *)advertModel {
    // 外部跳转
    if ([advertModel.openType isEqual:@"1"]) {
        [self openUrl:advertModel.advertisUrl];
    }
    // 内部跳转
    else {
        DS_WebViewController * vc = [[DS_WebViewController alloc] init];
        vc.webURLStr = advertModel.advertisUrl;
        DS_BaseNavigationController * navVC = [[DS_BaseNavigationController alloc] initWithRootViewController:vc];
        [KeyWindows.rootViewController presentViewController:navVC animated:YES completion:nil];
    }
}

/**
 打开链接(外部跳转)
 @param url 链接
 */
+(void)openUrl:(NSString *)url {
    if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:url]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    }
}


/**
 判断字符串是否为空
 @param str 字符串
 @return 结果
 */
+ (BOOL)isEmpty:(NSString *)str {
    if (!str) {
        return true;
    } else {
        NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        NSString *trimedString = [str stringByTrimmingCharactersInSet:set];
        if ([trimedString length] == 0) {
            return true;
        } else {
            return false;
        }
    }
}

#pragma mark - 时间
/* 获取当前时间戳 */
+ (NSString *)currentTimeStr {
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];//获取当前时间0秒后的时间
    NSTimeInterval time=[date timeIntervalSince1970]*1000;// *1000 是精确到毫秒，不乘就是精确到秒
    NSString *timeString = [NSString stringWithFormat:@"%.0f", time];
    return timeString;
}

/* 时间戳返回日期
 * timestamp 时间戳字符串
 * formatter 格式yyyy-MM-dd HH:mm:ss
 */
+ (NSString *)timestampTo:(NSString *)timestamp formatter:(NSString *)formatter {
    NSString *str = timestamp;
    NSTimeInterval time=[str doubleValue]/1000;
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:formatter];
    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
    return currentDateStr;
}

/**
 时间转换
 @param second 秒数
 @return 格式化时间
 */
+ (NSString *)timeFormater:(NSInteger)second {
    if (second > 0) {
        // 时
        NSInteger hour = second / 3600;
        NSString * hourStr = hour > 0 ? [NSString stringWithFormat:@"%ld", hour] : [NSString stringWithFormat:@"0%ld", hour];
        
        // 分
        NSInteger minute = second / 60 % 60;
        NSString * minuteStr = hour > 0 ? [NSString stringWithFormat:@"%ld", minute] : [NSString stringWithFormat:@"0%ld", minute];

        // 秒
        second = second % 60;
        NSString * secondStr = hour > 0 ? [NSString stringWithFormat:@"%ld", second] : [NSString stringWithFormat:@"0%ld", second];
        
        if(hour == 0){
            return [NSString stringWithFormat:@"%@分%@秒",minuteStr,secondStr];
        }
        return [NSString stringWithFormat:@"%@小时%@分%@秒",hourStr,minuteStr,secondStr];
    }else{
        return nil;
    }
}

/**
 由时间戳计算出星期
 @param timeInterval 时间戳
 @param prefix  前缀字符串 如“星期”
 @return 星期
 */
+ (NSString *)weekWithTime:(NSInteger)timeInterval prefix:(NSString *)prefix {
    // 获取时间
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:timeInterval / 1000];
    
    // 获取星期数（星期起始为0）
    NSCalendar * calendar = [NSCalendar currentCalendar];
    NSInteger week = [calendar component:NSCalendarUnitWeekday fromDate:date];
    NSString * weekStr = @"";
    switch (week) {
        case 1: weekStr = @"日"; break;
        case 2: weekStr = @"一"; break;
        case 3: weekStr = @"二"; break;
        case 4: weekStr = @"三"; break;
        case 5: weekStr = @"四"; break;
        case 6: weekStr = @"五"; break;
        case 7: weekStr = @"六"; break;
        default: break;
    }
    
    return [NSString stringWithFormat:@"%@%@", prefix, weekStr];
}

/**
 计算时间timeInterval与当前时间的间隔
 @param timeInterval 要比较的时间(秒)
 @return 相差间隔
 */
+ (NSInteger)timeOffsetWithTimeInterval:(NSTimeInterval)timeInterval {
    // 获取当前时间
    NSDate * nowDate = [NSDate dateWithTimeIntervalSinceNow:0];
    NSInteger nowTimeInterval = [nowDate timeIntervalSince1970];
    
    // 计算间隔时间
    NSTimeInterval offsetTime = nowTimeInterval - timeInterval;
    
    offsetTime = (NSTimeInterval)abs((int)offsetTime);
    return offsetTime;
}

#pragma mark - 彩种数据获取
/**
 通过图片ID获取彩种图片名
 @param lotteryID 图片ID
 @return 图片名
 */
+ (NSString *)lotteryIconWithLotteryID:(NSString *)lotteryID {
    switch ([lotteryID integerValue]) {
        case 1: // 重庆时时彩
            return @"chongqing";
        case 2: // 天津时时彩
            return @"tjssc";
        case 3: // 新疆时时彩
            return @"xinjiang";
        case 4: // 体彩排列3
            return @"pl3";
        case 5: // 福彩3D
            return @"fucai_3d";
        case 6: // 六合彩
            return @"";
        case 7: // 北京28
            return @"";
        case 8: // 北京快乐8
            return @"";
        case 9: // 北京PK10
            return @"";
        case 10: // 重庆幸运农场
            return @"cqxync";
        case 11: // 广东快乐十分
            return @"gdkl";
        case 12: // 双色球
            return @"shuangse";
        case 13: // 三分时时彩
            return @"";
        case 14: // 幸运飞艇
            return @"";
        case 15: // 分分时时彩
            return @"";
        case 16: // 两分时时彩
            return @"";
        case 17: // 五分时时彩
            return @"";
        case 18: // 江苏快3
            return @"";
        case 19: // 湖北快3
            return @"hubeikuai3";
        case 20: // 安徽快3
            return @"anhuikuai3";
        case 21: // 吉林快3
            return @"";
        case 22: // 10分六合彩
            return @"";
        case 23: // 极速PK10
            return @"";
        case 24: // 广东十一选五
            return @"";
        case 25: // 北京时时彩
            return @"beijing";
        case 26: // 吉林时时彩
            return @"jilin";
        default: return @"";
    }
}

/**
 通过图片ID获取彩种图片名
 @param lotteryID 图片ID
 @return 图片名
 */
+ (NSString *)lotteryTitleWithLotteryID:(NSString *)lotteryID {
    switch ([lotteryID integerValue]) {
        case 1:
            return @"重庆时时彩";
        case 2:
            return @"天津时时彩";
        case 3:
            return @"新疆时时彩";
        case 4:
            return @"体彩排列3";
        case 5:
            return @"福彩3D";
        case 6:
            return @"六合彩";
        case 7:
            return @"北京28";
        case 8:
            return @"北京快乐8";
        case 9:
            return @"北京PK10";
        case 10:
            return @"重庆幸运农场";
        case 11:
            return @"广东快乐十分";
        case 12:
            return @"双色球";
        case 13:
            return @"三分时时彩";
        case 14:
            return @"幸运飞艇";
        case 15:
            return @"分分时时彩";
        case 16:
            return @"两分时时彩";
        case 17:
            return @"五分时时彩";
        case 18:
            return @"江苏快3";
        case 19:
            return @"湖北快3";
        case 20:
            return @"安徽快3";
        case 21:
            return @"吉林快3";
        case 22:
            return @"十分六合彩";
        case 23:
            return @"极速PK10";
        case 24:
            return @"广东十一选五";
        case 25:
            return @"北京时时彩";
        case 26:
            return @"吉林时时彩";
        default: return @"";
    }
}

/**
 获取彩种字体颜色
 @param lotteryID 彩种ID
 @return 颜色
 */
+ (UIColor *)lotteryColorWithLotteryID:(NSString *)lotteryID {
    switch ([lotteryID integerValue]) {
        case 1: // 重庆时时彩
            return [UIColor redColor];
        case 2: // 天津时时彩
            return COLOR_HexRGB(@"F3692A");
        case 3: // 新疆时时彩
            return [UIColor redColor];
        case 4: // 体彩排列3
            return COLOR_HexRGB(@"#31CB3F");
        case 5: // 福彩3D
            return COLOR_HexRGB(@"DFA433");
        case 6: // 六合彩
            return [UIColor redColor];
        case 7: // 北京28
            return [UIColor redColor];
        case 8: // 北京快乐8
            return [UIColor redColor];
        case 9: // 北京PK10
            return [UIColor redColor];
        case 10: // 重庆幸运农场
            return COLOR_HexRGB(@"#E13095");
        case 11: // 广东快乐十分
            return [UIColor redColor];
        case 12: // 双色球
            return [UIColor redColor];
        case 13: // 三分时时彩
            return [UIColor redColor];
        case 14: // 幸运飞艇
            return [UIColor redColor];
        case 15: // 分分时时彩
            return [UIColor redColor];
        case 16: // 两分时时彩
            return [UIColor redColor];
        case 17: // 五分时时彩
            return [UIColor redColor];
        case 18: // 江苏快3
            return [UIColor redColor];
        case 19: // 湖北快3
            return [UIColor redColor];
        case 20: // 安徽快3
            return [UIColor redColor];
        case 21: // 吉林快3
            return [UIColor redColor];
        case 22: // 10分六合彩
            return [UIColor redColor];
        case 23: // 极速PK10
            return [UIColor redColor];
        case 24: // 广东十一选五
            return [UIColor redColor];
        case 25: // 北京时时彩
            return [UIColor redColor];
        case 26: // 吉林时时彩
            return [UIColor redColor];
        default: return [UIColor redColor];
    }
}

/** 获取当前应用所支持的所有彩种ID */
+ (NSArray *)allLottery {
    NSMutableArray * mArray = [NSMutableArray new];
//    [mArray addObject:@(1)];  // 重庆时时彩
    [mArray addObject:@(2)];  // 天津时时彩
//    [mArray addObject:@(3)];  // 新疆时时彩
    [mArray addObject:@(4)];  // 体彩排列3
    [mArray addObject:@(5)];  // 福彩3D
//    [mArray addObject:@(6)];  // 六合彩
//    [mArray addObject:@(7)];  // 北京28
//    [mArray addObject:@(8)];  // 北京快乐8
//    [mArray addObject:@(9)];  // 北京PK10
    [mArray addObject:@(10)]; // 重庆幸运农场
    [mArray addObject:@(11)]; // 广东快乐十分
//    [mArray addObject:@(12)]; // 双色球
//    [mArray addObject:@(13)]; // 三分时时彩
//    [mArray addObject:@(14)]; // 幸运飞艇
//    [mArray addObject:@(15)]; // 分分时时彩
//    [mArray addObject:@(16)]; // 两分时时彩
//    [mArray addObject:@(17)]; // 五分时时彩
//    [mArray addObject:@(18)]; // 江苏快3
//    [mArray addObject:@(19)]; // 湖北快3
//    [mArray addObject:@(20)]; // 安徽快3
//    [mArray addObject:@(21)]; // 吉林快3
//    [mArray addObject:@(22)]; // 十分六合彩
//    [mArray addObject:@(23)]; // 极速PK10
//    [mArray addObject:@(24)]; // 广东十一选五
    
    if ([DS_AreaLimitShare share].isAreaLimit) {
        NSArray * deleteArray = @[@(6), @(13), @(14), @(15), @(16), @(17), @(22), @(23)];
        [mArray removeObjectsInArray:deleteArray];
    }
    
    return mArray;
}

#pragma mark - 缓存
/** 获取缓存 */
+ (float)getCacheSize {
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains (NSCachesDirectory , NSUserDomainMask , YES) firstObject];
    return [self folderSizeAtPath:cachePath];
}

/** 清除缓存 */
+ (void)clearCache {
    NSString * cachePath = [NSSearchPathForDirectoriesInDomains (NSCachesDirectory , NSUserDomainMask , YES ) firstObject];
    NSArray * files = [[NSFileManager defaultManager ] subpathsAtPath :cachePath];
    //NSLog ( @"cachpath = %@" , cachePath);
    for ( NSString * p in files) {
        
        NSError * error = nil ;
        //获取文件全路径
        NSString * fileAbsolutePath = [cachePath stringByAppendingPathComponent :p];
        
        if ([[NSFileManager defaultManager ] fileExistsAtPath :fileAbsolutePath]) {
            [[NSFileManager defaultManager ] removeItemAtPath :fileAbsolutePath error :&error];
        }
    }
}

/** 计算文件夹大小 */
+ (float)folderSizeAtPath:(NSString *)folderPath {
    
    NSFileManager * manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath :folderPath]) return 0 ;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath :folderPath] objectEnumerator];
    NSString * fileName;
    long long folderSize = 0 ;
    while ((fileName = [childFilesEnumerator nextObject]) != nil ){
        //获取文件全路径
        NSString * fileAbsolutePath = [folderPath stringByAppendingPathComponent :fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize/( 1024.0 * 1024.0);
}

// 计算 单个文件的大小
+ (long long)fileSizeAtPath:( NSString *)filePath {
    NSFileManager * manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath :filePath]){
        return [[manager attributesOfItemAtPath :filePath error : nil] fileSize];
    }
    return 0;
}

@end
