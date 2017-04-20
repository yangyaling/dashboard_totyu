//
//  ColorSelectionCV.m
//  DashBoard
//
//  Created by totyu3 on 17/2/10.
//  Copyright © 2017年 NIT. All rights reserved.
//

#import "ColorSelectionCV.h"
#import "LGFColorSelectView.h"

@interface ColorSelectionCVCell : UICollectionViewCell<LGFColorSelectViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *ColorView;
@property (weak, nonatomic) IBOutlet UIButton *Device;
@property (nonatomic, strong) NSDictionary *DataDict;
@property (nonatomic, assign) NSInteger Row;
@end
@implementation ColorSelectionCVCell

-(void)setDataDict:(NSDictionary *)DataDict{
    _DataDict = DataDict;
    CGFloat devicefontsize;
    if(NITScreenW == 1024){
        devicefontsize = 15;
    }else if(NITScreenW == 1366){
        devicefontsize = 15;
    }else if(NITScreenW == 736){
        devicefontsize = 10;
    }else{
        devicefontsize = 8;
    }
    
    [_Device setTitle:[NSString stringWithFormat:@" %@",DataDict[@"actionname"]] forState:UIControlStateNormal];
    if ([DataDict[@"actionselect"] isEqualToString:@"YES"]) {
        [_Device setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_Device setBackgroundColor:SystemColor(1.0)];
    } else {
        [_Device setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_Device setBackgroundColor:NITColor(250.0, 250.0, 250.0)];
    }
    
    _ColorView.backgroundColor = [UIColor colorWithHex:DataDict[@"actioncolor"]];
}

-(void)SelectColor:(NSDictionary *)ColorDict{
    NSMutableDictionary *SystemUserDict = [NSMutableDictionary dictionaryWithContentsOfFile:SYSTEM_USER_DICT];
    NSMutableArray *systemactioninfo = [NSMutableArray arrayWithArray:SystemUserDict[@"systemactioninfo"]];
    NSMutableDictionary *dicBt = [NSMutableDictionary dictionaryWithDictionary:systemactioninfo[_Row]];
    [dicBt setObject:ColorDict[@"actioncolor"] forKey:@"actioncolor"];
    [systemactioninfo replaceObjectAtIndex:_Row withObject:dicBt];
    [SystemUserDict setObject:systemactioninfo forKey:@"systemactioninfo"];
    if ([SystemUserDict writeToFile:SYSTEM_USER_DICT atomically:NO]) {
        [[SealAFNetworking NIT] PostWithUrl:ZwupdateactioncolorType parameters:ColorDict mjheader:nil superview:nil success:^(id success){
            NSDictionary *tmpDic = [LGFNullCheck CheckNSNullObject:success];
            self.ColorView.backgroundColor = [UIColor colorWithHex:ColorDict[@"actioncolor"]];
            [NITNotificationCenter postNotification:[NSNotification notificationWithName:@"SystemReloadColor" object:nil userInfo:nil]];
            if ([tmpDic[@"code"] isEqualToString:@"501"]) {
                NSLog(@"errors: %@",tmpDic[@"errors"]);
            }
        }defeats:^(NSError *defeats){
        }];
    }
}

- (IBAction)ColorSelectButton:(id)sender {
    LGFColorSelectView *ColorSelect = [[LGFColorSelectView alloc]initWithFrame:LGFLastView.bounds Super:self Data:_DataDict];
    [LGFLastView addSubview:ColorSelect];
}

- (IBAction)DeviceSelectButton:(UIButton*)sender {
    NSMutableDictionary *SystemUserDict = [NSMutableDictionary dictionaryWithContentsOfFile:SYSTEM_USER_DICT];
    NSMutableArray *systemactioninfo = [NSMutableArray arrayWithArray:SystemUserDict[@"systemactioninfo"]];
    NSMutableDictionary *actionselectdict = [NSMutableDictionary dictionaryWithDictionary:systemactioninfo[_Row]];
    if ([actionselectdict[@"actionselect"] boolValue]) {
        [actionselectdict setValue:@"NO" forKey:@"actionselect"];
    } else {
        [actionselectdict setValue:@"YES" forKey:@"actionselect"];
    }
    [systemactioninfo replaceObjectAtIndex:_Row withObject:actionselectdict];
    [systemactioninfo enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (idx != _Row) {
            [obj setValue:@"NO" forKey:@"actionselect"];
            [systemactioninfo replaceObjectAtIndex:idx withObject:obj];
        }
    }];
    [systemactioninfo enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (idx == _Row) {
            [obj setValue:@"NO" forKey:@"selecttype"];
        } else {
            [obj setValue:actionselectdict[@"actionselect"] forKey:@"selecttype"];
        }
        [systemactioninfo replaceObjectAtIndex:idx withObject:obj];
    }];
    [SystemUserDict setObject:systemactioninfo forKey:@"systemactioninfo"];
    if ([SystemUserDict writeToFile:SYSTEM_USER_DICT atomically:NO]) {
        [NITNotificationCenter postNotification:[NSNotification notificationWithName:@"SystemReloadColor" object:nil userInfo:nil]];
    }
}

@end

