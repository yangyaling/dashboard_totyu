//
//  MBProgressHUD+MJ.m
//
//  Created by mj on 13-4-18.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "MBProgressHUD+MJ.h"
#import "UIImage+GIF.h"

@implementation MBProgressHUD (MJ)
#pragma mark 显示信息
+ (void)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view
{
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    
    hud.label.text = text;
    
    hud.backgroundView.backgroundColor = [UIColor whiteColor];
    
    hud.label.textColor = [UIColor blackColor];
    
    if(NITScreenW == 1024){
        hud.label.font = [UIFont systemFontOfSize:20];
    }else if(NITScreenW == 1366){
        hud.label.font = [UIFont systemFontOfSize:25];
    }else if(NITScreenW == 736){
        hud.label.font = [UIFont systemFontOfSize:15];
    }else{
        hud.label.font = [UIFont systemFontOfSize:15];
    }
    
    
//    // 设置图片
//    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"MBProgressHUD.bundle/%@", icon]]];
//    
    // 再设置模式
    hud.mode = MBProgressHUDModeIndeterminate;
    
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    // 1秒之后再消失
    [hud hideAnimated:YES afterDelay:1.0];
}

#pragma mark 显示错误信息
+ (void)showError:(NSString *)error toView:(UIView *)view{
    [self show:error icon:@"error.png" view:view];
}

+ (void)showSuccess:(NSString *)success toView:(UIView *)view
{
    [self show:success icon:@"success.png" view:view];
}

#pragma mark 显示一些信息
+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view {
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    
    hud.label.text = message;
        
    hud.mode = MBProgressHUDModeIndeterminate;
    
    hud.bezelView.backgroundColor = [UIColor whiteColor];
    
    hud.label.textColor = [UIColor blackColor];
    
    if(NITScreenW == 1024){
        hud.label.font = [UIFont systemFontOfSize:20];
    }else if(NITScreenW == 1366){
        hud.label.font = [UIFont systemFontOfSize:25];
    }else if(NITScreenW == 736){
        hud.label.font = [UIFont systemFontOfSize:15];
    }else{
        hud.label.font = [UIFont systemFontOfSize:15];
    }
    
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    return hud;
}

+ (void)showSuccess:(NSString *)success
{
    [self showSuccess:success toView:nil];
}

+ (void)showError:(NSString *)error
{
    [self showError:error toView:nil];
}

+ (MBProgressHUD *)showMessage:(NSString *)message
{
    return [self showMessage:message toView:nil];
}

+ (void)hideHUDForView:(UIView *)view
{
    [self hideHUDForView:view animated:YES];
}

+ (void)hideHUD
{
    [self hideHUDForView:nil];
}
@end
