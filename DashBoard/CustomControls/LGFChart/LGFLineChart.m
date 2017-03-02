//
//  LGFLineChart.m
//  DashBoard
//
//  Created by totyu3 on 17/2/13.
//  Copyright © 2017年 NIT. All rights reserved.
//

#define LineY(stri) ((self.height-4)-[(stri) floatValue]*((self.height-4)/_YTotalLength))+2

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
        
        if ([LineDict[@"actionid"] isEqualToString:@"環境1"]) {
            _YTotalLength = 50;
        }else if([LineDict[@"actionid"] isEqualToString:@"環境2"]){
            _YTotalLength = 100;
        }else{
            NSMutableArray *maxnumarr = [NSMutableArray array];
            for (id vlaue in _LineDataArray) {
                if (![NSNullJudge(vlaue) isEqual:@""]) {
                    [maxnumarr addObject:vlaue];
                }
            }
            _YTotalLength = [[maxnumarr valueForKeyPath:@"@max.floatValue"] intValue]*2;
        }
    }
    return self;
}


-(void)drawRect:(CGRect)rect{

    //获得处理的上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    //设置线条粗细宽度
    CGContextSetLineWidth(context, LineWidth);
    
    NSDictionary *attrs = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Helvetica-Bold" size:self.width/100], NSFontAttributeName, [UIColor redColor], NSForegroundColorAttributeName, nil];
    NSDictionary *NumAttrs = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"DBLCDTempBlack" size:self.width/100], NSFontAttributeName, [UIColor blackColor], NSForegroundColorAttributeName, nil];
    //添加x轴
    [@"MAX：" drawInRect:CGRectMake(2, 0, 30, 20) withAttributes:attrs];
    [[NSString stringWithFormat:@"%d",_YTotalLength] drawInRect:CGRectMake(30, 1, 100, 20) withAttributes:NumAttrs];
    
    //设置颜色
    [[UIColor colorWithHex:_LineDataDict[@"actioncolor"]] setStroke];

    if (_LineType==2) {
        NSArray *avgarray = [NSArray arrayWithArray:self.LineDataDict[@"avg"]];
        CGContextMoveToPoint(context, 0, LineY(avgarray[0]));
        for (int i = 1; i<avgarray.count; i++) {
            if (![NSNullJudge(avgarray[i]) isEqual:@""]) {
                CGContextAddLineToPoint(context, LineX(i), LineY(avgarray[i]));
            }
        }
        CGContextDrawPath(context, kCGPathStroke);
        
        NSArray *maxarray = [NSArray arrayWithArray:self.LineDataDict[@"max"]];
        CGContextMoveToPoint(context, 0, LineY(maxarray[0]));
        for (int i = 1; i<maxarray.count; i++) {
            if (![NSNullJudge(maxarray[i]) isEqual:@""]) {
                CGContextAddLineToPoint(context, LineX(i), LineY(maxarray[i]));
                CGFloat arr[] = {3,1};
                CGContextSetLineDash(context, 0, arr, 2);
            }
        }
        CGContextDrawPath(context, kCGPathStroke);
        
        NSArray *minarray = [NSArray arrayWithArray:self.LineDataDict[@"min"]];
        CGContextMoveToPoint(context, 0, LineY(minarray[0]));
        for (int i = 1; i<minarray.count; i++) {
            if (![NSNullJudge(minarray[i]) isEqual:@""]) {
                CGContextAddLineToPoint(context, LineX(i), LineY(minarray[i]));
                CGFloat arr[] = {3,1};
                CGContextSetLineDash(context, 0, arr, 2);
            }
        }
        CGContextDrawPath(context, kCGPathStroke);
        
    }else{
        if (_LineDataArray.count > 0 ) {
            CGContextMoveToPoint(context, 0, LineY(_LineDataArray[0]));
            for (int i = 1; i<_LineDataArray.count; i++) {
                if (![NSNullJudge(_LineDataArray[i]) isEqual:@""]) {
                    CGContextAddLineToPoint(context, LineX(i), LineY(_LineDataArray[i]));
                }
            }
            CGContextDrawPath(context, kCGPathStroke);
        }
    }
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
