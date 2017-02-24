//
//  LGFChartNumBar.h
//  DashBoard
//
//  Created by totyu3 on 17/2/8.
//  Copyright © 2017年 NIT. All rights reserved.
//

#import <UIKit/UIKit.h>
IB_DESIGNABLE
@interface LGFChartNumBar : UIView
- (instancetype)initWithCoder:(NSCoder *)aDecoder;
/**
 设置y轴显示数组
 */
@property (nonatomic, strong) NSArray *YValuesArray;
@property (nonatomic, strong) UIView *numbarview;
@property (nonatomic, assign) IBInspectable int numbartype;
@end
