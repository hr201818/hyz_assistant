//
//  DS_DataTool.h
//  DSLottery
//
//  Created by 黄玉洲 on 2018/4/26.
//  Copyright © 2018年 海南达生实业有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 用于数据的存储、解析等
 */
@interface DS_DataTool : NSObject

/**
 解归档
 @param filename 文件名
 @return 解完归档后的数据
 */
+ (id)loadDataList:(NSString *)filename;

/**
 归档
 @param object 归档的数据
 @param filename 文件名
 @return 操作结果
 */
+ (BOOL)saveDataList:(id)object fileName:(NSString *)filename;

/**
 删除归档
 @param filename 文件名
 @return 操作结果
 */
+ (BOOL)removeFile:(NSString *)filename;

@end
