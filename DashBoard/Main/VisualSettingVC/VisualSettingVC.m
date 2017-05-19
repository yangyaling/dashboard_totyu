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

@interface VisualSetAlert : NSObject
+(void)ShowMessage:(NSString*)message;
@end
@implementation VisualSetAlert
+(void)ShowMessage:(NSString*)message{
    UIAlertController *TextFieldAlert = [UIAlertController alertControllerWithTitle:@"入力エラー" message:message preferredStyle:UIAlertControllerStyleAlert];
    [LGFKeyWindow.rootViewController presentViewController:TextFieldAlert animated:YES completion:nil];
    AFTER(2.0,[TextFieldAlert dismissViewControllerAnimated:YES completion:nil];);
}
@end

@interface UserListCollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *RoomName;
@property (weak, nonatomic) IBOutlet UILabel *UserName;
@property (weak, nonatomic) IBOutlet UILabel *UserAge;
@property (weak, nonatomic) IBOutlet UILabel *UserSex;
@end
@implementation UserListCollectionCell
@end

@protocol SensorInformationTBCellDelegate <NSObject>
@required
- (void)SensorInformationTableReload;
@end
@interface SensorInformationTBCell : UITableViewCell
@property (nonatomic, weak) IBOutlet id<SensorInformationTBCellDelegate> SensorInformationDelegate;
@property (weak, nonatomic) IBOutlet UIButton *SensorName;
@property (weak, nonatomic) IBOutlet UIButton *DeviceName;
@property (weak, nonatomic) IBOutlet UITextField *DataExplain;
@property (nonatomic, strong) NSDictionary *DataDict;
@property (nonatomic, assign) NSInteger SuperRow;
@property (nonatomic, assign) NSInteger Row;
@property (nonatomic, assign) BOOL SuperEditing;
@end
@implementation SensorInformationTBCell

-(void)setDataDict:(NSDictionary *)DataDict{
    _DataDict = DataDict;
    [_SensorName setTitle:DataDict[@"displayname"] forState:UIControlStateNormal];
    [_DeviceName setTitle:DataDict[@"devicetypename"] forState:UIControlStateNormal];
    _DataExplain.text = DataDict[@"dataexplain"];
}

-(void)setSuperEditing:(BOOL)SuperEditing{
    _SuperEditing = SuperEditing;
    
    NSMutableArray *savearr = [NSMutableArray arrayWithContentsOfFile:SaveArrayPath];
    NSMutableDictionary *savedict = [NSMutableDictionary dictionaryWithDictionary:savearr[_SuperRow]];
    if (_Row == 0) {
        _SensorName.userInteractionEnabled = SuperEditing;
        _DeviceName.userInteractionEnabled = SuperEditing;
        _SensorName.layer.borderColor = SuperEditing ? NITColor(190, 190, 190).CGColor : [UIColor clearColor].CGColor;
        _DeviceName.layer.borderColor = SuperEditing ? NITColor(190, 190, 190).CGColor : [UIColor clearColor].CGColor;
        if ([savedict[@"actionclass"] isEqualToString:@"2"]) {
            _DataExplain.userInteractionEnabled = SuperEditing;
            _DataExplain.borderStyle = SuperEditing ? UITextBorderStyleRoundedRect : UITextBorderStyleNone;
        }else{
            _DataExplain.userInteractionEnabled = NO;
            _DataExplain.borderStyle = UITextBorderStyleNone;
        }
    }else{
        _SensorName.userInteractionEnabled = NO;
        _DeviceName.userInteractionEnabled = NO;
        _DataExplain.userInteractionEnabled = NO;
        _SensorName.layer.borderColor = [UIColor clearColor].CGColor;
        _DeviceName.layer.borderColor = [UIColor clearColor].CGColor;
        _DataExplain.borderStyle = UITextBorderStyleNone;
    }
}

