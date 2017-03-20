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

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
    }
    return self;
}

-(void)setBorderColor:(UIColor *)BorderColor{
    _BorderColor = BorderColor;
    self.layer.borderColor = _BorderColor.CGColor;
}

-(void)setCornerRadius:(CGFloat)CornerRadius{
    _CornerRadius =CornerRadius;
    self.layer.cornerRadius = _CornerRadius;
}

-(void)setBorderWidth:(CGFloat)BorderWidth{
    _BorderWidth = BorderWidth;
    self.layer.borderWidth = _BorderWidth;
}

-(void)setAlertArray:(NSArray *)AlertArray{
    _AlertArray = AlertArray;
    [self commonInit];
}

- (void)commonInit{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.AlertLabel = nil;
    self.NoAlert = nil;
    self.paoma = nil;
    [self addSubview:self.AlertLabel];
    if (_AlertArray.count == 0 || !_AlertArray) {
        [self addSubview:self.NoAlert];
    } else {
        [self addSubview:self.paoma];
    }
}

-(UILabel *)AlertLabel{
    if (!_AlertLabel) {
        _AlertLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.width / 4, self.height)];
        _AlertLabel.textAlignment = NSTextAlignmentCenter;
        _AlertLabel.text = [NSString stringWithFormat:@"アラート情報 %ld 件",_AlertArray.count];
        _AlertLabel.font = [UIFont boldSystemFontOfSize:25];
        if (_AlertArray.count==0) {
            _AlertLabel.textColor = [UIColor whiteColor];
        } else {
            _AlertLabel.textColor = [UIColor redColor];
        }
    }
    return _AlertLabel;
}

-(UILabel *)NoAlert{
    if (!_NoAlert) {
        _NoAlert = [[UILabel alloc]initWithFrame:CGRectMake(self.AlertLabel.width, _BorderWidth, self.width - self.AlertLabel.width - _BorderWidth, self.height - _BorderWidth * 2)];
        _NoAlert.clipsToBounds = YES;
        _NoAlert.backgroundColor = [UIColor whiteColor];
        _NoAlert.layer.cornerRadius = _CornerRadius;
        _NoAlert.text = @"すべて正常";
        _NoAlert.textAlignment = NSTextAlignmentCenter;
        _NoAlert.font = [UIFont boldSystemFontOfSize:25];
        _NoAlert.textColor = NITColor(20,221,140);
    }
    return _NoAlert;
}

-(LGFPaoMaView *)paoma{
    if (!_paoma) {
        _paoma = [[LGFPaoMaView alloc]initWithFrame:CGRectMake(self.AlertLabel.width, _BorderWidth, self.width-self.AlertLabel.width - _BorderWidth, self.height - _BorderWidth * 2) withTitleArray:_AlertArray];
        _paoma.backgroundColor = [UIColor whiteColor];
        _paoma.layer.cornerRadius = _CornerRadius;
    }
    return _paoma;
}

@end
