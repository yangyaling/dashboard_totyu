//
//  UnderlineView.m
//  DashBoard
//
//  Created by totyu3 on 17/1/22.
//  Copyright © 2017年 NIT. All rights reserved.
//

#import "UnderlineView.h"

@implementation UnderlineView

-(void)drawRect:(CGRect)rect{    
    if (_TopType) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextMoveToPoint(context, 0 , 0);
        CGContextAddLineToPoint(context, self.width, 0);
        CGContextSetLineWidth(context, 1.5);
        [SystemColor(1.0) setStroke];
        CGContextDrawPath(context, kCGPathStroke);
    }
    if (_BottomType) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextMoveToPoint(context, 0 , self.height);
        CGContextAddLineToPoint(context, self.width, self.height);
        CGContextSetLineWidth(context, 1.5);
        [SystemColor(1.0) setStroke];
        CGContextDrawPath(context, kCGPathStroke);
    }
    if (_LeftType) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextMoveToPoint(context, 0 , 0);
        CGContextAddLineToPoint(context, 0, self.height);
        CGContextSetLineWidth(context, 1.5);
        [SystemColor(1.0) setStroke];
        CGContextDrawPath(context, kCGPathStroke);
    }
    if (_RightType) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextMoveToPoint(context, self.width , 0);
        CGContextAddLineToPoint(context, self.width, self.height);
        CGContextSetLineWidth(context, 1.5);
        [SystemColor(1.0) setStroke];
        CGContextDrawPath(context, kCGPathStroke);
    }
    
}

@end