- (IBAction)SensorName:(UIButton *)sender {
    sender.backgroundColor = SystemColor(0.3);
    NSMutableArray *savearr = [NSMutableArray arrayWithContentsOfFile:SaveArrayPath];
    NSMutableDictionary *SystemUserDict = [NSMutableDictionary dictionaryWithContentsOfFile:SYSTEM_USER_DICT];
    NSMutableDictionary *savedict = [NSMutableDictionary dictionaryWithDictionary:savearr[_SuperRow]];
    UIAlertController *AddVisualSet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
    NSArray *sensornamearr;
    if (sender == _SensorName) {
        sensornamearr = [NSArray arrayWithArray:SystemUserDict[@"displaylist"]];
    } else {
        sensornamearr = [NSArray arrayWithArray:SystemUserDict[@"devicetypelist"]];
    }
    for (NSDictionary *devicedict in sensornamearr) {
        [AddVisualSet addAction:[UIAlertAction actionWithTitle:devicedict[@"name"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [sender setTitle:devicedict[@"name"] forState:UIControlStateNormal];
            if (sender == _SensorName) {
                [savedict setValue:devicedict[@"name"] forKey:@"displayname1"];
                [savedict setValue:devicedict[@"name"] forKey:@"displayname2"];
                [savedict setValue:devicedict[@"cd"] forKey:@"displaycd1"];
                [savedict setValue:devicedict[@"cd"] forKey:@"displaycd2"];
            } else {
                [savedict setValue:devicedict[@"name"] forKey:@"devicetypename1"];
                [savedict setValue:devicedict[@"cd"] forKey:@"devicetype1"];
            }
            if (![savedict[@"oflag"] isEqualToString:@"C"]) {
                [savedict setValue:@"U" forKey:@"oflag"];
            }
            sender.backgroundColor = [UIColor clearColor];
            [savearr replaceObjectAtIndex:_SuperRow withObject:savedict];
            if ([savearr writeToFile:SaveArrayPath atomically:NO]) {
                [self.SensorInformationDelegate SensorInformationTableReload];
            }
        }]];
    }
    [AddVisualSet addAction:[UIAlertAction actionWithTitle:@"キャンセル" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *_Nonnull action) {
        sender.backgroundColor = [UIColor clearColor];
    }]];
    [LGFKeyWindow.rootViewController presentViewController:AddVisualSet animated:YES completion:nil];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    textField.backgroundColor = SystemColor(0.3);
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    textField.backgroundColor = [UIColor clearColor];
    NSMutableArray *savearr = [NSMutableArray arrayWithContentsOfFile:SaveArrayPath];
    NSMutableDictionary *savedict = [NSMutableDictionary dictionaryWithDictionary:savearr[_SuperRow]];
    if(textField==self.DataExplain){
        if (![@[@"",@"1",@"2",@"3"] containsObject:textField.text]) {
            [VisualSetAlert ShowMessage:@"データ解釈方法１〜３の数字から、1つを選んでください。"];
            return NO;
        }
        if (_Row == 0) {
            [savedict setValue:textField.text forKey:@"dataexplain1"];
        }else{
            [savedict setValue:textField.text forKey:@"dataexplain2"];
        }
        if (![savedict[@"oflag"] isEqualToString:@"C"]) {
            [savedict setValue:@"U" forKey:@"oflag"];
        }
    }
    [savearr replaceObjectAtIndex:_SuperRow withObject:savedict];
    if ([savearr writeToFile:SaveArrayPath atomically:NO]) {
        [self.SensorInformationDelegate SensorInformationTableReload];
    }
    [textField resignFirstResponder];
    return YES;
}

@end

@protocol VisualSetOneTableCellDelegate <NSObject>
@required
-(void)VisualSetTableReload:(NSMutableArray *)SaveArr Row:(NSInteger)Row;
@end
@interface VisualSetOneTableCell : UITableViewCell <LGFColorSelectViewDelegate>
@property (nonatomic, weak) IBOutlet id<VisualSetOneTableCellDelegate> VisualSetOneDelegate;
@property (weak, nonatomic) IBOutlet UIButton *ColorView;
@property (weak, nonatomic) IBOutlet UIButton *ColorViewTwo;
@property (weak, nonatomic) IBOutlet UITextField *ActionName;
@property (weak, nonatomic) IBOutlet UITextField *ActionClass;
@property (weak, nonatomic) IBOutlet UITextField *ActionOrder;
@property (weak, nonatomic) IBOutlet UITextField *ActionExplain;
@property (weak, nonatomic) IBOutlet UITextField *ActionSummary;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *LeftCellHeight;
@property (weak, nonatomic) IBOutlet UITableView *SensorInformationTB;
@property (weak, nonatomic) IBOutlet UIButton *AddSensorInformationBtn;
@property (nonatomic, strong) NSMutableArray *SensorInformationArray;
@property (nonatomic, assign) NSInteger Row;
@property (nonatomic, assign) BOOL SuperEditing;
@end
@implementation VisualSetOneTableCell

-(void)setSuperEditing:(BOOL)SuperEditing{
    _SuperEditing = SuperEditing;
    
    //数据覆盖
    NSMutableDictionary *DataDict = [self SensorInformationArrayGet];
    
    _ActionName.userInteractionEnabled = SuperEditing;
    _ActionName.borderStyle = SuperEditing ? UITextBorderStyleRoundedRect : UITextBorderStyleNone;
    _ActionClass.userInteractionEnabled = NO;
    _ActionClass.borderStyle = UITextBorderStyleNone;
    _ActionOrder.userInteractionEnabled = NO;
    _ActionOrder.borderStyle = UITextBorderStyleNone;
    _ActionSummary.userInteractionEnabled = NO;
    _ActionSummary.borderStyle = UITextBorderStyleNone;
    if ([DataDict[@"actionclass"] isEqualToString:@"2"]) {
        _ActionExplain.userInteractionEnabled = SuperEditing;
        _ActionExplain.borderStyle = SuperEditing ? UITextBorderStyleRoundedRect : UITextBorderStyleNone;
    }else{
        _ActionExplain.userInteractionEnabled = NO;
        _ActionExplain.borderStyle = UITextBorderStyleNone;
    }
    
    if ([[NSString stringWithFormat:@"%@",DataDict[@"actionexplain"]] isEqualToString:@"4"]) {
        NSArray *colorarray = [DataDict[@"actioncolor"] componentsSeparatedByString:@"|"];
        _ColorView.backgroundColor = [UIColor colorWithHex:colorarray[0]];
        _ColorViewTwo.backgroundColor = [UIColor colorWithHex:colorarray[1]];
    } else {
        _ColorView.backgroundColor = [UIColor colorWithHex:DataDict[@"actioncolor"]];
        _ColorViewTwo.backgroundColor = [UIColor colorWithHex:DataDict[@"actioncolor"]];
    }

    _ActionName.text = [NSString stringWithFormat:@"%@",DataDict[@"actionname"]];
    _ActionClass.text = [NSString stringWithFormat:@"%@",DataDict[@"actionclass"]];
    _ActionOrder.text = [NSString stringWithFormat:@"%@",DataDict[@"actionorder"]];
    _ActionExplain.text = [NSString stringWithFormat:@"%@",DataDict[@"actionexplain"]];
    _ActionSummary.text = [NSString stringWithFormat:@"%@",DataDict[@"actionsummary"]];

}

