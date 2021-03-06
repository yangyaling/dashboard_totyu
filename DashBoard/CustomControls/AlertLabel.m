//
//  AlertLabel.m
//  センサーデータ可視化
//
//  Created by totyu3 on 16/12/22.
//  Copyright © 2016年 LGF. All rights reserved.
//

#import "AlertLabel.h"

@implementation AlertLabel

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        self.alpha = 0.8;
//        [self addTarget:self action:@selector(setTouchDown:) forControlEvents:UIControlEventTouchDown];
        [self addSubview:self.AlertIcon];
    }
    return self;
}

-(UIImageView *)AlertIcon{
    if (!_AlertIcon) {
        _AlertIcon = [[UIImageView alloc]initWithFrame:self.bounds];
        [_AlertIcon setImage:[UIImage imageNamed:@"AlertLabel"]];
    }
    return _AlertIcon;
}

-(void)setTouchDown:(UIButton*)button{
    [self.delegate AlertLabelClick];
}

//-(void)drawRect:(CGRect)rect{
    //获得处理的上下文
//    CGContextRef contextUp = UIGraphicsGetCurrentContext();
//    CGContextTranslateCTM(contextUp, 0, rect.size.height);
//    CGContextScaleCTM(contextUp, 1.0, -1.0);
//    [self drawAlertPoint:contextUp];

//    CGContextRef contextDown = UIGraphicsGetCurrentContext();
//    CGContextTranslateCTM(contextDown, 0, rect.size.height);
//    CGContextScaleCTM(contextDown, 1.0, -1.0);
//    [self drawAlertPoint:contextDown];
//}

//-(void)drawAlertPoint:(CGContextRef)context{
//    CGContextMoveToPoint(context, self.width / 20 , self.height / 2);
//    CGContextAddLineToPoint(context, self.width / 20*3, self.height / 10*4);
//    CGContextAddLineToPoint(context, self.width / 20*2, self.height / 10*3);
//    CGContextAddLineToPoint(context, self.width / 20*4, self.height / 10*3);
//    CGContextAddLineToPoint(context, self.width / 20*4, self.height / 10);
//    CGContextAddLineToPoint(context, self.width / 20*6, self.height / 10*2);
//    CGContextAddLineToPoint(context, self.width / 20*7, 0);
//    CGContextAddLineToPoint(context, self.width / 20*8 + self.width / 40, self.height / 10);
//    CGContextAddLineToPoint(context, self.width / 20*10, 0);
//    CGContextAddLineToPoint(context, self.width / 20*11 + self.width / 40, self.height / 10);
//    CGContextAddLineToPoint(context, self.width / 20*13, 0);
//    CGContextAddLineToPoint(context, self.width / 20*14, self.height / 10*2);
//    CGContextAddLineToPoint(context, self.width / 20*16, self.height / 10);
//    CGContextAddLineToPoint(context, self.width / 20*16, self.height / 10*3);
//    CGContextAddLineToPoint(context, self.width / 20*18, self.height / 10*3);
//    CGContextAddLineToPoint(context, self.width / 20*17, self.height / 10*4);
//    CGContextAddLineToPoint(context, self.width / 20*19, self.height / 2);
//    CGContextClosePath(context);
//    [[UIColor redColor] setFill];
//    //设置绘图方式并绘图stroke描边 fill填充
//    CGContextDrawPath(context, kCGPathFill);
//}



















@end
