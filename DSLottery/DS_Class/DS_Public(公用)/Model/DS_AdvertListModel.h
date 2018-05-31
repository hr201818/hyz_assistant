//
//  DS_AdvertListModel.h
//  DSLottery
//
//  Created by 黄玉洲 on 2018/5/9.
//  Copyright © 2018年 海南达生实业有限公司. All rights reserved.
//

#import "DS_BaseObject.h"


/**
 首页： 购彩按钮：10
       轮播：1~9
 列表：12 13 14 15 16
 咨询详情：顶部：17 18
         列表：18 19 20
 
 投注站 21 22
 开奖公告：23 24
 走势：25
 我的：26 27
 登录:28 29
 注册：30 31
 */
@interface DS_AdvertListModel : DS_BaseObject

@property (strong, nonatomic) NSMutableArray * list;

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

