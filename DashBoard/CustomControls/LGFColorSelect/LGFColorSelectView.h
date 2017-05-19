//
//  LGFColorSelectView.h
//  ColorTestView
//
//  Created by totyu3 on 17/2/21.
//  Copyright © 2017年 NIT. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LGFColorSelectViewDelegate <NSObject>
-(void)SelectColor:(NSDictionary *)ColorDict;
@end

@interface LGFColorSelectView : UIView
@property (nonatomic, copy) NSString *SelectId;
-(instancetype)initWithFrame:(CGRect)frame Super:(id)Super Data:(NSDictionary*)actiondict SelectButton:(UIButton*)SelectButton;
@property (nonatomic, assign) id<LGFColorSelectViewDelegate> delegate;
@end