-(NSMutableDictionary*)SensorInformationArrayGet{
    NSMutableArray *savearr = [NSMutableArray arrayWithContentsOfFile:SaveArrayPath];
    NSMutableArray *EnvironmentalArr = [NSMutableArray array];
    [savearr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj[@"actionclass"] isEqualToString:@"1"]) [EnvironmentalArr addObject:obj];
    }];
    NSMutableDictionary *DataDict = [NSMutableDictionary dictionaryWithDictionary:savearr[_Row]];
    if ([DataDict[@"actionclass"] isEqualToString:@"1"]) {
        [DataDict setValue:[NSString stringWithFormat:@"%ld",_Row + 1] forKey:@"actionorder"];
    }else{
        [DataDict setValue:[NSString stringWithFormat:@"%ld",(long)_Row - EnvironmentalArr.count + 1] forKey:@"actionorder"];
    }
    [savearr replaceObjectAtIndex:_Row withObject:DataDict];
    [savearr writeToFile:SaveArrayPath atomically:NO];
    //sensor情报数组生成
    _SensorInformationArray = [NSMutableArray array];
    if ([[NSString stringWithFormat:@"%@",DataDict[@"actionexplain"]]isEqualToString:@"6"]) {
        //[_AddSensorInformationBtn setHidden:NO];
        NSDictionary *SensorInformationDict1 = @{@"displayname" : DataDict[@"displayname1"] , @"devicetypename" : DataDict[@"devicetypename1"] , @"dataexplain" : DataDict[@"dataexplain1"]};
        NSDictionary *SensorInformationDict2 = @{@"displayname" : DataDict[@"displayname2"] , @"devicetypename" : DataDict[@"devicetypename2"] , @"dataexplain" : DataDict[@"dataexplain2"]};
        [_SensorInformationArray addObject:SensorInformationDict1];
        [_SensorInformationArray addObject:SensorInformationDict2];
    } else {
        //[_AddSensorInformationBtn setHidden:YES];
        NSDictionary *SensorInformationDict = @{@"displayname" : DataDict[@"displayname1"] , @"devicetypename" : DataDict[@"devicetypename1"] , @"dataexplain" : DataDict[@"dataexplain1"]};
        [_SensorInformationArray addObject:SensorInformationDict];
    }
    [_SensorInformationTB reloadData];
    _LeftCellHeight.constant = -(self.height - self.height / _SensorInformationArray.count);
    return DataDict;
}

- (IBAction)AddSensorInformation:(id)sender {
}

