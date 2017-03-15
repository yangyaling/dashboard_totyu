//
//  LGFBarChart.m
//  DashBoard
//
//  Created by totyu3 on 17/2/8.
//  Copyright © 2017年 NIT. All rights reserved.
//

#define BarX(stri) [(stri) floatValue]*(self.width/TotalLength)

#define TotalLength 1440

#import "LGFBarChart.h"

@implementation LGFBarChart

-(instancetype)initWithFrame:(CGRect)frame BarData:(id)BarData BarType:(int)BarType{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.BarType = BarType;
        if ([BarData isKindOfClass:[NSDictionary class]]) {
            self.BarDataDict = [NSDictionary dictionaryWithDictionary:BarData];
        }else{
            self.BarDataArray=[NSArray arrayWithArray:[[BarData reverseObjectEnumerator] allObjects]];
        }
    }
    return self;
}

-(void)drawRect:(CGRect)rect{
    
    NSMutableDictionary *SystemUserDict = [NSMutableDictionary dictionaryWithContentsOfFile:SYSTEM_USER_DICT];
    NSMutableArray *systemactioninfo = [SystemUserDict objectForKey:@"systemactioninfo"];

    //获得处理的上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    //设置线条粗细宽度
    CGContextSetLineWidth(context, self.frame.size.width/TotalLength*2);
    if (_BarType==1) {
        if (_BarDataArray) {
            for (NSDictionary *DataDict in _BarDataArray) {
                for (NSDictionary *removedict in systemactioninfo) {
                    if ([removedict[@"actionid"] isEqualToString:DataDict[@"actionid"]]) {
                        if (removedict[@"selecttype"]) {
                            if (![removedict[@"selecttype"] isEqualToString:@"YES"]) {
                                NSArray *DataArray = DataDict[@"data"];
                                for (int i = 0; i<DataArray.count; i++) {
                                    [[UIColor colorWithHex:DataDict[@"actioncolor"]] setStroke];
                                    CGContextMoveToPoint(context, BarX(DataArray[i]), self.height);
                                    CGContextAddLineToPoint(context, BarX(DataArray[i]), 0);
                                }
                                CGContextDrawPath(context, kCGPathStroke);
                            }
                        }else{
                            NSArray *DataArray = DataDict[@"data"];
                            for (int i = 0; i<DataArray.count; i++) {
                                [[UIColor colorWithHex:DataDict[@"actioncolor"]] setStroke];
                                CGContextMoveToPoint(context, BarX(DataArray[i]), self.height);
                                CGContextAddLineToPoint(context, BarX(DataArray[i]), 0);
                            }
                            CGContextDrawPath(context, kCGPathStroke);
                        }
                    }
                }
            }
        } else {
            for (NSDictionary *removedict in systemactioninfo) {
                if ([removedict[@"actionid"] isEqualToString:_BarDataDict[@"actionid"]]) {
                    if (removedict[@"selecttype"]) {
                        if (![removedict[@"selecttype"] isEqualToString:@"YES"]) {
                            [[UIColor colorWithHex:_BarDataDict[@"actioncolor"]] setStroke];
                            NSArray *array = [NSArray arrayWithArray:_BarDataDict[@"data"]];
                            for (int i = 0; i<array.count; i++) {
                                CGContextMoveToPoint(context, BarX(array[i]), self.height);
                                CGContextAddLineToPoint(context, BarX(array[i]), 0);
                            }
                            CGContextDrawPath(context, kCGPathStroke);
                        }
                    }else{
                        [[UIColor colorWithHex:_BarDataDict[@"actioncolor"]] setStroke];
                        NSArray *array = [NSArray arrayWithArray:_BarDataDict[@"data"]];
                        for (int i = 0; i<array.count; i++) {
                            CGContextMoveToPoint(context, BarX(array[i]), self.height);
                            CGContextAddLineToPoint(context, BarX(array[i]), 0);
                        }
                        CGContextDrawPath(context, kCGPathStroke);
                    }
                }
            }
        }
    } else {
        NSArray *array = [NSArray arrayWithArray:_BarDataDict[@"data"]];
        NSArray *colorarray = [_BarDataDict[@"actioncolor"] componentsSeparatedByString:@"|"];
        for (int i = 0; i<array.count; i++) {
            if ([array[i] intValue]==1) {
                [[UIColor colorWithHex:colorarray[0]] setStroke];
            }else{
                [[UIColor colorWithHex:colorarray[1]] setStroke];
            }
            CGContextMoveToPoint(context, i*(self.width/TotalLength), self.height);
            CGContextAddLineToPoint(context, i*(self.width/TotalLength), 0);
            CGContextDrawPath(context, kCGPathStroke);
        }
    }
    
    //添加辅助线
    CGContextSetLineWidth(context, 0.1);
    [[UIColor blackColor] setStroke];
    CGFloat arr[] = {2,1};
    CGContextSetLineDash(context, 0, arr, 2);
    for (int i = 0; i<=24; i++) {
        if (i>0&&i<24) {
            CGContextMoveToPoint(context, self.width/24 * i, self.height);
            CGContextAddLineToPoint(context, self.width/24 * i, 0);
        }
    }
    CGContextDrawPath(context, kCGPathStroke);
}

@end
