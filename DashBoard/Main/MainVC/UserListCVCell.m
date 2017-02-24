//
//  UserListCVCell.m
//  DashBoard
//
//  Created by totyu3 on 17/1/17.
//  Copyright © 2017年 NIT. All rights reserved.
//

#import "UserListCVCell.h"

@implementation UserListCVCell
-(void)setAlerttype:(NSString *)alerttype{
    
    [_alert removeFromSuperview];
    _alerttype = alerttype;
    if ([_alerttype isEqualToString:@"1"]) {
        _alert = [[AlertLabel alloc]initWithFrame:CGRectMake(_CellBGView.width/3*2, 2, _CellBGView.width/3, 50)];
        _alert.delegate = self;
        [_CellBGView addSubview:_alert];
        _CellBGView.backgroundColor = SystemColor(0.3);
        _CellBGView.layer.borderWidth = 0.0;
    }else{
        _CellBGView.backgroundColor = [UIColor whiteColor];
        _CellBGView.layer.borderColor = NITColor(220.0, 220.0, 220.0).CGColor;
        _CellBGView.layer.borderWidth = 0.5;
    }
}

-(void)AlertLabelClick{
    UIAlertController *testalert = [UIAlertController alertControllerWithTitle:@"TestAlert" message:[NSString stringWithFormat:@"%@はクリックしました，このページは展示されていません",_RoomName.text] preferredStyle:UIAlertControllerStyleAlert];
    [testalert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
    }]];
    [MasterKeyWindow.rootViewController presentViewController:testalert animated:YES completion:nil];
}
@end
