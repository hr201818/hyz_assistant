//
//  SZKCleanCache.m
//  CleanCache
//
//  Created by sunzhaokai on 16/5/11.
//  Copyright © 2016年 孙赵凯. All rights reserved.
//

#import "SZKCleanCache.h"
#import "SDImageCache.h"
#import <SDWebImage/UIImageView+WebCache.h>
//#import "UIImageView+WebCache.h"
#import <WebKit/WebKit.h>
@implementation SZKCleanCache
/**
 *  清理缓存
 */
+(void)cleanCache:(cleanCacheBlock)block
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //文件路径
        NSString *directoryPath=[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
        
        NSArray *subpaths = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:directoryPath error:nil];
        
        for (NSString *subPath in subpaths) {
            NSString *filePath = [directoryPath stringByAppendingPathComponent:subPath];
            [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
        }
        
        [[SDImageCache sharedImageCache] clearDiskOnCompletion:nil];
        [[SDImageCache sharedImageCache] clearMemory];

        [self deleteWebCache];
        //WebView清理缓存
        //返回主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            block();
        });

    });
    
}
//WebView清理缓存
+(void)cleanCacheAndCookie{
    //[[NSURLCache sharedURLCache] removeAllCachedResponses];
    //清除cookies
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies]){
        [storage deleteCookie:cookie];
    }
    //清除UIWebView的缓存
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    NSURLCache * cache = [NSURLCache sharedURLCache];
    [cache removeAllCachedResponses];
    [cache setDiskCapacity:0];
    [cache setMemoryCapacity:0];
}

+ (void)deleteWebCache {
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 9.0) {
        //        NSSet *websiteDataTypes
        //        = [NSSet setWithArray:@[
        //                                WKWebsiteDataTypeDiskCache,
        //                                //WKWebsiteDataTypeOfflineWebApplicationCache,
        //                                WKWebsiteDataTypeMemoryCache,
        //                                //WKWebsiteDataTypeLocalStorage,
        //                                //WKWebsiteDataTypeCookies,
        //                                //WKWebsiteDataTypeSessionStorage,
        //                                //WKWebsiteDataTypeIndexedDBDatabases,
        //                                //WKWebsiteDataTypeWebSQLDatabases
        //                                ]];
        //// All kinds of data
        if (@available(iOS 9.0, *)) {
            NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
            // Date from
            NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
              //// Execute
            dispatch_async(dispatch_get_main_queue(), ^{
                //must be used from main thread only
                // 这个方法  必须使用从主线程
                [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
                    // Done
                }];
            });
        } else {
            // Fallback on earlier versions
        }
    } else {
        
        NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *cookiesFolderPath = [libraryPath stringByAppendingString:@"/Cookies"];
        NSError *errors;
        [[NSFileManager defaultManager] removeItemAtPath:cookiesFolderPath error:&errors];
        
    }
}

/**
 *  计算整个目录大小
 */
+(float)folderSizeAtPath
{
    NSString *folderPath=[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSFileManager * manager=[NSFileManager defaultManager ];
    if (![manager fileExistsAtPath :folderPath]) {
        return 0 ;
    }
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath :folderPath] objectEnumerator ];
    NSString * fileName;
    long long folderSize = 0 ;
    while ((fileName = [childFilesEnumerator nextObject ]) != nil ){
        NSString * fileAbsolutePath = [folderPath stringByAppendingPathComponent :fileName];
        folderSize += [ self fileSizeAtPath :fileAbsolutePath];
    }
    //SDWebImage框架自身计算缓存的实现
    folderSize+=[[SDImageCache sharedImageCache] getSize];
//    NSInteger sizeInteger = [[NSURLCache sharedURLCache] currentDiskUsage];
//    float sizeInMB = sizeInteger / (1024.0f * 1024.0f);
     //WebView缓存大小
//    folderSize+= [[NSURLCache sharedURLCache] currentDiskUsage];
    
    return folderSize/(1024.0 * 1024.0);
}

/**
 *  计算单个文件大小
 */
+(long long)fileSizeAtPath:(NSString *)filePath{
    
    NSFileManager *manager = [NSFileManager defaultManager];
    
    if ([manager fileExistsAtPath :filePath]){
        
        return [[manager attributesOfItemAtPath :filePath error : nil ] fileSize];
    }
    return 0 ;
}

@end



























