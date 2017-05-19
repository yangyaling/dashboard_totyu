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
@property (weak, nonatomic) IBOutlet UITextField *hostcode;
@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated{
    _passWord.text = @"";
    _userId.text = @"sw00001";
    _passWord.text = @"P@ssw0rd";
    _hostcode.text = @"host01";
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

-(BOOL)textFieldShouldReturn:(UITextField*)textField{
    if (textField == _hostcode) {
        [_userId becomeFirstResponder];
    } else if (textField == _userId) {
        [_passWord becomeFirstResponder];
    } else {
        [self.view endEditing:YES];
        [self login:_hostcode.text staffid:_userId.text password:_passWord.text];
    }
    return YES;
}

- (IBAction)Login:(id)sender {
    if (!_hostcode.text.length) {
        [MBProgressHUD showError:@"ホストコードを入力してください" toView:self.view];
        return;
    }
    if (!_userId.text.length) {
        [MBProgressHUD showError:@"ユーザーIDを入力してください" toView:self.view];
        return;
    }
    if(!_passWord.text.length){
        [MBProgressHUD showError:@"パスワードを入力してください" toView:self.view];
        return;
    }
    [self login:_hostcode.text staffid:_userId.text password:_passWord.text];
}

- (void)login:(NSString*)hostcd staffid:(NSString*)staffid password:(NSString*)password{
    NSMutableDictionary *SystemUserDict = [NSMutableDictionary new];
    [SystemUserDict setValue:@"0" forKey:@"mainvcrow"];
    [SystemUserDict setValue:@"0" forKey:@"mainvcchildrow"];
    [SystemUserDict setValue:@"0" forKey:@"visualsetvcrow"];
    [SystemUserDict setValue:@"0" forKey:@"visualsetvcchildrow"];
    [SystemUserDict setValue:staffid forKey:@"staffid"];
    [SystemUserDict setValue:hostcd forKey:@"hostcd"];
    [SystemUserDict setValue:[NSDate NeedDateFormat:@"yyyy-MM-dd HH:mm:ss" ReturnType:returnstring date:[NSDate date]] forKey:@"newnoticetime"];
    [SystemUserDict setValue:[NSDate NeedDateFormat:@"yyyy-MM-dd HH:mm:ss" ReturnType:returnstring date:[NSDate date]] forKey:@"oldnoticetime"];
    NSDictionary *parameter = @{@"hostcd":hostcd,@"staffid":staffid,@"password":password};
    [MBProgressHUD showMessage:@"後ほど..." toView:self.view];
    [[SealAFNetworking NIT] PostWithUrl:ZwloginType parameters:parameter mjheader:nil superview:self.view success:^(id success){
        NSDictionary *tmpDic = [LGFNullCheck CheckNSNullObject:success];
        if ([tmpDic[@"code"] isEqualToString:@"200"]) {
            [NITUserDefaults setObject:tmpDic forKey:@"MainUserDict"];
            [SystemUserDict setValue:tmpDic[@"usertype"] forKey:@"systemusertype"];
            if ([SystemUserDict writeToFile:SYSTEM_USER_DICT atomically:NO] && (![tmpDic[@"usertype"] isEqualToString:@"3"] || ![tmpDic[@"usertype"] isEqualToString:@"x"])) {
                [CATransaction setCompletionBlock:^{
                    [MBProgressHUD showSuccess:@"登録成功!" toView:self.view];
                    LGFKeyWindow.rootViewController = [MainSB instantiateViewControllerWithIdentifier:@"MainView"];
                }];
            }
        } else {
            [CATransaction setCompletionBlock:^{
                [MBProgressHUD showError:@"登録失败!" toView:self.view];
            }];
            NSLog(@"errors: %@",tmpDic[@"errors"]);
        }
    }defeats:^(NSError *defeats){
        }];
}
@end
