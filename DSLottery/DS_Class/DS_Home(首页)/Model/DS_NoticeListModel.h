//
//  DS_NoticeListModel.h
//  DSLottery
//
//  Created by 黄玉洲 on 2018/5/9.
//  Copyright © 2018年 海南达生实业有限公司. All rights reserved.
//

#import "DS_BaseObject.h"

@interface DS_NoticeListModel : DS_BaseObject

@property (strong, nonatomic) NSMutableArray * noticeList;

@end

@interface DS_NoticeModel : DS_BaseObject

/** 公告内容 */
@property (copy, nonatomic) NSString * content;

/** 公告ID */
@property (copy, nonatomic) NSString * ID;


@end
