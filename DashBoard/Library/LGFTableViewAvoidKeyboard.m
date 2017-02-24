//
//  LGFTableViewAvoidKeyboard.m
//  MimamoriMaster
//
//  Created by totyu3 on 17/1/23.
//  Copyright © 2017年 LGF. All rights reserved.
//

#import "LGFTableViewAvoidKeyboard.h"

@interface LGFTableViewAvoidKeyboard ()<UITextFieldDelegate, UITextViewDelegate>
@property (nonatomic, strong) UITextField *editTextField;
@property (nonatomic, strong) UITextView *editTextView;
@property (nonatomic, strong)UITapGestureRecognizer *tapGesture;
@end

@implementation LGFTableViewAvoidKeyboard

-(UITapGestureRecognizer *)tapGesture{
    if (!_tapGesture) {
        _tapGesture =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selecttap)];
    }
    return _tapGesture;
}

- (void)searchTextViewWithView:(UIView *)view
{
    for (UIView *subview in view.subviews)
    {
        if ([subview isKindOfClass:[UITextView class]]) {
            ((UITextView *)subview).delegate = self;
        }
        if ([subview isKindOfClass:[UITextField class]]) {
            ((UITextField *)subview).delegate = self;
        }
        [self searchTextViewWithView:subview];
    }
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
//        [self searchTextViewWithView:self];
        [self addGestureRecognizer:self.tapGesture];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        
    }
    return self;
}

#pragma mark 键盘出现
-(void)keyboardWillShow:(NSNotification *)note{
    
    CGRect keyBoardRect=[note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.contentInset = UIEdgeInsetsMake(0, 0, keyBoardRect.size.height, 0);
}

#pragma mark 键盘消失
-(void)keyboardWillHide:(NSNotification *)note{
    
    self.contentInset = UIEdgeInsetsMake(0, 0, 49, 0);
}

- (void)selecttap{
    
//    self.contentInset = UIEdgeInsetsMake(0, 0, 49, 0);
    [self endEditing:YES];
}

//- (void)textFieldDidBeginEditing:(UITextField *)textField
//{
//    _editTextField = textField;
//    _editTextView = nil;
//}
//
//- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
//{
//    _editTextView = textView;
//    _editTextField = nil;
//    return YES;
//}

//-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
//    UIView *editView = _editTextView ? _editTextView : _editTextField;
//    [editView resignFirstResponder];
//}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
