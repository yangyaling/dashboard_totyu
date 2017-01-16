//
//  LifeRhythmVCCell.m
//  センサーデータ可視化
//
//  Created by totyu3 on 17/1/13.
//  Copyright © 2017年 LGF. All rights reserved.
//

#import "LifeRhythmVCCell.h"
#import "UUChart.h"

@interface LifeRhythmVCCell()<UUChartDataSource>

{
    NSArray *devicedataarray;
    NSMutableArray *allarray;
    NSString *selectdate;
    UUChart *chartview;
}
@end
@implementation LifeRhythmVCCell

-(void)setCellModel:(LifeRhythmVCModel *)CellModel{
 
    int celltype;
    
    allarray = [NSMutableArray array];
    
    if (chartview) {
        [chartview removeFromSuperview];
    }
    
    NSArray *devicearray = CellModel.devicevalues;
    NSArray *devicearrays = devicearray[6];
    NSDictionary *devicedict = devicearrays[0];
    
    celltype=0;
    devicedataarray = [devicedict valueForKey:@"devicevalues"];
    for (int i =0; i < devicearray.count; i++) {
        NSArray *allarr = [NSArray arrayWithArray:devicearray[i]];
        NSDictionary *alldict = [NSDictionary dictionaryWithDictionary:allarr[0]];
        NSArray *dvarr = [NSArray arrayWithArray:[alldict valueForKey:@"devicevalues"]];
        [allarray addObject:dvarr];
    }
    
    selectdate = [devicedict valueForKey:@"datestring"];
    
    chartview =[[UUChart alloc]initwithUUChartDataFrame:CGRectMake(3,1.5, [UIScreen mainScreen].bounds.size.width-6, 147)
                                             withSource:self withStyle:celltype==1?UUChartLineStyle:UUChartBarStyle withid:0 withmodel:CellModel withdate:selectdate];
    chartview.userInteractionEnabled = NO;
    [chartview showInView:self.contentView];
}

-(NSArray*)getXTitles:(int)num{
    NSMutableArray *xTitles = [[NSMutableArray alloc]initWithCapacity:0];
    for (int i =0; i<=num; i++) {
        if(num<25&&num>11){
            NSString *str = [NSString stringWithFormat:@"%d",i];
            [xTitles addObject:str];
        }else{
            NSString *str = [NSString stringWithFormat:@"%d",i+1];
            [xTitles addObject:str];
        }
    }
    return xTitles;
}

- (NSArray *)UUChart_xLableArray:(UUChart *)chart{

    return [self getXTitles:23];
}

- (NSArray *)UUChart_yValueArray:(UUChart *)chart{

    return @[devicedataarray];
}

- (NSArray *)UUChart_yValueArray4:(UUChart *)chart{

    return allarray;
}

- (NSArray *)UUChart_ColorArray:(UUChart *)chart
{

    return @[UUWhite];
}

@end
