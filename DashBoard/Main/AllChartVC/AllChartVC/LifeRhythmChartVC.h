//
//  LifeRhythmChartVC.h
//  DashBoard
//
//  Created by totyu3 on 17/2/13.
//  Copyright © 2017年 NIT. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LifeRhythmChartVCDelegate <NSObject>
@required
- (void)MJGetNewData;
@end

@interface LifeRhythmChartVC : UIViewController
@property (nonatomic, copy) NSString *DayStr;
@property (nonatomic, strong) NSString *LoadCSNotificationName;
@property (nonatomic, assign) id<LifeRhythmChartVCDelegate> delegate;
@end
