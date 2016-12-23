//
//  TopBar.h
//  センサーデータ可視化
//
//  Created by totyu3 on 16/12/19.
//  Copyright © 2016年 LGF. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SelectViewDelegate <NSObject>

-(void)selectview:(NSInteger)viewnum;

@end

IB_DESIGNABLE
@interface TopBar : UIView
-(instancetype)initWithCoder:(NSCoder *)aDecoder;
@property (nonatomic, strong) id<SelectViewDelegate>delegate;
@property (nonatomic, assign) IBInspectable float NormalFont;
@property (nonatomic, assign) IBInspectable float SelectFont;
@property (nonatomic, retain) IBInspectable UIColor *NormalTitleColor;
@property (nonatomic, retain) IBInspectable UIColor *SelectTitleColor;
@property (nonatomic, retain) IBInspectable UIColor *SelectLineColor;
@property (nonatomic, strong) NSMutableArray *ButtonArray;
@property (nonatomic, strong) UIView *UnderLine;
@property (nonatomic, strong) NSArray *TitleArray;
@end
