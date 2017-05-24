//
//  ActivityStatisticsChartVC.h
//  DashBoard
//
//  Created by totyu3 on 17/2/17.
//  Copyright © 2017年 NIT. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ActivityStatisticsChartVCDelegate <NSObject>
@required
- (void)MJGetNewData;
@end

@interface ActivityStatisticsChartVC : UIViewController
@property (nonatomic, copy) NSString *DayStr;
@property (nonatomic, copy) NSString *SumFlg;
@property (nonatomic, strong) NSString *LoadCSNotificationName;
@property (nonatomic, assign) id<ActivityStatisticsChartVCDelegate> delegate;
@end
