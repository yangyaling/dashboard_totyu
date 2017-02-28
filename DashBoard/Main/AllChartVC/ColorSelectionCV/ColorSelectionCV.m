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
    if ([DataDict[@"buttonStatus"] isEqualToString:@"YES"]) {
        self.Device.backgroundColor = [UIColor lightGrayColor];
    } else {
        self.Device.backgroundColor = [UIColor whiteColor];
    }
    [self.Device setTitle:DataDict[@"actionname"] forState:UIControlStateNormal];
    self.ColorView.backgroundColor = [UIColor colorWithHex:DataDict[@"actioncolor"]];
}

-(void)SelectColor:(NSDictionary *)ColorDict{
    
    NSData *dataBt = [NITUserDefaults objectForKey:@"actionList"];
    NSMutableArray *arrayBt = [NSMutableArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:dataBt]];
    
    NSMutableDictionary *dicBt = [NSMutableDictionary dictionaryWithDictionary:arrayBt[_Row]];
    [dicBt setObject:ColorDict[@"actioncolor"] forKey:@"actioncolor"];
    [arrayBt replaceObjectAtIndex:_Row withObject:dicBt];
    NSData *tmpdata = [NSKeyedArchiver archivedDataWithRootObject:arrayBt];
    [NITUserDefaults setObject:tmpdata forKey:@"actionList"];
    
    [[SealAFNetworking NIT] PostWithUrl:ZwupdateactioncolorType parameters:ColorDict mjheader:nil superview:nil success:^(id success){
        NSDictionary *tmpDic = success;
        
        self.ColorView.backgroundColor = [UIColor colorWithHex:ColorDict[@"actioncolor"]];
        
        [NITNotificationCenter removeObserver:self name:@"SystemReloadColor" object:nil];
        [NITNotificationCenter postNotification:[NSNotification notificationWithName:@"SystemReloadColor" object:nil userInfo:nil]];
        
        if ([tmpDic[@"code"] isEqualToString:@"501"]) {
            NSLog(@"errors: %@",tmpDic[@"errors"]);
        }
    }defeats:^(NSError *defeats){
    }];
}

- (IBAction)ColorSelectButton:(id)sender {
    
    [[LGFColorSelectView ColorSelect]ShowInView:self Data:_DataDict];
}
- (IBAction)DeviceSelectButton:(UIButton*)sender {
//    NSLog(@"------%ld",_Row);
//    sender.selected = !sender.selected;
    
    NSMutableDictionary *SystemUserDict = [NSMutableDictionary dictionaryWithContentsOfFile:SYSTEM_USER_DICT];
    NSData *data = [SystemUserDict objectForKey:@"systemactioninfo"];
    NSMutableDictionary *removedict = [NSMutableDictionary dictionary];
    NSMutableArray *actioninfoarr = [NSMutableArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:data]];
    
    
    //color list update
    NSData *dataBt = [NITUserDefaults objectForKey:@"actionList"];
    NSMutableArray *arrayBt = [NSMutableArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:dataBt]];
    
    NSMutableDictionary *dicBt = [NSMutableDictionary dictionaryWithDictionary:arrayBt[_Row]];
    
    NSMutableArray *selectBtArray = [NSMutableArray array];
 
    NSString *str = dicBt[@"buttonStatus"];
    
    if (!str.length) {
        
//        [sender setSelected:YES];
        
        
        for (int i = 0; i < arrayBt.count; i++) {
            NSMutableDictionary *Mdic = [NSMutableDictionary dictionaryWithDictionary:arrayBt[i]];
            if (i == _Row) {
                [Mdic setObject:@"YES" forKey:@"buttonStatus"];
            } else {
                [Mdic setObject:@"" forKey:@"buttonStatus"];
            }
            [selectBtArray addObject:Mdic];
        }
        [arrayBt removeAllObjects];
        arrayBt = selectBtArray.mutableCopy;
        
        [actioninfoarr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj[@"actionid"] isEqualToString:_DataDict[@"actionid"]]) {
                [removedict setValue:@"0" forKey:obj[@"actionid"]];
            }else{
                [removedict setValue:@"1" forKey:obj[@"actionid"]];
            }
        }];
    } else {
        [dicBt setObject:@"" forKey:@"buttonStatus"];
        [arrayBt replaceObjectAtIndex:_Row withObject:dicBt];
        NSMutableDictionary *removedict = [NSMutableDictionary dictionaryWithDictionary:SystemUserDict[@"actionremove"]];
        
        if (removedict.count > 0) {
            [removedict removeAllObjects];
        }
    }
    // 颜色列表的数据持久化
    NSData *tmpdata = [NSKeyedArchiver archivedDataWithRootObject:arrayBt];
    [NITUserDefaults setObject:tmpdata forKey:@"actionList"];
    
    //图标的数据持久化
    [SystemUserDict setObject:removedict forKey:@"actionremove"];
    [SystemUserDict writeToFile:SYSTEM_USER_DICT atomically:NO];
    
    
    [NITNotificationCenter removeObserver:self name:@"SystemReloadColor" object:nil];
    [NITNotificationCenter postNotification:[NSNotification notificationWithName:@"SystemReloadColor" object:nil userInfo:nil]];
    
}

