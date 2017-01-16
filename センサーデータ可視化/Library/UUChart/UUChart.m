//
//  UUChart.m
//  UUChart
//
//  Created by shake on 14-7-24.
//  Copyright (c) 2014年 uyiuyao. All rights reserved.
//

#import "UUChart.h"

@interface UUChart ()

@property (strong, nonatomic) UULineChart   *lineChart;

@property (strong, nonatomic) UUBarChart    *barChart;

@property (nonatomic, strong) NSString      *selectdate;

@property (nonatomic, assign) int           deviceclassid;

@property (assign, nonatomic) id<UUChartDataSource> dataSource;

@end

@implementation UUChart

-(id)initwithUUChartDataFrame:(CGRect)rect withSource:(id<UUChartDataSource>)dataSource withStyle:(UUChartStyle)style withid:(int)deviceclass withmodel:(LifeRhythmVCModel*)model withdate:(NSString*)date{
    self.dataSource = dataSource;
    self.chartStyle = style;
    _deviceclassid = deviceclass;
    _selectdate = date;
    _ChartModel = model;
    return [self initWithFrame:rect];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        self.clipsToBounds = NO;
    }
    return self;
}

-(void)setUpChart{
    
	if (self.chartStyle == UUChartLineStyle) {
        
        if(!_lineChart){
            
            _lineChart = [[UULineChart alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
            _lineChart.opaque = YES;
            [self addSubview:_lineChart];
        }

        [_lineChart backgroundColor:_deviceclassid devicemodel:_ChartModel withdate:_selectdate];
        //显示颜色
        if ([self.dataSource respondsToSelector:@selector(UUChart_ColorArray:)]) {
            [_lineChart setColors:[self.dataSource UUChart_ColorArray:self]];
        }
        
        
        [_lineChart setYValues:[self.dataSource UUChart_yValueArray:self]];
        
        [_lineChart setYValuesTwo:[self.dataSource UUChart_yValueArray4:self]];
        
        [_lineChart setXLabels:[self.dataSource UUChart_xLableArray:self]];
        
		[_lineChart strokeChart];
        
        //if([self.uuuid isEqualToString:@"8"]){
        
        
//        [_lineChart strokeCharttwo];
        
        
        //}


	}else if (self.chartStyle == UUChartBarStyle)
	{
        if (!_barChart) {
            _barChart = [[UUBarChart alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
            _barChart.opaque = YES;
            [self addSubview:_barChart];
        }
        if ([self.dataSource respondsToSelector:@selector(UUChartChooseRangeInLineChart:)]) {
            [_barChart setChooseRange:[self.dataSource UUChartChooseRangeInLineChart:self]];
        }

        [_barChart barbackgroundColor:_deviceclassid devicemodel:_ChartModel withdate:_selectdate];

        [_barChart setYValues:[self.dataSource UUChart_yValueArray:self]];
        
        [_barChart setYValuesTwo:[self.dataSource UUChart_yValueArray4:self]];
        
        [_barChart setXLabels:[self.dataSource UUChart_xLableArray:self]];

        [_barChart strokeChart];

	}
}

- (void)showInView:(UIView *)view
{
    self.opaque = YES;
    [self setUpChart];
    [view addSubview:self];
}

-(void)strokeChart
{

}



@end
