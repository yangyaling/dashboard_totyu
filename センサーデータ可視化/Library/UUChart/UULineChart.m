//
//  UULineChart.m
//  UUChartDemo
//
//  Created by shake on 14-7-24.
//  Copyright (c) 2014年 uyiuyao. All rights reserved.
//

#import "UULineChart.h"
#import "UUColor.h"
#import "UUChartLabel.h"
#import "UUChart.h"

@implementation UULineChart {
    
    int deviceclassid;
    //    int uiType;
    CAShapeLayer *_chartLine2;
    CAGradientLayer *gradientLayer;
}
-(void)backgroundColor:(int)deviceclass devicemodel:(LifeRhythmVCModel*)model withdate:(NSString *)date{
    deviceclassid = deviceclass;
    _ChartModel = model;
    NSString *sensorname;
    if (deviceclassid==1) {
        sensorname = [NSString stringWithFormat:@"%@:%.2f%@",model.devicename,[model.latestvalue floatValue],model.deviceunit];
        if ([model.devicename isEqualToString:@"温度"]) {
            UIColor *lightG = NITColorAlpha(255,90,75,0.7);
            UIColor *darkG = NITColorAlpha(215,51,30,1);
            CAGradientLayer *gradient = [CAGradientLayer layer];
            gradient.colors = [NSArray arrayWithObjects:(id)lightG.CGColor,(id)darkG.CGColor, nil];
            gradient.frame = self.bounds;
            [self.layer insertSublayer:gradient atIndex:0];
        }else if([model.devicename isEqualToString:@"湿度"]){
            UIColor * lightG= NITColorAlpha(155,125,255,0.7);
            UIColor *darkG = NITColorAlpha(115,65,255,1);
            CAGradientLayer *gradient = [CAGradientLayer layer];
            gradient.colors = [NSArray arrayWithObjects:(id)lightG.CGColor,(id)darkG.CGColor, nil];
            gradient.frame = self.bounds;
            [self.layer insertSublayer:gradient atIndex:0];
        }else{
            UIColor * lightG= NITColorAlpha(235,235,0,0.7);
            UIColor *darkG = NITColorAlpha(205,165,0,1);
            CAGradientLayer *gradient = [CAGradientLayer layer];
            gradient.colors = [NSArray arrayWithObjects:(id)lightG.CGColor,(id)darkG.CGColor, nil];
            gradient.frame = self.bounds;
            [self.layer insertSublayer:gradient atIndex:0];
        }
    }else{
        sensorname = model.devicename;
        UIColor *lightG = NITColorAlpha(115,180,255,1);
        UIColor *darkG = NITColorAlpha(85,160,225,1);
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.colors = [NSArray arrayWithObjects:(id)lightG.CGColor,(id)darkG.CGColor, nil];
        gradient.frame = self.bounds;
        [self.layer insertSublayer:gradient atIndex:0];
    }
    
    UILabel*typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width*0.8, self.frame.size.height)];
    typeLabel.center = self.center;
    typeLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:55];
    typeLabel.alpha = 0.2;
    typeLabel.textAlignment = NSTextAlignmentCenter;
    typeLabel.textColor = [UIColor whiteColor];
    typeLabel.text = sensorname;
    typeLabel.adjustsFontSizeToFitWidth = YES;
    [self addSubview:typeLabel];
    
    UILabel*dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width*0.75, 0, self.frame.size.width*0.22, 17 )];
    dateLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:11];
    dateLabel.alpha = 0.8;
    dateLabel.textAlignment = NSTextAlignmentRight;
    dateLabel.textColor = [UIColor whiteColor];
    dateLabel.text = date;
    dateLabel.adjustsFontSizeToFitWidth = YES;
    
    [self addSubview:dateLabel];
    
