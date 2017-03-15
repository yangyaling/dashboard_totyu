//
//  ColorSelectionCV.h
//  DashBoard
//
//  Created by totyu3 on 17/2/10.
//  Copyright © 2017年 NIT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NITCollectionView.h"
#import "LGFColorSelectView.h"
IB_DESIGNABLE
@interface ColorSelectionCV : NITCollectionView
@property (nonatomic, strong) NSMutableArray *ColorSelectionArray;
@property (nonatomic, copy) IBInspectable NSString *CSReuseIdentifier;
@end
