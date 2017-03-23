//
//  VisualSettingVC.m
//  DashBoard
//
//  Created by totyu3 on 17/1/17.
//  Copyright © 2017年 NIT. All rights reserved.
//
#define SaveArrayPath [NITFilePath stringByAppendingPathComponent:@"VSSaveArray.plist"]

#import "VisualSettingVC.h"
#import "LGFDropDown.h"
#import "LGFColorSelectView.h"

@interface UserListCollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *RoomName;
@property (weak, nonatomic) IBOutlet UILabel *UserName;
@property (weak, nonatomic) IBOutlet UILabel *UserAge;
@property (weak, nonatomic) IBOutlet UILabel *UserSex;
@end
@implementation UserListCollectionCell
@end

@interface VisualSetOneTableCell : UITableViewCell <LGFColorSelectViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *ColorView;
@property (weak, nonatomic) IBOutlet UITextField *ActionName;
@property (weak, nonatomic) IBOutlet UITextField *ActionOrder;
@property (weak, nonatomic) IBOutlet UITextField *ActionExplain;
@property (weak, nonatomic) IBOutlet UITextField *ActionSummary;
@property (weak, nonatomic) IBOutlet UITextField *SensorName;
@property (weak, nonatomic) IBOutlet UITextField *DeviceName;
@property (weak, nonatomic) IBOutlet UITextField *DataExplain;
@property (nonatomic, strong) NSDictionary *DataDict;
@property (nonatomic, assign) NSInteger Row;
@end
@implementation VisualSetOneTableCell

-(void)setDataDict:(NSDictionary *)DataDict{
    
    _DataDict = DataDict;
    if ([DataDict[@"actionclass"]isEqualToString:@"1"]) {
        self.ColorView.backgroundColor = [UIColor clearColor];
        self.ColorView.userInteractionEnabled = NO;
    } else {
        self.ColorView.backgroundColor = [UIColor colorWithHex:DataDict[@"actioncolor"]];
        self.ColorView.userInteractionEnabled = YES;
    }
    self.ActionName.text = [NSString stringWithFormat:@"%@",DataDict[@"actionname"]];
    self.ActionOrder.text = [NSString stringWithFormat:@"%@",DataDict[@"actionorder"]];
    self.ActionExplain.text = [NSString stringWithFormat:@"%@",DataDict[@"actionexplain"]];
    self.ActionSummary.text = [NSString stringWithFormat:@"%@",DataDict[@"actionsummary"]];
    self.SensorName.text = [NSString stringWithFormat:@"%@",DataDict[@"sensorname"]];
    self.DeviceName.text = [NSString stringWithFormat:@"%@",DataDict[@"devicename1"]];
    self.DataExplain.text = [NSString stringWithFormat:@"%@",DataDict[@"dataexplain1"]];
}

- (IBAction)ColorSelect:(id)sender {
    LGFColorSelectView *ColorSelect = [[LGFColorSelectView alloc]initWithFrame:WindowView.bounds Super:self Data:_DataDict];
    [WindowView addSubview:ColorSelect];
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    NSMutableArray *savearr = [NSMutableArray arrayWithContentsOfFile:SaveArrayPath];
    NSMutableDictionary *savedict = [NSMutableDictionary dictionaryWithDictionary:savearr[_Row]];
    
    if (textField==self.ActionName) {
        [savedict setValue:textField.text forKey:@"actionname"];
    }else if(textField==self.ActionOrder){
        [savedict setValue:textField.text forKey:@"actionorder"];
    }else if(textField==self.ActionExplain){
        [savedict setValue:textField.text forKey:@"actionexplain"];
    }else if(textField==self.ActionSummary){
        [savedict setValue:textField.text forKey:@"actionsummary"];
    }else if(textField==self.SensorName){
        [savedict setValue:textField.text forKey:@"sensorname"];
    }else if(textField==self.DeviceName){
        [savedict setValue:textField.text forKey:@"devicename1"];
    }else if(textField==self.DataExplain){
        [savedict setValue:textField.text forKey:@"dataexplain1"];
    }
    [savearr replaceObjectAtIndex:_Row withObject:savedict];
    [savearr writeToFile:SaveArrayPath atomically:NO];
    [textField resignFirstResponder];
    return YES;
}

-(void)SelectColor:(NSDictionary *)ColorDict{
    
    self.ColorView.backgroundColor = [UIColor colorWithHex:ColorDict[@"actioncolor"]];

    NSMutableArray *savearr = [NSMutableArray arrayWithContentsOfFile:SaveArrayPath];
    NSMutableDictionary *savedict = [NSMutableDictionary dictionaryWithDictionary:savearr[_Row]];
    [savedict setValue:ColorDict[@"actioncolor"] forKey:@"actioncolor"];
    [savearr replaceObjectAtIndex:_Row withObject:savedict];
    [savearr writeToFile:SaveArrayPath atomically:NO];
}
@end

