//
//  LifeRhythmDetailVC.m
//  センサーデータ可視化
//
//  Created by totyu3 on 17/1/19.
//  Copyright © 2017年 LGF. All rights reserved.
//

#import "LifeRhythmDetailVC.h"

@interface LifeRhythmDetailVC ()
@property (weak, nonatomic) IBOutlet UILabel *nowTime;
@property (weak, nonatomic) IBOutlet UILabel *roomName;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@end

@implementation LifeRhythmDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _nowTime.text = _weektime;
    _roomName.text = _model.roomname;
    _userName.text = _model.user0name;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
