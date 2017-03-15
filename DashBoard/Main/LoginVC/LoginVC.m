//
//  LoginVC.m
//  DashBoard
//
//  Created by totyu3 on 17/1/17.
//  Copyright © 2017年 NIT. All rights reserved.
//

#import "LoginVC.h"
//#import "MainVC.h"

@interface LoginVC ()
@property (strong, nonatomic) IBOutlet UITextField *userId;
@property (strong, nonatomic) IBOutlet UITextField *passWord;
@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated{
    
    _passWord.text = @"";
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

- (IBAction)Login:(id)sender {
    
    if (!_userId.text.length) {
        [MBProgressHUD showError:@"ユーザIDを入力してください" toView:self.view];
        return;
    }
    if(!_passWord.text.length){
        [MBProgressHUD showError:@"パスワードを入力してください" toView:self.view];
        return;
    }
    [self login:_userId.text password:_passWord.text];
}

- (void)login:(NSString*)userid password:(NSString*)password{
    
    NSMutableDictionary *SystemUserDict = [NSMutableDictionary new];
    [SystemUserDict setValue:userid forKey:@"userid1"];
    [SystemUserDict setValue:[NSDate NeedDateFormat:@"yyyy-MM-dd HH:mm:ss" ReturnType:returnstring date:[NSDate date]] forKey:@"newnoticetime"];
    
    if ([SystemUserDict writeToFile:SYSTEM_USER_DICT atomically:NO]) {
    
        NSDictionary *parameter = @{@"userid":userid,@"password":password};
        
        [MBProgressHUD showMessage:@"後ほど..." toView:self.view];
        [[SealAFNetworking NIT] PostWithUrl:ZwloginType parameters:parameter mjheader:nil superview:self.view success:^(id success){
            NSDictionary *tmpDic = [LGFNullCheck CheckNSNullObject:success];
            if ([tmpDic[@"code"] isEqualToString:@"200"]) {
                [NITUserDefaults setObject:tmpDic forKey:@"MainUserDict"];
                [MBProgressHUD showSuccess:@"登録成功!" toView:self.view];
                MasterKeyWindow.rootViewController = [MainSB instantiateViewControllerWithIdentifier:@"MainView"];
            }else{
                [MBProgressHUD showError:@"登録失败!" toView:self.view];
                NSLog(@"errors: %@",tmpDic[@"errors"]);
            }
        }defeats:^(NSError *defeats){
        }];
    }else{
        [MBProgressHUD showError:@"登録失败!" toView:self.view];
    }
}
@end