@interface VisualSetTwoTableCell : UITableViewCell <LGFColorSelectViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *ColorView;
@property (weak, nonatomic) IBOutlet UITextField *ActionName;
@property (weak, nonatomic) IBOutlet UITextField *ActionOrder;
@property (weak, nonatomic) IBOutlet UITextField *ActionExplain;
@property (weak, nonatomic) IBOutlet UITextField *ActionSummary;
@property (weak, nonatomic) IBOutlet UITextField *SensorName;
@property (weak, nonatomic) IBOutlet UITextField *DeviceName;
@property (weak, nonatomic) IBOutlet UITextField *SensorName2;
@property (weak, nonatomic) IBOutlet UITextField *DeviceName2;
@property (weak, nonatomic) IBOutlet UITextField *DataExplain;
@property (weak, nonatomic) IBOutlet UITextField *DataExplain2;
@property (nonatomic, strong) NSDictionary *DataDict;
@property (nonatomic, assign) NSInteger Row;
@end
@implementation VisualSetTwoTableCell

-(void)setDataDict:(NSDictionary *)DataDict{
    
    _DataDict = DataDict;
    if ([DataDict[@"actionclass"]isEqualToString:@"1"]) {
        self.ColorView.backgroundColor = [UIColor clearColor];
        self.ColorView.userInteractionEnabled = NO;
    } else {
        self.ColorView.backgroundColor = [UIColor colorWithHex:DataDict[@"actioncolor"]];
        self.ColorView.userInteractionEnabled = YES;
    }
    self.ActionName.text = [NSString stringWithFormat:@"%@",DataDict[@"actionname"]];
    self.ActionOrder.text = [NSString stringWithFormat:@"%@",DataDict[@"actionorder"]];
    self.ActionExplain.text = [NSString stringWithFormat:@"%@",DataDict[@"actionexplain"]];
    self.ActionSummary.text = [NSString stringWithFormat:@"%@",DataDict[@"actionsummary"]];
    self.SensorName.text = [NSString stringWithFormat:@"%@",DataDict[@"sensorname"]];
    self.DeviceName.text = [NSString stringWithFormat:@"%@",DataDict[@"devicename1"]];
    self.SensorName2.text = [NSString stringWithFormat:@"%@",DataDict[@"sensorname"]];
    self.DeviceName2.text = [NSString stringWithFormat:@"%@",DataDict[@"devicename2"]];
    self.DataExplain.text = [NSString stringWithFormat:@"%@",DataDict[@"dataexplain1"]];
    self.DataExplain2.text = [NSString stringWithFormat:@"%@",DataDict[@"dataexplain2"]];
}

- (IBAction)ColorSelect:(id)sender {
    LGFColorSelectView *ColorSelect = [[LGFColorSelectView alloc]initWithFrame:WindowView.bounds Super:self Data:_DataDict];
    [WindowView addSubview:ColorSelect];
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    NSMutableArray *savearr = [NSMutableArray arrayWithContentsOfFile:SaveArrayPath];
    
    NSMutableDictionary *savedict = [NSMutableDictionary dictionaryWithDictionary:savearr[_Row]];
    
    if (textField==self.ActionName) {
        [savedict setValue:textField.text forKey:@"actionname"];
    }else if(textField==self.ActionOrder){
        [savedict setValue:textField.text forKey:@"actionorder"];
    }else if(textField==self.ActionExplain){
        [savedict setValue:textField.text forKey:@"actionexplain"];
    }else if(textField==self.ActionSummary){
        [savedict setValue:textField.text forKey:@"actionsummary"];
    }else if(textField==self.SensorName){
        [savedict setValue:textField.text forKey:@"sensorname"];
    }else if(textField==self.DeviceName){
        [savedict setValue:textField.text forKey:@"devicename1"];
    }else if(textField==self.DeviceName2){
        [savedict setValue:textField.text forKey:@"devicename2"];
    }else if(textField==self.DataExplain){
        [savedict setValue:textField.text forKey:@"dataexplain1"];
    }else if(textField==self.DataExplain2){
        [savedict setValue:textField.text forKey:@"dataexplain2"];
    }
    [savearr replaceObjectAtIndex:_Row withObject:savedict];
    
    [savearr writeToFile:SaveArrayPath atomically:NO];
    [textField resignFirstResponder];
    return YES;

}


-(void)SelectColor:(NSDictionary *)ColorDict{
    
    self.ColorView.backgroundColor = [UIColor colorWithHex:ColorDict[@"actioncolor"]];

    NSMutableArray *savearr = [NSMutableArray arrayWithContentsOfFile:SaveArrayPath];
    NSMutableDictionary *savedict = [NSMutableDictionary dictionaryWithDictionary:savearr[_Row]];
    [savedict setValue:ColorDict[@"actioncolor"] forKey:@"actioncolor"];
    [savearr replaceObjectAtIndex:_Row withObject:savedict];
    [savearr writeToFile:SaveArrayPath atomically:NO];
}
@end

