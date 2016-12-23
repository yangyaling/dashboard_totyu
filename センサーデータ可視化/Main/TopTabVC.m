//
//  TopTabVC.m
//  センサーデータ可視化
//
//  Created by totyu3 on 16/12/19.
//  Copyright © 2016年 LGF. All rights reserved.
//

#import "TopTabVC.h"
#import "FishTabButtonPagerController.h"
#import "AlertBar.h"
#import "OneVC.h"
#import "TwoVC.h"

@interface TopTabVC ()<FishPagerControllerDataSource>
{
    UIView  *vcview;
}
@property (weak, nonatomic) IBOutlet AlertBar *AlertBarView;
@property (nonatomic, strong) FishTabButtonPagerController *pagerController;
@property (weak, nonatomic) IBOutlet UIView *VCView;
@property (nonatomic, strong) NSArray *PagerArray;
@property (weak, nonatomic) IBOutlet UILabel *NowTime;

@end

@implementation TopTabVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addPagerController];
    
    _AlertBarView.AlertArray = @[@"103号室　10:52",@"108号室　14:42",@"110号室　11:24",@"112号室　08:34"];
    _AlertBarView.AlertTitle = @"アラート情報 4 件";

    _NowTime.text = [[NSDate date]needDateStatus:JapanHMSType];
    [self performSelector:@selector(autoTime) withObject:nil afterDelay:1];
}


- (void)autoTime {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(autoTime) object:nil];
    _NowTime.text = [[NSDate date]needDateStatus:JapanHMSType];
    [self performSelector:@selector(autoTime) withObject:nil afterDelay:1];
}

-(NSArray *)PagerArray{
    if (!_PagerArray) {
        _PagerArray = [NSMutableArray arrayWithObjects:@"見守られる方",@"見守られる方",@"生活リズム", nil];
    }
    return _PagerArray;
}

- (void)addPagerController
{
    _pagerController = [[FishTabButtonPagerController alloc]init];
    _pagerController.cellWidth = NITScreenW/3-1;
    _pagerController.dataSource = self;
    _pagerController.barStyle = TYPagerBarStyleProgressView;
    _pagerController.view.frame = _VCView.bounds;
    [_VCView addSubview:_pagerController.view];
}

- (void)scrollToRamdomIndex
{
    [_pagerController moveToControllerAtIndex:arc4random()%30 animated:NO];
}

#pragma mark - TYPagerControllerDataSource

- (NSInteger)numberOfControllersInPagerController
{
    return self.PagerArray.count;
}

- (NSString *)pagerController:(FishPagerController *)pagerController titleForIndex:(NSInteger)index
{
    return self.PagerArray[index];
}

- (UIViewController *)pagerController:(FishPagerController *)pagerController controllerForIndex:(NSInteger)index
{
    if (index==0) {
        UIStoryboard *MainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        OneVC *onevc = [MainSB instantiateViewControllerWithIdentifier:@"ViewOneSB"];
        return onevc;
    }else if(index==1){
        UIStoryboard *MainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        TwoVC *twovc = [MainSB instantiateViewControllerWithIdentifier:@"ViewTwoSB"];
        
        return twovc;
    }else{
        UIStoryboard *MainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        TwoVC *twovc = [MainSB instantiateViewControllerWithIdentifier:@"ViewThreeSB"];
        
        return twovc;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
