//
//  LifeRhythmVCModel.h
//  センサーデータ可視化
//
//  Created by totyu3 on 17/1/13.
//  Copyright © 2017年 LGF. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LifeRhythmVCModel : NSObject
@property (nonatomic, strong) NSArray                        *devicevalues;
@property (nonatomic, copy) NSString                         *devicename;
@property (nonatomic, copy) NSString                         *deviceid;
@property (nonatomic, copy) NSString                         *nodeid;
@property (nonatomic, copy) NSString                         *nodename;
@property (nonatomic, copy) NSString                         *latestvalue;
@property (nonatomic, copy) NSString                         *deviceunit;
@property (nonatomic, copy) NSString                         *batterystatus;
@property (nonatomic, strong) NSArray                        *subdeviceinfo;
@end