//        UILabel*unitLabel = [[UILabel alloc]initWithFrame:CGRectMake(4, 0, 30, 20)];
//        [unitLabel setFont:[UIFont boldSystemFontOfSize:10.0f]];
//        unitLabel.textAlignment = NSTextAlignmentLeft;
//        unitLabel.textColor = [UIColor whiteColor];
//        unitLabel.text = model.deviceunit;
//    
//        UIView*pathLabel = [[UIView alloc]initWithFrame:CGRectMake(0,16, [UIScreen mainScreen].bounds.size.width,0.5)];
//        pathLabel.backgroundColor = [UIColor whiteColor];
//    
//        UIView*pathLabelTwo = [[UIView alloc]initWithFrame:CGRectMake(0,self.bounds.size.height-15, [UIScreen mainScreen].bounds.size.width,0.5)];
//        pathLabelTwo.backgroundColor = [UIColor whiteColor];
//        [self addSubview:pathLabelTwo];
//        [self addSubview:pathLabel];
//        [self addSubview:unitLabel];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.clipsToBounds = YES;
        self.layer.cornerRadius = 6;
        self.opaque = YES;
        
    }
    
    return self;
}

-(void)setYValues:(NSArray *)yValues
{
    _yValues = yValues;
    
}
-(void)setYValuesTwo:(NSArray *)yValues2
{
    [self setYLabels:yValues2];
}

-(void)setYLabels:(NSArray *)yLabels
{
    
    if ([_ChartModel.devicename isEqualToString:@"温度"]) {
        _yValueMax = 40;
        _yValueMin = 0;
    } else if ([_ChartModel.devicename isEqualToString:@"湿度"]) {
        _yValueMax = 100;
        _yValueMin = 0;
        
    } else if ([_ChartModel.devicename isEqualToString:@"明るさ"]) {
        _yValueMax = 100;
        _yValueMin = 0;
    } else {
        NSInteger max = 0;
        NSInteger min = 1000000000;
        
        for (NSArray * ary in yLabels) {
            for (NSString *valueString in ary) {
                NSInteger value = [valueString integerValue];
                if (value > max) {
                    max = value;
                }
                if (value < min) {
                    min = value;
                }
            }
        }
        if (max <= 1) {
            max = 1;
        }
        if (self.showRange) {
            _yValueMin = min;
        }else{
            _yValueMin = 0;
        }
        _yValueMax = (int)max;
        
        if (_chooseRange.max!=_chooseRange.min) {
            _yValueMax = _chooseRange.max;
            _yValueMin = _chooseRange.min;
        }
    }
    float level = (_yValueMax-_yValueMin) /4.0;
    CGFloat chartCavanHeight = (self.frame.size.height*0.9 - UULabelHeight*3)*1.05;
    CGFloat levelHeight = chartCavanHeight /3.5;
    
    for (int i=0; i<5; i++) {
        if (i==0||i==4) {
            UUChartLabel * label = [[UUChartLabel alloc] initWithFrame:CGRectMake(0.0,chartCavanHeight - i*levelHeight+20, UUYLabelwidth+9, UULabelHeight+16.5)];
            label.textAlignment = NSTextAlignmentCenter;
            label.text = [NSString stringWithFormat:@"%d",(int)(level * i+_yValueMin)];
            [self addSubview:label];
        }
    }
    
}


