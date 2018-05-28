//
//  DS_AdvertListModel.m
//  DSLottery
//
//  Created by 黄玉洲 on 2018/5/9.
//  Copyright © 2018年 海南达生实业有限公司. All rights reserved.
//

#import "DS_AdvertListModel.h"

@implementation DS_AdvertListModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"list"  : [DS_AdvertModel class]};
}

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    [self processModel];
    return YES;
}

/** 处理数据 */
- (void)processModel {
    _bannerList = [[NSMutableArray alloc]init];
    _advertList = [[NSMutableArray alloc]init];
    for (DS_AdvertModel * model in self.list) {
        // 轮播图
        if([model.locationId isEqual:@"2"] ||
           [model.locationId isEqual:@"3"]){
            [_bannerList addObject:model];
        }
        // 其他广告图
        else{
            [_advertList addObject:model];
        }
    }
}

@end

@implementation DS_AdvertModel

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    [self processModel];
    return YES;
}

/** 处理数据 */
- (void)processModel {
    NSString * imageURLStr = [NSString stringWithFormat:@"%@%@.png?",IMGURL,self.advertisImgId];
    self.imageURL = [NSURL URLWithString:imageURLStr];
}

- (NSUInteger)hash
{
    NSString *toHash = [NSString stringWithFormat:@"%@", self.locationId];
    return [toHash hash];
}

- (BOOL)isEqual:(id)object
{
    return [self hash] == [object hash];
}

@end
