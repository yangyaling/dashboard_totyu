//
//  SealAFNetworking.m
//  AFnetworking-Test
//
//  Created by totyu3 on 16/8/19.
//  Copyright © 2016年 totyu3. All rights reserved.
//

#define ZwloginURL @"https://mimamori2p1hb.azurewebsites.net/dashboard/zwlogin.php"

#define ZwgetFacilityListURL @"https://mimamori2p1hb.azurewebsites.net/dashboard/zwgetfacilitylist.php"

#define ZwgetcolorinfoURL @"https://mimamori2p1hb.azurewebsites.net/dashboard/Zwgetcolorinfo.php"

#define ZwgetbuildinginfoURL @"https://mimamori2p1hb.azurewebsites.net/dashboard/zwgetbuildinginfo.php"
#define ZwgetcustlistURL @"https://mimamori2p1hb.azurewebsites.net/dashboard/zwgetcustlist.php"

#define ZwgetalertinfoURL @"https://mimamori2p1hb.azurewebsites.net/dashboard/zwgetalertinfo.php"

#define ZwgetvzconfiginfoURL @"https://mimamori2p1hb.azurewebsites.net/dashboard/zwgetvzconfiginfo.php"
#define ZwgetupdatevzconfiginfoURL @"https://mimamori2p1hb.azurewebsites.net/dashboard/zwupdatevzconfiginfo.php"
#define ZwupdatenoticeURL @"https://mimamori2p1hb.azurewebsites.net/dashboard/zwupdatenoticeinfo.php"

#define ZwupdateactioncolorURL @"https://mimamori2p1hb.azurewebsites.net/dashboard/zwupdateactioncolor.php"

#define ZwgetvznoticeinfoURL @"https://mimamori2p1hb.azurewebsites.net/dashboard/zwgetvznoticeinfo.php"
#define ZwgetvznoticecountURL @"https://mimamori2p1hb.azurewebsites.net/dashboard/zwgetvznoticecount.php"

#define WeeklylrinfoURL @"https://mimamori2p1hb.azurewebsites.net/dashboard/zwgetweeklylrinfo.php"

#define LrinfoURL @"https://mimamori2p1hb.azurewebsites.net/dashboard/zwgetlrinfo.php"

#define LrsuminfoURL @"https://mimamori2p1hb.azurewebsites.net/dashboard/zwgetlrsuminfo.php"

//#define LrsuminfoURL @"https://mimamori2p1.azurewebsites.net/dashboard/zwgetcolor.php"

#import "SealAFNetworking.h"

#import <UIKit/UIKit.h>
@interface SealAFNetworking ()
@end
@implementation SealAFNetworking

+(SealAFNetworking *)NIT{
    static SealAFNetworking*NIT = nil;
    
    if (!NIT) {
        NIT = [[SealAFNetworking alloc]init];
    }
    return NIT;
}

- (AFHTTPSessionManager *)manager {
    
    if (!_manager) {
        _manager = [AFHTTPSessionManager manager];
        _manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"application/x-json",@"text/html", nil];
        [_manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        [_manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        _manager.requestSerializer.timeoutInterval = 50.f;//超时时间
    }
    return _manager;
}

- (void)PostWithUrl:(NITPostUrlType)URLtype
         parameters:(id)parameters
           mjheader:(id)mjheader
          superview:(id)selfview
            success:(void (^)(id))success
            defeats:(void (^)(NSError *))defeats {
    
    NSString *UrlString;
    
    
    if (URLtype == ZwloginType) UrlString = ZwloginURL;
    if (URLtype == ZwgetFacilityList) UrlString = ZwgetFacilityListURL;//新接口
    
    if (URLtype == ZwgetcolorinfoType) UrlString = ZwgetcolorinfoURL;
    
    if (URLtype == ZwgetbuildinginfoType) UrlString = ZwgetbuildinginfoURL;
    if (URLtype == ZwgetcustlistType) UrlString = ZwgetcustlistURL;
    if (URLtype == ZwgetalertinfoType) UrlString = ZwgetalertinfoURL;
    
    
    
    if (URLtype == ZwgetvzconfiginfoType) UrlString = ZwgetvzconfiginfoURL;
    if (URLtype == ZwgetupdatevzconfiginfoType) UrlString = ZwgetupdatevzconfiginfoURL;
    if (URLtype == ZwupdateactioncolorType) UrlString = ZwupdateactioncolorURL;
    if (URLtype == ZwupdatenoticeType) UrlString = ZwupdatenoticeURL;
    
    if (URLtype == ZwgetvznoticeinfoType) UrlString = ZwgetvznoticeinfoURL;
    if (URLtype == ZwgetvznoticecountType) UrlString = ZwgetvznoticecountURL;
    
    if (URLtype == WeeklylrinfoType) UrlString = WeeklylrinfoURL;
    if (URLtype == LrinfoType) UrlString = LrinfoURL;
    if (URLtype == LrsuminfoType) UrlString = LrsuminfoURL;
    
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    [self.manager POST:UrlString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (responseObject) {
            if (selfview) {
                [self RequestEnd:selfview mjheader:mjheader];
            }
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error) {
            if (selfview) {
                [self RequestEnd:selfview mjheader:mjheader];
                [MBProgressHUD showError:@"タイムアウト" toView:selfview];
            }
            defeats(error);
        }
    }];
}

-(void)RequestEnd:(UIView*)view mjheader:(id)mjheader{
    [mjheader endRefreshing];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [MBProgressHUD hideHUDForView:view];
}

-(void)requestCancel{
    
    [self.manager.operationQueue cancelAllOperations];
}

@end