@interface ColorSelectionCV ()
@property (weak, nonatomic) IBOutlet UICollectionView *ColorSelection;
@end
@implementation ColorSelectionCV

-(NSMutableArray *)ColorSelectionArray{
    if (!_ColorSelectionArray) {
        _ColorSelectionArray = [NSMutableArray array];
    }
    return _ColorSelectionArray;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    NSMutableDictionary *SystemUserDict = [NSMutableDictionary dictionaryWithContentsOfFile:SYSTEM_USER_DICT];
    NSMutableArray *systemactioninfo = [NSMutableArray arrayWithArray:SystemUserDict[@"systemactioninfo"]];
    if (systemactioninfo.count == 0) {
        [self LoadNewData];
    }
    [NITNotificationCenter addObserver:self selector:@selector(ReloadColor:) name:@"SystemReloadColor" object:nil];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [_ColorSelection reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)ReloadColor:(id)sender{
    [_ColorSelection reloadData];
}

- (void)LoadNewData{
    [MBProgressHUD showMessage:@"" toView:_ColorSelection];
    NSMutableDictionary *SystemUserDict = [NSMutableDictionary dictionaryWithContentsOfFile:SYSTEM_USER_DICT];
    NSString *buildingid = SystemUserDict[@"buildingid"];
    NSString *floorno = SystemUserDict[@"floorno"];
    [[SealAFNetworking NIT] PostWithUrl:ZwgetvzconfiginfoType parameters:NSDictionaryOfVariableBindings(buildingid,floorno) mjheader:nil superview:_ColorSelection success:^(id success){
        NSDictionary *tmpDic = [LGFNullCheck CheckNSNullObject:success];
        if ([tmpDic[@"code"] isEqualToString:@"200"]) {
            NSArray *UserListArray = [NSArray arrayWithArray:tmpDic[@"vzconfiginfo"]];
            if ([[NoDataLabel alloc] Show:@"データがない" SuperView:_ColorSelection DataBool:UserListArray.count])return;
            NSMutableDictionary *SystemUserDict = [NSMutableDictionary dictionaryWithContentsOfFile:SYSTEM_USER_DICT];
            for (NSDictionary *dict in UserListArray) {
                if ([dict[@"userid0"] isEqualToString:SystemUserDict[@"userid0"]] && [dict[@"roomid"] isEqualToString:SystemUserDict[@"roomid"]]) {
                    NSArray *actioninfoarray = [NSArray arrayWithArray:dict[@"actioninfo"]];
                    [actioninfoarray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        if (![obj[@"actionclass"]isEqualToString:@"1"]) {
                            [self.ColorSelectionArray addObject:obj];
                        } else {
                            if ([[NSString stringWithFormat:@"%@",obj[@"actionexplain"]] isEqualToString:@"4"]) {
                                NSArray *colorarray = [obj[@"actioncolor"] componentsSeparatedByString:@"|"];
                                [SystemUserDict setValue:colorarray[0]forKey:@"lightcolor"];
                                [SystemUserDict setValue:colorarray[1] forKey:@"darkcolor"];
                            }
                        }
                    }];
                    //selecttype: 选中了哪个device  actionselect:选中了哪个cell
                    [self.ColorSelectionArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        [obj setValue:@"NO" forKey:@"selecttype"];
                        [obj setValue:@"NO" forKey:@"actionselect"];
                        [self.ColorSelectionArray replaceObjectAtIndex:idx withObject:obj];
                    }];
                    [SystemUserDict setObject:self.ColorSelectionArray forKey:@"systemactioninfo"];
                }
            }
            if ([SystemUserDict writeToFile:SYSTEM_USER_DICT atomically:NO]) {
                [_ColorSelection reloadData];
            }
        } else {
            NSLog(@"errors: %@",tmpDic[@"errors"]);
            [[NoDataLabel alloc] Show:@"system errors" SuperView:_ColorSelection DataBool:0];
        }
    }defeats:^(NSError *defeats){
        NSLog(@"errors:%@",[defeats localizedDescription]);
        [[TimeOutReloadButton alloc]Show:self SuperView:_ColorSelection];
    }];
}

#pragma mark - UICollectionViewDataSource And Delegate

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSMutableDictionary *SystemUserDict = [NSMutableDictionary dictionaryWithContentsOfFile:SYSTEM_USER_DICT];
    NSMutableArray *systemactioninfo = [NSMutableArray arrayWithArray:SystemUserDict[@"systemactioninfo"]];
    return systemactioninfo.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(_ColorSelection.width,_ColorSelection.height / 5 + (_ColorSelection.height / 5 * 0.1));
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ColorSelectionCVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ColorSelectionCell" forIndexPath:indexPath];
    NSMutableDictionary *SystemUserDict = [NSMutableDictionary dictionaryWithContentsOfFile:SYSTEM_USER_DICT];
    NSMutableArray *systemactioninfo = [NSMutableArray arrayWithArray:SystemUserDict[@"systemactioninfo"]];
    cell.DataDict = systemactioninfo[indexPath.item];
    cell.Row = indexPath.item;
    return cell;
}

- (void)dealloc{
    [NITNotificationCenter removeObserver:self];
}

@end