@end

@interface ColorSelectionCV ()<UICollectionViewDelegate,UICollectionViewDataSource>

@end
@implementation ColorSelectionCV

static NSString * const reuseIdentifier = @"ColorSelectionCVCell";

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
        [self LoadPlaceData];
        [NITNotificationCenter addObserver:self selector:@selector(ReloadColor:) name:@"SystemReloadColor" object:nil];
    }
    return self;
}

-(void)ReloadColor:(id)sender{
    _ColorSelectionArray = nil;
//    [self LoadPlaceData];
    [self reloadData];
}

- (void)LoadPlaceData{
    
    [MBProgressHUD showMessage:@"" toView:self];
    [[SealAFNetworking NIT] PostWithUrl:ZwgetbuildinginfoType parameters:nil mjheader:nil superview:self success:^(id success){
        NSDictionary *tmpDic = success;
        if ([tmpDic[@"code"] isEqualToString:@"200"]) {
            
            NSArray *BuildingArray = [NSArray arrayWithArray:tmpDic[@"buildingInfo"]];
            [self LoadVzConfigData:BuildingArray[2]];
        }else{
            NSLog(@"errors: %@",tmpDic[@"errors"]);
        }
    }defeats:^(NSError *defeats){
        
    }];
}

- (void)LoadVzConfigData:(NSDictionary*)Building{
    
    [MBProgressHUD showMessage:@"" toView:self];
    NSDictionary *parameter = @{@"buildingid":Building[@"buildingid"],@"floorno":Building[@"floorno"]};
    [[SealAFNetworking NIT] PostWithUrl:ZwgetvzconfiginfoType parameters:parameter mjheader:nil superview:self success:^(id success){
        NSDictionary *tmpDic = success;
        if ([tmpDic[@"code"] isEqualToString:@"200"]) {
            NSArray *UserListArray = [NSArray arrayWithArray:tmpDic[@"vzconfiginfo"]];
            [[NoDataLabel alloc] Show:@"データがない" SuperView:self DataBool:UserListArray.count];
            
            NSMutableDictionary *SystemUserDict = [NSMutableDictionary dictionaryWithContentsOfFile:SYSTEM_USER_DICT];
//            NSLog(@"%@",SystemUserDict);
            NSArray *actioninfoarray = [NSArray array];
            
            if (UserListArray.count>0) {
                for (NSDictionary *dict in UserListArray) {
                    if ([dict[@"userid0"] isEqualToString:SystemUserDict[@"userid0"]]&&[dict[@"roomid"] isEqualToString:SystemUserDict[@"roomid"]]) {
                        actioninfoarray = dict[@"actioninfo"];

                        [SystemUserDict setObject:[NSKeyedArchiver archivedDataWithRootObject:actioninfoarray] forKey:@"systemactioninfo"];
                        [SystemUserDict writeToFile:SYSTEM_USER_DICT atomically:NO];
                    }
                }
                
                for (NSDictionary *datadict in actioninfoarray) {
                    if (![datadict[@"actionclass"]isEqualToString:@"1"]) {
                        [self.ColorSelectionArray addObject:datadict];
                    }else{
                        if ([[NSString stringWithFormat:@"%@",datadict[@"actionexplain"]] isEqualToString:@"4"]) {
                            NSArray *colorarray = [datadict[@"actioncolor"] componentsSeparatedByString:@"|"];
                            NSMutableDictionary *SystemUserDict = [NSMutableDictionary dictionaryWithContentsOfFile:SYSTEM_USER_DICT];
                            [SystemUserDict setValue:colorarray[0]forKey:@"lightcolor"];
                            [SystemUserDict setValue:colorarray[1] forKey:@"darkcolor"];
                            [SystemUserDict writeToFile:SYSTEM_USER_DICT atomically:NO];
                        }
                    }
                }
            }else{
                self.ColorSelectionArray = nil;
            }
            NSData *tmpdata = [NSKeyedArchiver archivedDataWithRootObject:self.ColorSelectionArray];
            [NITUserDefaults setObject:tmpdata forKey:@"actionList"];
            
            [self reloadData];
        }else{
            NSLog(@"errors: %@",tmpDic[@"errors"]);
            [[NoDataLabel alloc] Show:[tmpDic[@"errors"] firstObject] SuperView:self DataBool:0];
        }
    }defeats:^(NSError *defeats){
        NSLog(@"errors:%@",[defeats localizedDescription]);
    }];
}

#pragma mark - UICollectionViewDataSource And Delegate

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSData *data = [NITUserDefaults objectForKey:@"actionList"];
    NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    return array.count;
//    self.ColorSelectionArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ColorSelectionCVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    NSData *data = [NITUserDefaults objectForKey:@"actionList"];
    NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    cell.DataDict = array[indexPath.item];
    cell.Row = indexPath.item;
//    self.ColorSelectionArray[indexPath.item];
    return cell;
}

- (void)dealloc{
    
    [NITNotificationCenter removeObserver:self];
}

@end
