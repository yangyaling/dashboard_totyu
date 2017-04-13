//
//  AlertBar.m
//  センサーデータ可視化
//
//  Created by totyu3 on 16/12/20.
//  Copyright © 2016年 LGF. All rights reserved.
//

#import "AlertBar.h"

@interface AlertBar ()

@end
@implementation AlertBar

-(void)setCornerRadius:(CGFloat)CornerRadius{
    _CornerRadius =CornerRadius;
    self.layer.cornerRadius = _CornerRadius;
}

-(void)setAlertArray:(NSArray *)AlertArray{
    _AlertArray = AlertArray;
    _AlertLabel.text = [NSString stringWithFormat:@"アラート情報 %ld 件",_AlertArray.count];
    if (_AlertArray.count == 0 || !_AlertArray) {
        _AlertLabel.textColor = [UIColor whiteColor];
        _PaoMaView.text = @"すべて正常";
    } else {
        _AlertLabel.textColor = [UIColor redColor];
        _PaoMaView.text = @"";
        _PaoMaView.AlertArray = _AlertArray;
    }
}

@end
