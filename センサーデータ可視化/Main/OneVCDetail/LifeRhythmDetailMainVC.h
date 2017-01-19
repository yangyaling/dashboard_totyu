//
//  LifeRhythmDetailMainVC.h
//  センサーデータ可視化
//
//  Created by totyu3 on 17/1/19.
//  Copyright © 2017年 LGF. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OneVCModel.h"

@interface LifeRhythmDetailMainVC : UIViewController
@property (nonatomic, strong) OneVCModel *model;
@property (nonatomic, copy) NSString *weektime;
@end
