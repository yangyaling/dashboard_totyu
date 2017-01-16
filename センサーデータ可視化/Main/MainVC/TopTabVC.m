//
//  TopTabVC.m
//  センサーデータ可視化
//
//  Created by totyu3 on 16/12/19.
//  Copyright © 2016年 LGF. All rights reserved.
//

#import "TopTabVC.h"
#import "AlertBar.h"
#import "OneVC.h"

@interface TopTabVC ()
{
    UIView  *vcview;
}
@property (weak, nonatomic) IBOutlet AlertBar *AlertBarView;
//@property (nonatomic, strong) FishTabButtonPagerController *pagerController;
@property (weak, nonatomic) IBOutlet UIView *VCView;
@property (weak, nonatomic) IBOutlet UILabel *NowTime;
@end

@implementation TopTabVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // [self addPagerController];
    
    [NITUserDefaults setObject:@"0" forKey:@"logintype"];
    
    [NITNotificationCenter addObserver:self selector:@selector(getAlertArray:) name:@"getalertarray" object:nil];
    
    _NowTime.text = [[NSDate date]needDateStatus:JapanHMSType];
    [self performSelector:@selector(autoTime) withObject:nil afterDelay:1];
    
    UIStoryboard *notificationsb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc = [notificationsb instantiateViewControllerWithIdentifier:@"ViewInSB"];
    [self addChildViewController:vc];
    [vc view].frame = _VCView.bounds;
    [_VCView addSubview:[vc view]];
}

-(void)getAlertArray:(NSNotification*)sender{
    NSDictionary *dict = sender.userInfo;
    NSArray *alertarr = [NSArray arrayWithArray:dict[@"AlertArray"]];
    _AlertBarView.AlertArray = alertarr;
}

- (void)autoTime{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(autoTime) object:nil];
    _NowTime.text = [[NSDate date]needDateStatus:JapanHMSType];
    [self performSelector:@selector(autoTime) withObject:nil afterDelay:1];
}

//- (void)addPagerController
//{
//    _pagerController = [[FishTabButtonPagerController alloc]init];
//    _pagerController.cellWidth = NITScreenW/self.PagerArray.count-1;
//    _pagerController.dataSource = self;
//    _pagerController.barStyle = TYPagerBarStyleProgressView;
//    _pagerController.view.frame = _VCView.bounds;
//    [self.navigationItem.titleView addSubview:_pagerController.view];
//}

//- (void)scrollToRamdomIndex
//{
//    [_pagerController moveToControllerAtIndex:arc4random()%30 animated:NO];
//}
//
//#pragma mark - TYPagerControllerDataSource
//
//- (NSInteger)numberOfControllersInPagerController
//{
//    return self.PagerArray.count;
//}
//
//- (NSString *)pagerController:(FishPagerController *)pagerController titleForIndex:(NSInteger)index
//{
//    return self.PagerArray[index];
//}
//
//- (UIViewController *)pagerController:(FishPagerController *)pagerController controllerForIndex:(NSInteger)index
//{
//    if (index==0) {
//        UIStoryboard *MainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        OneVC *onevc = [MainSB instantiateViewControllerWithIdentifier:@"ViewOneSB"];
//        return onevc;
//    }else{
//        UIStoryboard *MainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        TwoVC *twovc = [MainSB instantiateViewControllerWithIdentifier:@"ViewThreeSB"];
//        return twovc;
//    }
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
