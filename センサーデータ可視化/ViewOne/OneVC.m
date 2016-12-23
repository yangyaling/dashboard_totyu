//
//  OneVC.m
//  センサーデータ可視化
//
//  Created by totyu3 on 16/12/21.
//  Copyright © 2016年 LGF. All rights reserved.
//

#import "OneVC.h"
#import "OneVCCell.h"

@interface OneVC ()
{
    UIPageControl *OnePageView;
}
@property (nonatomic, strong) NSMutableArray *MainArray;

@end

@implementation OneVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Register cell classes    
    [self collectionViewsets];
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    OnePageView = [[UIPageControl alloc] initWithFrame:CGRectMake(0, NITScreenH-40, NITScreenW, 40)];
    OnePageView.pageIndicatorTintColor = [UIColor lightGrayColor];
    OnePageView.currentPageIndicatorTintColor = [UIColor blackColor];
    OnePageView.numberOfPages = self.MainArray.count/6;
    OnePageView.userInteractionEnabled = NO;
    [WindowView.rootViewController.view addSubview:OnePageView];
}

-(void)viewWillDisappear:(BOOL)animated{
    [OnePageView removeFromSuperview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)collectionViewsets{
    
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    CGSize itemSize = CGSizeMake(self.collectionView.width/3,(self.collectionView.height-222)/2);
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
    OneVCCell *cell = [OneVCCell cellWithTableView:self.collectionView indexPath:indexPath];
//    cell.backgroundColor = NITRandomColor;
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
    OnePageView.currentPage = page;
}


-(NSMutableArray *)MainArray{
    if (!_MainArray) {

        NSString *path = [[NSBundle mainBundle] pathForResource:@"UserTestData" ofType:@"plist"];
        _MainArray = [[NSMutableArray alloc]initWithContentsOfFile:path];
        for (int i = 0; i < _MainArray.count; i++) {
            if (i%6==1) {
                [_MainArray exchangeObjectAtIndex:i withObjectAtIndex:i+1];
                [_MainArray exchangeObjectAtIndex:i withObjectAtIndex:i+2];
                [_MainArray exchangeObjectAtIndex:i+2 withObjectAtIndex:i+3];
            }
        }
    }
    return _MainArray;
}





@end
