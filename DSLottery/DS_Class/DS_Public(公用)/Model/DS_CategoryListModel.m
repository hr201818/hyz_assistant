//
//  DS_CategoryListModel.m
//  DSLottery
//
//  Created by 黄玉洲 on 2018/5/9.
//  Copyright © 2018年 海南达生实业有限公司. All rights reserved.
//

#import "DS_CategoryListModel.h"

@implementation DS_CategoryListModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"appNewsCategorys"  : [DS_CategoryModel class]};
}

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    [self processModel];
    return YES;
}

/** 处理模型 */
-(void)processModel {
    for (DS_CategoryModel * model in self.appNewsCategorys) {
        if ([model.name isEqual:@"彩票资讯"]) {
            self.newsCategory = [model.children mutableCopy];
        } else if ([model.name isEqual:@"cityCategory"]) {
            self.cityCategory = [model.children mutableCopy];
        }
    }
}

@end

@implementation DS_CategoryModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"children"  : [DS_CategoryModel class]};
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"ID" : @"id"};
}

@end
