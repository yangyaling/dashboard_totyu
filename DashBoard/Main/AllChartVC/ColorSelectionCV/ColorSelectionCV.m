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
    if ([DataDict[@"actionselect"] isEqualToString:@"YES"]) {
        [self.Device setTitleColor:SystemColor(1.0) forState:UIControlStateNormal];
        self.Device.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
    } else {
        [self.Device setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.Device.titleLabel.font = [UIFont systemFontOfSize:14];
    }
    [self.Device setTitle:DataDict[@"actionname"] forState:UIControlStateNormal];
    self.ColorView.backgroundColor = [UIColor colorWithHex:DataDict[@"actioncolor"]];
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
    [[LGFColorSelectView ColorSelect]ShowInView:self Data:_DataDict];
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
        if (idx!=_Row) {
            [obj setValue:@"NO" forKey:@"actionselect"];
            [systemactioninfo replaceObjectAtIndex:idx withObject:obj];
        }
    }];
    [systemactioninfo enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (idx==_Row) {
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

@interface ColorSelectionCV ()<UICollectionViewDelegate,UICollectionViewDataSource>
@end
@implementation ColorSelectionCV

-(NSMutableArray *)ColorSelectionArray{
    if (!_ColorSelectionArray) {
        _ColorSelectionArray = [NSMutableArray array];
    }
    return _ColorSelectionArray;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        NSMutableDictionary *SystemUserDict = [NSMutableDictionary dictionaryWithContentsOfFile:SYSTEM_USER_DICT];
        NSMutableArray *systemactioninfo = [NSMutableArray arrayWithArray:SystemUserDict[@"systemactioninfo"]];
        if (systemactioninfo.count == 0) {
            [self LoadVzConfigData];
        }
        [NITNotificationCenter addObserver:self selector:@selector(ReloadColor:) name:@"SystemReloadColor" object:nil];
    }
    return self;
}

-(void)ReloadColor:(id)sender{
    [UIView performWithoutAnimation:^{
        [self reloadSections:[NSIndexSet indexSetWithIndex:0]];
    }];
}

- (void)LoadVzConfigData{
    [MBProgressHUD showMessage:@"後ほど..." toView:self];
    NSMutableDictionary *SystemUserDict = [NSMutableDictionary dictionaryWithContentsOfFile:SYSTEM_USER_DICT];
    NSDictionary *parameter = @{@"buildingid":SystemUserDict[@"buildingid"],@"floorno":SystemUserDict[@"floorno"]};
    [[SealAFNetworking NIT] PostWithUrl:ZwgetvzconfiginfoType parameters:parameter mjheader:nil superview:self success:^(id success){
        NSDictionary *tmpDic = [LGFNullCheck CheckNSNullObject:success];
        if ([tmpDic[@"code"] isEqualToString:@"200"]) {
            NSArray *UserListArray = [NSArray arrayWithArray:tmpDic[@"vzconfiginfo"]];
            if ([[NoDataLabel alloc] Show:@"データがない" SuperView:self DataBool:UserListArray.count])return;
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
                    [self.ColorSelectionArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        [obj setValue:@"NO" forKey:@"selecttype"];
                        [obj setValue:@"NO" forKey:@"actionselect"];
                        [self.ColorSelectionArray replaceObjectAtIndex:idx withObject:obj];
                    }];
                    [SystemUserDict setObject:self.ColorSelectionArray forKey:@"systemactioninfo"];
                }
            }
            if ([SystemUserDict writeToFile:SYSTEM_USER_DICT atomically:NO]) {
                [UIView performWithoutAnimation:^{
                    [self reloadSections:[NSIndexSet indexSetWithIndex:0]];
                }];
            }
        } else {
            NSLog(@"errors: %@",tmpDic[@"errors"]);
            [[NoDataLabel alloc] Show:@"system errors" SuperView:self DataBool:0];
        }
    }defeats:^(NSError *defeats){
        NSLog(@"errors:%@",[defeats localizedDescription]);
    }];
}

#pragma mark - UICollectionViewDataSource And Delegate

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSMutableDictionary *SystemUserDict = [NSMutableDictionary dictionaryWithContentsOfFile:SYSTEM_USER_DICT];
    NSMutableArray *systemactioninfo = [NSMutableArray arrayWithArray:SystemUserDict[@"systemactioninfo"]];
    [[NoDataLabel alloc] Show:@"データがない" SuperView:self DataBool:systemactioninfo.count];
    return systemactioninfo.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(self.width,self.height / 5 + (self.height / 5 * 0.1));
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ColorSelectionCVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:_CSReuseIdentifier forIndexPath:indexPath];
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