-(void)setXLabels:(NSArray *)xLabels
{
    
    _xLabels = xLabels;
    CGFloat num = 0;
    
    num = xLabels.count;
    
    _xLabelWidth = (self.frame.size.width-5 - UUYLabelwidth)/num;
    
    for (int i=0; i<xLabels.count; i++) {
        
        NSString *labelText = xLabels[i];
        UUChartLabel * label = [[UUChartLabel alloc] initWithFrame:CGRectMake(i * _xLabelWidth+UUYLabelwidth, self.frame.size.height - UULabelHeight, _xLabelWidth, UULabelHeight)];
        
        label.text = labelText;
        if (xLabels.count>40) {
            if ([label.text intValue]%2!=0) {
                label.text = [NSString stringWithFormat:@"%d",[label.text intValue]/2];
                label.frame =  CGRectMake(i * _xLabelWidth+UUYLabelwidth-1.5, self.frame.size.height - UULabelHeight, _xLabelWidth*1.5, UULabelHeight);
            }else{
                label.text = @"";
            }
        }
        if (xLabels.count >25&&xLabels.count<40) {
            if ([label.text intValue] >1 && [label.text intValue] <7) {
                label.text = @"";
            }else if([label.text intValue] >7 && [label.text intValue] <13){
                label.text = @"";
            }else if([label.text intValue] >13 && [label.text intValue] <19){
                label.text = @"";
            }else if([label.text intValue] >19 && [label.text intValue] <25){
                label.text = @"";
            }else if([label.text intValue] >25 && [label.text intValue] <xLabels.count){
                label.text = @"";
            }
        }
        [self addSubview:label];
    }
    
}

-(void)setColors:(NSArray *)colors
{
    _colors = colors;
}

- (void)setMarkRange:(CGRange)markRange
{
    _markRange = markRange;
}

- (void)setChooseRange:(CGRange)chooseRange
{
    _chooseRange = chooseRange;
}

- (void)setShowHorizonLine:(NSMutableArray *)ShowHorizonLine
{
    _ShowHorizonLine = ShowHorizonLine;
}

