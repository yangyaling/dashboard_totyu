//
//  MainCVC.m
//  センサーデータ可視化
//
//  Created by totyu3 on 17/1/11.
//  Copyright © 2017年 LGF. All rights reserved.
//

#import "MainCVC.h"
#import "OneVC.h"

@interface MainCVC ()
/**
 *  总数组
 */
@property (strong, nonatomic) NSMutableArray *controlarr;
@property (weak, nonatomic) IBOutlet UISegmentedControl *SelectViewSeg;
@end

@implementation MainCVC

static NSString * const reuseIdentifier = @"MainCVCell";

- (IBAction)SelectView:(UISegmentedControl *)sender {
    
    [self.collectionView layoutIfNeeded];
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:sender.selectedSegmentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
}

-(NSMutableArray *)controlarr{
    
    if (!_controlarr) {
        _controlarr = [NSMutableArray array];
        UIStoryboard *lifesb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        OneVC *onevc = [lifesb instantiateViewControllerWithIdentifier:@"OneVCSB"];
        [self addChildViewController:onevc];
        [_controlarr addObject:onevc];
        UIViewController *twovc = [lifesb instantiateViewControllerWithIdentifier:@"TwoVCSB"];
        [self addChildViewController:twovc];
        [_controlarr addObject:twovc];
        
    }
    return _controlarr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    [self collectionViewsets];
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0]  atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
}

- (IBAction)getNewData:(id)sender {

    [NITNotificationCenter removeObserver:self name:@"loadnewdata" object:nil];
    //创建一个消息对象
    NSNotification * notice = [NSNotification notificationWithName:@"loadnewdata" object:nil userInfo:nil];
    //发送消息
    [NITNotificationCenter postNotification:notice];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)collectionViewsets{
    
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    CGSize itemSize = CGSizeMake(NITScreenW,NITScreenH-185);
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = itemSize;
    layout.minimumLineSpacing = 0.0f;
    self.collectionView.collectionViewLayout = layout;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.userInteractionEnabled = YES;
    self.collectionView.pagingEnabled =YES;
}

#pragma mark <UICollectionViewDataSource>

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.controlarr.count;
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
