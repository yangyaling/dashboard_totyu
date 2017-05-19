//
//  LifeRhythmDetailChartVC.h
//  DashBoard
//
//  Created by totyu3 on 17/2/13.
//  Copyright © 2017年 NIT. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LifeRhythmDetailChartVCDelegate <NSObject>
@required
- (void)MJGetNewData;
@end

@interface LifeRhythmDetailChartVC : UIViewController
@property (nonatomic, copy) NSString *DayStr;
@property (nonatomic, assign) id<LifeRhythmDetailChartVCDelegate> delegate;
@end
