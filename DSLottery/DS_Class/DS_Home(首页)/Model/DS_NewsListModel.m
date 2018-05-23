//
//  DS_NewsListModel.m
//  DSLottery
//
//  Created by 黄玉洲 on 2018/5/9.
//  Copyright © 2018年 海南达生实业有限公司. All rights reserved.
//

#import "DS_NewsListModel.h"

@implementation DS_NewsListModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"articleList"  : [DS_NewsModel class]};
}

@end

@implementation DS_NewsModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"ID" : @"id"};
}

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    [self processModel];
    return YES;
}

-(void)processModel{
    self.imageId = [NSString stringWithFormat:@"%@%@.png?",IMGURL,self.imageId];
    
//    BOOL isSave = NO;
//    
//    self.look = [DS_UserDefaultTool homeNewsLookWithNewsID:self.ID];
//    if (!self.look) {
//        isSave = YES;
//
//        NSInteger lookNumber = arc4random() % 1000;
//        self.look = [NSString stringWithFormat:@"%ld",lookNumber];
//    }
//
//    self.praise = [DS_UserDefaultTool homeNewsPraiseWithNewsID:self.ID];
//    if (!self.praise) {
//        isSave = YES;
//
//        NSInteger praisekNumber = arc4random() % 1000;
//        self.praise = [NSString stringWithFormat:@"%ld",praisekNumber];
//    }
//
//    if (isSave) {
//        [DS_UserDefaultTool setHomeNewsPraise:self.praise look:self.look newsID:self.ID];
//    }
    
    
}
@end

