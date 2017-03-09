//
//  UserListCVCell.h
//  DashBoard
//
//  Created by totyu3 on 17/1/17.
//  Copyright © 2017年 NIT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlertBar.h"
#import "AlertLabel.h"

@interface UserListCVCell : UICollectionViewCell<AlertLabelDelegate>

@property (weak, nonatomic) IBOutlet UIView *CellBGView;
@property (weak, nonatomic) IBOutlet UILabel *RoomName;
@property (weak, nonatomic) IBOutlet UILabel *UserName;
@property (weak, nonatomic) IBOutlet UIImageView *UserImage;
@property (weak, nonatomic) IBOutlet UILabel *UserAge;
@property (weak, nonatomic) IBOutlet UILabel *UserSex;
@property (weak, nonatomic) IBOutlet UILabel *temperature;
@property (weak, nonatomic) IBOutlet UILabel *luminance;
@property (nonatomic, copy) NSString *alerttype;
@property (nonatomic, strong) AlertLabel *alert;

@property (nonatomic, strong) NSArray *alertArray;

@end
