//
//  LifeRhythmVC.m
//  センサーデータ可視化
//
//  Created by totyu3 on 17/1/13.
//  Copyright © 2017年 LGF. All rights reserved.
//

#import "LifeRhythmVC.h"
#import "LifeRhythmVCModel.h"
#import "LifeRhythmVCCell.h"

@interface LifeRhythmVC ()
/**
 *  总数组
 */
@property (strong, nonatomic) NSMutableArray *ZworksDataArray;
@property (weak, nonatomic) IBOutlet UILabel *nowTime;
@property (weak, nonatomic) IBOutlet UILabel *roomName;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UITableView *chartTableView;

@end

@implementation LifeRhythmVC

static NSString * const reuseIdentifier = @"ChartCollectionViewCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday |
    NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    comps = [calendar components:unitFlags fromDate:[NSDate date]];
    NSArray *weekarray = @[@"日",@"月",@"火",@"水",@"木",@"金",@"土"];

    _nowTime.text = [NSString stringWithFormat:@"%@(%@)",[[NSDate date]needDateStatus:JapanMDType],weekarray[[comps weekday]-1]];
    _roomName.text = _model.roomname;
    _userName.text = _model.user0name;
    [self loadNewData];
}

-(void)loadNewData{
    
    [MBProgressHUD showMessage:@"後ほど..." toView:self.view];
    NSString *userid1 = [NITUserDefaults objectForKey:@"userid1"];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"nowdate"] = [[NSDate date]needDateStatus:HaveHMSType];
    parameters[@"userid1"] = userid1;
    parameters[@"userid0"] = _model.userid0;
    parameters[@"deviceclass"] = @"1";
    [[SealAFNetworking NIT] PostWithUrl:DaySensorURLType parameters:parameters mjheader:nil superview:self.view success:^(id success){
        NSDictionary *tmpDic = success;
        NSArray *tmpArr = [LifeRhythmVCModel mj_objectArrayWithKeyValuesArray:[tmpDic valueForKey:@"deviceinfo"]];
        if (tmpArr.count == 0) {
            [_ZworksDataArray removeAllObjects];
            [MBProgressHUD showError:@"データがありません" toView:self.view];
        }else{
            _ZworksDataArray = [NSMutableArray arrayWithArray:tmpArr];
            [_chartTableView reloadData];
        }
    }defeats:^(NSError *defeats){
    }];
}

#pragma mark UITableView delegate and dataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return _ZworksDataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 150;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LifeRhythmVCCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    cell.CellModel = _ZworksDataArray[indexPath.section];
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    LifeRhythmVCModel *model = _ZworksDataArray[section];
    CGRect frame = CGRectMake(0, 0, NITScreenW, 30);
    CGRect labelframe = CGRectMake(NITScreenW * 0.1, 0, NITScreenW * 0.8, 30);
    CGRect imageframe = CGRectMake(NITScreenW * 0.9, 5, 20, 20);
    UIView *bgview = [[UIView alloc] initWithFrame:frame];
    UILabel *label = [[UILabel alloc]initWithFrame:labelframe];
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:imageframe];
    [imageV setContentMode:UIViewContentModeScaleAspectFit];
    bgview.backgroundColor =  [[UIColor lightGrayColor]colorWithAlphaComponent:0.3];
    [label setText:[NSString stringWithFormat:@"%@（%@）",model.devicename,model.nodename]];
    [label setFont:[UIFont systemFontOfSize:14]];
    label.textAlignment = NSTextAlignmentCenter; //居中文字
    if ([model.batterystatus intValue] == 1) {
        [imageV setImage:[UIImage imageNamed:@"battery_full"]];
    }else if ([model.batterystatus intValue] == 2){
        [imageV setImage:[UIImage imageNamed:@"battery_warn"]];
    }else if ([model.batterystatus intValue] == 3){
        [imageV setImage:[UIImage imageNamed:@"battery_empty"]];
    }
    [bgview addSubview:label];
    [bgview addSubview:imageV];
    return bgview;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
