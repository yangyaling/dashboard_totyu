//
//  OneVCCell.m
//  センサーデータ可視化
//
//  Created by totyu3 on 16/12/21.
//  Copyright © 2016年 LGF. All rights reserved.
//

#import "OneVCCell.h"
@interface OneVCCell ()<AlertLabelDelegate>

@end
@implementation OneVCCell

static NSString * const reuseIdentifier = @"OneVCCCell";

+ (instancetype)cellWithTableView:(UICollectionView *)collectionView indexPath:(NSIndexPath*)indexPath{
    OneVCCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:reuseIdentifier owner:self options:nil].firstObject;
    }
    cell.cellbgview.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    cell.cellbgview.layer.shadowOpacity = 1.0;
    cell.cellbgview.layer.shadowOffset = CGSizeMake(0,0);
    cell.opaque = YES;
    cell.cellbgview.layer.masksToBounds = NO;
    cell.cellbgview.layer.shouldRasterize = YES;
    cell.cellbgview.layer.rasterizationScale = [UIScreen mainScreen].scale;
    return cell;
}

-(void)setAlerttype:(NSString *)alerttype{
    
    [_alert removeFromSuperview];
    _cellbgview.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    _alerttype = alerttype;
    if ([_alerttype isEqualToString:@"1"]) {
        _alert = [[AlertLabel alloc]initWithFrame:CGRectMake(0, 5, _cellbgview.width/2, 80)];
        _alert.delegate = self;
        [_cellbgview addSubview:_alert];
        _cellbgview.layer.shadowColor = [UIColor redColor].CGColor;
    }
}

-(void)AlertLabelClick{
    UIAlertController *testalert = [UIAlertController alertControllerWithTitle:@"TestAlert" message:[NSString stringWithFormat:@"%@はクリックしました，このページは展示されていません",_RoomName.text] preferredStyle:UIAlertControllerStyleAlert];
    [testalert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
    }]];
    [WindowView.rootViewController presentViewController:testalert animated:YES completion:nil];
}








@end
