//
//  LGFLineChart.m
//  DashBoard
//
//  Created by totyu3 on 17/2/13.
//  Copyright © 2017年 NIT. All rights reserved.
//

#define DLineY(stri) (_YMaxLength - [(stri) floatValue]) / (_YTotalLength/(self.height - 1)) + 0.5

#define LineX(stri) (stri) * (self.width / _XTotalLength)

#define LineWidth 1

#import "LGFLineChart.h"

@implementation LGFLineChart

-(instancetype)initWithFrame:(CGRect)frame LineDict:(NSDictionary *)LineDict LineType:(LineType)LineType{
    self = [super initWithFrame:frame];
    if (self) {
        UILongPressGestureRecognizer *longPressPR = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressAction:)];
        longPressPR.minimumPressDuration = 0.3;
        [self addGestureRecognizer:longPressPR];
        self.backgroundColor = [UIColor clearColor];
        _LineDataDict = [NSDictionary dictionaryWithDictionary:LineDict];
        _LineType = LineType;
        
        if (_LineType == EnvironmentSet) {
            NSArray *avgarray = [NSArray arrayWithArray:_LineDataDict[@"avg"]];
            _XTotalLength = (int)avgarray.count - 1;
        } else {
            if (_LineType == EnvironmentList) {
                _XTotalLength = 1440;
            }else{
                NSArray *dataarray = [NSArray arrayWithArray:_LineDataDict[@"data"]];
                _XTotalLength = (int)dataarray.count - 1;
            }
        }
    }
    return self;
}

-(NSArray*)TotalValueCheck:(NSMutableArray*)array{
    NSMutableArray *numarr = [NSMutableArray array];
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (![obj isEqual:@""]) {
            [numarr addObject:obj];
        }
    }];

    if ([_LineDataDict[@"actionid"] isEqualToString:@"環境1"] && _LineType == EnvironmentSet) {
        _YMaxLength = 50;
        _YMinLength = 0;
    }else if([_LineDataDict[@"actionid"] isEqualToString:@"環境2"]  && _LineType == EnvironmentSet){
        _YMaxLength = 100;
        _YMinLength = 0;
    } else {
        _YMaxLength = [[numarr valueForKeyPath:@"@max.floatValue"] floatValue];
        _YMinLength = [[numarr valueForKeyPath:@"@min.floatValue"] floatValue];
    }
    _YTotalLength = _YMaxLength - _YMinLength;
    if (_YTotalLength == 0) {
        _YTotalLength = _YMaxLength;
    }
    return numarr;
}


-(void)drawRect:(CGRect)rect{
    //获得处理的上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, LineWidth);
    [[UIColor colorWithHex:_LineDataDict[@"actioncolor"]] setStroke];
    if (_LineType == EnvironmentSet) {
        NSMutableArray *maxarr = [NSMutableArray arrayWithArray:_LineDataDict[@"max"]];
        NSMutableArray *minarr = [NSMutableArray arrayWithArray:_LineDataDict[@"min"]];
        NSMutableArray *avgarr = [NSMutableArray arrayWithArray:_LineDataDict[@"avg"]];
        
        NSMutableArray *allarr = [NSMutableArray arrayWithArray:_LineDataDict[@"max"]];
        [allarr addObjectsFromArray:minarr];
        [self TotalValueCheck:allarr];
        
        //画平均值折线
        [self DrawChartLine:context LineArray:avgarr DottedLineBOOL:NO];
        //画最大值,最小值折线
        [self DrawChartLine:context LineArray:maxarr DottedLineBOOL:YES];
        [self DrawChartLine:context LineArray:minarr DottedLineBOOL:YES];
        
        
    } else {
        [self TotalValueCheck:_LineDataDict[@"data"]];
        [self DrawChartLine:context LineArray:_LineDataDict[@"data"] DottedLineBOOL:NO];
    }
    
    [self AddAuxiliaryLine:context];
    [self AddMaxMinLabel];
}

/**
 画折线
 @param LineArray 折线数组
 @param DottedLineBOOL 是否要画虚线
 */
-(void)DrawChartLine:(CGContextRef)context LineArray:(NSArray*)LineArray DottedLineBOOL:(BOOL)DottedLineBOOL{
    //判断是否要画虚线
    if (DottedLineBOOL) {
        CGFloat arr[] = {3,1};
        CGContextSetLineDash(context, 0, arr, 2);
    }
    if (LineArray.count > 0 ) {
        [LineArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if (idx < LineArray.count-1) {//前后空数据判断
                if (![obj isEqualToString:@""]&&![LineArray[idx+1] isEqualToString:@""]) {
                    CGContextMoveToPoint(context, LineX(idx), DLineY(obj));
                    CGContextAddLineToPoint(context, LineX(idx+1), DLineY(LineArray[idx+1]));
                    CGContextDrawPath(context, kCGPathStroke);
                }
            }
        }];
    }
}
/**
 添加最大值，最小值显示
 */
