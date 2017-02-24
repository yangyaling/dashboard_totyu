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
+(LGFColorSelectView *)ColorSelect;
- (void)ShowInView:(id)Super Data:(NSDictionary*)actiondict;
@property (nonatomic, assign) id<LGFColorSelectViewDelegate> delegate;
@end
