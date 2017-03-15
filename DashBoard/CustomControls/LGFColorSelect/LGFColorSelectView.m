//
//  LGFColorSelectView.m
//  ColorTestView
//
//  Created by totyu3 on 17/2/21.
//  Copyright © 2017年 NIT. All rights reserved.
//

#import "LGFColorSelectView.h"

@interface LGFColorSelectView ()
@property (nonatomic, strong)UILabel *Title;
@property (nonatomic, strong)UIImageView *ColorImageView;
@property (nonatomic, strong)UIView *ResultView;
@property (nonatomic, strong)UITapGestureRecognizer *tapGesture;
@property (nonatomic, strong) UIButton *confirm;
@property (nonatomic, strong) UIButton *cancel;
@property (nonatomic, strong) NSDictionary *actiondict;
@property (nonatomic, strong) UIView *Cover;
@end
@implementation LGFColorSelectView

+(LGFColorSelectView *)ColorSelect{
    static LGFColorSelectView*ColorSelect = nil;
    
    if (!ColorSelect) {
        ColorSelect = [[LGFColorSelectView alloc]init];
        ColorSelect.backgroundColor = [UIColor whiteColor];
        ColorSelect.layer.cornerRadius = 5.0;
        ColorSelect.layer.shadowColor = [UIColor blackColor].CGColor;
        ColorSelect.layer.shadowOffset = CGSizeMake(1,1);
        ColorSelect.layer.shadowOpacity = 0.3;
    }
    return ColorSelect;
}

- (void)ShowInView:(id)Super Data:(NSDictionary*)actiondict{
    
    self.actiondict = actiondict;
    
    self.delegate = Super;

    self.frame = CGRectMake(WindowView.width/3, WindowView.height/5, WindowView.width/3, WindowView.height/5*3);
    [self.Cover addSubview:self];

    [self addSubview:self.Title];
    
    [self addSubview:self.confirm];
    
    [self addSubview:self.cancel];
    
    [self addSubview:self.ColorImageView];
    
    [self addSubview:self.ResultView];
    
    [self.ColorImageView addGestureRecognizer:self.tapGesture];
    
    self.Title.text = self.actiondict[@"actionname"];
    
    [self.ResultView setBackgroundColor:[UIColor colorWithHex:self.actiondict[@"actioncolor"]]];
}

//选择颜色
-(void)selectColorAction:(UITapGestureRecognizer *)sender{
    CGPoint tempPoint = [sender locationInView:sender.view];
    [self finishedAction:tempPoint];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint tempPoint = [touch locationInView:self.ColorImageView];
    if (CGRectContainsPoint(CGRectMake(0.0f, 0.0f, self.ColorImageView.size.width, self.ColorImageView.size.height), tempPoint)) {
        [self finishedAction:tempPoint];
    }
}

//完成选择
-(void)finishedAction:(CGPoint)point{
    UIColor *tempColor = [self colorAtPixel:point ColorImage:self.ColorImageView];
    [self.ResultView setBackgroundColor:tempColor];
}

//确认选择
- (void)confirmedit{
    
    [self RemoveAllView];
    NSMutableDictionary *SystemUserDict = [NSMutableDictionary dictionaryWithContentsOfFile:SYSTEM_USER_DICT];
    NSDictionary *parameter = @{@"userid0":SystemUserDict[@"userid0"],@"actionid":self.actiondict[@"actionid"],@"actionexplain":self.actiondict[@"actionexplain"],@"actioncolor":[UIColor hexFromUIColor:self.ResultView.backgroundColor]};
    [self.delegate SelectColor:parameter];
}

//取消选择
- (void)canceledit{
    [self RemoveAllView];
}

