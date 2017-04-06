//
//  LGFPaoMaView.m
//  センサーデータ可視化
//
//  Created by totyu3 on 16/12/21.
//  Copyright © 2016年 LGF. All rights reserved.
//

#define xisnshigeshu 3

#define PaoMaLabelFrame CGRectMake(self.width/xisnshigeshu * i + 5, 5, self.width/xisnshigeshu - 10, self.height - 10)

#define currentFrame CGRectMake(0, 0, self.width / xisnshigeshu*titlearray.count, self.height)

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

- (instancetype)initWithFrame:(CGRect)frame withTitleArray:(NSArray *)titlearray{
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        time = titlearray.count*2;
        OneShowContentView = [[UIView alloc]initWithFrame:currentFrame];

        BOOL hasAMPM = [[NSDateFormatter dateFormatFromTemplate:@"j" options:0 locale:[NSLocale currentLocale]] rangeOfString:@"a"].location != NSNotFound;
        
        for (int i = 0; i < titlearray.count; i++) {
            UILabel *lab = [[UILabel alloc]initWithFrame:PaoMaLabelFrame];
            NSDictionary *alertdict = titlearray[i];
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
    return self;
}

-(void)labelset:(UILabel*)lab{
    lab.textAlignment = NSTextAlignmentCenter;
    lab.textColor = [UIColor whiteColor];
    lab.font = [UIFont boldSystemFontOfSize:20];
    lab.backgroundColor = [UIColor orangeColor];
    lab.layer.cornerRadius = 5;
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
