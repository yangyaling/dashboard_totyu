//
//  LGFPaoMaView.m
//  センサーデータ可視化
//
//  Created by totyu3 on 16/12/21.
//  Copyright © 2016年 LGF. All rights reserved.
//

#define xisnshigeshu 3

#define PaoMaLabelFrame CGRectMake(self.width/xisnshigeshu * i + 5, self.height / 15, self.width/xisnshigeshu - 10, self.height - (self.height / 15) * 2)

#define currentFrame CGRectMake(0, 0, self.width / xisnshigeshu*AlertArray.count, self.height)

#import "LGFPaoMaView.h"
@interface LGFPaoMaView ()
{
    //单次循环的时间
    NSInteger time;
    //展示的内容视图
    UIView *OneShowContentView;
}
@end
@implementation LGFPaoMaView

-(void)setAlertArray:(NSMutableArray *)AlertArray{

    self.clipsToBounds = YES;
    time = AlertArray.count*2;
    OneShowContentView = [[UIView alloc]initWithFrame:currentFrame];
    
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [OneShowContentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    BOOL hasAMPM = [[NSDateFormatter dateFormatFromTemplate:@"j" options:0 locale:[NSLocale currentLocale]] rangeOfString:@"a"].location != NSNotFound;
    
    for (int i = 0; i < AlertArray.count; i++) {
        UILabel *lab = [[UILabel alloc]initWithFrame:PaoMaLabelFrame];
        NSDictionary *alertdict = AlertArray[i];
        NSDate *registdate = [NSDate NeedDateFormat:@"YYYY-MM-dd HH:mm:ss" ReturnType:returndate date:alertdict[@"registdate"]];
        lab.text = [NSString stringWithFormat:@"%@ %@",alertdict[@"roomname"],[NSDate NeedDateFormat:[NSString stringWithFormat:@"%@%@:mm:ss",hasAMPM ? @"aa " : @"", hasAMPM ? @"hh" : @"HH"] ReturnType:returnstring date:registdate]];
        [self labelset:lab];
        [OneShowContentView addSubview:lab];
    }
    [self addSubview: OneShowContentView];
    if (OneShowContentView.width > self.width) {
        [self doAnimation];
    }
}

-(void)labelset:(UILabel*)lab{
    lab.textAlignment = NSTextAlignmentCenter;
    lab.textColor = [UIColor whiteColor];
    if(NITScreenW == 1024){
        lab.font = [UIFont boldSystemFontOfSize:20];
    }else if(NITScreenW == 1366){
        lab.font = [UIFont boldSystemFontOfSize:25];
    }else if(NITScreenW == 736){
        lab.font = [UIFont boldSystemFontOfSize:15];
    }else{
        lab.font = [UIFont boldSystemFontOfSize:12];
    }
    
    lab.backgroundColor = [UIColor orangeColor];
    lab.adjustsFontSizeToFitWidth = YES;
    lab.layer.cornerRadius = 3;
    lab.clipsToBounds = YES;
    lab.opaque = YES;
}

- (void)doAnimation{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:time];
    [UIView setAnimationRepeatCount:LONG_MAX];
    [UIView setAnimationRepeatAutoreverses:YES];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    OneShowContentView.transform = CGAffineTransformMakeTranslation(-(OneShowContentView.width - self.width), 0);
    [UIView commitAnimations];
}

@end