- (UIColor *)colorAtPixel:(CGPoint)point ColorImage:(UIImageView*)image{

    if (!CGRectContainsPoint(CGRectMake(0.0f, 0.0f, image.size.width, image.size.height), point)) {
        return nil;
    }
    NSInteger pointX = trunc(point.x);
    NSInteger pointY = trunc(point.y);
    CGImageRef cgImage = image.image.CGImage;
    NSUInteger width = image.size.width;
    NSUInteger height = image.size.height;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    int bytesPerPixel = 4;
    int bytesPerRow = bytesPerPixel * 1;
    NSUInteger bitsPerComponent = 8;
    unsigned char pixelData[4] = { 0, 0, 0, 0 };
    CGContextRef context = CGBitmapContextCreate(pixelData,
                                                 1,
                                                 1,
                                                 bitsPerComponent,
                                                 bytesPerRow,
                                                 colorSpace,                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    CGContextSetBlendMode(context, kCGBlendModeCopy);
    CGContextTranslateCTM(context, -pointX, pointY-(CGFloat)height);
    CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, (CGFloat)width, (CGFloat)height), cgImage);
    CGContextRelease(context);
    CGFloat red   = (CGFloat)pixelData[0] / 255.0f;
    CGFloat green = (CGFloat)pixelData[1] / 255.0f;
    CGFloat blue  = (CGFloat)pixelData[2] / 255.0f;
    CGFloat alpha = (CGFloat)pixelData[3] / 255.0f;
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

-(UITapGestureRecognizer *)tapGesture{
    if (!_tapGesture) {
        _tapGesture =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectColorAction:)];
    }
    return _tapGesture;
}

-(UIView *)Cover{
    if (!_Cover) {
        _Cover = [[UIView alloc]initWithFrame:WindowView.bounds];
        _Cover.backgroundColor = [UIColor clearColor];
        [WindowView addSubview:_Cover];
    }
    return _Cover;
}

-(UIView *)ResultView{
    if (!_ResultView) {
        _ResultView = [[UIView alloc]initWithFrame:CGRectMake(self.width/4*3, self.height/16, self.height/8, self.height/8)];
        _ResultView.backgroundColor = [UIColor whiteColor];
        _ResultView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _ResultView.layer.borderWidth = 0.5;
        _ResultView.layer.cornerRadius = 3.0;
    }
    return _ResultView;
}

-(UILabel *)Title{
    if (!_Title) {
        _Title = [[UILabel alloc]initWithFrame:CGRectMake(0, self.height/16, self.width/4*3, self.height/8)];
        _Title.font = [UIFont systemFontOfSize:30];
        _Title.textAlignment = NSTextAlignmentCenter;
    }
    return _Title;
}

-(UIImageView *)ColorImageView{
    if (!_ColorImageView) {
        _ColorImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, self.height/4, self.width-20, self.height/4*3-50)];
        [_ColorImageView setImage:[UIImage imageNamed:@"huaban.png"]];
        _ColorImageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _ColorImageView.layer.borderWidth = 0.5;
        _ColorImageView.userInteractionEnabled = YES;
    }
    return _ColorImageView;
}

-(UIButton *)confirm{
    if (!_confirm) {
        _confirm = [[UIButton alloc]initWithFrame:CGRectMake(10+(self.width-20)/2, self.height-50, (self.width-20)/2, 50)];
        [_confirm setTitle:@"確認" forState:UIControlStateNormal];
        [_confirm setTitleColor:NITColor(30, 150, 250) forState:UIControlStateNormal];
        [_confirm addTarget:self action:@selector(confirmedit) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirm;
}

-(UIButton *)cancel{
    if (!_cancel) {
        _cancel = [[UIButton alloc]initWithFrame:CGRectMake(10, self.height-50, (self.width-20)/2, 50)];
        [_cancel setTitle:@"キャンセル" forState:UIControlStateNormal];
        [_cancel setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_cancel addTarget:self action:@selector(canceledit) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancel;
}

-(NSDictionary *)actiondict{
    if (!_actiondict) {
        _actiondict = [NSDictionary dictionary];
    }
    return _actiondict;
}

-(void)RemoveAllView{
    [self.Cover removeFromSuperview];
    [self.Title removeFromSuperview];
    [self.ColorImageView removeFromSuperview];
    [self.ResultView removeFromSuperview];
    [self removeFromSuperview];
    self.tapGesture = nil;
    self.Cover = nil;
//    self.Title = nil;
//    self.ColorImageView = nil;
//    self.ResultView = nil;
}


@end
