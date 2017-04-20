//
//  NITSegmented.m
//  DashBoard
//
//  Created by totyu3 on 17/1/19.
//  Copyright © 2017年 NIT. All rights reserved.
//

#import "NITSegmented.h"

@implementation NITSegmented

-(void)setSegmentedFont:(float)SegmentedFont{
    
    UIFont *font;
    
    if(NITScreenW == 1024){
        font = [UIFont boldSystemFontOfSize:20];
    }else if(NITScreenW == 1366){
        font = [UIFont boldSystemFontOfSize:25];
    }else if(NITScreenW == 736){
        font = [UIFont boldSystemFontOfSize:15];
    }else{
        font = [UIFont boldSystemFontOfSize:12];
    }
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font
                                                           forKey:NSFontAttributeName];
    [self setTitleTextAttributes:attributes
                                  forState:UIControlStateNormal];
}

@end
