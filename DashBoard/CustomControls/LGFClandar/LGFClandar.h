//
//  LGFClandar.h
//  DashBoard
//
//  Created by totyu3 on 17/2/16.
//  Copyright © 2017年 NIT. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LGFClandarDelegate <NSObject>
- (void)SelectDate:(NSDate*)date;
@end

@interface LGFClandar : UIView
+(LGFClandar *)Clandar;
- (void)ShowInView:(id)SuperSelf  Date:(NSString*)Date;
@property (nonatomic, assign) id<LGFClandarDelegate> delegate;
@end
