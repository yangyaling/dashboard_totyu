//
//  LGFLineChart.m
//  DashBoard
//
//  Created by totyu3 on 17/2/13.
//  Copyright © 2017年 NIT. All rights reserved.
//

#define DLineY(stri) (_YMaxLength - [(stri) floatValue]) / (_YTotalLength/(self.height - 2)) + 1

#define LineX(stri) (stri) * (self.width / _XTotalLength)

#define LineWidth 1

#import "LGFLineChart.h"

@implementation LGFLineChart

-(instancetype)initWithFrame:(CGRect)frame LineDict:(NSDictionary *)LineDict LineType:(LineType)LineType{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _LineDataDict = [NSDictionary dictionaryWithDictionary:LineDict];
        _LineType = LineType;
        
        if (_LineType == EnvironmentSet) {
            NSArray *avgarray = [NSArray arrayWithArray:_LineDataDict[@"avg"]];
            _XTotalLength = (int)avgarray.count - 1;
        } else {
            NSArray *dataarray = [NSArray arrayWithArray:_LineDataDict[@"data"]];
            _XTotalLength = (int)dataarray.count - 1;
        }
    }
    return self;
}

-(NSArray*)TotalValueCheck:(NSArray*)array{
    NSMutableArray *numarr = [NSMutableArray array];
    for (id vlaue in array) {
        if (![vlaue isEqual:@""]) {
            [numarr addObject:vlaue];
        }
    }
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
    return numarr;
}


-(void)drawRect:(CGRect)rect{
    //获得处理的上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, LineWidth);
    [[UIColor colorWithHex:_LineDataDict[@"actioncolor"]] setStroke];
    if (_LineType == EnvironmentSet) {
        //画平均值折线
        [self DrawChartLine:context LineArray:[self TotalValueCheck:_LineDataDict[@"avg"]] DottedLineBOOL:NO];
        //画最大值,最小值折线
        [self DrawChartLine:context LineArray:[self TotalValueCheck:_LineDataDict[@"max"]] DottedLineBOOL:YES];
        [self DrawChartLine:context LineArray:[self TotalValueCheck:_LineDataDict[@"min"]] DottedLineBOOL:YES];
    } else {
        [self DrawChartLine:context LineArray:[self TotalValueCheck:_LineDataDict[@"data"]] DottedLineBOOL:NO];
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
        CGContextMoveToPoint(context, 0, DLineY(LineArray[0]));
        for (int i = 1; i < LineArray.count; i++) {
            CGContextAddLineToPoint(context, LineX(i), DLineY(LineArray[i]));
        }
        CGContextDrawPath(context, kCGPathStroke);
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
 触摸查看值
 */
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSSet *allTouches = [event allTouches];    //返回与当前接收者有关的所有的触摸对象
    UITouch *touch = [allTouches anyObject];   //视图中的所有对象
    CGPoint point = [touch locationInView:[touch view]]; //返回触摸点在视图中的当前坐标
    int x = point.x;
    int row = (_XTotalLength + 1)/self.width * x;
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(RemoveDataLine) object:nil];
    [_DataLine removeFromSuperview];

    if (![_LineDataDict[@"data"][row] isEqualToString:@""] && ![_LineDataDict[@"avg"][row] isEqualToString:@""]) {
        
        if (_LineType == EnvironmentList) {
            _DataLine = [[UIView alloc]initWithFrame:CGRectMake(x, 0, 1, self.height)];
        } else {
            _DataLine = [[UIView alloc]initWithFrame:CGRectMake((self.width / _XTotalLength) * row - 0.5, 0, 1, self.height)];
        }
        _DataLine.backgroundColor = SystemColor(1.0);
        [self addSubview:_DataLine];

        if (_LineType == EnvironmentSet) {
            [self DataLineTitle:[NSString stringWithFormat:@"最大値：%@ 平均値：%@ 最小値：%@",_LineDataDict[@"max"][row],_LineDataDict[@"avg"][row],_LineDataDict[@"min"][row]]];
        } else {
            [self DataLineTitle:[NSString stringWithFormat:@"%@",_LineDataDict[@"data"][row]]];
        }
    }
}

-(void)DataLineTitle:(NSString*)DataLineTitleText{
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(RemoveDataLineTitle) object:nil];
    [_DataLineTitle removeFromSuperview];
    CGSize size=[DataLineTitleText sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12]}];
    _DataLineTitle = [[UILabel alloc]initWithFrame:CGRectMake(self.width / 2 - ((size.width+20) / 2), self.height / 2 - 10, size.width+20, 20)];
    _DataLineTitle.text = DataLineTitleText;
    _DataLineTitle.backgroundColor = SystemColor(1.0);
    _DataLineTitle.textColor = [UIColor whiteColor];
    _DataLineTitle.textAlignment = NSTextAlignmentCenter;
    _DataLineTitle.font = [UIFont systemFontOfSize:12];
    _DataLineTitle.clipsToBounds = YES;
    _DataLineTitle.layer.cornerRadius = 3.0;
    [self addSubview:_DataLineTitle];
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    [self performSelector:@selector(RemoveDataLine) withObject:nil afterDelay:0.2];
    [self performSelector:@selector(RemoveDataLineTitle) withObject:nil afterDelay:1];
    NSLog(@"取消触摸");
}

-(void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_DataLine removeFromSuperview];
    [_DataLineTitle removeFromSuperview];
    NSLog(@"取消取消");
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
    return [NSString stringWithFormat:@"%02d:%02d:%02d",hours, minutes, seconds];
}
@end
