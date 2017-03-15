//
//  LGFLineChart.h
//  DashBoard
//
//  Created by totyu3 on 17/2/13.
//  Copyright © 2017年 NIT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LGFLineChart : UIView
-(instancetype)initWithFrame:(CGRect)frame LineDict:(NSDictionary *)LineDict LineType:(int)LineType;
@property (nonatomic, strong) NSArray *LineDataArray;
@property (nonatomic, strong) NSDictionary *LineDataDict;
@property (nonatomic, assign) float YTotalLength;
@property (nonatomic, assign) float YMaxLength;
@property (nonatomic, assign) float YMinLength;
@property (nonatomic, assign) int XTotalLength;
@property (nonatomic, assign) int LineType; //1:生活详细 2:活动集计
@end
