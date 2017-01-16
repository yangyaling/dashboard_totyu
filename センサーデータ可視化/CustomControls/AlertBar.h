//
//  AlertBar.h
//  センサーデータ可視化
//
//  Created by totyu3 on 16/12/20.
//  Copyright © 2016年 LGF. All rights reserved.
//

#import <UIKit/UIKit.h>
IB_DESIGNABLE
@interface AlertBar : UIView
-(instancetype)initWithCoder:(NSCoder *)aDecoder;
@property (nonatomic) IBInspectable CGFloat           BorderWidth;
@property (nonatomic) IBInspectable CGFloat           CornerRadius;
@property (nonatomic) IBInspectable UIColor          *BorderColor;
@property (nonatomic, strong) NSArray *AlertArray;
@end
