//
//  AlertBar.h
//  センサーデータ可視化
//
//  Created by totyu3 on 16/12/20.
//  Copyright © 2016年 LGF. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LGFPaoMaView.h"
IB_DESIGNABLE
@interface AlertBar : UIView
@property (nonatomic) IBInspectable CGFloat           CornerRadius;
@property (nonatomic, strong) NSArray *AlertArray;
@property (nonatomic, weak) IBOutlet UILabel*AlertLabel;
@property (nonatomic, weak) IBOutlet LGFPaoMaView*PaoMaView;
@end
