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
    [[SealAFNetworking NIT] PostWithUrl:ZwgetvznoticeinfoType parameters:nil mjheader:nil superview:self.view success:^(id success){
        NSDictionary *tmpDic = [LGFNullCheck CheckNSNullObject:success];
        if ([tmpDic[@"code"] isEqualToString:@"200"]) {
            self.NoticeArray = tmpDic[@"vznoticeinfo"];
            if ([[NoDataLabel alloc] Show:@"すべてが正常で" SuperView:self.view DataBool:self.NoticeArray.count])return;
            NSDictionary *newdatadict = [NSDictionary dictionaryWithDictionary:self.NoticeArray[0]];
            NSMutableDictionary *SystemUserDict = [NSMutableDictionary dictionaryWithContentsOfFile:SYSTEM_USER_DICT];
            [SystemUserDict setValue:newdatadict[@"registdate"] forKey:@"newnoticetime"];
            if ([SystemUserDict writeToFile:SYSTEM_USER_DICT atomically:NO]) {
                [_NoticeCollection reloadSections:[NSIndexSet indexSetWithIndex:0]];
                [_NoticeCollection selectItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
                NSDictionary *dict = self.NoticeArray[0];
                _NoticeDetailTextView.text = [NSString stringWithFormat:@"%@ %@",dict[@"content"],dict[@"registdate"]];
            }
        } else {
            NSLog(@"errors: %@",tmpDic[@"errors"]);
            [[NoDataLabel alloc] Show:@"system errors" SuperView:self.view DataBool:0];
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

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *DataDict = self.NoticeArray[indexPath.item];
    NoticeCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    UIView* selectedBGView = [[UIView alloc] initWithFrame:cell.bounds];
    selectedBGView.backgroundColor = SystemColor(0.3);
    cell.selectedBackgroundView = selectedBGView;
    cell.NoticeDetail.text = DataDict[@"title"];
    cell.NoticeTime.text = DataDict[@"registdate"];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = self.NoticeArray[indexPath.row];
    _NoticeDetailTextView.text = [NSString stringWithFormat:@"%@ %@",dict[@"content"],dict[@"registdate"]];
}


@end
