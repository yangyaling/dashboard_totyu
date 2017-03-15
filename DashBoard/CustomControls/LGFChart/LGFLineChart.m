//
//  LGFLineChart.m
//  DashBoard
//
//  Created by totyu3 on 17/2/13.
//  Copyright © 2017年 NIT. All rights reserved.
//

#define SLineY(stri) ((self.height-4)-[(stri) floatValue]*((self.height-4)/_YTotalLength))+2

#define DLineY(stri) (self.height-2) - ((_YMaxLength-[(stri) floatValue]) / (_YTotalLength/(self.height-2))-1)

#define LineX(stri) (stri)*(self.width/_XTotalLength)

#define LineWidth 2

#import "LGFLineChart.h"

@implementation LGFLineChart

-(instancetype)initWithFrame:(CGRect)frame LineDict:(NSDictionary *)LineDict LineType:(int)LineType{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _LineDataDict = [NSDictionary dictionaryWithDictionary:LineDict];
        _LineType = LineType;
        if (_LineType==2) {
            NSArray *avgarray = [NSArray arrayWithArray:self.LineDataDict[@"avg"]];
            _XTotalLength = (int)avgarray.count-1;
        }else{
            _LineDataArray = [NSArray arrayWithArray:self.LineDataDict[@"data"]];
            _XTotalLength = (int)self.LineDataArray.count-1;
        }

        NSMutableArray *maxnumarr = [NSMutableArray array];
        for (id vlaue in _LineDataArray) {
            if (![NSNullJudge(vlaue) isEqual:@""]) {
                [maxnumarr addObject:vlaue];
            }
        }
        
        _YTotalLength = [[maxnumarr valueForKeyPath:@"@max.floatValue"] floatValue]-[[maxnumarr valueForKeyPath:@"@min.floatValue"] floatValue];
        _YMaxLength = [[maxnumarr valueForKeyPath:@"@max.floatValue"] floatValue];
        _YMinLength = _LineType == 0 ? [[maxnumarr valueForKeyPath:@"@min.floatValue"] floatValue] : 0.0;
        if (_YTotalLength==0) _YTotalLength=1;
    }
    return self;
}


-(void)drawRect:(CGRect)rect{

    //获得处理的上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    //设置线条粗细宽度
    CGContextSetLineWidth(context, LineWidth);

    //设置颜色
    [[UIColor colorWithHex:_LineDataDict[@"actioncolor"]] setStroke];

    if (_LineType==2) {
        NSArray *avgarray = [NSArray arrayWithArray:self.LineDataDict[@"avg"]];
        CGContextMoveToPoint(context, 0, SLineY(avgarray[0]));
        for (int i = 1; i<avgarray.count; i++) {
            if (![NSNullJudge(avgarray[i]) isEqual:@""]) {
                CGContextAddLineToPoint(context, LineX(i), SLineY(avgarray[i]));
            }
        }
        CGContextDrawPath(context, kCGPathStroke);
        
        NSArray *maxarray = [NSArray arrayWithArray:self.LineDataDict[@"max"]];
        CGContextMoveToPoint(context, 0, SLineY(maxarray[0]));
        for (int i = 1; i<maxarray.count; i++) {
            if (![NSNullJudge(maxarray[i]) isEqual:@""]) {
                CGContextAddLineToPoint(context, LineX(i), SLineY(maxarray[i]));
                CGFloat arr[] = {3,1};
                CGContextSetLineDash(context, 0, arr, 2);
            }
        }
        CGContextDrawPath(context, kCGPathStroke);
        
        NSArray *minarray = [NSArray arrayWithArray:self.LineDataDict[@"min"]];
        CGContextMoveToPoint(context, 0, SLineY(minarray[0]));
        for (int i = 1; i<minarray.count; i++) {
            if (![NSNullJudge(minarray[i]) isEqual:@""]) {
                CGContextAddLineToPoint(context, LineX(i), SLineY(minarray[i]));
                CGFloat arr[] = {3,1};
                CGContextSetLineDash(context, 0, arr, 2);
            }
        }
        CGContextDrawPath(context, kCGPathStroke);
        
    }else{
        if (_LineDataArray.count > 0 ) {
            CGContextMoveToPoint(context, 0, _LineType == 0 ? DLineY(_LineDataArray[0]) : SLineY(_LineDataArray[0]));
            for (int i = 1; i<_LineDataArray.count; i++) {
                if (![NSNullJudge(_LineDataArray[i]) isEqual:@""]) {
                    CGContextAddLineToPoint(context, LineX(i), _LineType == 0 ? DLineY(_LineDataArray[i]) : SLineY(_LineDataArray[i]));
                }
            }
            CGContextDrawPath(context, kCGPathStroke);
        }
    }
    
    //添加辅助线
    CGContextSetLineWidth(context, 0.1);
    [[UIColor blackColor] setStroke];
    CGFloat arr[] = {2,1};
    CGContextSetLineDash(context, 0, arr, 2);
    int total;
    if (_LineType==0) {
        total = 24;
    }else{
        total = _XTotalLength;
    }
    for (int i = 0; i<=total; i++) {
        if (i>0&&i<total) {
            CGContextMoveToPoint(context, self.width/total * i, self.height);
            CGContextAddLineToPoint(context, self.width/total * i, 0);
        }
    }
    CGContextDrawPath(context, kCGPathStroke);
    
    NSDictionary *attrs = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Helvetica-Bold" size:9], NSFontAttributeName, [UIColor redColor], NSForegroundColorAttributeName, nil];
    NSDictionary *NumAttrs = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"DBLCDTempBlack" size:10], NSFontAttributeName, [UIColor blackColor], NSForegroundColorAttributeName, nil];
    //添加x轴
    [@"MAX：" drawInRect:CGRectMake(2, self.height/2-10, 30, 10) withAttributes:attrs];
    [[NSString stringWithFormat:@"%0.2f",_YMaxLength] drawInRect:CGRectMake(32, self.height/2-9, 100, 10) withAttributes:NumAttrs];
    
    [@"MIN：" drawInRect:CGRectMake(2, self.height/2, 30, 10) withAttributes:attrs];
    [[NSString stringWithFormat:@"%0.2f",_YMinLength] drawInRect:CGRectMake(32, self.height/2+1, 100, 10) withAttributes:NumAttrs];
}

//-(UIImage*)convertViewToImage:(UIView*)view{
//    
//    CGSize barview = view.bounds.size;
//    UIGraphicsBeginImageContextWithOptions(barview, NO, [UIScreen mainScreen].scale);
//    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
//    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return image;
//}

@end
