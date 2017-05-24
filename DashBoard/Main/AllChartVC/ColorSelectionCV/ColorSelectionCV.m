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

- (IBAction)ColorSelectButton:(UIButton*)sender {
    LGFColorSelectView *ColorSelect = [[LGFColorSelectView alloc]initWithFrame:LGFLastView.bounds Super:self Data:_DataDict SelectButton:sender];
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

- (void)viewDidLoad{
    [super viewDidLoad];
    [NITNotificationCenter addObserver:self selector:@selector(ReloadColor:) name:@"SystemReloadColor" object:nil];
    [NITNotificationCenter addObserver:self selector:@selector(LoadColorSelectionData:) name:_LoadCSNotificationName object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)ReloadColor:(id)sender{
    [_ColorSelection reloadData];
}

- (void)LoadColorSelectionData:(NSNotification*)sender{
    [MBProgressHUD hideHUDForView:_ColorSelection];
    [MBProgressHUD showMessage:@"" toView:_ColorSelection];
    NSDictionary *parameter;
    NSMutableDictionary *SystemUserDict = [NSMutableDictionary dictionaryWithContentsOfFile:SYSTEM_USER_DICT];
    if ([sender.userInfo[@"forweekly"] isEqualToString:@"2"]) {
        parameter = @{@"userid0" : SystemUserDict[@"userid0"] ,@"basedate" : sender.userInfo[@"basedate"] ,@"sumflg" : sender.userInfo[@"sumflg"]};
    } else {
        parameter = @{@"userid0" : SystemUserDict[@"userid0"] ,@"basedate" : sender.userInfo[@"basedate"] ,@"forweekly" : sender.userInfo[@"forweekly"]};
    }
    NSLog(@"%@",@"99999999");
    [[SealAFNetworking NIT] PostWithUrl:ZwgetcolorinfoType parameters:parameter mjheader:nil superview:_ColorSelection success:^(id success){
        NSDictionary *tmpDic = [LGFNullCheck CheckNSNullObject:success];
        if ([tmpDic[@"code"] isEqualToString:@"200"]) {
            NSArray *EnvironmentalArray = [NSArray arrayWithArray:tmpDic[@"colorlist"][0]];
            NSArray *ActivityArray = [NSArray arrayWithArray:tmpDic[@"colorlist"][1]];
            [[NoDataLabel alloc] Show:@"データがない" SuperView:_ColorSelection DataBool:ActivityArray.count];
            NSMutableDictionary *SystemUserDict = [NSMutableDictionary dictionaryWithContentsOfFile:SYSTEM_USER_DICT];
            _ColorSelectionArray = [NSMutableArray arrayWithArray:ActivityArray];
            [EnvironmentalArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                if ([obj[@"actionexplain"] isEqualToString:@"4"]) {
                    NSArray *colorarray = [obj[@"actioncolor"] componentsSeparatedByString:@"|"];
                    [SystemUserDict setValue:colorarray[0]forKey:@"lightcolor"];
                    [SystemUserDict setValue:colorarray[1] forKey:@"darkcolor"];
                }
            }];
            //selecttype: 选中了哪个device  actionselect:选中了哪个cell
            [_ColorSelectionArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                [obj setValue:@"NO" forKey:@"selecttype"];
                [obj setValue:@"NO" forKey:@"actionselect"];
                [_ColorSelectionArray replaceObjectAtIndex:idx withObject:obj];
                }];
            [SystemUserDict setObject:_ColorSelectionArray forKey:@"systemactioninfo"];
            if ([SystemUserDict writeToFile:SYSTEM_USER_DICT atomically:NO]) {
                [_ColorSelection reloadData];
                [NITNotificationCenter postNotification:[NSNotification notificationWithName:[NSString stringWithFormat:@"%@%@",_LoadCSNotificationName,@"Child"] object:nil userInfo:nil]];
            }
        } else {
            NSLog(@"errors: %@",tmpDic[@"errors"]);
            [MBProgressHUD showError:@"system errors" toView:_ColorSelection];
//            [[NoDataLabel alloc] Show:@"system errors" SuperView:_ColorSelection DataBool:0];
        }
    }defeats:^(NSError *defeats){
        NSLog(@"errors:%@",[defeats localizedDescription]);
//        [[TimeOutReloadButton alloc]Show:self SuperView:_ColorSelection];
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
