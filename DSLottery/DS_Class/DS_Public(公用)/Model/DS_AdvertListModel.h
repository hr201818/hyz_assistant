//
//  DS_AdvertListModel.h
//  DSLottery
//
//  Created by 黄玉洲 on 2018/5/9.
//  Copyright © 2018年 海南达生实业有限公司. All rights reserved.
//

#import "DS_BaseObject.h"

@interface DS_AdvertListModel : DS_BaseObject

@property (strong, nonatomic) NSMutableArray * list;

#pragma mark - 非接口数据
/** 用于轮播的广告 */
@property (strong, nonatomic) NSMutableArray * bannerList;

/** 其他广告 */
@property (strong, nonatomic) NSMutableArray * advertList;

@end

@interface DS_AdvertModel : NSObject

@property (copy, nonatomic) NSString * locationId;

@property (copy, nonatomic) NSString * advertisTitle;

@property (copy, nonatomic) NSString * advertisUrl;

@property (copy, nonatomic) NSString * advertisImgId;

@property (copy, nonatomic) NSString * davertisImgData;

@property (copy, nonatomic) NSString * advertisClickNum;

@property (copy, nonatomic) NSString * advertisFollowNum;

@property (copy, nonatomic) NSString * version;

@property (copy, nonatomic) NSURL    * imageURL;

/** 打开方式（0:外部，1:内嵌） */
@property (copy, nonatomic) NSString * openType;

@end

