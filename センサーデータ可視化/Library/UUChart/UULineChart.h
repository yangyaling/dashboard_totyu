//
//  UULineChart.h
//  UUChartDemo
//
//  Created by shake on 14-7-24.
//  Copyright (c) 2014年 uyiuyao. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "UUColor.h"
#import "LifeRhythmVCModel.h"

#define chartMargin     10
#define xLabelMargin    15
#define yLabelMargin    20
#define UULabelHeight    15
#define UUYLabelwidth     20
#define UUTagLabelwidth     80

@interface UULineChart : UIView

-(void)backgroundColor:(int)deviceclass devicemodel:(LifeRhythmVCModel*)model withdate:(NSString*)date;

@property (strong, nonatomic) NSArray * xLabels;

@property (strong, nonatomic) NSArray * yLabels;

@property (strong, nonatomic) NSArray * yValues;

-(void)setYValuesTwo:(NSArray *)yValues2;

@property (nonatomic, strong) NSArray * colors;

@property (nonatomic) CGFloat xLabelWidth;
@property (nonatomic) CGFloat yValueMin;
@property (nonatomic) CGFloat yValueMax;

@property (nonatomic, assign) CGRange markRange;

@property (nonatomic, assign) CGRange chooseRange;

@property (nonatomic, assign) BOOL showRange;

@property (nonatomic, retain) NSMutableArray *ShowHorizonLine;
@property (nonatomic, retain) NSMutableArray *ShowMaxMinArray;

@property (nonatomic, strong)  LifeRhythmVCModel *ChartModel;

-(void)strokeChart;
-(void)strokeCharttwo;
//- (NSArray *)chartLabelsForX;

@end