- (IBAction)ColorSelect:(UIButton*)sender {
    if (!_SuperEditing) {
        NSMutableArray *savearr = [NSMutableArray arrayWithContentsOfFile:SaveArrayPath];
        NSMutableDictionary *savedict = [NSMutableDictionary dictionaryWithDictionary:savearr[_Row]];
        LGFColorSelectView *ColorSelect = [[LGFColorSelectView alloc]initWithFrame:LGFLastView.bounds Super:self Data:savedict SelectButton:sender];
        [LGFLastView addSubview:ColorSelect];
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    textField.backgroundColor = SystemColor(0.3);
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    textField.backgroundColor = [UIColor clearColor];
    NSMutableArray *savearr = [NSMutableArray arrayWithContentsOfFile:SaveArrayPath];
    NSMutableDictionary *savedict = [NSMutableDictionary dictionaryWithDictionary:savearr[_Row]];
    if (textField == _ActionName){
        [savedict setValue:textField.text forKey:@"actionname"];
    }else if(textField == _ActionClass){
        [savedict setValue:textField.text forKey:@"actionclass"];
    }else if(textField == _ActionOrder){
        [savedict setValue:textField.text forKey:@"actionorder"];
    }else if(textField == _ActionExplain){
        if (![@[@"",@"1",@"2",@"3",@"4",@"5",@"6"] containsObject:textField.text]) {
            [VisualSetAlert ShowMessage:@"活動解釈方法は１〜６の数字から、1つを選んでください。"];
            return NO;
        }else{
            if ([savedict[@"actionid"] isEqualToString:@"環境3"] && ![textField.text isEqualToString:@"4"]) {
                [VisualSetAlert ShowMessage:@"活動解釈方法４は、環境が「明るさ」の場合のみ使われます。入力項目を再チェックしてください。"];
                return NO;
            }
            [savedict setValue:textField.text forKey:@"actionexplain"];
            if ([textField.text isEqualToString:@"6"]) {
                [savedict setValue:savedict[@"displayname1"] forKey:@"displayname2"];
                [savedict setValue:savedict[@"displaycd1"] forKey:@"displaycd2"];
                [savedict setValue:@"明るさ" forKey:@"devicetypename2"];
                [savedict setValue:@"3" forKey:@"devicetype2"];
                [savedict setValue:@"3" forKey:@"dataexplain2"];
            }else{
                [savedict setValue:@"" forKey:@"displayname2"];
                [savedict setValue:@"" forKey:@"displaycd2"];
                [savedict setValue:@"" forKey:@"devicetypename2"];
                [savedict setValue:@"" forKey:@"devicetype2"];
                [savedict setValue:@"" forKey:@"dataexplain2"];
            }
        }
    }else if(textField == _ActionSummary){
        if (![@[@"0",@"1",@"2"] containsObject:textField.text]) {
            [VisualSetAlert ShowMessage:@"活動集計方法は０〜２の数字から、1つを選んでください。"];
            return NO;
        }else{
            if ([savedict[@"actionclass"] isEqualToString:@"2"] && ![textField.text isEqualToString:@"1"]) {
                [VisualSetAlert ShowMessage:@"活動の場合は、活動集計方法１のみ使われます。入力項目を再チェックしてください。"];
                return NO;
            }
            if ([savedict[@"actionclass"] isEqualToString:@"1"]) {
                if ([savedict[@"actionid"] isEqualToString:@"環境3"]) {
                    if (![textField.text isEqualToString:@"0"]) {
                        [VisualSetAlert ShowMessage:@"活動集計方法０は、環境が「明るさ」の場合のみ使われます。入力項目を再チェックしてください。"];
                        return NO;
                    }
                }else{
                    if (![textField.text isEqualToString:@"2"]) {
                        [VisualSetAlert ShowMessage:@"環境の場合は、活動集計方法２のみ使われます。入力項目を再チェックしてください。"];
                        return NO;
                    }
                }
            }
        }
        [savedict setValue:textField.text forKey:@"actionsummary"];
    }
    if (![savedict[@"oflag"] isEqualToString:@"C"]) {
        [savedict setValue:@"U" forKey:@"oflag"];
    }
    [savearr replaceObjectAtIndex:_Row withObject:savedict];
    if ([savearr writeToFile:SaveArrayPath atomically:NO]) {
        [self.VisualSetOneDelegate VisualSetTableReload:savearr Row:_Row];
    }
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString*)string{
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
    NSString*filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    BOOL basicTest = [string isEqualToString:filtered];
    if(!basicTest) {
        if (textField == _ActionClass || textField == _ActionOrder || textField == _ActionExplain || textField == _ActionSummary) {
            [VisualSetAlert ShowMessage:@"数字のみ入力可能です。入力項目を再チェックしてください。"];
            return NO;
        }
    }else{
        NSMutableArray *savearr = [NSMutableArray arrayWithContentsOfFile:SaveArrayPath];
        NSMutableDictionary *savedict = [NSMutableDictionary dictionaryWithDictionary:savearr[_Row]];
        if (textField == _ActionExplain && ![string isEqualToString:@"6"] && [savedict[@"actionexplain"] isEqualToString:@"6"] && ![string isEqualToString:@""]) {
            UIAlertController *TextFieldAlert = [UIAlertController alertControllerWithTitle:@"アラート" message:@"活動解釈方法を変えますと、センサー情報２が削除されます、変更しますか？" preferredStyle:UIAlertControllerStyleAlert];
            [TextFieldAlert addAction:[UIAlertAction actionWithTitle:@"いいえ" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {}]];
            [TextFieldAlert addAction:[UIAlertAction actionWithTitle:@"はい" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {textField.text = string;}]];
            [LGFKeyWindow.rootViewController presentViewController:TextFieldAlert animated:YES completion:nil];
            return NO;
        }
    }
    return YES;
}

-(void)SelectColor:(NSDictionary *)ColorDict{

    if ([[NSString stringWithFormat:@"%@",ColorDict[@"actionexplain"]] isEqualToString:@"4"]) {
        NSArray *colorarray = [ColorDict[@"actioncolor"] componentsSeparatedByString:@"|"];
        _ColorView.backgroundColor = [UIColor colorWithHex:colorarray[0]];
        _ColorViewTwo.backgroundColor = [UIColor colorWithHex:colorarray[1]];
    } else {
        _ColorView.backgroundColor = [UIColor colorWithHex:ColorDict[@"actioncolor"]];
        _ColorViewTwo.backgroundColor = [UIColor colorWithHex:ColorDict[@"actioncolor"]];
    }

    NSMutableArray *savearr = [NSMutableArray arrayWithContentsOfFile:SaveArrayPath];
    NSMutableDictionary *savedict = [NSMutableDictionary dictionaryWithDictionary:savearr[_Row]];
    [savedict setValue:ColorDict[@"actioncolor"] forKey:@"actioncolor"];
    if (![savedict[@"oflag"] isEqualToString:@"C"]) {
        [savedict setValue:@"U" forKey:@"oflag"];
    }
    [savearr replaceObjectAtIndex:_Row withObject:savedict];
    [savearr writeToFile:SaveArrayPath atomically:NO];
}

-(void)SensorInformationTableReload{
    MAIN([self SensorInformationArrayGet];);
}

#pragma mark - Table view DataSource and Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _SensorInformationArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return _SensorInformationTB.height / _SensorInformationArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *DataDict = self.SensorInformationArray[indexPath.row];
    SensorInformationTBCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SensorInformationTBCell" forIndexPath:indexPath];
    cell.SuperRow = _Row;
    cell.Row = indexPath.row;
    cell.DataDict = DataDict;
    cell.SuperEditing = _SuperEditing;
    cell.autoresizingMask =  UIViewAutoresizingFlexibleWidth;
    return cell;
}

@end