-(void)strokeCharttwo
{
    [_chartLine2 removeFromSuperlayer];
    [gradientLayer removeFromSuperlayer];
    
    for (int i=0; i<_yValues.count; i++) {
        
        NSArray *childAry = _yValues[i];
        UIBezierPath *progressline = [UIBezierPath bezierPath];
        CGFloat xPosition = (UUYLabelwidth + _xLabelWidth/2.0);
        CGFloat chartCavanHeight = (self.frame.size.height*0.9 - UULabelHeight*3)*1.05;
        
        //第一个点
        [progressline moveToPoint:CGPointMake(xPosition,self.frame.size.height-26)];
        [progressline addLineToPoint:CGPointMake(xPosition,self.frame.size.height-26)];
        
        NSInteger index = 0;
        
        for (NSString * valueString in childAry) {
            
            float grade =([valueString floatValue]-_yValueMin) / ((float)_yValueMax-_yValueMin);
            CGPoint point = CGPointMake(xPosition+index*_xLabelWidth, chartCavanHeight - grade * chartCavanHeight+UULabelHeight+14);
            [progressline addLineToPoint:point];
            index += 1;
        }
        
        [progressline addLineToPoint:CGPointMake(xPosition+6*_xLabelWidth,self.frame.size.height-26)];
        [progressline addLineToPoint:CGPointMake(xPosition,self.frame.size.height-26)];
        [progressline closePath];
        
        //划线
        [_chartLine2 removeFromSuperlayer];
        [gradientLayer removeFromSuperlayer];
        _chartLine2 = [CAShapeLayer layer];
        _chartLine2.opaque = YES;
        _chartLine2.fillColor = [UIColor whiteColor].CGColor;
        _chartLine2.lineWidth   = 0.0;
        _chartLine2.path = progressline.CGPath;
        //_chartLine2.fillColor = [[UIColor colorWithWhite:1.0 alpha:1.0] CGColor];
        //[self.layer addSublayer:_chartLine2];
        
        UIColor *lightG = [UIColor colorWithWhite:1.0 alpha:0.5];
        UIColor *darkG = [UIColor colorWithWhite:1.0 alpha:0.0];
        gradientLayer = [CAGradientLayer layer];
        gradientLayer.frame = self.frame ;// self.view.frame;
        gradientLayer.opaque = YES;
        gradientLayer.colors = [NSArray arrayWithObjects:(id)lightG.CGColor,(id)darkG.CGColor, nil];
        gradientLayer.locations=@[@0.0,@0.8];
        [self.layer addSublayer:gradientLayer];//加上渐变层
        gradientLayer.mask=_chartLine2;
        
        
    }
}
-(void)strokeChart
{
    for (int i=0; i<_yValues.count; i++) {
        
        NSArray *childAry = _yValues[i];
        
        if (childAry.count==0) {
            return;
        }
        //获取最大最小位置
        CGFloat max = [childAry[0] floatValue];
        CGFloat min = [childAry[0] floatValue];
        NSInteger max_i = 0;
        NSInteger min_i = 0;
        
        for (int j=0; j<childAry.count; j++){
            CGFloat num = [childAry[j] floatValue];
            if (max<=num){
                max = num;
                max_i = j;
            }
            if (min>=num){
                min = num;
                min_i = j;
            }
        }
        
        //划线
        CAShapeLayer *_chartLine = [CAShapeLayer layer];
        _chartLine.lineCap = kCALineCapRound;
        _chartLine.lineJoin = kCALineJoinBevel;
        
        _chartLine.fillColor   = [[UIColor blackColor] CGColor];
        
        _chartLine.lineWidth   = 1.0;
        _chartLine.lineDashPhase=6.0;
        _chartLine.strokeEnd   = 0.0;
        _chartLine.opaque = YES;
        _chartLine.drawsAsynchronously = YES;
        [self.layer addSublayer:_chartLine];
        
        UIBezierPath *progressline = [UIBezierPath bezierPath];
        CGFloat firstValue = [[childAry objectAtIndex:0] floatValue];
        CGFloat xPosition = (UUYLabelwidth + _xLabelWidth/2.0);
        CGFloat chartCavanHeight = (self.frame.size.height*0.9 - UULabelHeight*3)*1.19;
        
        float grade = ((float)firstValue-_yValueMin) / ((float)_yValueMax-_yValueMin);
        
        //第一个点
        BOOL isShowMaxAndMinPoint = YES;
        if (self.ShowMaxMinArray) {
            if ([self.ShowMaxMinArray[i] intValue]>0) {
                isShowMaxAndMinPoint = (max_i==0 || min_i==0)?NO:YES;
            }else{
                isShowMaxAndMinPoint = YES;
            }
        }
        
        [progressline moveToPoint:CGPointMake(xPosition, chartCavanHeight - grade * chartCavanHeight+UULabelHeight+8)];
        [progressline setLineWidth:1.5];
        [progressline setLineCapStyle:kCGLineCapRound];
        [progressline setLineJoinStyle:kCGLineJoinRound];
        
        NSInteger index = 0;
        
        for (NSString * valueString in childAry) {
            
            float grade =([valueString floatValue]-_yValueMin) / ((float)_yValueMax-_yValueMin);
            if (index != 0) {
                
                CGPoint point = CGPointMake(xPosition+index*_xLabelWidth, chartCavanHeight - grade * chartCavanHeight+UULabelHeight+8);
                [progressline addLineToPoint:point];
                
                BOOL isShowMaxAndMinPoint = YES;
                if (self.ShowMaxMinArray) {
                    if ([self.ShowMaxMinArray[i] intValue]>0) {
                        isShowMaxAndMinPoint = (max_i==index || min_i==index)?NO:YES;
                    }else{
                        isShowMaxAndMinPoint = YES;
                    }
                }
                
                
                [progressline moveToPoint:point];
            }
            index += 1;
        }
        
        
        _chartLine.path = progressline.CGPath;
        if ([[_colors objectAtIndex:i] CGColor]) {
            _chartLine.strokeColor = [[_colors objectAtIndex:i] CGColor];
        }else{
            _chartLine.strokeColor = [UUWhite CGColor];
        }
        CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        pathAnimation.duration = childAry.count*0.1;
        pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
        pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
        pathAnimation.autoreverses = NO;
        [_chartLine addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
        
        _chartLine.strokeEnd = 1.0;
        
    }
    
}
-(id)init{
    return self;
}

@end



