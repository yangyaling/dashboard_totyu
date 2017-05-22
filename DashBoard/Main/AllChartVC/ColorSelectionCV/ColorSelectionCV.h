//
//  ColorSelectionCV.h
//  DashBoard
//
//  Created by totyu3 on 17/2/10.
//  Copyright © 2017年 NIT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LGFColorSelectView.h"
IB_DESIGNABLE
@interface ColorSelectionCV : UIViewController
@property (nonatomic, strong) NSMutableArray *ColorSelectionArray;
@property (nonatomic, strong) NSString *LoadCSNotificationName;
//- (void)LoadColorSelectionData:(NSString*)basedate forweekly:(NSString*)forweekly sumflg:(NSString*)sumflg;
@end
