//
//  UUBar.m
//  UUChartDemo
//
//  Created by shake on 14-7-24.
//  Copyright (c) 2014年 uyiuyao. All rights reserved.
//

#import "UUBar.h"
#import "UUColor.h"

@implementation UUBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        _chartLine = [CAShapeLayer layer];
        
        _chartLine.lineCap = kCALineCapSquare;
        _chartLine.fillColor   = [[UIColor whiteColor] CGColor];
        _chartLine.lineWidth   = self.frame.size.width;
        _chartLine.strokeEnd   = 0.0;
        self.clipsToBounds = YES;
        [self.layer addSublayer:_chartLine];
        
    }
    return self;
}

-(void)setGrade:(float)grade
{
    if (grade>0){
        _grade = grade;
        UIBezierPath *progressline = [UIBezierPath bezierPath];
        
        [progressline moveToPoint:CGPointMake(self.frame.size.width/2.0, self.frame.size.height+30)];
        [progressline addLineToPoint:CGPointMake(self.frame.size.width/2.0, ((1 - (grade-0.3)) * self.frame.size.height)-28)];
        
        [progressline setLineWidth:1.0];
        [progressline setLineCapStyle:kCGLineCapSquare];
        _chartLine.path = progressline.CGPath;
        
        if (_barColor) {
            _chartLine.strokeColor = [_barColor CGColor];
        }else{
            _chartLine.strokeColor = [[UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:220.0/255.0 alpha:0.7f] CGColor];
        }
        
//        UILabel *valuelabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.frame.size.height+20, self.frame.size.width, 6)];
//        valuelabel.backgroundColor = [UIColor clearColor];
//        valuelabel.textAlignment = NSTextAlignmentCenter;
//        valuelabel.textColor = [UIColor blackColor];
//        valuelabel.font = [UIFont systemFontOfSize:6];
//        valuelabel.adjustsFontSizeToFitWidth = YES;
//        valuelabel.text = [NSString stringWithFormat:@"%d",_valuetitle];
//        [self addSubview:valuelabel];
//        
//        [UIView animateWithDuration:1.5 animations:^{
//            valuelabel.frame = CGRectMake(0, ((1 - (grade-0.3)) * self.frame.size.height)-30, self.frame.size.width, 6);
//        }];
        
        CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        pathAnimation.duration = 1.5;
        pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
        pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
        pathAnimation.autoreverses = NO;
        [_chartLine addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
        
        _chartLine.strokeEnd = 2.0;
    }
}

@end