@interface VisualSettingVC ()<LGFDropDownDelegate>
{
    NSInteger UserListCollectionSelectItem;
    int SystemUserType;
}
@property (weak, nonatomic) IBOutlet LGFDropDown *PlaceDropDown;
@property (weak, nonatomic) IBOutlet UICollectionView *UserListCollection;
@property (weak, nonatomic) IBOutlet UIButton *EditButton;
@property (weak, nonatomic) IBOutlet LGFTableViewAvoidKeyboard *VisualSetActivityTable;
@property (strong, nonatomic) IBOutlet UIView *VisualSetTableHeader;
@property (strong, nonatomic) IBOutlet UIView *VisualSetTableFooter;
@property (weak, nonatomic) IBOutlet UIButton *AddVisualSet;
@property (nonatomic, strong) NSArray *UserListArray;
@end

@implementation VisualSettingVC

static NSString * const reuseIdentifiercv = @"UserListCollectionCell";
static NSString * const reuseIdentifiertbvone = @"VisualSetTableOneCell";

-(NSArray *)UserListArray{
    if (!_UserListArray) {
        _UserListArray = [NSArray array];
    }
    return _UserListArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSMutableArray *savearr = [NSMutableArray array];
    [savearr writeToFile:SaveArrayPath atomically:NO];
    NSMutableDictionary *SystemUserDict = [NSMutableDictionary dictionaryWithContentsOfFile:SYSTEM_USER_DICT];
    SystemUserType = [SystemUserDict[@"systemusertype"] intValue];
    [_AddVisualSet setHidden:YES];
    if (SystemUserType != 1) {
        [_EditButton setEnabled:NO];
        [_EditButton setTitle:@"" forState:UIControlStateNormal];
    }
    [self LoadPlaceData];
}
/**
 取得楼层数据
 */
- (void)LoadPlaceData{
    [MBProgressHUD showMessage:@"後ほど..." toView:self.view];
    NSMutableDictionary *SystemUserDict = [NSMutableDictionary dictionaryWithContentsOfFile:SYSTEM_USER_DICT];
    NSString *staffid = SystemUserDict[@"staffid"];
    NSString *hostcd = SystemUserDict[@"hostcd"];
    [[SealAFNetworking NIT] PostWithUrl:ZwgetbuildinginfoType parameters:NSDictionaryOfVariableBindings(staffid,hostcd) mjheader:nil superview:self.view success:^(id success){
        NSDictionary *tmpDic = [LGFNullCheck CheckNSNullObject:success];
        if ([tmpDic[@"code"] isEqualToString:@"200"]) {
            _PlaceDropDown.delegate = self;
            _PlaceDropDown.DefaultTitle = tmpDic[@"buildingInfo"][0][@"facilityname2"];
            _PlaceDropDown.DataArray = tmpDic[@"buildingInfo"];
            [_PlaceDropDown selectRow:[SystemUserDict[@"visualsetvcrow"] integerValue] childrow:[SystemUserDict[@"visualsetvcchildrow"] integerValue]];
        } else {
            NSLog(@"errors: %@",tmpDic[@"errors"]);
        }
    }defeats:^(NSError *defeats){
    }];
}
/**
 取得user数据
 */
