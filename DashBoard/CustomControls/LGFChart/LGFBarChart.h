//
//  LGFBarChart.h
//  DashBoard
//
//  Created by totyu3 on 17/2/8.
//  Copyright © 2017年 NIT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LGFBarChart : UIView
-(instancetype)initWithFrame:(CGRect)frame BarData:(id)BarData BarType:(int)BarType;
@property (nonatomic, strong) UIView *DataLine;
@property (nonatomic, strong) UILabel *DataLineTitle;
@property (nonatomic, strong) NSArray *BarDataArray;
@property (nonatomic, strong) NSDictionary *BarDataDict;
@property (nonatomic, assign) int BarType; //1:生活一览 2:明るさ
@end
