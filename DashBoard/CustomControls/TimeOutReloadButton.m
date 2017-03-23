//
//  TimeOutReloadButton.m
//  DashBoard
//
//  Created by totyu3 on 17/3/21.
//  Copyright © 2017年 NIT. All rights reserved.
//

#import "TimeOutReloadButton.h"

@implementation TimeOutReloadButton

-(void)Show:(id)Super SuperView:(UIView*)SuperView{
    [self removeFromSuperview];
    
    TimeOutReloadButton *button = [[TimeOutReloadButton alloc]initWithFrame:CGRectMake(SuperView.width / 2-SuperView.width / 10, SuperView.height / 2 + SuperView.height / 20, SuperView.width / 5, SuperView.height / 10)];
    [button setTitle:@"リロード" forState:UIControlStateNormal];
    [button setTitleColor:SystemColor(1.0) forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:SuperView.height / 15];
    button.layer.cornerRadius = SuperView.height / 50;
    button.layer.borderWidth = 0.5;
    button.layer.borderColor = SystemColor(1.0).CGColor;
    [SuperView addSubview:button];
    [button addTarget:Super action:@selector(LoadNewData) forControlEvents:UIControlEventTouchUpInside];
    [button addTarget:self action:@selector(LoadNewData) forControlEvents:UIControlEventTouchUpInside];
}

-(void)LoadNewData{
    [self removeFromSuperview];
}

@end