@interface VisualSettingVC ()<LGFDropDownDelegate>
{
    NSInteger UserListCollectionSelectItem;
}
@property (weak, nonatomic) IBOutlet LGFDropDown *PlaceDropDown;
@property (weak, nonatomic) IBOutlet UITableView *VisualDetailTable;
@property (weak, nonatomic) IBOutlet UICollectionView *UserListCollection;
@property (weak, nonatomic) IBOutlet UITableView *VisualSetTable;
@property (weak, nonatomic) IBOutlet UIButton *SaveButton;
@property (nonatomic, strong) NSArray *UserListArray;
@property (nonatomic, strong) NSArray *VisualSetArray;
@end

@implementation VisualSettingVC

static NSString * const reuseIdentifiercv = @"UserListCollectionCell";
static NSString * const reuseIdentifiertbvone = @"VisualSetTableOneCell";
static NSString * const reuseIdentifiertbvtwo = @"VisualSetTwoTableCell";

-(NSArray *)UserListArray{
    if (!_UserListArray) {
        _UserListArray = [NSArray array];
    }
    return _UserListArray;
}

-(NSArray *)VisualSetArray{
    if (!_VisualSetArray) {
        _VisualSetArray = [NSArray array];
    }
    return _VisualSetArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //UserListCollection 设置默认选中
    UserListCollectionSelectItem = 0;
    [self LoadPlaceData];
}
/**
 取得楼层数据
 */
- (void)LoadPlaceData{
    [MBProgressHUD showMessage:@"後ほど..." toView:self.view];
    [[SealAFNetworking NIT] PostWithUrl:ZwgetbuildinginfoType parameters:nil mjheader:nil superview:self.view success:^(id success){
        NSDictionary *tmpDic = [LGFNullCheck CheckNSNullObject:success];
        if ([tmpDic[@"code"] isEqualToString:@"200"]) {
            
            self.BuildingArray = tmpDic[@"buildingInfo"];
            [self LoadVzConfigData:self.BuildingArray[0]];
            _PlaceDropDown.delegate = self;
            _PlaceDropDown.DefaultTitle = self.BuildingArray[0][@"displayname"];
            _PlaceDropDown.DataArray = self.BuildingArray;
        } else {
            NSLog(@"errors: %@",tmpDic[@"errors"]);
        }
    }defeats:^(NSError *defeats){
    }];
}
/**
 取得user数据
 */