-(void)AddMaxMinLabel{
    NSDictionary *attrs = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Helvetica-Bold" size:10], NSFontAttributeName, [UIColor blackColor], NSForegroundColorAttributeName, nil];
    NSDictionary *NumAttrs = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:9], NSFontAttributeName, [UIColor blackColor], NSForegroundColorAttributeName, nil];
    [@"MAX：" drawInRect:CGRectMake(2, 0, 35, 10) withAttributes:attrs];
    [[NSString stringWithFormat:@"%0.2f",_YMaxLength] drawInRect:CGRectMake(35, 0, 100, 10) withAttributes:NumAttrs];
    [@"MIN：" drawInRect:CGRectMake(2, self.height - 11, 35, 10) withAttributes:attrs];
    [[NSString stringWithFormat:@"%0.2f",_YMinLength] drawInRect:CGRectMake(35, self.height - 11, 100, 10) withAttributes:NumAttrs];
}
/**
 添加辅助线
 */
-(void)AddAuxiliaryLine:(CGContextRef)context{
    CGContextSetLineWidth(context, 0.3);
    [[UIColor blackColor] setStroke];
    CGFloat arr[] = {2,1};
    CGContextSetLineDash(context, 0, arr, 2);
    int total;
    if (_LineType == EnvironmentList) {
        total = 24;
    } else {
        total = _XTotalLength;
    }
    for (int i = 0; i <= total; i++) {
        if (i > 0 && i < total) {
            CGContextMoveToPoint(context, self.width / total * i, self.height);
            CGContextAddLineToPoint(context, self.width / total * i, 0);
        }
    }
    CGContextDrawPath(context, kCGPathStroke);
}
/**
 长按查看值
 */
- (void)longPressAction:(UILongPressGestureRecognizer *)sender{
    if (sender.state == UIGestureRecognizerStateBegan) {
        CGPoint point = [sender locationInView:self];
        int x = point.x;
        int row = (_XTotalLength + 1)/self.width * x;
        
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(RemoveDataLine) object:nil];
        [_DataLine removeFromSuperview];

        if (_LineType == EnvironmentList) {
            _DataLine = [[UIView alloc]initWithFrame:CGRectMake(x, 0, 1, self.height)];
        } else {
            _DataLine = [[UIView alloc]initWithFrame:CGRectMake((self.width / _XTotalLength) * row - 0.5, 0, 1, self.height)];
        }
        _DataLine.backgroundColor = [UIColor blackColor];
        [self addSubview:_DataLine];
        
        NSArray *DataArray;
        
        if (_LineType == EnvironmentSet) {
            DataArray = [NSArray arrayWithArray:_LineDataDict[@"avg"]];
        } else {
            DataArray = [NSArray arrayWithArray:_LineDataDict[@"data"]];
        }
        
        if (DataArray.count > 0 && row < DataArray.count && ![DataArray[row] isEqualToString:@""]) {
            if (_LineType == EnvironmentSet) {
                [self DataLineTitle:[NSString stringWithFormat:@"最大値：%0.2f 平均値：%0.2f 最小値：%0.2f",[_LineDataDict[@"max"][row] floatValue],[_LineDataDict[@"avg"][row] floatValue],[_LineDataDict[@"min"][row] floatValue]]];
            } else {
                if (_LineType == ActivitySet) {
                    [self DataLineTitle:[NSString stringWithFormat:@"%@",DataArray[row]]];
                }else{
                    [self DataLineTitle:[NSString stringWithFormat:@"%@ %0.2f",[self timeFormatted:86400/(self.width/x)],[_LineDataDict[@"data"][row] floatValue]]];
                }
            }
        }else{
            [self DataLineTitle:@"データがない"];
        }
    }else if(sender.state == UIGestureRecognizerStateEnded) {
        [self performSelector:@selector(RemoveDataLine) withObject:nil afterDelay:0.2];
        [self performSelector:@selector(RemoveDataLineTitle) withObject:nil afterDelay:1.5];
        NSLog(@"取消触摸");
    }else if(sender.state == UIGestureRecognizerStateCancelled) {
        [_DataLine removeFromSuperview];
        [_DataLineTitle removeFromSuperview];
        NSLog(@"取消取消");
    }
}

-(void)DataLineTitle:(NSString*)DataLineTitleText{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(RemoveDataLineTitle) object:nil];
    [_DataLineTitle removeFromSuperview];
    CGSize size=[DataLineTitleText sizeWithAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"Helvetica-Bold" size:12]}];
    _DataLineTitle = [[UILabel alloc]initWithFrame:CGRectMake(self.width / 2 - ((size.width+20) / 2), self.height / 2 - 10, size.width+20, 20)];
    _DataLineTitle.text = DataLineTitleText;
    _DataLineTitle.backgroundColor = [UIColor whiteColor];
    _DataLineTitle.textColor = SystemColor(1.0);
    _DataLineTitle.textAlignment = NSTextAlignmentCenter;
    _DataLineTitle.font = [UIFont fontWithName:@"Helvetica-Bold" size:12];
    _DataLineTitle.layer.borderWidth = 0.5;
    _DataLineTitle.layer.borderColor = SystemColor(1.0).CGColor;
    _DataLineTitle.clipsToBounds = YES;
    _DataLineTitle.layer.cornerRadius = _DataLineTitle.height/2;
    [self addSubview:_DataLineTitle];
}

-(void)RemoveDataLineTitle{
    [_DataLineTitle removeFromSuperview];
}

-(void)RemoveDataLine{
    [_DataLine removeFromSuperview];
}

- (NSString *)timeFormatted:(int)totalSeconds{
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    int hours = totalSeconds / 3600;
    return [NSString stringWithFormat:@"%02d時%02d分%02d秒",hours, minutes, seconds];
}
@end
