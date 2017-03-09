//
//  AllChartVC.m
//  DashBoard
//
//  Created by totyu3 on 17/1/20.
//  Copyright © 2017年 NIT. All rights reserved.
//

#import "AllChartVC.h"
#import "LifeRhythmVC.h"
#import "ActivityStatisticsVC.h"

@interface AllChartVC ()
@property (strong, nonatomic) NSMutableArray *controlarr;
@property (weak, nonatomic) IBOutlet NITCollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *SelectViewSeg;
@end
@implementation AllChartVC

static NSString * const reuseIdentifier = @"AllChartVCCell";

- (IBAction)SelectView:(UISegmentedControl *)sender {
    
    [self.collectionView layoutIfNeeded];
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:sender.selectedSegmentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
}

-(NSMutableArray *)controlarr{
    
    if (!_controlarr) {
        _controlarr = [NSMutableArray array];
        LifeRhythmVC *lrvc = [MainSB instantiateViewControllerWithIdentifier:@"LifeRhythmVCSB"];
        [self addChildViewController:lrvc];
        [_controlarr addObject:lrvc];
        ActivityStatisticsVC *asvc = [MainSB instantiateViewControllerWithIdentifier:@"ActivityStatisticsVCSB"];
        [self addChildViewController:asvc];
        [_controlarr addObject:asvc];
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
    
    int page = (int) (scrollView.contentOffset.x/scrollView.frame.size.width+0.5)%self.controlarr.count;
    _SelectViewSeg.selectedSegmentIndex = page;
}

@end