- (void)LoadVzConfigData:(NSDictionary*)Building{
    [MBProgressHUD showMessage:@"後ほど..." toView:self.view];
    NSDictionary *parameter = @{@"buildingid":Building[@"buildingid"],@"floorno":Building[@"floorno"]};
    [[SealAFNetworking NIT] PostWithUrl:ZwgetvzconfiginfoType parameters:parameter mjheader:nil superview:self.view success:^(id success){
        NSDictionary *tmpDic = [LGFNullCheck CheckNSNullObject:success];
        if ([tmpDic[@"code"] isEqualToString:@"200"]) {
            self.UserListArray = tmpDic[@"vzconfiginfo"];
            [[NoDataLabel alloc] Show:@"データがない" SuperView:self.view DataBool:self.UserListArray.count];
            if (self.UserListArray.count>0) {
                NSDictionary *dict = self.UserListArray[UserListCollectionSelectItem];
                NSMutableDictionary *SystemUserDict = [NSMutableDictionary dictionaryWithContentsOfFile:SYSTEM_USER_DICT];
                [SystemUserDict setValue:dict[@"userid0"] forKey:@"userid0"];
                [SystemUserDict setValue:dict[@"roomid"] forKey:@"roomid"];
                [SystemUserDict writeToFile:SYSTEM_USER_DICT atomically:NO];
                _SaveButton.alpha = 1.0;
                self.VisualSetArray = dict[@"actioninfo"];
                [self.VisualSetArray writeToFile:SaveArrayPath atomically:NO];
            } else {
                _SaveButton.alpha = 0.0;
                self.VisualSetArray = nil;
            }
            [_VisualSetTable reloadData];
            [_UserListCollection reloadData];
            [_UserListCollection selectItemAtIndexPath:[NSIndexPath indexPathForItem:UserListCollectionSelectItem inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
        } else {
            NSLog(@"errors: %@",tmpDic[@"errors"]);
            [[NoDataLabel alloc] Show:@"system errors" SuperView:self.view DataBool:0];
        }
    }defeats:^(NSError *defeats){
    }];
}
/**
 保存更新可视化设定
 */
- (IBAction)SaveData:(id)sender {
    [MBProgressHUD showMessage:@"後ほど..." toView:self.view];
    NSIndexPath *indexpath = _UserListCollection.indexPathsForSelectedItems.lastObject;
    NSDictionary *DataDict = self.UserListArray[indexpath.item];
    NSMutableDictionary *SystemUserDict = [NSMutableDictionary dictionaryWithContentsOfFile:SYSTEM_USER_DICT];
    NSMutableArray *savearr = [NSMutableArray arrayWithContentsOfFile:SaveArrayPath];
    NSDictionary *parameter = @{@"userid1":SystemUserDict[@"userid1"],@"userid0":DataDict[@"userid0"],@"roomid":DataDict[@"roomid"],@"actioninfo":[self ArrayToJson:savearr]};
    [[SealAFNetworking NIT] PostWithUrl:ZwgetupdatevzconfiginfoType parameters:parameter mjheader:nil superview:self.view success:^(id success){
        NSDictionary *tmpDic = [LGFNullCheck CheckNSNullObject:success];
        if ([tmpDic[@"code"] isEqualToString:@"200"]) {
            [self LoadVzConfigData:self.BuildingArray[_PlaceDropDown.SelectRow]];
//            [MBProgressHUD showSuccess:@"成功" toView:self.view];
        } else {
            NSLog(@"errors: %@",tmpDic[@"errors"]);
//            [MBProgressHUD showError:@"失败" toView:self.view];
        }
    }defeats:^(NSError *defeats){
        NSLog(@"errors");
    }];
}
/**
 *  数组转json
 */
-(NSString*)ArrayToJson:(NSMutableArray*)array{
    NSMutableArray *scenariodtlinfo = [NSMutableArray arrayWithArray:array];
    NSData * jsondata = [NSJSONSerialization dataWithJSONObject:scenariodtlinfo
                                                        options:NSJSONWritingPrettyPrinted
                                                          error:nil];
    NSString *jsonstr = [[NSString alloc] initWithData:jsondata encoding:NSUTF8StringEncoding];
    return jsonstr;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
/**
 楼层下拉框 代理
 */
-(void)nowSelectRow:(NSString *)selecttitle selectrow:(NSInteger)selectrow{
    [self LoadVzConfigData:self.BuildingArray[selectrow]];
}

#pragma mark UICollectionView Delegate and DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.UserListArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(_UserListCollection.width,_UserListCollection.height/4);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *DataDict = self.UserListArray[indexPath.item];
    UserListCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifiercv forIndexPath:indexPath];
    UIView* selectedBGView = [[UIView alloc] initWithFrame:cell.bounds];
    selectedBGView.backgroundColor = SystemColor(0.8);
    cell.selectedBackgroundView = selectedBGView;
    cell.UserAge.text = [NSString stringWithFormat:@"%@",DataDict[@"userold"]];
    cell.RoomName.text = DataDict[@"roomname"];
    cell.UserName.text = DataDict[@"username0"];
    cell.UserSex.text = DataDict[@"usersex"];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    UserListCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifiercv forIndexPath:indexPath];
    for (id obj in cell.subviews) {
        if ([obj isKindOfClass:[UILabel class]]) {
            UILabel *title = obj;
            title.textColor = [UIColor whiteColor];
        }
    }
    UserListCollectionSelectItem = indexPath.item;
    NSDictionary *dict = self.UserListArray[indexPath.item];
    self.VisualSetArray = dict[@"actioninfo"];
    NSMutableDictionary *SystemUserDict = [NSMutableDictionary dictionaryWithContentsOfFile:SYSTEM_USER_DICT];
    [SystemUserDict setValue:dict[@"userid0"] forKey:@"userid0"];
    [SystemUserDict setValue:dict[@"roomid"] forKey:@"roomid"];
    [SystemUserDict writeToFile:SYSTEM_USER_DICT atomically:NO];
    if ([self.VisualSetArray writeToFile:SaveArrayPath atomically:NO]) {
        [_VisualSetTable reloadData];
    }
}

#pragma mark - Table view DataSource and Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.VisualSetArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *DataDict = self.VisualSetArray[indexPath.item];
    if ([[NSString stringWithFormat:@"%@",DataDict[@"actionexplain"]]isEqualToString:@"6"]) {
        return 90;
    } else {
        return 50;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *DataDict = self.VisualSetArray[indexPath.item];
    if ([[NSString stringWithFormat:@"%@",DataDict[@"actionexplain"]]isEqualToString:@"6"]) {
        VisualSetTwoTableCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifiertbvtwo forIndexPath:indexPath];
        cell.Row = indexPath.row;
        cell.DataDict = DataDict;
        return cell;
    } else {
        VisualSetOneTableCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifiertbvone forIndexPath:indexPath];
        cell.Row = indexPath.row;
        cell.DataDict = DataDict;
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

}

@end
