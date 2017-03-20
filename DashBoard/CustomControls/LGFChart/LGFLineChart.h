//
//  LGFLineChart.h
//  DashBoard
//
//  Created by totyu3 on 17/2/13.
//  Copyright © 2017年 NIT. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    EnvironmentSet,//活动集计环境
    ActivitySet,//活动集计活动
    EnvironmentList//生活详细一览
} LineType;

@interface LGFLineChart : UIView
-(instancetype)initWithFrame:(CGRect)frame LineDict:(NSDictionary *)LineDict LineType:(LineType)LineType;
@property (nonatomic, strong) UIView *DataLine;
@property (nonatomic, strong) UILabel *DataLineTitle;
@property (nonatomic, strong) NSDictionary *LineDataDict;
@property (nonatomic, strong) NSString *Unit;
@property (nonatomic, assign) float YTotalLength;
@property (nonatomic, assign) float YMaxLength;
@property (nonatomic, assign) float YMinLength;
@property (nonatomic, assign) int XTotalLength;
@property (nonatomic, assign) LineType LineType;
@end
