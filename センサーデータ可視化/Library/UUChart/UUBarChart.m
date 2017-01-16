//
//  UUBarChart.m
//  UUChartDemo
//
//  Created by shake on 14-7-24.
//  Copyright (c) 2014年 uyiuyao. All rights reserved.
//

#define yLabelMargin    20
#define UULabelHeight   15

#import "UUBarChart.h"
#import "UUChartLabel.h"
#import "UUBar.h"

@interface UUBarChart ()
{
    UIView *myScrollView;
}
@end

@implementation UUBarChart {
    //NSHashTable *_chartLabelsForX;
}
-(void)barbackgroundColor:(int)deviceclass devicemodel:(LifeRhythmVCModel*)model withdate:(NSString *)date{
    NSString *sensorname;
    
    sensorname = model.devicename;
    UIColor *lightG = NITColorAlpha(115,180,255,1);
    UIColor *darkG = NITColorAlpha(85,160,225,1);
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.colors = [NSArray arrayWithObjects:(id)lightG.CGColor,(id)darkG.CGColor, nil];
    gradient.frame = self.bounds;
    [self.layer insertSublayer:gradient atIndex:0];
    
    UILabel*typeLabel = [[UILabel alloc]initWithFrame:self.frame];
    typeLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:55];
    typeLabel.alpha = 0.2;
    typeLabel.textAlignment = NSTextAlignmentCenter;
    typeLabel.textColor = [UIColor whiteColor];
    typeLabel.text = sensorname;
    typeLabel.adjustsFontSizeToFitWidth = YES;
    
    [self addSubview:typeLabel];
    
    UILabel*dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width*0.75, 0, self.frame.size.width*0.22, 17)];
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
        myScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(UUYLabelwidth, 5, frame.size.width-UUYLabelwidth, frame.size.height)];
        self.layer.cornerRadius = 6;
        self.opaque = YES;
        [self addSubview:myScrollView];
    }
    return self;
}

-(void)setYValues:(NSArray *)yValues
{
    _yValues = yValues;
    
}
-(void)setYValuesTwo:(NSArray *)yValues2
{
    _yValues2 = yValues2;
    [self setYLabels:_yValues2];
}
-(void)setYLabels:(NSArray *)yLabels
{
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
    NSInteger num;
    
    num = xLabels.count;
    
    _xLabelWidth = (self.frame.size.width-5 - UUYLabelwidth)/num;
    
    for (int i=0; i<xLabels.count; i++) {
        UUChartLabel * label = [[UUChartLabel alloc] initWithFrame:CGRectMake((i *  _xLabelWidth ), self.frame.size.height - UULabelHeight-5, _xLabelWidth, UULabelHeight)];
        label.text = xLabels[i];
        
        if (xLabels.count >25) {
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
        
        if (xLabels.count <8) {
            if ([label.text isEqualToString: @"0"]) {
                label.text = @"月";
            }else if([label.text isEqualToString: @"1"]){
                label.text = @"火";
            }else if([label.text isEqualToString: @"2"]){
                label.text = @"水";
            }else if([label.text isEqualToString: @"3"]){
                label.text = @"木";
            }else if([label.text isEqualToString: @"4"]){
                label.text = @"金";
            }else if([label.text isEqualToString: @"5"]){
                label.text = @"土";
            }else if([label.text isEqualToString: @"6"]){
                label.text = @"日";
            }
        }
        
        
        [myScrollView addSubview:label];
        
    }
    
}

-(void)setColors:(NSArray *)colors
{
    _colors = colors;
}

- (void)setChooseRange:(CGRange)chooseRange
{
    _chooseRange = chooseRange;
}

-(void)strokeChart
{
    
    CGFloat chartCavanHeight = self.frame.size.height - UULabelHeight*3;
    
    for (int i=0; i<_yValues.count; i++) {
        if (i==2)
            return;
        NSArray *childAry = _yValues[i];
        for (int j=0; j<childAry.count; j++) {
            NSString *valueString = childAry[j];
            float value = [valueString floatValue];
            float grade = ((float)value-(float)_yValueMin) / ((float)_yValueMax-(float)_yValueMin);
            
            UUBar * bar = [[UUBar alloc] initWithFrame:CGRectMake((j+(_yValues.count==1?0.1:0.05))*_xLabelWidth +i*_xLabelWidth * 0.47, UULabelHeight+3, _xLabelWidth * (_yValues.count==1?0.8:0.45), chartCavanHeight+3)];
            bar.barColor = [_colors objectAtIndex:i];
            bar.valuetitle = value;
            bar.grade = grade;
            
            [myScrollView addSubview:bar];
        }
    }
}

@end

