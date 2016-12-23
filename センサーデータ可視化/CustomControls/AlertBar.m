//
//  AlertBar.m
//  センサーデータ可視化
//
//  Created by totyu3 on 16/12/20.
//  Copyright © 2016年 LGF. All rights reserved.
//

#import "AlertBar.h"
#import "LGFPaoMaView.h"

@interface AlertBar ()
@property (nonatomic , strong) LGFPaoMaView *paoma;
@property (nonatomic , strong) UILabel *NoAlert;
@property (nonatomic, strong) UILabel *AlertLabel;
@property (nonatomic, strong) UIView *Mask;
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
}

-(void)layoutSubviews{
    [self commonInit];
}

- (void)commonInit{
    
    [self addSubview:self.AlertLabel];
    if (_AlertArray.count==0||!_AlertArray) {
        [self.paoma removeFromSuperview];
        [self addSubview:self.NoAlert];
    }else{
        [self.NoAlert removeFromSuperview];
        [self addSubview:self.paoma];
    }
    [self addSubview:self.Mask];
}

-(UIView *)Mask{
    if (!_Mask) {
        _Mask = [[UIView alloc]initWithFrame:CGRectMake(self.AlertLabel.width, 0, 40, self.height)];
        UIColor *lightG = [UIColor colorWithWhite:1.0 alpha:0.0];
        UIColor *darkG = [UIColor colorWithWhite:1.0 alpha:1.0];
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.frame = _Mask.bounds;
        gradientLayer.opaque = YES;
        gradientLayer.colors = [NSArray arrayWithObjects:(id)lightG.CGColor,(id)darkG.CGColor, nil];
        gradientLayer.startPoint = CGPointMake(1, 0.5);
        gradientLayer.endPoint   = CGPointMake(0, 0.5);
        [_Mask.layer addSublayer:gradientLayer];//加上渐变层

    }
    return _Mask;
}

-(UILabel *)AlertLabel{
    if (!_AlertLabel) {
        _AlertLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.width/4, self.height)];
        _AlertLabel.textAlignment = NSTextAlignmentCenter;
        _AlertLabel.text = _AlertTitle;
        _AlertLabel.font = [UIFont systemFontOfSize:25];
    }
    return _AlertLabel;
}

-(UILabel *)NoAlert{
    if (!_NoAlert) {
        _NoAlert = [[UILabel alloc]initWithFrame:CGRectMake(self.AlertLabel.width, 0, self.width-self.AlertLabel.width, self.height)];
        _NoAlert.text = @"すべて正常";
        _NoAlert.textAlignment = NSTextAlignmentCenter;
        _NoAlert.font = [UIFont systemFontOfSize:25];
        _NoAlert.textColor = NITColor(20,221,140);
    }
    return _NoAlert;
}

-(LGFPaoMaView *)paoma{
    if (!_paoma) {
        _paoma = [[LGFPaoMaView alloc]initWithFrame:CGRectMake(self.AlertLabel.width, 0, self.width-self.AlertLabel.width, self.height) withTitleArray:_AlertArray];
    }
    return _paoma;
}

@end