- (void)LoadVzConfigData{
    [MBProgressHUD showMessage:@"後ほど..." toView:self.view];
    NSMutableDictionary *SystemUserDict = [NSMutableDictionary dictionaryWithContentsOfFile:SYSTEM_USER_DICT];
    NSString *facilitycd = SystemUserDict[@"visualsetvcfacilitycd"];
    NSString *staffid = SystemUserDict[@"staffid"];
    NSString *floorno = SystemUserDict[@"visualsetvcfloorno"];
    if (facilitycd && staffid && floorno) {
        [[SealAFNetworking NIT] PostWithUrl:ZwgetvzconfiginfoType parameters:NSDictionaryOfVariableBindings(facilitycd,staffid,floorno) mjheader:nil superview:self.view success:^(id success){
            NSDictionary *tmpDic = [LGFNullCheck CheckNSNullObject:success];
            if ([tmpDic[@"code"] isEqualToString:@"200"]) {
                self.UserListArray = tmpDic[@"vzconfiginfo"];
                if ([[NoDataLabel alloc] Show:@"データがない" SuperView:self.view DataBool:self.UserListArray.count]) {
                    NSDictionary *dict = self.UserListArray[UserListCollectionSelectItem];
                    NSMutableDictionary *SystemUserDict = [NSMutableDictionary dictionaryWithContentsOfFile:SYSTEM_USER_DICT];
                    [SystemUserDict setValue:tmpDic[@"displaylist"] forKey:@"displaylist"];
                    [SystemUserDict setValue:tmpDic[@"devicetypelist"] forKey:@"devicetypelist"];
                    [SystemUserDict setValue:dict[@"userid0"] forKey:@"userid0"];
                    [SystemUserDict setValue:dict[@"roomid"] forKey:@"roomid"];
                    [SystemUserDict writeToFile:SYSTEM_USER_DICT atomically:NO];
                    NSMutableArray *savearr = dict[@"actioninfo"];
                    [savearr writeToFile:SaveArrayPath atomically:NO];
                }
                [self VisualSetTableNotEdit:NO];
                [_UserListCollection reloadData];
                [_UserListCollection selectItemAtIndexPath:[NSIndexPath indexPathForItem:UserListCollectionSelectItem inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
            } else {
                NSLog(@"errors: %@",tmpDic[@"errors"]);
                [MBProgressHUD showError:@"system errors" toView:self.view];
//                [[NoDataLabel alloc] Show:@"system errors" SuperView:self.view DataBool:0];
            }
        }defeats:^(NSError *defeats){
        }];
    }
}
-(void)ClickEditUpdateNotice{
    NSMutableDictionary *SystemUserDict = [NSMutableDictionary dictionaryWithContentsOfFile:SYSTEM_USER_DICT];
    NSString *userid0 = SystemUserDict[@"userid0"];
    [[SealAFNetworking NIT] PostWithUrl:ZwupdatenoticeType parameters:NSDictionaryOfVariableBindings(userid0) mjheader:nil superview:self.view success:^(id success){
        NSDictionary *tmpDic = [LGFNullCheck CheckNSNullObject:success];
        if ([tmpDic[@"code"] isEqualToString:@"200"]) {
        } else {
            NSLog(@"errors: %@",tmpDic[@"errors"]);
            [MBProgressHUD showError:@"system errors" toView:self.view];
        }
    }defeats:^(NSError *defeats){
    }];
}
/**
 编辑可视化设定
 */
- (IBAction)EditVisualSetTable:(UIButton*)sender {
    if (self.UserListArray.count>0) {
        [_VisualSetActivityTable setEditing:!_VisualSetActivityTable.editing animated:YES];
        [self VisualSetTableNotEdit:_VisualSetActivityTable.editing];
    }
}
-(void)VisualSetTableNotEdit:(BOOL)editing{
    if (SystemUserType == 1) {
        [_VisualSetActivityTable setEditing:editing];
        [_AddVisualSet setHidden:!editing];
        [_EditButton setTitle:editing ? @"完了" : @"編集" forState:UIControlStateNormal];
        if (editing) {
            NSMutableDictionary *SystemUserDict = [NSMutableDictionary dictionaryWithContentsOfFile:SYSTEM_USER_DICT];
            if ([SystemUserDict[@"historyinfocount"] integerValue] > 0) {
                [self ClickEditUpdateNotice];
            }
        }
    }
    NSMutableArray *savearr = [NSMutableArray arrayWithContentsOfFile:SaveArrayPath];
    [CATransaction setCompletionBlock: ^{
        [self VisualSetTableReload:savearr Row:editing ? savearr.count - 1 : 0];
    }];
}
/** 
 添加可视化设定
 */
- (IBAction)AddVisualSetTable:(UIButton *)sender {
    
    if (SystemUserType == 1) {
    
        NSMutableArray *savearr = [NSMutableArray arrayWithContentsOfFile:SaveArrayPath];
        NSMutableDictionary *DataDict = [NSMutableDictionary dictionary];
        
        UIAlertController *AddVisualSet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        [AddVisualSet addAction:[UIAlertAction actionWithTitle:@"環境(温度)" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [DataDict setValue:@"1" forKey:@"actionclass"];
            [DataDict setValue:@"#000000" forKey:@"actioncolor"];
            [DataDict setValue:@"5" forKey:@"actionexplain"];
            [DataDict setValue:@"環境1" forKey:@"actionid"];
            [DataDict setValue:@"2" forKey:@"actionsummary"];
            [DataDict setValue:@"3" forKey:@"dataexplain1"];
            [self OldValueSet:DataDict SaveArr:savearr];
        }]];
        [AddVisualSet addAction:[UIAlertAction actionWithTitle:@"環境(湿度)" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [DataDict setValue:@"1" forKey:@"actionclass"];
            [DataDict setValue:@"#000000" forKey:@"actioncolor"];
            [DataDict setValue:@"5" forKey:@"actionexplain"];
            [DataDict setValue:@"環境2" forKey:@"actionid"];
            [DataDict setValue:@"2" forKey:@"actionsummary"];
            [DataDict setValue:@"3" forKey:@"dataexplain1"];
            [self OldValueSet:DataDict SaveArr:savearr];
        }]];
        [AddVisualSet addAction:[UIAlertAction actionWithTitle:@"環境(明るさ)" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [DataDict setValue:@"1" forKey:@"actionclass"];
            [DataDict setValue:@"#FFFF00|#0000FF" forKey:@"actioncolor"];
            [DataDict setValue:@"4" forKey:@"actionexplain"];
            [DataDict setValue:@"環境3" forKey:@"actionid"];
            [DataDict setValue:@"0" forKey:@"actionsummary"];
            [DataDict setValue:@"3" forKey:@"dataexplain1"];
            [self OldValueSet:DataDict SaveArr:savearr];
        }]];
        [AddVisualSet addAction:[UIAlertAction actionWithTitle:@"活動(ユーザ指定)" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [DataDict setValue:@"2" forKey:@"actionclass"];
            [DataDict setValue:@"#000000" forKey:@"actioncolor"];
            [DataDict setValue:@"" forKey:@"actionexplain"];
            [DataDict setValue:@"活動2" forKey:@"actionid"];
            [DataDict setValue:@"1" forKey:@"actionsummary"];
            [DataDict setValue:@"" forKey:@"dataexplain1"];
            [self OldValueSet:DataDict SaveArr:savearr];
        }]];
        [AddVisualSet addAction:[UIAlertAction actionWithTitle:@"キャンセル" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *_Nonnull action) {
        }]];
        [self presentViewController:AddVisualSet animated:YES completion:nil];
    
    } else {
        [MBProgressHUD showError:@"権限がない" toView:self.view];
    }
}
-(void)OldValueSet:(NSMutableDictionary*)DataDict SaveArr:(NSMutableArray*)SaveArr{
    [DataDict setValue:@"" forKey:@"actionorder"];
    [DataDict setValue:@"C" forKey:@"oflag"];
    [DataDict setValue:@"" forKey:@"actionname"];
    [DataDict setValue:@"3" forKey:@"dataexplain2"];
    [DataDict setValue:@"" forKey:@"devicetypename1"];
    [DataDict setValue:@"" forKey:@"devicetype1"];
    [DataDict setValue:@"明るさ" forKey:@"devicetypename2"];
    [DataDict setValue:@"3" forKey:@"devicetype2"];
    [DataDict setValue:@"" forKey:@"displayname1"];
    [DataDict setValue:@"" forKey:@"displaycd1"];
    [DataDict setValue:@"" forKey:@"displayname2"];
    [DataDict setValue:@"" forKey:@"displaycd2"];
    NSInteger NewRow;
    if ([DataDict[@"actionclass"] isEqualToString:@"1"]) {
        NSMutableArray *EnvironmentalArr = [NSMutableArray array];
        [SaveArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if ([obj[@"actionclass"] isEqualToString:@"1"]) [EnvironmentalArr addObject:obj];
        }];
        [SaveArr insertObject:DataDict atIndex:EnvironmentalArr.count];
        NewRow = EnvironmentalArr.count;
    }else{
        [SaveArr addObject:DataDict];
        NewRow = SaveArr.count-1;
    }
    if ([SaveArr writeToFile:SaveArrayPath atomically:NO]) {
        [self VisualSetTableReload:SaveArr Row:NewRow];
    }
}
/**
 保存更新可视化设定
 */
