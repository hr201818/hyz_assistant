//
//  UIViewController+DSControllerHud.m
//  DS_lottery
//
//  Created by pro on 2018/4/24.
//  Copyright © 2018年 海南达生实业有限公司. All rights reserved.
//

#import "UIViewController+DSControllerHud.h"
#import "MBProgressHUD.h"
@implementation UIViewController (DSControllerHud)
-(void)showhud
{
    [self removesubviewshud];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.hidden = NO;
}

-(void)showhudtext:(NSString *)text
{
    [self removesubviewshud];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = text;
}

-(void)showMessagetext:(NSString *)text
{
    [self removesubviewshud];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = text;
    hud.offset = CGPointMake(0.f, 0);
    [hud hideAnimated:YES afterDelay:2.f];
}

-(void)hidehud
{
    for (UIView * view in self.view.subviews)
    {
        if ([view isKindOfClass:[MBProgressHUD class]])
        {
            MBProgressHUD *hud = (MBProgressHUD *)view;
            [hud hideAnimated:YES];
        }
    }
}

-(void)hudSuccessText:(NSString *)text{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];

    // Set the custom view mode to show any view.
    hud.mode = MBProgressHUDModeCustomView;
    // Set an image view with a checkmark.
    UIImage *image = [[UIImage imageNamed:@"MBHUD_Success"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    hud.customView = [[UIImageView alloc] initWithImage:image];
    // Looks a bit nicer if we make it square.
    hud.square = YES;
    // Optional label text.
    hud.label.text = text;

    [hud hideAnimated:YES afterDelay:2.f];
}

-(void)hudErrorText:(NSString *)text{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];

    // Set the custom view mode to show any view.
    hud.mode = MBProgressHUDModeCustomView;
    // Set an image view with a checkmark.
    UIImage *image = [[UIImage imageNamed:@"MBHUD_Error"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    hud.customView = [[UIImageView alloc] initWithImage:image];
    // Looks a bit nicer if we make it square.
    hud.square = YES;
    // Optional label text.
    hud.label.text = text;

    [hud hideAnimated:YES afterDelay:2.f];
}

-(void)removesubviewshud
{
    for (UIView * view in self.view.subviews)
    {
        if ([view isKindOfClass:[MBProgressHUD class]])
        {
            [view removeFromSuperview];
        }
    }
}
@end
