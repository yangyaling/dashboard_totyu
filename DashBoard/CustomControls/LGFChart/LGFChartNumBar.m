//
//  LGFChartNumBar.m
//  DashBoard
//
//  Created by totyu3 on 17/2/8.
//  Copyright © 2017年 NIT. All rights reserved.
//
#define BarYValueWidth i*(_numbarview.width/_YValuesArray.count)+_numbartype

#define BarYValueFrame CGRectMake(BarYValueWidth, _numbarview.y, _numbarview.width/_YValuesArray.count, _numbarview.height)

#define LineYValueWidth i*((_numbarview.width + _numbarview.width/_YValuesArray.count + _numbarview.width/_YValuesArray.count/_YValuesArray.count)/_YValuesArray.count)

#define LineYValueFrame CGRectMake(LineYValueWidth+_numbartype-(_numbarview.width/_YValuesArray.count)/2, _numbarview.y, _numbarview.width/_YValuesArray.count, _numbarview.height)

#define NumBarRect CGRectMake(_numbartype, 0, self.width-_numbartype-10, self.height)

#define NumLineRect CGRectMake(_numbartype, 0, self.width-_numbartype-34, self.height)


#import "LGFChartNumBar.h"

@implementation LGFChartNumBar

/**
 *  storyboard添加
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    return self;
}

-(void)setNumbartype:(int)numbartype{
    _numbartype = numbartype;

    if (_numbartype!=190) {
        self.YValuesArray = @[@"0時",@"1時",@"2時",@"3時",@"4時",@"5時",@"6時",@"7時",@"8時",@"9時",@"10時",@"11時",@"12時",@"13時",@"14時",@"15時",@"16時",@"17時",@"18時",@"19時",@"20時",@"21時",@"22時",@"23時"];//默认y轴数组
    }
}

-(void)setYValuesArray:(NSArray *)YValuesArray{
    _YValuesArray = YValuesArray;
    _numbarview = [[UIView alloc]initWithFrame:_numbartype!=190 ? NumBarRect : NumLineRect];
    
    //添加y轴
    for (int i = 0; i<_YValuesArray.count; i++) {
        UILabel *NumTitle = [[UILabel alloc]initWithFrame:_numbartype!=190 ?BarYValueFrame : LineYValueFrame];
        NumTitle.font = [UIFont fontWithName:@"DBLCDTempBlack" size:_numbarview.height/3];
        NumTitle.textColor = [UIColor blackColor];
        NumTitle.textAlignment = NSTextAlignmentCenter;
        NumTitle.text = _YValuesArray[i];
        [self addSubview:NumTitle];
    }
    [self addSubview:_numbarview];
}

-(void)drawRect:(CGRect)rect{
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextMoveToPoint(context, 0 , 0);
    CGContextAddLineToPoint(context, self.width, 0);
    CGContextSetLineWidth(context, 1.5);
    [SystemColor(1.0) setStroke];
    CGContextDrawPath(context, kCGPathStroke);
}


@end