- (IBAction)SaveData:(id)sender {
    [self SaveVisualSetData];
}
/**
 数据更新
 */
-(void)SaveVisualSetData{
    NSMutableDictionary *SystemUserDict = [NSMutableDictionary dictionaryWithContentsOfFile:SYSTEM_USER_DICT];
    NSMutableArray *savearr = [NSMutableArray arrayWithContentsOfFile:SaveArrayPath];
    if (savearr.count > 0) {
        if ([self CheckArrayEmpty:savearr]) {
            [MBProgressHUD showMessage:@"後ほど..." toView:self.view];
            NSIndexPath *indexpath = _UserListCollection.indexPathsForSelectedItems.lastObject;
            NSDictionary *DataDict = self.UserListArray[indexpath.item];
            NSDictionary *parameter = @{@"userid1":SystemUserDict[@"staffid"],@"userid0":DataDict[@"userid0"],@"actioninfo":[self ArrayToJson:savearr]};
            [[SealAFNetworking NIT] PostWithUrl:ZwgetupdatevzconfiginfoType parameters:parameter mjheader:nil superview:self.view success:^(id success){
                NSDictionary *tmpDic = [LGFNullCheck CheckNSNullObject:success];
                if ([tmpDic[@"code"] isEqualToString:@"200"]) {
                    [CATransaction setCompletionBlock:^{
                        [MBProgressHUD showSuccess:@"保存しました" toView:self.view];
                    }];
                    [self LoadVzConfigData];
                } else {
                    NSLog(@"%@ errors: %@",tmpDic[@"code"],tmpDic[@"errors"]);
                    [CATransaction setCompletionBlock:^{
                        [MBProgressHUD showError:@"保存が失敗しました、設定情報を再チェックしてください。" toView:self.view];
                    }];
                }
            }defeats:^(NSError *defeats){
                NSLog(@"errors");
            }];
        }else{
            [VisualSetAlert ShowMessage:@"入力項目に漏れはないか、再チェックしてください。"];
        }
    }
}

/**
 判断数组内是否存在空值
 */
-(BOOL)CheckArrayEmpty:(id)nullarray{
    NSMutableArray *arr = [NSMutableArray arrayWithArray:nullarray];
    __block BOOL booltype = YES;
    [arr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj[@"actionexplain"] isEqualToString:@"6"]) {
            [obj enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                if ([key isEqualToString:@"actionexplain"] || [key isEqualToString:@"actionname"] || [key isEqualToString:@"displayname1"] || [key isEqualToString:@"displaycd1"] || [key isEqualToString:@"devicetypename1"] || [key isEqualToString:@"devicetype1"] || [key isEqualToString:@"devicetypename2"] || [key isEqualToString:@"devicetype2"] || [key isEqualToString:@"displayname2"] || [key isEqualToString:@"displaycd2"]) {
                    if ([obj isEqualToString:@""])  booltype = NO;
                }
            }];
        }else{
            [obj enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                if ([key isEqualToString:@"actionexplain"] || [key isEqualToString:@"actionname"] || [key isEqualToString:@"displayname1"] || [key isEqualToString:@"displaycd1"] || [key isEqualToString:@"devicetypename1"] || [key isEqualToString:@"devicetype1"]) {
                    if ([obj isEqualToString:@""])  booltype = NO;
                }
            }];
        }
    }];
    return booltype;
}
/**
 *  数组转json
 */
-(NSString*)ArrayToJson:(NSMutableArray*)array{
    NSMutableArray *scenariodtlinfo = [NSMutableArray arrayWithArray:array];
    NSData * jsondata = [NSJSONSerialization dataWithJSONObject:scenariodtlinfo options:NSJSONWritingPrettyPrinted error:nil];
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
    UserListCollectionSelectItem = 0;
    [self LoadVzConfigData];
}

/**
 数据刷新
 */
