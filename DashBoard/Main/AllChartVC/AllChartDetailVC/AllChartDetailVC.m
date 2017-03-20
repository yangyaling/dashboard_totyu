//
//  AllChartDetailVC.m
//  DashBoard
//
//  Created by totyu3 on 17/1/20.
//  Copyright © 2017年 NIT. All rights reserved.
//

#import "AllChartDetailVC.h"
#import "LifeRhythmDetailVC.h"
#import "ActivityStatisticsDetailVC.h"

@interface AllChartDetailVC ()
@property (strong, nonatomic) NSMutableArray *controlarr;
@property (weak, nonatomic) IBOutlet NITCollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *SelectViewSeg;
@end
@implementation AllChartDetailVC

static NSString * const reuseIdentifier = @"AllChartDetailVCCell";

- (IBAction)SelectView:(UISegmentedControl *)sender {
    [self.collectionView layoutIfNeeded];
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:sender.selectedSegmentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
}
/**
 视图控制器数组
 */
-(NSMutableArray *)controlarr{
    if (!_controlarr) {
        _controlarr = [NSMutableArray array];
        LifeRhythmDetailVC *lrdvc = [MainSB instantiateViewControllerWithIdentifier:@"LifeRhythmDetailVCSB"];
        lrdvc.SelectDay = _SelectDay;
        lrdvc.Weekdate = _Weekdate;
        [self addChildViewController:lrdvc];
        [_controlarr addObject:lrdvc];
        ActivityStatisticsDetailVC *asdvc = [MainSB instantiateViewControllerWithIdentifier:@"ActivityStatisticsDetailVCSB"];
        asdvc.SelectDay = _SelectDay;
        [self addChildViewController:asdvc];
        [_controlarr addObject:asdvc];
    }
    return _controlarr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UICollectionViewDataSource And Delegate

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.controlarr.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(_collectionView.width,_collectionView.height);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    UIView *view = [self.controlarr[indexPath.item]view];
    view.size = cell.size;
    [cell.contentView addSubview:view];
    return cell;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    int page = scrollView.contentOffset.x / scrollView.width;
    _SelectViewSeg.selectedSegmentIndex = page;
}

@end
