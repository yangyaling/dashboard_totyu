//
//  TwoVC.m
//  センサーデータ可視化
//
//  Created by totyu3 on 16/12/22.
//  Copyright © 2016年 LGF. All rights reserved.
//

#import "TwoVC.h"
#import "TwoVCCell.h"

@interface TwoVC ()
{
    UIPageControl *TwoPageView;
}
@property (nonatomic, strong) NSMutableArray *MainArray;
@end

@implementation TwoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self collectionViewsets];
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    TwoPageView = [[UIPageControl alloc] initWithFrame:CGRectMake(0, NITScreenH-40, NITScreenW, 40)];
    TwoPageView.pageIndicatorTintColor = [UIColor lightGrayColor];
    TwoPageView.currentPageIndicatorTintColor = [UIColor blackColor];
    TwoPageView.numberOfPages = self.MainArray.count/12;
    TwoPageView.userInteractionEnabled = NO;
    [WindowView.rootViewController.view addSubview:TwoPageView];
}

-(void)viewWillDisappear:(BOOL)animated{
    [TwoPageView removeFromSuperview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)collectionViewsets{
    
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    CGSize itemSize = CGSizeMake(self.collectionView.width/3,(self.collectionView.height-222)/4);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = itemSize;
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    self.collectionView.collectionViewLayout = layout;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.pagingEnabled =YES;
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.MainArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TwoVCCell *cell = [TwoVCCell cellWithTableView:self.collectionView indexPath:indexPath];
    NSDictionary *dict = self.MainArray[indexPath.item];
    cell.RoomName.text = dict[@"roomname"];
    cell.UserName.text = dict[@"username"];
    [cell.UserImage setImage:[UIImage imageNamed:dict[@"userimage"]]];
    cell.UserAge.text = dict[@"userage"];
    cell.UserSex.text = dict[@"usersex"];
    cell.alerttype = dict[@"alerttype"];
    return cell;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    int page = scrollView.contentOffset.x / scrollView.width;
    NSLog(@"%d",page);
    TwoPageView.currentPage = page;
}

-(NSArray *)MainArray{
    if (!_MainArray) {
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"UserTestDataTwo" ofType:@"plist"];
        _MainArray = [[NSMutableArray alloc]initWithContentsOfFile:path];

        NSMutableArray *arr = [_MainArray copy];
        
        for (int i = 0; i < _MainArray.count; i++) {
            if (i%12==0) {
                [_MainArray replaceObjectAtIndex:i+4 withObject:arr[i+1]];
                [_MainArray replaceObjectAtIndex:i+8 withObject:arr[i+2]];
                [_MainArray replaceObjectAtIndex:i+1 withObject:arr[i+3]];
                [_MainArray replaceObjectAtIndex:i+5 withObject:arr[i+4]];
                [_MainArray replaceObjectAtIndex:i+9 withObject:arr[i+5]];
                [_MainArray replaceObjectAtIndex:i+2 withObject:arr[i+6]];
                [_MainArray replaceObjectAtIndex:i+6 withObject:arr[i+7]];
                [_MainArray replaceObjectAtIndex:i+10 withObject:arr[i+8]];
                [_MainArray replaceObjectAtIndex:i+3 withObject:arr[i+9]];
                [_MainArray replaceObjectAtIndex:i+7 withObject:arr[i+10]];
            }
        }
    }
    return _MainArray;
}


@end
