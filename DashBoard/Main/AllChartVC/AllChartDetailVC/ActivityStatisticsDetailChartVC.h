//
//  ActivityStatisticsDetailChartVC.h
//  DashBoard
//
//  Created by totyu3 on 17/2/14.
//  Copyright © 2017年 NIT. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ActivityStatisticsDetailChartVCDelegate <NSObject>
@required
- (void)MJGetNewData;
@end

@interface ActivityStatisticsDetailChartVC : UIViewController
@property (nonatomic, copy) NSString *DayStr;
@property (nonatomic, strong) NSString *LoadCSNotificationName;
@property (nonatomic, assign) id<ActivityStatisticsDetailChartVCDelegate> delegate;
@end
