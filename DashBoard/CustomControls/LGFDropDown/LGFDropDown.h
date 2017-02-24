//
//  LGFDropDown.h
//  下拉菜单
//
//  Created by totyu3 on 16/7/11.
//  Copyright © 2016年 totyu3. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol LGFDropDownDelegate <NSObject>
/**
 *  选中触发代理
 *
 *  @param selecttitle 选中标题
 */
-(void)nowSelectRow:(NSString*)selecttitle selectrow:(NSInteger)selectrow;
@end
IB_DESIGNABLE
@interface LGFDropDown : UIView
@property (nonatomic,weak) id<LGFDropDownDelegate> delegate;
-(id)initWithFrame:(CGRect)frame;
/**
 *  菜单数组
 */
@property (nonatomic, strong) NSArray          *DataArray;
/**
 *  背景颜色
 */
@property (nonatomic) IBInspectable UIColor           *BackGroundColor;
/**
 *  标题圆角
 */
@property (nonatomic) IBInspectable CGFloat           CornerRadius;
/**
 *  箭头颜色
 */
@property (nonatomic) IBInspectable UIColor           *ArrowColor;
/**
 *  标题字体颜色
 */
@property (nonatomic) IBInspectable UIColor           *TextColor;
/**
 *  点击选中标题字体改变颜色
 */
@property (nonatomic) IBInspectable UIColor           *SelectColor;
/**
 *  标题边框粗细
 */
@property (nonatomic) IBInspectable CGFloat           BorderWidth;
/**
 *  标题边框颜色
 */
@property (nonatomic) IBInspectable UIColor          *BorderColor;
/**
 *  默认标题名字
 */
@property (nonatomic) IBInspectable NSString          *DefaultTitle;
/**
 *  选中row
 */
@property NSInteger                                    SelectRow;
/**
 *  默认选中
 */
-(void)selectRow:(NSInteger)row;

@end
