//
//  LoginVC.m
//  センサーデータ可視化
//
//  Created by totyu3 on 17/1/11.
//  Copyright © 2017年 LGF. All rights reserved.
//

#import "LoginVC.h"
#import "TopTabVC.h"

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

- (IBAction)saveBtn:(id)sender {
    
    if (!_userId.text.length) {
        [MBProgressHUD showError:@"ユーザIDを入力してください" toView:self.view];
        return;
    }
    
    if(!_passWord.text.length){
        [MBProgressHUD showError:@"パスワードを入力してください" toView:self.view];
        return;
    }
    
    [_passWord resignFirstResponder];
    NSString *calendarupdatetime = [[NSDate date] needDateStatus:HaveHMSType];
    [NITUserDefaults setObject:calendarupdatetime forKey:@"calendarupdatetime"];
    [self login:_userId.text password:_passWord.text];
    [NITUserDefaults setObject:_userId.text forKey:@"userid1"];
}

- (void)login:(NSString*)userid password:(NSString*)password
{
    [MBProgressHUD showMessage:@"後ほど..." toView:self.view];
    //body 参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"userid"] = userid;
    parameters[@"usertype"] = @"1";
    parameters[@"password"] = password;
    [[SealAFNetworking NIT] PostWithUrl:LoginURLType parameters:parameters mjheader:nil superview:self.view success:^(id success){
        NSDictionary *tmpDic = success;
        NSString *code =[tmpDic objectForKey:@"code"];
        if ([code isEqualToString:@"200"]) {
            NSString *username = [tmpDic objectForKey:@"username"];
            if (username) {
                [NITUserDefaults setObject:username forKey:@"userid1name"];
            }else{
                [NITUserDefaults setObject:@"" forKey:@"userid1name"];
            }
            [MBProgressHUD showSuccess:@"登録成功!" toView:self.view];
            UIStoryboard *notificationsb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            TopTabVC *vc = [notificationsb instantiateViewControllerWithIdentifier:@"MainView"];
            MasterKeyWindow.rootViewController = vc;
            
        }else{
            [MBProgressHUD showError:@"登録失敗!" toView:self.view];
        }
    }defeats:^(NSError *defeats){
    }];
}

@end
