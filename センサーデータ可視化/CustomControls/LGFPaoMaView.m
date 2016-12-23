//
//  LGFPaoMaView.m
//  センサーデータ可視化
//
//  Created by totyu3 on 16/12/21.
//  Copyright © 2016年 LGF. All rights reserved.
//

#define xisnshigeshu 3

#define PaoMaLabelFrame CGRectMake(self.width/xisnshigeshu*i+5, 10, self.width/xisnshigeshu-10, labelHeight-20)

#import "LGFPaoMaView.h"
@interface LGFPaoMaView ()
{
    //左侧label的frame
    CGRect currentFrame;
    
    //右侧label的frame
    CGRect behindFrame;

    //label的高度
    CGFloat labelHeight;
    
    //是否为暂停状态
    BOOL isStop;
    
    //单次循环的时间
    NSInteger time;
    
    //展示的内容视图
    UIView *OneShowContentView;
    UIView *TwoShowContentView;
}
@end
@implementation LGFPaoMaView

- (instancetype)initWithFrame:(CGRect)frame withTitleArray:(NSArray *)titlearray
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.clipsToBounds = YES;
        self.layer.cornerRadius = 5;
        
        time = titlearray.count*3;
        
        CGFloat viewHeight = frame.size.height;
        labelHeight = viewHeight;

        //计算文本的宽度
        CGFloat calcuWidth = frame.size.width/xisnshigeshu*titlearray.count;
        
        //这两个frame很重要 分别记录的是左右两个label的frame 而且后面也会需要到这两个frame
        currentFrame = CGRectMake(0, 0, calcuWidth, labelHeight);
        behindFrame = CGRectMake(currentFrame.origin.x+currentFrame.size.width, 0, calcuWidth, labelHeight);
        
        OneShowContentView = [[UIView alloc]initWithFrame:currentFrame];
        for (int i = 0; i<titlearray.count; i++) {
            UILabel *lab = [[UILabel alloc]initWithFrame:PaoMaLabelFrame];
            lab.text = titlearray[i];
            [self labelset:lab];
            [OneShowContentView addSubview:lab];
        }
        [self addSubview: OneShowContentView];

        //如果文本的宽度大于视图的宽度才开始跑
        if (calcuWidth>frame.size.width) {
            TwoShowContentView = [[UIView alloc]initWithFrame:behindFrame];
            for (int i = 0; i<titlearray.count; i++) {
                UILabel *lab = [[UILabel alloc]initWithFrame:PaoMaLabelFrame];
                lab.text = titlearray[i];
                [self labelset:lab];
                [TwoShowContentView addSubview:lab];
            }
            [self addSubview: TwoShowContentView];
            [self doAnimation];
        }
    }
    return self;
}

-(void)labelset:(UILabel*)lab{
    
    lab.textAlignment = NSTextAlignmentCenter;
    lab.textColor = [UIColor whiteColor];
    lab.font = [UIFont systemFontOfSize:20.0f];
    lab.backgroundColor = [UIColor orangeColor];
    lab.layer.shadowColor = [UIColor redColor].CGColor;
    lab.layer.shadowOpacity = 0.5;
    lab.layer.shadowOffset = CGSizeMake(0,0);
    lab.opaque = YES;
    lab.layer.masksToBounds = NO;
    lab.layer.shouldRasterize = YES;
    lab.layer.rasterizationScale = [UIScreen mainScreen].scale;
//    lab.clipsToBounds = YES;
}

- (void)doAnimation
{
    [UIView animateWithDuration:time delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        OneShowContentView.transform = CGAffineTransformMakeTranslation(-currentFrame.size.width, 0);
        TwoShowContentView.transform = CGAffineTransformMakeTranslation(-currentFrame.size.width, 0);
    } completion:^(BOOL finished) {
        OneShowContentView.transform = CGAffineTransformIdentity;
        TwoShowContentView.transform = CGAffineTransformIdentity;
        OneShowContentView.frame = behindFrame;
        TwoShowContentView.frame = currentFrame;
        [self doAnimation];
    }];
}

- (void)start
{

    [self resumeLayer:OneShowContentView.layer];
    [self resumeLayer:TwoShowContentView.layer];
    isStop = NO;
}

- (void)stop
{

    [self pauseLayer:OneShowContentView.layer];
    [self pauseLayer:TwoShowContentView.layer];
    isStop = YES;
}

//暂停动画
- (void)pauseLayer:(CALayer*)layer
{
    CFTimeInterval pausedTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
    
    layer.speed = 0;
    
    layer.timeOffset = pausedTime;
}

//恢复动画
- (void)resumeLayer:(CALayer*)layer
{
    //当你是停止状态时，则恢复
    if (isStop) {
        
        CFTimeInterval pauseTime = [layer timeOffset];
        
        layer.speed = 1.0;
        
        layer.timeOffset = 0.0;
        
        layer.beginTime = 0.0;
        
        CFTimeInterval timeSincePause = [layer convertTime:CACurrentMediaTime() fromLayer:nil]-pauseTime;
        
        layer.beginTime = timeSincePause;
    }
    
}


@end
