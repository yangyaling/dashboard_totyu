//
//  LGFChartNumBar.m
//  DashBoard
//
//  Created by totyu3 on 17/2/8.
//  Copyright © 2017年 NIT. All rights reserved.
//
#define BarYValueWidth idx*(_numbarview.width / _YValuesArray.count) + _numbartype

#define BarYValueFrame CGRectMake(BarYValueWidth, _numbarview.y, _numbarview.width/_YValuesArray.count, _numbarview.height)

#define LineYValueWidth idx*((_numbarview.width + _numbarview.width / _YValuesArray.count + _numbarview.width / _YValuesArray.count / _YValuesArray.count) / _YValuesArray.count)

#define LineYValueFrame CGRectMake(LineYValueWidth + _numbartype - (_numbarview.width / _YValuesArray.count) / 2, _numbarview.y, _numbarview.width / _YValuesArray.count, _numbarview.height)

#define NumBarRect CGRectMake(_numbartype, 0, self.width - _numbartype - 10, self.height)

#define NumLineRect CGRectMake(_numbartype, 0, self.width - _numbartype - 35, self.height)


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
    if (_numbartype != 190) {
        self.YValuesArray = @[@"0時",@"1時",@"2時",@"3時",@"4時",@"5時",@"6時",@"7時",@"8時",@"9時",@"10時",@"11時",@"12時",@"13時",@"14時",@"15時",@"16時",@"17時",@"18時",@"19時",@"20時",@"21時",@"22時",@"23時"];//默认y轴数组
    }
}

-(void)layoutSubviews{
    if (_numbartype != 190) {
        [self addnumbarview];
    }
}

-(void)setYValuesArray:(NSArray *)YValuesArray{
    _YValuesArray = YValuesArray;
    if (!(_numbartype != 190)) {
        [self addnumbarview];
    }
}

-(void)addnumbarview{
    [_numbarview removeFromSuperview];
    _numbarview = [[UIView alloc]initWithFrame:_numbartype != 190 ? NumBarRect : NumLineRect];
    //添加y轴
    [_YValuesArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UILabel *NumTitle = [[UILabel alloc]initWithFrame:_numbartype != 190 ? BarYValueFrame : LineYValueFrame];
        NumTitle.font = [UIFont systemFontOfSize:_numbarview.height / 3];
        NumTitle.adjustsFontSizeToFitWidth = YES;
        NumTitle.textColor = [UIColor blackColor];
        NumTitle.textAlignment = NSTextAlignmentCenter;
        NumTitle.text = obj;
        [self addSubview:NumTitle];
    }];
    [self addSubview:_numbarview];
}

@end
