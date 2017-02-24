//
//  UIColor+UIColor.h
//  DashBoard
//
//  Created by totyu3 on 17/2/17.
//  Copyright © 2017年 NIT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (UIColor)
+ (UIColor*) colorWithHex:(NSString*)hexValue alpha:(CGFloat)alphaValue;
+ (UIColor*) colorWithHex:(NSString*)hexValue;
+ (NSString *) hexFromUIColor: (UIColor*) color;
@end
