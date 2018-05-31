//
//  DS_AreaLimitShare.m
//  DSLottery
//
//  Created by 黄玉洲 on 2018/5/28.
//  Copyright © 2018年 海南达生实业有限公司. All rights reserved.
//

#import "DS_AreaLimitShare.h"

@interface DS_AreaLimitShare ()

/** 是否区域限制 */
@property (assign, nonatomic) BOOL isAreaLimit;

/** 区域限制内容 */
@property (copy, nonatomic) NSString * content;

@end

@implementation DS_AreaLimitShare

static DS_AreaLimitShare * areaLmitShare;
/** 实例 */
+ (DS_AreaLimitShare *)share {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        areaLmitShare = [[DS_AreaLimitShare alloc] init];
        areaLmitShare.isAreaLimit = YES;
        areaLmitShare.content = @"";
    });
    return areaLmitShare;
}

/**
 请求区域限制状态
 @param complete 请求完成
 @param fail 请求失败
 */
- (void)requestCheckIPComplete:(void(^)(void))complete
                          fail:(void(^)(NSError * failure))fail {
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
    [dic setValue:@"AA6" forKey:@"tip"];
    [DS_Networking postConectWithS:Link_AreaLimit Parameter:dic Succeed:^(id result) {
        if ([result[@"result"] integerValue] == 1 ) {
            if ([result[@"pass"] integerValue] == 1) {
                self.isAreaLimit = YES;
            }else {
                self.isAreaLimit = NO;
            }
        }
        if (complete) {
            complete();
        }
    } Failure:^(NSError *failure) {
        if (fail) {
            fail(failure);
        }
    }];
}

/** 请求版本 */
- (void)requestGengxinComplete:(void(^)(void))complete
                          fail:(void(^)(NSError * failure))fail {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [DS_Networking postConectWithS:GETAPPGENXIN Parameter:dic Succeed:^(id result) {
        if (Request_Success(result)) {
            self.content = result[@"content"];
        }
        if (complete) {
            complete();
        }
    } Failure:^(NSError *failure) {
        if (fail) {
            fail(failure);
        }
    }];
    
//    [DS_Networking startPostNetWorkWithURL:GETAPPGENXIN params:dic successBlk:^(id responseObject) {
//        //        [MBProgressHUD hideHUD];
//        NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
//        NSLog(@"%@",dataDic);
//
//        if ([dataDic[@"result"] integerValue] == 1 ) {
//
//            Helper.closeLiuhe = @"0";//dataDic[@"closeLiuhe"];
//            Helper.clauseContent = dataDic[@"content"];
//
//            if ([dataDic[@"force"] integerValue]==1) {
//                Helper.isForce = YES;
//                Helper.updateUrl = dataDic[@"url"];
//
//                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"当前版本过于陈旧，请及时更新！" preferredStyle:UIAlertControllerStyleAlert];
//                UIAlertAction *OKAction = [UIAlertAction actionWithTitle:@"立即更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//
//                    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:Helper.updateUrl]]) {
//                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:Helper.updateUrl] options:@{} completionHandler:nil];
//                    }
//                }];
//                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"暂不更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//
//                }];
//                [alertController addAction:cancelAction];
//                [alertController addAction:OKAction];
//                [self presentViewController:alertController animated:YES completion:nil];
//
//                //                ViewController *vc = [ViewController new];
//                //                vc.urlStr = Helper.updateUrl;
//                //                [self.navigationController presentViewController:vc animated:YES completion:nil];
//
//            }else {
//                Helper.isForce = NO;
//            }
//
//            [self createDataWithDictionary:[HttpHelper shareHelper].dataDic];
//
//            //            if ([dataDic[@"status"] integerValue]==0) {
//            //                Helper.isShenheZhong = NO;
//            //                [self createDataWithDictionary:[HttpHelper shareHelper].dataDic];
//            //                [self.collectionView reloadData];
//            //
//            //            }else {
//            //                Helper.isShenheZhong = YES;
//            //            }
//
//        } else {
//
//        }
//    } failedBlk:^(id errorInfo) {
//
//    }];
}

@end
