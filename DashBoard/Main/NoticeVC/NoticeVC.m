//
//  NoticeVC.m
//  DashBoard
//
//  Created by totyu3 on 17/2/8.
//  Copyright © 2017年 NIT. All rights reserved.
//

#import "NoticeVC.h"

@interface NoticeCollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UITextView *NoticeDetail;
@property (weak, nonatomic) IBOutlet UILabel *NoticeTime;
@property (weak, nonatomic) IBOutlet UILabel *NewLabel;

@end
@implementation NoticeCollectionCell
@end

@interface NoticeVC ()
@property (weak, nonatomic) IBOutlet UICollectionView *NoticeCollection;
@property (weak, nonatomic) IBOutlet UITextView *NoticeDetailTextView;
@property (nonatomic, strong) NSArray *NoticeArray;
@end

@implementation NoticeVC

static NSString * const reuseIdentifier = @"NoticeCollectionCell";

-(NSArray *)NoticeArray{
    if (!_NoticeArray) {
        _NoticeArray = [NSArray array];
    }
    return _NoticeArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadNewData];
}
/**
 发送请求获取新数据
 */
- (void)loadNewData{
    [MBProgressHUD showMessage:@"後ほど..." toView:self.view];
    NSMutableDictionary *SystemUserDict = [NSMutableDictionary dictionaryWithContentsOfFile:SYSTEM_USER_DICT];
//    NSString *registdate = SystemUserDict[@"newnoticetime"];
    NSString *staffid = SystemUserDict[@"staffid"];
    [[SealAFNetworking NIT] PostWithUrl:ZwgetvznoticeinfoType parameters:NSDictionaryOfVariableBindings(staffid) mjheader:nil superview:self.view success:^(id success){
        NSDictionary *tmpDic = [LGFNullCheck CheckNSNullObject:success];
        if ([tmpDic[@"code"] isEqualToString:@"200"]) {
            self.NoticeArray = tmpDic[@"vznoticeinfo"];
            if ([[NoDataLabel alloc] Show:@"すべてが正常で" SuperView:self.view DataBool:self.NoticeArray.count]){
                NSDictionary *newdatadict = [NSDictionary dictionaryWithDictionary:self.NoticeArray[0]];
                [SystemUserDict setValue:newdatadict[@"registdate"] forKey:@"newnoticetime"];
                if ([SystemUserDict writeToFile:SYSTEM_USER_DICT atomically:NO]) {
                    [_NoticeCollection reloadData];
                    [_NoticeCollection selectItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
                    NSDictionary *dict = self.NoticeArray[0];
                    _NoticeDetailTextView.text = [NSString stringWithFormat:@"%@ %@",dict[@"content"],dict[@"registdate"]];
                }
            } else {
                [_NoticeCollection reloadData];
            }
        } else {
            NSLog(@"errors: %@",tmpDic[@"errors"]);
            [MBProgressHUD showError:@"system errors" toView:self.view];
//            [[NoDataLabel alloc] Show:@"system errors" SuperView:self.view DataBool:0];
        }
    }defeats:^(NSError *defeats){
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark UICollectionView Delegate and DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.NoticeArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(_NoticeCollection.width,_NoticeCollection.height / 4);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *DataDict = self.NoticeArray[indexPath.item];
    NoticeCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    UIView* selectedBGView = [[UIView alloc] initWithFrame:cell.bounds];
    selectedBGView.backgroundColor = SystemColor(0.3);
    cell.selectedBackgroundView = selectedBGView;
    cell.NoticeDetail.text = DataDict[@"title"];
    cell.NoticeTime.text = DataDict[@"registdate"];
    NSMutableDictionary *SystemUserDict = [NSMutableDictionary dictionaryWithContentsOfFile:SYSTEM_USER_DICT];
    [cell.NewLabel setHidden:[NSDate compareDate:DataDict[@"registdate"] withDate:SystemUserDict[@"oldnoticetime"]] != 0 ? YES : NO];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = self.NoticeArray[indexPath.row];
    _NoticeDetailTextView.text = [NSString stringWithFormat:@"%@ %@",dict[@"content"],dict[@"registdate"]];
}

- (void)dealloc{
    NSMutableDictionary *SystemUserDict = [NSMutableDictionary dictionaryWithContentsOfFile:SYSTEM_USER_DICT];
    NSDictionary *newdatadict = [NSDictionary dictionaryWithDictionary:self.NoticeArray[0]];
    [SystemUserDict setValue:newdatadict[@"registdate"] forKey:@"oldnoticetime"];
    [SystemUserDict writeToFile:SYSTEM_USER_DICT atomically:NO];
}

@end
