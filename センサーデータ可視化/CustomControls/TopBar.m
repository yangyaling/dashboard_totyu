//
//  TopBar.m
//  センサーデータ可視化
//
//  Created by totyu3 on 16/12/19.
//  Copyright © 2016年 LGF. All rights reserved.
//

#import "TopBar.h"

@implementation TopBar

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setDefaultAttribute];//设置默认属性
    }
    return self;
}

-(void)setDefaultAttribute{
    _SelectFont = 35;
    _NormalFont = 30;
    _NormalTitleColor = [UIColor lightGrayColor];
    _SelectTitleColor = [UIColor blackColor];
    _SelectLineColor = [UIColor blackColor];
}

-(void)setNormalFont:(float)NormalFont{
    _NormalFont = NormalFont;
}

-(void)setSelectFont:(float)SelectFont{
    _SelectFont = SelectFont;
}

-(void)setNormalTitleColor:(UIColor *)NormalTitleColor{
    _NormalTitleColor = NormalTitleColor;
}

-(void)setSelectTitleColor:(UIColor *)SelectTitleColor{
    _SelectTitleColor = SelectTitleColor;
}

-(void)setTitleArray:(NSArray *)TitleArray{
    _TitleArray = TitleArray;
}

-(void)layoutSubviews{
    [self commonInit];
}

- (void)commonInit{
 
    _ButtonArray = [NSMutableArray array];
    for (int i = 0; i<_TitleArray.count; i++) {
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width/_TitleArray.count*i, 0, self.width/_TitleArray.count, self.height-3)];
        button.tag = i;
        [button setTitle:_TitleArray[i] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(TouchDown:) forControlEvents:UIControlEventTouchDown];
        if (i==0) {//默认选中第一个
            _UnderLine = [[UIView alloc]initWithFrame:CGRectMake(button.x, self.height-2, button.width, 2)];
            _UnderLine.backgroundColor = _SelectLineColor;
            [self addSubview:_UnderLine];
            button.titleLabel.font = [UIFont systemFontOfSize:_SelectFont];
            [button setTitleColor:_SelectTitleColor forState:UIControlStateNormal];
            [self.delegate selectview:button.tag];
        }else{
            button.titleLabel.font = [UIFont systemFontOfSize:_NormalFont];
            [button setTitleColor:_NormalTitleColor forState:UIControlStateNormal];
        }
        [self addSubview:button];
        
        [_ButtonArray addObject:button];
    }
}

-(void)TouchDown:(UIButton*)button{
    for (UIButton *btn in _ButtonArray) {
        btn.titleLabel.font = [UIFont systemFontOfSize:_NormalFont];
        [btn setTitleColor:_NormalTitleColor forState:UIControlStateNormal];
    }
    button.titleLabel.font = [UIFont systemFontOfSize:_SelectFont];
    [button setTitleColor:_SelectTitleColor forState:UIControlStateNormal];
    [UIView animateWithDuration:0.2 animations:^{
        _UnderLine.frame = CGRectMake(button.x, self.height-2, button.frame.size.width, 2);
    }];
    [self.delegate selectview:button.tag];
}

@end
