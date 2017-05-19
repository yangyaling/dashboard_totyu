//
//  NoDataLabel.m
//  DashBoard
//
//  Created by totyu3 on 17/2/14.
//  Copyright © 2017年 NIT. All rights reserved.
//

#import "NoDataLabel.h"

@implementation NoDataLabel
/**
 没数据时，提示用标题
 */
-(BOOL)Show:(NSString*)title SuperView:(UIView*)SuperView DataBool:(NSInteger)DataBool{
    [self RemoveFrom:SuperView];
    if (DataBool == 0) {
        NoDataLabel *nodatalabel = [[NoDataLabel alloc]initWithFrame:[SuperView isKindOfClass:[UICollectionView class]] ? SuperView.frame : SuperView.bounds];
        nodatalabel.text = title;
        nodatalabel.textColor = [UIColor lightGrayColor];
        nodatalabel.textAlignment = NSTextAlignmentCenter;
        [SuperView addSubview:nodatalabel];
        return NO;
    } else {
        return YES;
    }
}

-(void)RemoveFrom:(UIView*)SuperView{    
    for (UIView *view in SuperView.subviews) {
        if ([view isKindOfClass:[NoDataLabel class]]) {
            [view removeFromSuperview];
        }
    }
}

@end
