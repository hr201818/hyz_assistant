//
//  DS_MapViewController.h
//  DSLottery
//
//  Created by 黄玉洲 on 2018/5/15.
//  Copyright © 2018年 海南达生实业有限公司. All rights reserved.
//

#import "DS_BaseViewController.h"
#import <BaiduMapAPI_Map/BMKMapView.h>
@interface DS_MapViewController : DS_BaseViewController

/** 维度 */
@property (assign, nonatomic) CGFloat    latitude;

/** 经度 */
@property (assign, nonatomic) CGFloat    longitude;

/** 用户所在经纬度 */
@property (assign, nonatomic) CLLocationCoordinate2D currentCordinate;

/** 图片路径 */
@property (copy, nonatomic)   NSString * imageUrl;

/** 类别 */
@property (copy, nonatomic)   NSString * typeName;

/** 描述 */
@property (copy, nonatomic)   NSString * hudText;

@end
