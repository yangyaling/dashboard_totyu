//
//  TwoVCCell.h
//  センサーデータ可視化
//
//  Created by totyu3 on 16/12/22.
//  Copyright © 2016年 LGF. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlertLabel.h"

@interface TwoVCCell : UICollectionViewCell
+ (instancetype)cellWithTableView:(UICollectionView *)collectionView indexPath:(NSIndexPath*)indexPath;
@property (weak, nonatomic) IBOutlet UIView *cellbgview;
@property (weak, nonatomic) IBOutlet UILabel *RoomName;
@property (weak, nonatomic) IBOutlet UILabel *UserName;
@property (weak, nonatomic) IBOutlet UIImageView *UserImage;
@property (weak, nonatomic) IBOutlet UILabel *UserAge;
@property (weak, nonatomic) IBOutlet UILabel *UserSex;
@property (nonatomic, copy) NSString *alerttype;
@property (nonatomic, strong) AlertLabel *alert;
@end
