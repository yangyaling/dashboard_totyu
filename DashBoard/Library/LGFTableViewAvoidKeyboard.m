//
//  LGFTableViewAvoidKeyboard.m
//  MimamoriMaster
//
//  Created by totyu3 on 17/1/23.
//  Copyright © 2017年 LGF. All rights reserved.
//

#import "LGFTableViewAvoidKeyboard.h"

@interface LGFTableViewAvoidKeyboard ()<UITableViewDelegate>
@property (nonatomic, strong)UIButton *tapGesture;
@end

@implementation LGFTableViewAvoidKeyboard

-(UIButton *)tapGesture{
    if (!_tapGesture) {
        _tapGesture =  [[UIButton alloc]initWithFrame:self.bounds];
        [_tapGesture addTarget:self action:@selector(selecttap) forControlEvents:UIControlEventTouchDown];
    }
    return _tapGesture;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.delegate = self;
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

#pragma mark 键盘出现
-(void)keyboardWillShow:(NSNotification *)note{
    _tapGesture.frame = self.bounds;
    [LGFKeyWindow.rootViewController.view addSubview:self.tapGesture];
    CGFloat keyBoardRectheight = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    [self setContentInset:UIEdgeInsetsMake(0, 0, keyBoardRectheight, 0)];
    MAIN([self setContentInset:UIEdgeInsetsMake(0, 0, keyBoardRectheight - self.height *0.15, 0)];);

}

#pragma mark 键盘消失
-(void)keyboardWillHide:(NSNotification *)note{
    self.contentInset = UIEdgeInsetsZero;
    [self.tapGesture removeFromSuperview];
}

- (void)selecttap{
    [self endEditing:YES];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
