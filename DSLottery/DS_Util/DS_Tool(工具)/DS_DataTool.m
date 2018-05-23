//
//  DS_DataTool.m
//  DSLottery
//
//  Created by 黄玉洲 on 2018/4/26.
//  Copyright © 2018年 海南达生实业有限公司. All rights reserved.
//

#import "DS_DataTool.h"
static NSString * folderName = @"Local_CacheData";
@implementation DS_DataTool

/**
 解归档
 @param filename 文件名
 @return 解完归档后的数据
 */
+ (id)loadDataList:(NSString *)filename {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:folderName];
    NSFileManager *manager = [[NSFileManager alloc] init];
    if (![manager fileExistsAtPath:path]) {
        NSError *error ;
        [manager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
            
        }
    }
    NSString * fileDirectory = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.arc",filename]];
    // 解档
    return [NSKeyedUnarchiver unarchiveObjectWithFile:fileDirectory];
}

/**
 归档
 @param object 归档的数据
 @param filename 文件名
 @return 操作结果
 */
+ (BOOL)saveDataList:(id)object fileName:(NSString *)filename {
    // 归档对象
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [[paths objectAtIndex:0]stringByAppendingPathComponent:folderName];
    NSFileManager *manager = [[NSFileManager alloc]init];
    if (![manager fileExistsAtPath:path]) {
        NSError *error ;
        [manager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
            
        }
    }
    NSString* fileDirectory = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.arc",filename]];
    BOOL success = [NSKeyedArchiver archiveRootObject:object toFile:fileDirectory];
    
    if (success) {
        return YES;
    }
    return NO;
}

/**
 删除归档
 @param filename 文件名
 @return 操作结果
 */
+ (BOOL)removeFile:(NSString *)filename {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [[paths objectAtIndex:0]stringByAppendingPathComponent:folderName];
    NSFileManager *manager = [[NSFileManager alloc]init];
    if (![manager fileExistsAtPath:path]) {
        return YES;
    }
    
    NSString* fileDirectory = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.arc",filename]];
    
    BOOL success = [manager removeItemAtPath:fileDirectory error:nil];
    if (success) {
        NSLog(@"归档删除成功");
        return YES;
    }
    else {
        return NO;
    }
}

@end