-(void)VisualSetTableReload:(NSMutableArray *)SaveArr Row:(NSInteger)Row{
    MAIN([_VisualSetActivityTable reloadData];MAIN(if (SaveArr.count > 0) {[_VisualSetActivityTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:Row inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];}););
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
    selectedBGView.backgroundColor = SystemColor(0.3);
    cell.selectedBackgroundView = selectedBGView;
    cell.UserAge.text = [NSString stringWithFormat:@"%@",DataDict[@"userold"]];
    cell.RoomName.text = DataDict[@"roomid"];
    cell.UserName.text = DataDict[@"username0"];
    cell.UserSex.text = DataDict[@"usersex"];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    UserListCollectionSelectItem = indexPath.item;
    NSDictionary *dict = self.UserListArray[indexPath.item];
    NSMutableDictionary *SystemUserDict = [NSMutableDictionary dictionaryWithContentsOfFile:SYSTEM_USER_DICT];
    [SystemUserDict setValue:dict[@"userid0"] forKey:@"userid0"];
    [SystemUserDict setValue:dict[@"roomid"] forKey:@"roomid"];
    [SystemUserDict writeToFile:SYSTEM_USER_DICT atomically:NO];
    NSMutableArray *savearr = dict[@"actioninfo"];
    if ([savearr writeToFile:SaveArrayPath atomically:NO]) {
        [self VisualSetTableReload:savearr Row:0];
    }
}

#pragma mark - Table view DataSource and Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSMutableArray *savearr = [NSMutableArray arrayWithContentsOfFile:SaveArrayPath];
    return savearr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableArray *savearr = [NSMutableArray arrayWithContentsOfFile:SaveArrayPath];
    NSMutableDictionary *DataDict = [NSMutableDictionary dictionaryWithDictionary:savearr[indexPath.row]];
    if ([DataDict[@"actionexplain"]isEqualToString:@"6"]) {
        return self.view.height / 6;
    } else {
        return self.view.height / 12;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"削除";
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    if (sourceIndexPath == destinationIndexPath) return;
    NSMutableArray *savearr = [NSMutableArray arrayWithContentsOfFile:SaveArrayPath];
    id object = [savearr objectAtIndex:sourceIndexPath.row];
    [savearr removeObjectAtIndex:sourceIndexPath.row];
    [savearr insertObject:object atIndex:destinationIndexPath.row];
    NSMutableDictionary *savedictone = [NSMutableDictionary dictionaryWithDictionary:savearr[sourceIndexPath.row]];
    NSMutableDictionary *savedicttwo = [NSMutableDictionary dictionaryWithDictionary:savearr[destinationIndexPath.row]];
    if (![savedictone[@"oflag"] isEqualToString:@"C"]) {
        [savedictone setValue:@"U" forKey:@"oflag"];
    }
    [savearr replaceObjectAtIndex:sourceIndexPath.row withObject:savedictone];
    if (![savedicttwo[@"oflag"] isEqualToString:@"C"]) {
        [savedicttwo setValue:@"U" forKey:@"oflag"];
    }
    [savearr replaceObjectAtIndex:destinationIndexPath.row withObject:savedicttwo];
    if ([savearr writeToFile:SaveArrayPath atomically:NO]) {
        [self VisualSetTableReload:savearr Row:destinationIndexPath.row];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return self.view.height * 0.05;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return _VisualSetTableHeader;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return _VisualSetActivityTable.height * 0.15;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return _VisualSetTableFooter;
}

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath{
    NSMutableArray *savearr = [NSMutableArray arrayWithContentsOfFile:SaveArrayPath];
    NSMutableArray *EnvironmentalArr = [NSMutableArray array];
    [savearr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj[@"actionclass"] isEqualToString:@"1"]) [EnvironmentalArr addObject:obj];
    }];
    if (proposedDestinationIndexPath.row < EnvironmentalArr.count) {
        return [NSIndexPath indexPathForRow:EnvironmentalArr.count inSection:0];
    }
    return proposedDestinationIndexPath;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableArray *savearr = [NSMutableArray arrayWithContentsOfFile:SaveArrayPath];
    NSMutableDictionary *DataDict = [NSMutableDictionary dictionaryWithDictionary:savearr[indexPath.row]];
    if ([DataDict[@"actionclass"] isEqualToString:@"1"]) {
        return NO;
    }
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        UIAlertController *TextFieldAlert = [UIAlertController alertControllerWithTitle:@"" message:@"設定情報を削除します、よろしいですか。" preferredStyle:UIAlertControllerStyleAlert];
        [TextFieldAlert addAction:[UIAlertAction actionWithTitle:@"いいえ" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {}]];
        [TextFieldAlert addAction:[UIAlertAction actionWithTitle:@"はい" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            NSMutableArray *savearr = [NSMutableArray arrayWithContentsOfFile:SaveArrayPath];
            NSMutableDictionary *savedict = [NSMutableDictionary dictionaryWithDictionary:savearr[indexPath.row]];
            [savedict setValue:@"D" forKey:@"oflag"];
            [savearr replaceObjectAtIndex:indexPath.row withObject:savedict];
            if ([savearr writeToFile:SaveArrayPath atomically:NO]) {
                [self SaveVisualSetData];
            }
        }]];
        [LGFKeyWindow.rootViewController presentViewController:TextFieldAlert animated:YES completion:nil];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    VisualSetOneTableCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifiertbvone forIndexPath:indexPath];
    cell.Row = indexPath.row;
    cell.SuperEditing = tableView.editing;
    cell.autoresizingMask =  UIViewAutoresizingFlexibleWidth;
    return cell;
}

@end
