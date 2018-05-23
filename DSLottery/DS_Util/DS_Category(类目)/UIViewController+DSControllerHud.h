//
//  UIViewController+DSControllerHud.h
//  DS_lottery
//
//  Created by pro on 2018/4/24.
//  Copyright © 2018年 海南达生实业有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (DSControllerHud)
/**
 * 显示加载器 (没有文字)
 */
-(void)showhud;

/**
 * 显示加载器 (有文字)
 */
-(void)showhudtext:(NSString *)text;

/**
 *  隐藏加载器
 */
-(void)hidehud;

/**
 * 文字提示
 */
-(void)showMessagetext:(NSString *)text;

/**
 * 加载成功
 */
-(void)hudSuccessText:(NSString *)text;

/**
 * 加载失败
 */
-(void)hudErrorText:(NSString *)text;
@end
