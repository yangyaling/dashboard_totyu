//
//  LGFBarChart.m
//  DashBoard
//
//  Created by totyu3 on 17/2/8.
//  Copyright © 2017年 NIT. All rights reserved.
//

#define BarX(stri) [(stri) floatValue] * (self.width / TotalLength)

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
        } else {
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
    CGContextSetLineWidth(context, self.frame.size.width / TotalLength * 2);
    if (_BarType == 1) {
        if (_BarDataArray) {
            for (NSDictionary *DataDict in _BarDataArray) {
                [self DrawChartBar:context BarDict:DataDict SYSInfo:systemactioninfo];
            }
        } else {
            [self DrawChartBar:context BarDict:_BarDataDict SYSInfo:systemactioninfo];
        }
    } else {
        NSArray *array = [NSArray arrayWithArray:_BarDataDict[@"data"]];
        NSArray *colorarray = [_BarDataDict[@"actioncolor"] componentsSeparatedByString:@"|"];
        for (int i = 0; i < array.count; i++) {
            if ([array[i] intValue] == 1) {
                [[UIColor colorWithHex:colorarray[0]] setStroke];
            } else {
                [[UIColor colorWithHex:colorarray[1]] setStroke];
            }
            CGContextMoveToPoint(context, i * (self.width/TotalLength), self.height);
            CGContextAddLineToPoint(context, i * (self.width/TotalLength), 0);
            CGContextDrawPath(context, kCGPathStroke);
        }
    }
    [self AddAuxiliaryLine:context];
}
/**
 添加辅助线
 */
-(void)AddAuxiliaryLine:(CGContextRef)context{
    CGContextSetLineWidth(context, 0.3);
    [[UIColor blackColor] setStroke];
    CGFloat arr[] = { 2, 1};
    CGContextSetLineDash(context, 0, arr, 2);
    for (int i = 0; i <= 24; i++) {
        if (i > 0 && i < 24) {
            CGContextMoveToPoint(context, self.width / 24 * i, self.height);
            CGContextAddLineToPoint(context, self.width / 24 * i, 0);
        }
    }
    CGContextDrawPath(context, kCGPathStroke);
}
/**
 画柱
 @param BarDict 柱字典
 @param SYSInfo 是否显示判断用字典
 */
-(void)DrawChartBar:(CGContextRef)context BarDict:(NSDictionary*)BarDict SYSInfo:(NSMutableArray*)SYSInfo{
    [[UIColor colorWithHex:BarDict[@"actioncolor"]] setStroke];
    for (NSDictionary *removedict in SYSInfo) {
        if ([removedict[@"actionid"] isEqualToString:BarDict[@"actionid"]]) {
            if (![removedict[@"selecttype"] isEqualToString:@"YES"]) {
                NSArray *DataArray = BarDict[@"data"];
                for (int i = 0; i < DataArray.count; i++) {
                    CGContextMoveToPoint(context, BarX(DataArray[i]), self.height);
                    CGContextAddLineToPoint(context, BarX(DataArray[i]), 0);
                }
                CGContextDrawPath(context, kCGPathStroke);
            }
        }
    }
}
///**
// 触摸查看值
// */
//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
//    NSSet *allTouches = [event allTouches];    //返回与当前接收者有关的所有的触摸对象
//    UITouch *touch = [allTouches anyObject];   //视图中的所有对象
//    CGPoint point = [touch locationInView:[touch view]]; //返回触摸点在视图中的当前坐标
//    int x = point.x;
//    
//    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(RemoveDataLine) object:nil];
//    [_DataLine removeFromSuperview];
//    _DataLine = [[UIView alloc]initWithFrame:CGRectMake(x, 0, 1, self.height)];
//    _DataLine.backgroundColor = SystemColor(1.0);
//    [self addSubview:_DataLine];
//    [self DataLineTitle:[self timeFormatted:86400/(self.width/x)]];
//}
//-(void)DataLineTitle:(NSString*)DataLineTitleText{
//    
//    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(RemoveDataLineTitle) object:nil];
//    [_DataLineTitle removeFromSuperview];
//    CGSize size=[DataLineTitleText sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12]}];
//    _DataLineTitle = [[UILabel alloc]initWithFrame:CGRectMake(self.width / 2 - ((size.width+20) / 2), self.height / 2 - 10, size.width+20, 20)];
//    _DataLineTitle.text = DataLineTitleText;
//    _DataLineTitle.backgroundColor = SystemColor(1.0);
//    _DataLineTitle.textColor = [UIColor whiteColor];
//    _DataLineTitle.textAlignment = NSTextAlignmentCenter;
//    _DataLineTitle.font = [UIFont systemFontOfSize:12];
//    _DataLineTitle.clipsToBounds = YES;
//    _DataLineTitle.layer.cornerRadius = 3.0;
//    [self addSubview:_DataLineTitle];
//}
//
//-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    
//    [self performSelector:@selector(RemoveDataLine) withObject:nil afterDelay:0.2];
//    [self performSelector:@selector(RemoveDataLineTitle) withObject:nil afterDelay:1];
//    NSLog(@"取消触摸");
//}
//
//-(void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    [_DataLine removeFromSuperview];
//    [_DataLineTitle removeFromSuperview];
//    NSLog(@"取消取消");
//}
//
//-(void)RemoveDataLineTitle{
//    [_DataLineTitle removeFromSuperview];
//}
//
//-(void)RemoveDataLine{
//    [_DataLine removeFromSuperview];
//}
//
//- (NSString *)timeFormatted:(int)totalSeconds{
//    int seconds = totalSeconds % 60;
//    int minutes = (totalSeconds / 60) % 60;
//    int hours = totalSeconds / 3600;
//    return [NSString stringWithFormat:@"%02d:%02d:%02d",hours, minutes, seconds];
//}
@end
