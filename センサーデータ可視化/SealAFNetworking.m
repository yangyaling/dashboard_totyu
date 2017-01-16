//
//  SealAFNetworking.m
//  AFnetworking-Test
//
//  Created by totyu3 on 16/8/19.
//  Copyright © 2016年 totyu3. All rights reserved.
//
#define UserURL @"http://mimamori2.azurewebsites.net/zwgetcustlist.php"
#define LoginURL @"http://mimamori.azurewebsites.net/mimamorugawa/zwlogin.php"
#define DaySensorDataURL @"http://mimamori2.azurewebsites.net/zwgetdailydeviceinfo.php"


#define userprocURL @"http://mimamori2.azurewebsites.net/cms/user/userproc.php"
#define adduserprocURL @"http://mimamori2.azurewebsites.net/cms/user/adduserproc.php"
#define edituserURL @"http://mimamori2.azurewebsites.net/cms/user/edituser.php"
#define edituserprocURL @"http://mimamori2.azurewebsites.net/cms/user/edituserproc.php"
#define deleteuserprocURL @"http://mimamori2.azurewebsites.net/cms/user/deleteuserproc.php"

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
        _manager.requestSerializer.timeoutInterval = 60.f;//超时时间
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

    if (URLtype == UserURLType) UrlString = UserURL;
    if (URLtype == LoginURLType) UrlString = LoginURL;
    if (URLtype == DaySensorURLType) UrlString = DaySensorDataURL;

    
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
//    [NITProgress ShowProgress:RequestEnd];
}

-(void)requestCancel{
    
    [self.manager.operationQueue cancelAllOperations];
}

@end
