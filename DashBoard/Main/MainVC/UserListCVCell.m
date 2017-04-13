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
    
    _alerttype = alerttype;
    for (NSDictionary *dic in _alertArray) {
        if ([dic[@"roomid"] isEqualToString:alerttype]) {
            [_alert removeFromSuperview];
            _alert = [[AlertLabel alloc]initWithFrame:CGRectMake(self.width-self.width/6, 0, self.width/6, self.width/6)];
            _alert.delegate = self;
            [self addSubview:_alert];
            _CellBGView.backgroundColor = SystemColor(0.3);
        }
    }
}

-(void)AlertLabelClick{
//    UIAlertController *testalert = [UIAlertController alertControllerWithTitle:@"TestAlert" message:[NSString stringWithFormat:@"%@はクリックしました，このページは展示されていません",_RoomName.text] preferredStyle:UIAlertControllerStyleAlert];
//    [testalert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
//    }]];
//    [LGFKeyWindow.rootViewController presentViewController:testalert animated:YES completion:nil];
}
@end
