//
//  AlertLabel.h
//  センサーデータ可視化
//
//  Created by totyu3 on 16/12/22.
//  Copyright © 2016年 LGF. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AlertLabelDelegate <NSObject>

-(void)AlertLabelClick;

@end

@interface AlertLabel : UIButton
@property (nonatomic, strong) id<AlertLabelDelegate> delegate;
-(instancetype)initWithFrame:(CGRect)frame;
@property (nonatomic, strong) UIImageView *AlertIcon;
@end
